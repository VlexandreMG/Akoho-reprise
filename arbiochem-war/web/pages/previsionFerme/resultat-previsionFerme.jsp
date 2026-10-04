<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="previsionFerme.PrevisionFerme" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="affichage.Graphe" %>
<%@ page import="previsionFerme.AdminPrevisionFerme" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="previsionFerme.PrevisionFermeLib" %>

<% try {
    UserEJB u = (user.UserEJB) session.getAttribute("u");
    String nomTable = "PREVISIONFERMEVIDE";
    PrevisionFermeLib prevision = new PrevisionFermeLib();
    prevision.setNomTable(nomTable);
    PageInsert pi = new PageInsert(prevision, request, u);
    pi.setLien((String) session.getAttribute("lien"));
    pi.setTitre("Résultat prévisionnel");
    boolean afficherResultat = "POST".equalsIgnoreCase(request.getMethod());
    PrevisionFerme minimum = null;

    Liste[] liste = new Liste[2];
    Magasin magasin = new Magasin();
    magasin.setNomTable("magasin2");
    liste[0] = new Liste("idMagasin", magasin, "val", "id" ," and actif = 1");
    String[] val = {"","semaine","mois"};
    String[] aff = {"Jour","Semaine","Mois"};
    liste[1] = new Liste("grouperPar",aff,val);
    liste[0].ajouterVide();
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("grouperPar").setDefaut("semaine");
    pi.getFormu().getChamp("idProduit").setLibelle("Produit");
    pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pi.getFormu().getChamp("daty").setLibelle("Date du jour");
    pi.getFormu().getChamp("datyDebut").setLibelle("Date d&eacute;but");
    pi.getFormu().getChamp("datyFin").setLibelle("Date fin");
    pi.getFormu().getChamp("grouperPar").setLibelle("Grouper par");
    pi.getFormu().getChamp("entree").setVisible(false);
    pi.getFormu().getChamp("sortie").setVisible(false);
    pi.getFormu().getChamp("qteInitial").setVisible(false);
    pi.getFormu().getChamp("idProduitLib").setVisible(false);
    pi.getFormu().getChamp("qteFinal").setVisible(false);
    pi.getFormu().getChamp("idProduit").setPageAppelComplete("produits.IngredientsLib","id","ST_INGREDIENTSAUTO","libelle","idProduitLib");
    if (afficherResultat) {
        PageInsert pageInsert = new PageInsert(prevision, request);
        prevision = (PrevisionFermeLib) pageInsert.getObjectAvecValeur();
        pi.getFormu().setDefaut(prevision);
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.datetostring(prevision.getDaty()));
        pi.getFormu().getChamp("datyDebut").setDefaut(Utilitaire.datetostring(prevision.getDatyDebut()));
        pi.getFormu().getChamp("datyFin").setDefaut(Utilitaire.datetostring(prevision.getDatyFin()));
        pi.setTitre(pi.getTitre() + " : \""+prevision.getIdProduitLib()+"\"");
    } else {
        String moisDefaut = Utilitaire.getMois(Utilitaire.dateDuJour());
        String anneeDefaut = Utilitaire.getAnnee(Utilitaire.dateDuJour());
        String[] debutFinDefaut = Utilitaire.getBorneDatyMoisAnnee(moisDefaut, anneeDefaut);
        pi.getFormu().getChamp("datyDebut").setDefaut(debutFinDefaut[0]);
        pi.getFormu().getChamp("datyFin").setDefaut(debutFinDefaut[1]);
    }
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();

    String[] paramVide = {};
    String[] libEntete = {"daty","qteInitial", "entree", "sortie", "qteFinal"};
    String[] libEnteteAffiche = {"Date","Quantit&eacute; initial", "Entr&eacute;e", "Sortie", "Quantit&eacute; finale"};
    PageRecherche pr = new PageRecherche(prevision, request, paramVide, paramVide, 3, libEntete, libEntete.length);
    pr.setUtilisateur((UserEJB) session.getAttribute("u"));
    pr.setLien((String) session.getAttribute("lien"));
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=previsionFerme/resultat-previsionFerme.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
    </form>
    <% if (afficherResultat) { %>
        <div class="col-md-12 nopadding">
            <h2 class="h520pxSemibold" style="margin-bottom: 0" >Graphe</h2>
        </div>
        <div class="cardradius col-md-12 mb-5 m-0">
            <canvas id="qte"></canvas>
        </div>
        <div class="cardradius col-md-12 mb-5 m-0">
            <canvas id="entreeGraphe"></canvas>
        </div>
        <div class="cardradius col-md-12 mb-5 m-0">
            <canvas id="sortieGraphe"></canvas>
        </div>
    <%
        AdminPrevisionFerme ap = new AdminPrevisionFerme(prevision);
        ap.getPrevision(null);
        minimum = ap.getMinimum();
        String colAbs = "datyG"+prevision.getGrouperPar();
        pr.creerObjetPage(libEntete,null);
        pr.getTableau().setData(ap.getListePrev());
        pr.getTableau().transformerDataString();
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        Graphe g = new Graphe(ap.getListePrev(),colAbs,new String[]{"qteFinal"},new String[]{"Quantité Finale"},"qte","daty");
        g.setCouleurs(new String[]{"#2563EB"});
        g.setBgCouleurs(new String[]{"#2563EB"});
        Graphe g1 = new Graphe(ap.getListePrev(),colAbs,new String[]{"entree"},new String[]{"Entrée"},"entreeGraphe","daty");
        g1.setCouleurs(new String[]{"#16A34A"});
        g1.setBgCouleurs(new String[]{"#16A34A"});
        Graphe g2 = new Graphe(ap.getListePrev(),colAbs,new String[]{"sortie"},new String[]{"Sortie"},"sortieGraphe","daty");
        g2.setCouleurs(new String[]{"#F1C40F"});
        g2.setBgCouleurs(new String[]{"#F1C40F"});
        out.println("<h2 class=\"h520pxSemibold\" >Tableau</h2>");
        out.println(g.getHtml());
        out.println(g1.getHtml());
        out.println(g2.getHtml());
        out.println(pr.getTableau().getHtml());
    } if(minimum!=null) { %>
    <div id="toremove">
        <table>
            <tr id="minimum-values">
                <%for( int i = 0; i < libEntete.length - 2; i++ ){
                        out.println("<td></td>");
                } %>
                <td style="padding: 10px">
                    <strong class="strong">
                        Date minimum : <%= utilitaire.Utilitaire.format(minimum.getDaty()) %>
                    </strong>
                </td>
                <td style="text-align: right; padding: 10px">
                    <strong class="strong">
                        Quantit&eacute; minimum : <%= utilitaire.Utilitaire.formaterAr(minimum.getQteFinal()) %>
                    </strong>
                </td>
            </tr>
        </table>
    </div>
    <% } %>
</div>
<script>
    document.querySelectorAll('button, input[type="submit"], input[type="button"]').forEach(function(btn) {
        var texteActuel = btn.tagName === 'BUTTON' ? btn.textContent.trim() : btn.value.trim();
        if (texteActuel === 'Enregistrer') {
            if (btn.tagName === 'BUTTON') {
                btn.textContent = 'Afficher la prévision';
            } else {
                btn.value = 'Afficher la prévision';
            }
        }
    });
</script>
<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

