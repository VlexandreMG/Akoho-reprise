<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.couvoir.SuiviChambreFroideLib" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    SuiviChambreFroideLib o = new SuiviChambreFroideLib();
    o.setNomTable("SUIVICHAMBREFROIDE_LIB");
    String[] listeCrt = {"daty","idSalleStockageOeufLib","etatLib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","daty","idSalleStockageOeufLib","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("liste des suivi chambre foride");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/couvoir/suivichambrefroide-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idSalleStockageOeufLib").setLibelle("Salle de stockage d'oeuf");
    Liste listeEtat = new Liste("etatlib");
    String [] aff = new String[]{"","Cr&eacute;&eacute;","Valid&eacute;","Annul&eacute;"};
    String [] affVal = new String[]{"","CREE", "VISEE", "ANNULEE"};
    listeEtat.ajouterValeur(affVal,aff);
    affichage.Champ[] liste = new affichage.Champ[1];
    liste[0] = listeEtat;
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("etatLib").setLibelle("&Eacute;tat");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().setLienFille("ferme/couvoir/inc/suivichambrefroide-details.jsp&id=");

    String[] enteteRecap = {"","Nombre","Somme des quantit&eacute;s de poussins &agrave; contr&ocirc;le"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=ferme/couvoir/suivichambrefroide-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Date","Salle de stockage des œufs","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

