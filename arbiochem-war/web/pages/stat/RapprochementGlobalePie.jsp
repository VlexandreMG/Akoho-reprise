<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="affichage.Graphe" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="stat.RapprochementGlobalePie" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="utils.ConstanteAsync" %>

<% try {
    RapprochementGlobalePie bdc = new RapprochementGlobalePie();
    bdc.setNomTable("V_RAPPROCHEMENT_POURCENTAGE");

    String listeCrt[] = {"daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"val", "pourcentage"};

    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("dashboard/rapprochement-couts.jsp");

    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");

    String[] colSomme = {"pourcentage"};
    pr.creerObjetPage(libEntete, colSomme);

    String libEnteteAffiche[] = {"Libellé", "Pourcentage (%)"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String description = "Graphe : R&eacute;partition des coûts de production en pourcentage ";

    String titreGraph = "Répartition des coûts de production en pourcentage";
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Statistique Coûts de Production</h1>
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
                            <canvas id="rapprochementChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
<%
        String colAbs1 = "val";
        String[] colOrd1 = {""};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{AdminGen.getDataChart(pr.getTableau().getData(), "val", "pourcentage")};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "rapprochementChart", "");
        g1.setTypeGraphe("pie");
        out.println(g1.getHtml("ctx3"));
    } catch (Exception e) {
        e.printStackTrace();
    }
%>