
<%@page import="affichage.PageRecherche"%>
<%@ page import="compteur.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="maintenance.configuration.CompteurMaintenance" %>
<%@ page import="machine.Ligne" %>
<%@ page import="maintenance.tranche.Tranche" %>
<%@ page import="produits.Ingredients" %>



<% try{
    String[] etatVal = {"","1","11","0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Vis&eacute;e(s)","Annul&eacute;e(s)"};
    
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    CompteurMaintenance t = new CompteurMaintenance();
    String nomTable = "CompteurCPL";
    // if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
    //     nomTable = request.getParameter("etat");
    // }
    t.setNomTable(nomTable);

    String listeCrt[] = {"id", "idLigne", "idCategorie", "daty","idMagasin"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "idLigneLib", "idCategorieLib","ancien", "valeur", "ecart","daty", "idMagasinLib","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des Compteurs Maintenance");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compteur/releve-liste.jsp");
    String awhere = "";
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        awhere += " and etat=" + request.getParameter("etat");
    }
    pr.setAWhere(awhere);
    Liste[] listes = new Liste[4];
    Ligne m = new Ligne();
    m.setNomTable("LIGNE");
    Tranche mag = new Tranche();
    mag.setNomTable("TRANCHE");
    Magasin magasin = new Magasin();
    listes[0] = new Liste("idLigne", m, "val", "id");
    listes[1] = new Liste("idTranche", mag, "val", "id");
    listes[2] = new Liste("idMagasin", magasin, "val", "id");
    Ingredients ingredientsConsommable = new Ingredients();
    ingredientsConsommable.setNomTable("AS_INGREDIENTS_CONSOMMABLE");
    listes[3] = new Liste("idCategorie", ingredientsConsommable,"libelle","id");

    pr.getFormu().changerEnChamp(listes);

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idLigne").setLibelle("Ligne");
    pr.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=compteur/releve-fiche.jsp" , pr.getLien() + "?but=ligne/ligne-fiche.jsp", pr.getLien() + "?but=tranche/tranche-fiche.jsp"};
    String colonneLien[] = {"id" ,"idLigne","idTranche"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String[] urlLienMultiple = {"id", "idLigne","idTranche"};
    String[] urlLienAffiche = {"id", "id","id"};

    pr.getTableau().setUrlLienAffiche(urlLienAffiche);
    pr.getTableau().setUrlLien(urlLienMultiple);

    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"ID", "Ligne", "Cat&eacute;gorie","Ancien", "valeur", "&eacute;cart","Date", "Magasin","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    // String[] etatVal = {"COMPTEURLIB","COMPTEURLIBCREER", "COMPTEURLIBANNULER", "COMPTEURLIBVISER"};
    // String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)","Annul&eacute;(s)","Valid&eacute;(s)"};
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=compteur/releve-saisie.jsp\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i> saisie d'un relev&eacute;</a>"
    );

%>
// <script>
//     function changerDesignation() {
//         document.getElementById("bdlc-liste--form").submit();
//     }
// </script>
<script>
    function changerDesignation() {
        document.filtre.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdlc-liste--form" name="filtre" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
                <div class="row col-md-12" style="margin-top: 12px;">
                    <div class="col-md-2 nopadding" style="width: 271px" >
                        <label class="input-label" for="etat">&Eacute;tat :</label>
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < etatAff.length; i++ ){ %>
                            <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                            <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                            <% } else { %>
                            <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                            <% } %>
                            <%    }
                            %>
                        </select>
                    </div>
                   
        </div>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



