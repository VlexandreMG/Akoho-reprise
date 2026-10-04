<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="ferme.configuration.*"%>
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
<%
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Batiment mere = new Batiment();
    BatimentDetail fille = new BatimentDetail();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idFerme").setLibelle("Ferme");
    pi.getFormu().getChamp("nomBatiment").setLibelle("Nom du batiment");
    pi.getFormu().getChamp("Capacite").setLibelle("Capacit&eacute;");
    pi.getFormu().getChamp("densite").setLibelle("Densit&eacute;");
    pi.getFormu().getChamp("longueur").setLibelle("Longueur");
    pi.getFormu().getChamp("largeur").setLibelle("Largeur");
    pi.getFormu().getChamp("idFerme").setPageAppelComplete("magasin.Magasin","id","MAGASIN2");

    pi.getFormufle().getChamp("idParquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("capacite_0").setLibelle("Capacit&eacute;");
    pi.getFormufle().getChamp("idLot_0").setLibelle("Lot");
    pi.getFormufle().getChamp("idSexe_0").setLibelle("Sexe");
    pi.getFormufle().getChamp("densite_0").setLibelle("Densit&eacute;");
    pi.getFormufle().getChamp("surface_0").setLibelle("Surface");
    pi.getFormufle().getChamp("effectif_0").setLibelle("Effectif");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMere"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("capacite"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("effectif"), false);
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idParquet"),"ferme.configuration.Parquet","id","PARQUET","","");
    affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idParquet"), "ferme/configuration/parquet-saisie.jsp","id;val");
    pi.getFormufle().getChampMulitple("idLot").setVisible(false);
    // affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idLot"),"ferme.lot.Lot","id","LOT","","");

    affichage.Liste[] listef = new Liste[1];
    TypeObjet sexe=new TypeObjet();
    sexe.setNomTable("SEXE");
    listef[0]=new Liste("idSexe",sexe,"val","id");
    pi.getFormufle().changerEnChamp(listef);
    pi.getFormufle().getChamp("idSexe_0").setLibelle("Sexe");

    String classeMere = "ferme.configuration.Batiment";
    String classeFille = "ferme.configuration.BatimentDetail";
    String butApresPost = "ferme/configuration/batiment-fiche.jsp";
    String colonneMere = "idMere";
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <%
        if (request.getParameter("acte")!=null && request.getParameter("acte")!=""){
            out.println("<h1>Modification du Batiment</h1>");
        }else{
            out.println("<h1>Saisie d'un batiment</h1>");
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
