<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="ferme.aliment.DistributionAliment"%>
<%@page import="ferme.aliment.DistributionAlimentDetail"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageInsert"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="java.util.Date" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.Parquet" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    DistributionAliment mere = new DistributionAliment();
    DistributionAlimentDetail fille = new DistributionAlimentDetail();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idFerme").setLibelle("Ferme");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idLot").setLibelle("Lot");
    pi.getFormu().getChamp("idFerme").setPageAppelComplete("magasin.Magasin","id","MAGASIN2");
    pi.getFormu().getChamp("idLot").setPageAppelComplete("ferme.lot.Lot","id","LOT");
    pi.getFormu().getChamp("etat").setVisible(false);

    Liste[] liste = new Liste[2];
    Batiment b = new Batiment();
    liste[0] = new Liste("idBatiment",b,"nomBatiment","id");
    ParquetBatiment p = new ParquetBatiment();
    liste[1] = new Liste("idParquet",p,"val","id");
    liste[0].setDeroulanteDependante(liste[1],"idbatiment","onchange");
    pi.getFormufle().changerEnChamp(liste);

    pi.getFormufle().getChamp("idParquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("idBatiment_0").setLibelle("Batiment");
    pi.getFormufle().getChamp("idAliment_0").setLibelle("Aliment");
    pi.getFormufle().getChamp("idLotStock_0").setLibelle("Lot Stock");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("rationParTete_0").setLibelle("Ration par t&ecirc;te");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMere"), false);
    //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idParquet"),"ferme.configuration.Parquet","id","PARQUET","","");
    //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idBatiment"),"ferme.configuration.Batiment","id","BATIMENT","","");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idAliment"),"produits.Ingredients","id","AS_INGREDIENTS","","");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idLotStock"),"stock.MvtStock","id","MVTSTOCK","","");

    String classeMere = "ferme.aliment.DistributionAliment";
    String classeFille = "ferme.aliment.DistributionAlimentDetail";
    String butApresPost = "ferme/aliment/distributionaliment-fiche.jsp";
    String colonneMere = "idMere";
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <%
        if (request.getParameter("acte")!=null && request.getParameter("acte")!=""){
            out.println("<h1>Modification du distribution d'aliment</h1>");
        }else{
            out.println("<h1>Saisie d'une distribution d'aliment</h1>");
        }
    %>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
        </div>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>
</div>
</script>
<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>
