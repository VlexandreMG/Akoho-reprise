<%@ page import="user.UserEJB" %>
<%@ page import="affichage.*" %>
<%@ page import="paie.accident.*" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="utils.ConstanteAigleDor" %>
<%@ page import="bean.ResultatEtSomme" %>
<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>
<%
    try {
        String lien = (String) session.getAttribute("lien");
        UserEJB u = (user.UserEJB) session.getAttribute("u");
        String[] paramVide = {};
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;

        // ===================== PALETTES PAR GRAPHIQUE =====================

        // Graph 0 : Répartition par gravité (Doughnut) -> dégradé Vert -> Rouge
        String[] palettesGravite = {
            "#28a745", // Vert (léger)
            "#8bc34a", // Vert clair
            "#ffc107", // Jaune
            "#fd7e14", // Orange
            "#e74a3b", // Rouge orangé
            "#dc3545"  // Rouge (grave / mortel)
        };

        // Graph 1 : Analyse par type d'accident (Bar) -> palette large et variée
        String[] palettesType = {
            "#4e73df", "#6f42c1", "#20c997", "#17a2b8", "#6610f2",
            "#0d6efd", "#5a4fcf", "#36b9cc", "#4dabf7", "#748ffc",
            "#9b59b6", "#1abc9c", "#3498db", "#2ecc71", "#34495e"
        };

        // Graph 2 : Évolution mensuelle (Line) -> couleurs vives pour ligne + points
        String[] palettesEvolution = {
            "#e74a3b", // Ligne principale (rouge)
            "#f6c23e", // Points (jaune)
            "#fd7e14", // Zone (orange)
            "#dc3545"  // Alerte (rouge foncé)
        };

        // Graph 3 : Accidents par Business Unit (Bar) -> palette chaude/orangée
        String[] palettesBusiness = {
            "#f6c23e", "#fd7e14", "#e74a3b", "#dc3545", "#d63384",
            "#6f42c1", "#0dcaf0", "#198754", "#0d6efd", "#6610f2",
            "#ff6f61", "#ffa07a", "#ff8c00", "#cd853f", "#b22222"
        };

        // ====================================================================

        String[] colAfficheCat = {};
        String[] criterePoint = {};
        String[] critereIntPoint = {};
        
        PageRecherche[] pr = new PageRecherche[4]; 
        pr[0] = new PageRecherche(new RepartitionAccidentGravite(), request, criterePoint, critereIntPoint, 4, paramVide, paramVide.length);
        pr[0].setUtilisateur((user.UserEJB) session.getAttribute("u"));
        pr[0].setNpp(9999);

        pr[1] = new PageRecherche(new StatAccidentType(), request, criterePoint, critereIntPoint, 4, paramVide, paramVide.length);
        pr[1].setUtilisateur((user.UserEJB) session.getAttribute("u"));
        pr[1].setNpp(9999);

        pr[2] = new PageRecherche(new StatAccidentEvolution(), request, criterePoint, critereIntPoint, 4, paramVide, paramVide.length);
        pr[2].setUtilisateur((user.UserEJB) session.getAttribute("u"));
        pr[2].setNpp(9999);
        pr[2].setAWhere(" order by moisInt asc");

        pr[3] = new PageRecherche(new StatAccidentBusiness(), request, criterePoint, critereIntPoint, 4, paramVide, paramVide.length);
        pr[3].setUtilisateur((user.UserEJB) session.getAttribute("u"));
        pr[3].setNpp(9999);

        PageRecherche.creerObjetPage(pr);
        ResultatEtSomme rprtitionAccdGravite    = pr[0].getRs();
        ResultatEtSomme statAccidentType        = pr[1].getRs();
        ResultatEtSomme statAccidentEvolution   = pr[2].getRs();
        ResultatEtSomme statAccidentBusiness    = pr[3].getRs();

        // --- Graph 0 : Répartition par gravité (Doughnut) ---
        String[] colAffichePrd = {"id_gravite_lib"};
        String[] legendePrd = {"Nombre des accidents"};
        String[] colValNbFormation = {"nombreaccidents"};
        DashboardGraphOpt dgRepartitionAccidentGrvt = new DashboardGraphOpt(rprtitionAccdGravite, colAffichePrd, legendePrd, DashboardGraphType.DOUGHNUT);
        dgRepartitionAccidentGrvt.setTitre("Répartition des accidents par gravité");
        dgRepartitionAccidentGrvt.setIcon("pie_chart");
        dgRepartitionAccidentGrvt.setColValeur(colValNbFormation);
        dgRepartitionAccidentGrvt.setColSpan(6);
        dgRepartitionAccidentGrvt.setLienPage("accident/accident-liste.jsp");
        dgRepartitionAccidentGrvt.setBackgroundColor(backgroundColor);
        dgRepartitionAccidentGrvt.setCouleurs(palettesGravite);
        dgRepartitionAccidentGrvt.setCanvasId("graphRepartitionAccidentGrvt");
        dgRepartitionAccidentGrvt.creerGraph();
        
        // --- Graph 1 : Analyse par type (Bar) ---
        String[] colAfficheStatAcc = {"id_type_accident_lib"};
        String[] legendeStatAcc = {"Nombre des accidents"};
        String[] colValNbStatAcc = {"nombreaccidents"};
        DashboardGraphOpt dgStatAccidentType = new DashboardGraphOpt(statAccidentType, colAfficheStatAcc, legendeStatAcc, DashboardGraphType.BAR);
        dgStatAccidentType.setColAffiche(new String[]{"id_type_accident_lib"});
        dgStatAccidentType.setTitre("Analyse des accidents par type");
        dgStatAccidentType.setIcon("bar_chart");
        dgStatAccidentType.setColSpan(6);
        dgStatAccidentType.setLimite(10);
        dgStatAccidentType.setOrdre("desc");
        dgStatAccidentType.setOrientation("vertical");
        dgStatAccidentType.setBackgroundColor(backgroundColor);
        dgStatAccidentType.setCouleurs(palettesType);
        dgStatAccidentType.setCanvasId("chartStatAccidentType");
        dgStatAccidentType.setColValeur(colValNbStatAcc);
        dgStatAccidentType.creerGraph();

        // --- Graph 2 : Évolution mensuelle (Line) ---
        String[] colAfficheEvolution = {"mois"};
        String[] legendeEvolution = {"Nombre des accidents"};
        String[] colValEvolution = {"nombreaccidents"};
        DashboardGraphOpt dgStatAccidentEvolution = new DashboardGraphOpt(statAccidentEvolution, colAfficheEvolution, legendeEvolution, DashboardGraphType.LINE);
        dgStatAccidentEvolution.setColAffiche(new String[]{"mois"});
        dgStatAccidentEvolution.setTitre("Évolution mensuelle des accidents");
        dgStatAccidentEvolution.setIcon("show_chart");
        dgStatAccidentEvolution.setColSpan(6);
        dgStatAccidentEvolution.setOrdre("moisint asc");
        dgStatAccidentEvolution.setOrientation("vertical");
        dgStatAccidentEvolution.setBackgroundColor(backgroundColor);
        dgStatAccidentEvolution.setCouleurs(palettesEvolution);
        dgStatAccidentEvolution.setCanvasId("chartStatAccidentEvolution");
        dgStatAccidentEvolution.setColValeur(colValEvolution);
        dgStatAccidentEvolution.creerGraph();

        // --- Graph 3 : Accidents par Business Unit (Bar) ---
        String[] colAfficheBusiness = {"idbulib"};
        String[] legendeBusiness = {"Nombre des accidents"};
        String[] colValBusiness = {"nombreaccidents"};
        DashboardGraphOpt dgStatAccidentBusiness = new DashboardGraphOpt(statAccidentBusiness, colAfficheBusiness, legendeBusiness, DashboardGraphType.BAR);
        dgStatAccidentBusiness.setColAffiche(new String[]{"idbulib"});
        dgStatAccidentBusiness.setTitre("Accidents par Business Unit");
        dgStatAccidentBusiness.setIcon("business");
        dgStatAccidentBusiness.setColSpan(6);
        dgStatAccidentBusiness.setLimite(10);
        dgStatAccidentBusiness.setOrdre("desc");
        dgStatAccidentBusiness.setOrientation("vertical");
        dgStatAccidentBusiness.setBackgroundColor(backgroundColor);
        dgStatAccidentBusiness.setCouleurs(palettesBusiness);
        dgStatAccidentBusiness.setCanvasId("chartStatAccidentBusiness");
        dgStatAccidentBusiness.setColValeur(colValBusiness);
        dgStatAccidentBusiness.creerGraph();
%>

<div class="content-wrapper">
    <section class="content-header"><h1>Dashboard Gestion des Accidents</h1></section>
    <section class="content">
        <form action="<%=lien%>?but=paie/formation/accident-dashboard.jsp" method="post" name="formulaire">
        </form>
        <div class="row">
            <%=dgRepartitionAccidentGrvt.getHtml()%>
            <%=dgStatAccidentType.getHtml()%>
        </div>
        <div class="row">
            <%=dgStatAccidentEvolution.getHtml()%>
            <%=dgStatAccidentBusiness.getHtml()%>
        </div>
    </section>
</div>
<% } catch (Exception e) { e.printStackTrace(); } %>