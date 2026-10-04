<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Graphe" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="stat.StatDepenseCat" %>
<%@ page import="affichage.Liste" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>

<% try{
    StatDepenseCat bdc = new StatDepenseCat();
    String listeCrt[] = {"annee","categorieingredient"};
    String listeInt[] = {};
    String libEntete[] = {};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setNpp(9999);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stat/stat-depense-cat-chart.jsp");
    Liste[] liste = new Liste[1];
    liste[0] = new Liste("categorieingredient",new CategorieIngredient(),"val","id");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("categorieingredient").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String titreGraph = "&Eacute;volution des d&eacute;penses par cat&eacute;gorie ";
%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= titreGraph %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <div class="row m-0">
            <div class="cardradius">
                <canvas id="graph_depense_cat"></canvas>
                <h5 class="card-title text-center"><%= titreGraph %></h5>
            </div>
        </div>
    </section>

</div>
<%
        String colAbs1 = "moisstring";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};
        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "moisstring", "depense")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_depense_cat", "moisint");
        g1.setTypeGraphe("line");
        out.println(g1.getHtml("ctx_depense_cat"));
    }catch(Exception e){

        e.printStackTrace();
    }
%>