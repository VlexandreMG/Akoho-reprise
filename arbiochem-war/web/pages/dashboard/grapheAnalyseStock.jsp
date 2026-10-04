<%@ page import="affichage.*" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="dashboard.*" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="user.UserEJB" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script src="${pageContext.request.contextPath}/chartPlugins/Chart.min.js"></script>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        String dateDuJour = Utilitaire.dateDuJour();
        UserEJB u = (user.UserEJB) session.getAttribute("u");
        String anneeCourante = Utilitaire.getAnnee(dateDuJour);
        String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;
        String[] palettes = ConstanteDashboard.DEFAULT_COLORS;
        String[] paramVide = {};

        String[] critere = {"dateInv"};
        String[] critereInt = {"dateInv"};

        PageRecherche[] pr = new PageRecherche[6];

        for (int i = 0; i < 6; i++) {
            pr[i] = new PageRecherche(new V_InventaireFilleCPL(), request, critere, critereInt, 4, paramVide, 0);
            pr[i].setUtilisateur(u);
            pr[i].setNpp(20000);

            pr[i].getFormu().getChamp("dateInv1").setDefaut(Utilitaire.getDebutAnnee(anneeCourante));
            pr[i].getFormu().getChamp("dateInv2").setDefaut(dateDuJour);
            pr[i].getFormu().getChamp("dateInv1").setLibelle("Date début");
            pr[i].getFormu().getChamp("dateInv2").setLibelle("Date fin");
        }

        pr[1].setAWhere(" AND categorieIngredient = 'CAT004' ");

        pr[2].setAWhere(" AND categorieIngredient IN ('CAT008','CAT001')");

        pr[4].setAWhere(" AND categorieIngredient = 'CAT004'");

        pr[5].setAWhere(" AND categorieIngredient IN ('CAT008','CAT001')");

        PageRecherche.creerObjetPage(pr);

        DashboardGraphOpt[] g = new DashboardGraphOpt[6];
        String[] colDateAffiche = {"dateInv"};

        g[0] = new DashboardGraphOpt(pr[0].getRs(), colDateAffiche, new String[]{"Valeur Totale"}, DashboardGraphType.LINE);
        g[0].setTitre("Évolution de la valeur de stock (Total)");
        g[0].setColValeur(new String[]{"montantReelle"});
        g[0].setCanvasId("chartStockTotal");
        g[0].setUnite(" Ar");

        g[1] = new DashboardGraphOpt(pr[1].getRs(), colDateAffiche, new String[]{"Valeur MP"}, DashboardGraphType.LINE);
        g[1].setTitre("Évolution de la valeur de stock (Mat. Premières)");
        g[1].setColValeur(new String[]{"montantReelle"});
        g[1].setCanvasId("chartStockMP");
        g[1].setUnite(" Ar");

        g[2] = new DashboardGraphOpt(pr[2].getRs(), colDateAffiche, new String[]{"Valeur PF/SF"}, DashboardGraphType.LINE);
        g[2].setTitre("Évolution de la valeur de stock (PF + Semi-finis)");
        g[2].setColValeur(new String[]{"montantReelle"});
        g[2].setCanvasId("chartStockPF");
        g[2].setUnite(" Ar");

        g[3] = new DashboardGraphOpt(pr[3].getRs(), colDateAffiche, new String[]{"Écart Total"}, DashboardGraphType.LINE);
        g[3].setTitre("Évolution de l'écart sur inventaire (Total)");
        g[3].setColValeur(new String[]{"ecart"});
        g[3].setCanvasId("chartEcartTotal");
        g[3].setUnite("");

        g[4] = new DashboardGraphOpt(pr[4].getRs(), colDateAffiche, new String[]{"Écart MP"}, DashboardGraphType.LINE);
        g[4].setTitre("Évolution de l'écart sur inventaire (Mat. Premières)");
        g[4].setColValeur(new String[]{"ecart"});
        g[4].setCanvasId("chartEcartMP");
        g[4].setUnite("");

        g[5] = new DashboardGraphOpt(pr[5].getRs(), colDateAffiche, new String[]{"Écart PF/SF"}, DashboardGraphType.LINE);
        g[5].setTitre("Évolution de l'écart sur inventaire (PF + Semi-finis)");
        g[5].setColValeur(new String[]{"ecart"});
        g[5].setCanvasId("chartEcartPF");
        g[5].setUnite("");

        for (DashboardGraphOpt graph : g) {
            graph.setColAffiche(colDateAffiche);
            graph.setIcon("trending_up");
            graph.setColSpan(6);
            graph.setBackgroundColor(backgroundColor);
            graph.setCouleurs(palettes);
            graph.creerGraph();
        }
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Dashboard Gestion des Inventaires</h1>
    </section>

    <section class="content">
        <form action="<%=lien%>?but=<%=pr[0].getApres()%>" method="post">
            <%=pr[0].getFormu().getHtmlEnsemble()%>
        </form>

        <div class="row p-3">
            <h2 class="col-md-12 h520pxSemibold">Analyse des Valeurs de Stock</h2>
            <div class="row">
                <%=g[0].getHtml()%>
                <%=g[1].getHtml()%>
            </div>
            <div class="row" style="margin-top: 20px;">
                <%=g[2].getHtml()%>
            </div>

            <h2 class="col-md-12 h520pxSemibold" style="margin-top: 30px;">Analyse des Écarts d'Inventaire</h2>
            <div class="row">
                <%=g[3].getHtml()%>
                <%=g[4].getHtml()%>
            </div>
            <div class="row" style="margin-top: 20px;">
                <%=g[5].getHtml()%>
            </div>
        </div>
    </section>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Suppression du bouton exporter selon ton exemple
        const exportBtn = document.querySelector('[data-target="#exporter"]');
        if (exportBtn) {
            const wrapper = exportBtn.closest(".d-flex");
            (wrapper || exportBtn).style.display = "none";
        }

        // Cache le bloc mots-clés s'il existe
        const motsCles = document.querySelector(".mots-cless");
        if (motsCles) {
            motsCles.style.display = "none";
        }
    });
</script>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage().replace("'", "\\'")%>');
    history.back();
</script>
<%
    }
%>