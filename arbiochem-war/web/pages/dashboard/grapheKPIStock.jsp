<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.*" %>
<%@ page import="stock.EtatStockParEntreeStandard" %>
<%@ page import="constante.ConstanteDashboard" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="mg.mapping.*" %>

<% try{
    String lien = (String) session.getAttribute("lien");
    UserEJB u = (user.UserEJB) session.getAttribute("u");
     //String backgroundColor = ConstanteDashboard.DEFAULT_GRAPH_BACKGROUND_COLOR;
     String backgroundColor = "rgba(255, 255, 255, 0.8)";
    String[] palettes = {"#4e73df", "#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b"};

    String[] paramDaty = {"daty"};
    String[] paramVide = {};
    DashboardGraph[] graphs = new DashboardGraph[3];

    EtatStockParEntreeStandard vst = new EtatStockParEntreeStandard();
    vst.setNomTable("V_ETATSTOCK_ENTREE_STANDARD");
    String[] colValCa = {"montantreste"};
    String[] legendeCa = {"Montant restant"};
    PageRecherche prvst = new PageRecherche(vst, request, paramDaty, paramDaty, 4, legendeCa, legendeCa.length);
    graphs[0] = new DashboardGraph(prvst, colValCa, null,legendeCa, DashboardGraphType.CARD);
    graphs[0].setTitre("Valeur en stock total");
    graphs[0].setUnite(" Ar");
    graphs[0].setColSpan(4);
    graphs[0].setIcon("shopping_cart");
    //graphs[0].setLienPage("vente/vente-liste.jsp");
    graphs[0].setBackgroundColor(backgroundColor);
    graphs[0].setCanvasId("caValeurStockTotal");

    EtatStockParEntreeStandard vsmp = new EtatStockParEntreeStandard();
    vsmp.setNomTable("V_ETATSTOCK_ENTREE_STANDARD");
    String[] colValvsmp = {"montantreste"};
    String[] legendevsmp = {"Montant restant"};
    PageRecherche prvsmp = new PageRecherche(vsmp, request, paramDaty, paramDaty, 4, legendevsmp, legendevsmp.length);
    prvsmp.setAWhere(" and categorieIngredient = 'CAT004'");
    graphs[1] = new DashboardGraph(prvsmp, colValvsmp, null,legendevsmp, DashboardGraphType.CARD);
    graphs[1].setTitre("valeur en stock MP");
    graphs[1].setUnite(" Ar");
    graphs[1].setColSpan(4);
    graphs[1].setIcon("shopping_cart");
    //graphs[1].setLienPage("vente/vente-liste.jsp");
    graphs[1].setBackgroundColor(backgroundColor);
    graphs[1].setCanvasId("caValeurStockmp");

    EtatStockParEntreeStandard vspf = new EtatStockParEntreeStandard();
    vspf.setNomTable("V_ETATSTOCK_ENTREE_STANDARD");
    String[] colValvspf = {"montantreste"};
    String[] legendevspf = {"Montant restant"};
    PageRecherche prvspf = new PageRecherche(vspf, request, paramDaty, paramDaty, 4, legendevspf, legendevspf.length);
    prvspf.setAWhere(" and(categorieIngredient = 'CAT008' or categorieIngredient = 'CAT001')");
    graphs[2] = new DashboardGraph(prvspf, colValvspf, null,legendevspf, DashboardGraphType.CARD);
    graphs[2].setTitre("valeur en stock PF + semi fini (produit fabriqu&eacute;)");
    graphs[2].setUnite(" Ar");
    graphs[2].setColSpan(4);
    graphs[2].setIcon("shopping_cart");
    //graphs[2].setLienPage("vente/vente-liste.jsp");
    graphs[2].setBackgroundColor(backgroundColor);
    graphs[2].setCanvasId("caValeurStockPF");
    String[] colDefautT =  {"daty"};

    DashboardApj da = new DashboardApj(graphs, u);
    da.setApres("grapheAnalyseStock.jsp");
    da.setLien(lien);
    da.getFormu().getChamp("daty1").setLibelle("Date Min");
    da.getFormu().getChamp("daty2").setLibelle("Date Max");
    da.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    da.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());


    graphs[0].creerObjetPage();

    for(DashboardGraph graph : graphs) {
        graph.setBackgroundColor(backgroundColor);
        graph.setCouleurs(palettes);
    }
    da.creerObjetPage(true);
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1>Tableau de bord</h1>
    </section>
    <section class="content">
        <form action="<%=lien%>?but=dashboard/grapheKPIStock.jsp" method="post" name="formulaire" id="dashboardForm">
            <%=da.getHtmlFormu()%>
        </form>
        <div class="row">
            <%=graphs[0].getHtml()%>
            <%=graphs[1].getHtml()%>
            <%=graphs[2].getHtml()%>
        </div>
    </section>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>
