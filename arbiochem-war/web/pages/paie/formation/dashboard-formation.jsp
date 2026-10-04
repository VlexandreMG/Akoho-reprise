<%@ page import="user.UserEJB" %>
<%@ page import="affichage.*" %>
<%@ page import="paie.formation.dashboard.*" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="bean.ResultatEtSomme" %>

<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        UserEJB u = (user.UserEJB) session.getAttribute("u");
        String[] paramVide = {};
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;

        // Nouvelle palette de couleurs personnalisée
        String[] palettes = {"#4e73df", "#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b"};

        String[] criterePoint = {};
        String[] critereIntPoint = {};

        // 1. Initialisation de toutes les recherches (16 au total)
        PageRecherche[] pr = new PageRecherche[16];

        pr[0] = new PageRecherche(new CoutFormationType(), request, paramVide, paramVide, 4, null, 0);
        pr[1] = new PageRecherche(new PresenceGlobale(), request, paramVide, paramVide, 4, null, 0);
        pr[2] = new PageRecherche(new RepartitionPrestataire(), request, paramVide, paramVide, 4, null, 0);
        pr[3] = new PageRecherche(new PresenceParFormation(), request, paramVide, paramVide, 4, null, 0);
        pr[4] = new PageRecherche(new FormationParSemestre(), request, paramVide, paramVide, 4, null, 0);
        pr[5] = new PageRecherche(new FormationParCategorie(), request, paramVide, paramVide, 4, null, 0);
        pr[6] = new PageRecherche(new FormationParType(), request, paramVide, paramVide, 4, null, 0);
        pr[7] = new PageRecherche(new FormationBilanGlobal(), request, paramVide, paramVide, 4, null, 0);
        pr[8] = new PageRecherche(new FormationHeureAnnee(), request, paramVide, paramVide, 4, null, 0);
        pr[9] = new PageRecherche(new FormationStagiaireAnnee(), request, paramVide, paramVide, 4, null, 0);
        pr[10] = new PageRecherche(new MoyenneHeureStagiaire(), request, paramVide, paramVide, 4, null, 0);
        pr[11] = new PageRecherche(new FormationBudgetAnnee(), request, paramVide, paramVide, 4, null, 0);
        pr[12] = new PageRecherche(new CoutFormationParAction(), request, paramVide, paramVide, 4, null, 0);
        pr[13] = new PageRecherche(new TopFormateur(), request, paramVide, paramVide, 4, null, 0);
        pr[14] = new PageRecherche(new FormationRealisationIntExt(), request, criterePoint, critereIntPoint, 4, paramVide, 0);
        pr[15] = new PageRecherche(new FormationExecutif(), request, criterePoint, critereIntPoint, 4, paramVide, 0);

        // Application des configurations globales et limites spécifiques
        for (PageRecherche p : pr) {
            p.setUtilisateur(u);
            p.setNpp(9999);
        }
        pr[11].setNpp(2000); // Exception : Budget Année
        pr[12].setNpp(2000); // Exception : Top Formations Coûteuses
        pr[13].setNpp(2000); // Exception : Top Formateurs

        // Exécution de toutes les requêtes SQL en une seule opération
        PageRecherche.creerObjetPage(pr);

        // 2. Configuration des Widgets (DashboardGraphOpt)
        DashboardGraphOpt[] g = new DashboardGraphOpt[16];

        // 0. Structure des dépenses (Pie Chart)
        g[0] = new DashboardGraphOpt(pr[0].getRs(), new String[]{"typeCout"}, new String[]{"Coût"}, DashboardGraphType.PIE);
        g[0].setTitre("Structure des dépenses");
        g[0].setColValeur(new String[]{"montantTotal"});
        g[0].setColAffiche(new String[]{"typeCout"});
        g[0].setUnite(" Ar");
        g[0].setColSpan(6);
        g[0].setIcon("pie_chart");
        g[0].setCanvasId("chartCout");

        // 1. Assiduité globale (Donut Chart)
        g[1] = new DashboardGraphOpt(pr[1].getRs(), new String[]{"statut"}, new String[]{"Nombre"}, DashboardGraphType.DOUGHNUT);
        g[1].setTitre("Assiduité globale");
        g[1].setColValeur(new String[]{"nombre"});
        g[1].setColAffiche(new String[]{"statut"});
        g[1].setColSpan(6);
        g[1].setIcon("donut_large");
        g[1].setCanvasId("chartPresenceGlobal");

        // 2. Comparaison Prestataires (Donut Chart)
        g[2] = new DashboardGraphOpt(pr[2].getRs(), new String[]{"typePrestataire"}, new String[]{"Nombre"}, DashboardGraphType.DOUGHNUT);
        g[2].setTitre("Interne vs Externe");
        g[2].setColValeur(new String[]{"nombreFormation"});
        g[2].setColAffiche(new String[]{"typePrestataire"});
        g[2].setColSpan(4);
        g[2].setIcon("business");
        g[2].setCanvasId("chartPrestataire");

        // 3. Formations les plus suivies (Bar Horizontal)
        g[3] = new DashboardGraphOpt(pr[3].getRs(), new String[]{"intituleFormation"}, new String[]{"Taux (%)"}, DashboardGraphType.BAR);
        g[3].setTitre("Taux de présence par formation");
        g[3].setOrientation("horizontal");
        g[3].setColValeur(new String[]{"tauxPresence"});
        g[3].setColAffiche(new String[]{"intituleFormation"});
        g[3].setOrientation("horizontal");
        g[3].setOrdre("desc");
        g[3].setColSpan(8);
        g[3].setIcon("bar_chart");
        g[3].setCanvasId("chartPresenceFormation");

        // 4. Répartition des formations sur l'année (Bar)
        g[4] = new DashboardGraphOpt(pr[4].getRs(), new String[]{"semestre"}, new String[]{"Nombre"}, DashboardGraphType.BAR);
        g[4].setTitre("Répartition des formations sur l'année");
        g[4].setColValeur(new String[]{"nombreFormation"});
        g[4].setColAffiche(new String[]{"semestre"});
        g[4].setColSpan(6);
        g[4].setIcon("calendar_today");
        g[4].setCanvasId("chartSemestre");

        // 5. Catégories de formation dominantes (Bar Horizontal)
        g[5] = new DashboardGraphOpt(pr[5].getRs(), new String[]{"categorieFormation"}, new String[]{"Nombre"}, DashboardGraphType.BAR);
        g[5].setTitre("Catégories de formation dominantes");
        g[5].setOrientation("horizontal");
        g[5].setColValeur(new String[]{"nombreFormation"});
        g[5].setColAffiche(new String[]{"categorieFormation"});
        g[5].setOrientation("horizontal");
        g[5].setOrdre("desc");
        g[5].setColSpan(6);
        g[5].setIcon("list");
        g[5].setCanvasId("chartCategorie");

        // 6. Types de formation les plus utilisés (Bar Horizontal)
        g[6] = new DashboardGraphOpt(pr[6].getRs(), new String[]{"typeFormation"}, new String[]{"Nombre"}, DashboardGraphType.BAR);
        g[6].setTitre("Types de formation les plus utilisés");
        g[6].setOrientation("horizontal");
        g[6].setColValeur(new String[]{"nombreFormation"});
        g[6].setColAffiche(new String[]{"typeFormation"});
        g[6].setOrientation("horizontal");
        g[6].setOrdre("desc");
        g[6].setColSpan(8);
        g[6].setIcon("category");
        g[6].setCanvasId("chartTypeFormation");

        // 7. Avancement global du plan de formation (Donut Chart)
        g[7] = new DashboardGraphOpt(pr[7].getRs(), new String[]{"statut"}, new String[]{"Nombre"}, DashboardGraphType.DOUGHNUT);
        g[7].setTitre("Avancement global du plan de formation");
        g[7].setColValeur(new String[]{"nombre"});
        g[7].setColAffiche(new String[]{"statut"});
        g[7].setColSpan(4);
        g[7].setIcon("check_circle");
        g[7].setCanvasId("chartBilanGlobal");

        // 8. Évolution de l'effort de formation (Line)
        g[8] = new DashboardGraphOpt(pr[8].getRs(), new String[]{"mois"}, new String[]{"Heures"}, DashboardGraphType.LINE);
        g[8].setTitre("Évolution de l'effort de formation par mois");
        g[8].setColValeur(new String[]{"totalHeureFormation"});
        g[8].setColAffiche(new String[]{"mois"});
        g[8].setUnite(" h");
        g[8].setColSpan(5);
        g[8].setCanvasId("chartEvolutionHeure");
        g[8].setIcon("trending_up");

        // 9. Nombre de collaborateurs formés (Line)
        g[9] = new DashboardGraphOpt(pr[9].getRs(), new String[]{"mois"}, new String[]{"Collaborateurs"}, DashboardGraphType.LINE);
        g[9].setTitre("Nombre de collaborateurs formés par mois");
        g[9].setColValeur(new String[]{"nombreStagiaire"});
        g[9].setColAffiche(new String[]{"mois"});
        g[9].setColSpan(7);
        g[9].setIcon("groups");
        g[9].setCanvasId("chartEvolutionStagiaire");

        // 10. Intensité moyenne de formation (Line)
        g[10] = new DashboardGraphOpt(pr[10].getRs(), new String[]{"mois"}, new String[]{"Moyenne (h)"}, DashboardGraphType.LINE);
        g[10].setTitre("Intensité moyenne de formation par mois");
        g[10].setColValeur(new String[]{"moyenneHeureParStagiaire"});
        g[10].setColAffiche(new String[]{"mois"});
        g[10].setUnite(" h/pers");
        g[10].setColSpan(12);
        g[10].setIcon("trending_up");
        g[10].setCanvasId("chartMoyenneHeure");

        // 11. BUDGET PREVISIONNEL (Line)
        g[11] = new DashboardGraphOpt(pr[11].getRs(), new String[]{"annee"}, new String[]{"Budget"}, DashboardGraphType.LINE);
        g[11].setTitre("Évolution des budgets alloués");
        g[11].setColValeur(new String[]{"budgetTotalPrevisionnel"});
        g[11].setColAffiche(new String[]{"annee"});
        g[11].setUnite(" Ar");
        g[11].setColSpan(12);
        g[11].setIcon("attach_money");
        g[11].setCanvasId("chartBudgetAnnee");

        // 12. TOP FORMATIONS COUTEUSES (Bar Horizontal)
        g[12] = new DashboardGraphOpt(pr[12].getRs(), new String[]{"intituleFormation"}, new String[]{"Coût Total"}, DashboardGraphType.BAR);
        g[12].setTitre("Top 10 des formations les plus coûteuses");
        g[12].setOrientation("horizontal");
        g[12].setColValeur(new String[]{"coutTotal"});
        g[12].setColAffiche(new String[]{"intituleFormation"});
        g[12].setOrientation("horizontal");
        g[12].setOrdre("desc");
        g[12].setLimite(10);
        g[12].setUnite(" Ar");
        g[12].setColSpan(6);
        g[12].setIcon("request_quote");
        g[12].setCanvasId("chartCoutAction");

        // 13. TOP FORMATEURS (Bar Horizontal)
        g[13] = new DashboardGraphOpt(pr[13].getRs(), new String[]{"nomFormateur"}, new String[]{"Formations"}, DashboardGraphType.BAR);
        g[13].setTitre("Formateurs les plus sollicités");
        g[13].setOrientation("horizontal");
        g[13].setColValeur(new String[]{"nombreFormation"});
        g[13].setColAffiche(new String[]{"nomFormateur"});
        g[13].setOrientation("horizontal");
        g[13].setOrdre("desc");
        g[13].setColSpan(6);
        g[13].setIcon("school");
        g[13].setCanvasId("chartTopFormateur");

        // 14. Réalisation Int/Ext (Bar) - Ancien 'dgormationRealisationIntExt'
        g[14] = new DashboardGraphOpt(pr[14].getRs(), new String[]{"typeprestataire"}, new String[]{"Nombre non réalisé", "Nombre réalisé"}, DashboardGraphType.BAR);
        g[14].setTitre("Suivi des formations internes et externes");
        g[14].setColValeur(new String[]{"nbrealisee", "nbnonrealisee"});
        g[14].setColAffiche(new String[]{"typeprestataire"});
        g[14].setIcon("bar_chart");
        g[14].setColSpan(12);
        g[14].setLimite(10);
        g[14].setOrdre("desc");
        g[14].setOrientation("vertical");
        g[14].setCanvasId("chartPrestatairerealisation");

        // 15. Executif (Card) - Ancien 'dgFormationExecutif'
        g[15] = new DashboardGraphOpt(pr[15].getRs(), new String[]{"typeprestataire"}, new String[]{"Nombre de formations", "Nombre de formations réalisées", "Nombre de stagiaires formés", "Total des heures de formation", "Budget de formation", "Taux de présence", "Taux de couverture"}, DashboardGraphType.CARD);
        g[15].setColValeur(new String[]{"nbformationtotal", "nbformationrealisee", "nbstagiaireforme", "totalheureformation", "budgetformation", "tauxpresence", "tauxcouverture"});
        g[15].setIcon("trending_up");
        g[15].setColSpan(6);
        g[15].setAvecDate(false);
        g[15].setCanvasId("graphformationexecutif");

        // Finalisation de tous les graphiques
        for (DashboardGraphOpt graph : g) {
            graph.setBackgroundColor(backgroundColor);
            graph.setCouleurs(palettes); // La nouvelle palette est appliquée ici
            graph.creerGraph();
        }
