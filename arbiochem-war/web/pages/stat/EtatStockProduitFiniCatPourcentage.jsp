<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="affichage.Graphe" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="stat.EtatStockProduitFiniCatPourcentage" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="utils.ConstanteAsync" %>

<% try {
    EtatStockProduitFiniCatPourcentage bdc = new EtatStockProduitFiniCatPourcentage();
    String listeCrt[] = {"daty"};
    String listeInt[] = {"daty"};
    // Note: On garde pourcentage dans l'entête pour l'affichage,
    // mais on l'enlève de colSomme pour éviter l'erreur SQL
    String libEntete[] = {"idTypeProduitLib", "pourcentage"};

    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stat/production-cat-pourcentage.jsp");

    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");

    String[] colSomme = null; // IMPORTANT: Fixe l'erreur ORA-00904
    pr.creerObjetPage(libEntete, colSomme);

    String libEnteteAffiche[] = {"Type de Produit", "Valeur (%)"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String description = "Graphe : R&eacute;partition par type de produit (%) ";

    String titreGraph = "Répartition par type de produit (%)";
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Analyse de Production</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <% out.println(pr.getFormu().getHtmlEnsemble()); %>
        </form>
        <%
            out.println(pr.getHtmlWithEvaluation(ConstanteAsync.API_URL, ConstanteAsync.API_KEY, titreGraph, description));
        %>
        <br>
        <div class="row mt-4">
            <div class="col-md-12 mb-4">
                <div class="card h-100" style="border-radius: 10px; padding: 1em">
                    <div class="card-body">
                        <h5 class="card-title text-center"><%= titreGraph %></h5>
                        <div style="max-width: 500px; margin: 0 auto;">
                            <canvas id="chartEtatStockProduitFiniPourcentage"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
<%
        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "idTypeProduitLib", "pourcentage")};
        Graphe g1 = new Graphe(data1, "idTypeProduitLib", new String[]{""}, new String[]{""}, "chartEtatStockProduitFiniPourcentage", "");
        g1.setTypeGraphe("pie");
        out.println(g1.getHtml());
    } catch (Exception e) {
        e.printStackTrace();
    } %>