%>
<style>
    #chartCategorie {
        height: 344px !important;
    }

    #chartContainer_chartSemestre {
        height: 360px !important;
    }

    #chartSemestre {
        height: 344px !important;
    }

    #chartContainer_chartCategorie {
        height: 360px !important;
    }

    #chartContainer_chartTopFormateur {
        height: 724px !important;
    }

    #chartTopFormateur {
        height: 708px !important;
    }

    #chartContainer_chartCoutAction {
        height: 724px !important;
    }

    #chartCoutAction {
        height: 708px !important;
    }

</style>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Dashboard Gestion des Formations</h1>
    </section>

    <section class="content">
        <form action="<%=lien%>?but=formation/dashboard-formation.jsp" method="post" name="formulaire">
            <%= pr[0].getFormu().getHtmlEnsemble() %>
        </form>

        <div class="row" style="margin-top: 20px;">
            <div class="col-md-12 nopadding">
                <%=g[15].getHtml()%>
            </div>
        </div>
        <div class="row" style="margin-top: 20px;">
            <%=g[0].getHtml()%>
            <%=g[1].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <%=g[2].getHtml()%>
            <%=g[3].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <%=g[4].getHtml()%>
            <%=g[5].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <%=g[6].getHtml()%>
            <%=g[7].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <%=g[8].getHtml()%>
            <%=g[9].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <%=g[10].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <h2 class="col-md-12 h520pxSemibold">Analyse Budgétaire et Expertise</h2>
            <%=g[11].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <%=g[12].getHtml()%>
            <%=g[13].getHtml()%>
        </div>

        <div class="row" style="margin-top: 20px;">
            <div class="col-md-12 nopadding">
                <%=g[14].getHtml()%>
            </div>
        </div>
    </section>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<div class='alert alert-danger'>Erreur : " + e.getMessage() + "</div>");
    }
%>