<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="ferme.vaccination.*"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageInsert"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Date" %>
<%
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    VaccinationPoussin mere = new VaccinationPoussin();
    VaccinationPoussinDetail fille = new VaccinationPoussinDetail();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idLot").setLibelle("Lot");
    pi.getFormu().getChamp("idLot").setPageAppelComplete("ferme.lot.Lot","id","LOT");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("etat").setVisible(false);

    pi.getFormufle().getChamp("idBatiment_0").setLibelle("Batiment");
    pi.getFormufle().getChamp("idParquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("idTypeVaccination_0").setLibelle("Type de vaccination");
    pi.getFormufle().getChamp("idMaladiePoussin_0").setLibelle("Maladie");
    pi.getFormufle().getChamp("idVaccin_0").setLibelle("Vaccin");
    pi.getFormufle().getChamp("idModeAdministration_0").setLibelle("Mode d'administration");
    pi.getFormufle().getChamp("qteDose_0").setLibelle("Quantit&eacute; / Dose");
    pi.getFormufle().getChamp("heureDebut_0").setLibelle("Heure d&eacute;but");
    pi.getFormufle().getChamp("heureFin_0").setLibelle("Heure fin");
    pi.getFormufle().getChamp("dateExpiration_0").setLibelle("Date d'expiration");

    for(int i=0;i<nombreLigne;i++){
        pi.getFormufle().getChamp("heureDebut_"+i).setType("time");
        pi.getFormufle().getChamp("heureFin_"+i).setType("time");
    }
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMere"), false);

    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idBatiment"),"ferme.configuration.Batiment","id","BATIMENT","","");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idParquet"),"ferme.configuration.Parquet","id","PARQUET","","");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idMaladiePoussin"),"bean.TypeObjet","id","MALADIEPOUSSIN","","");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idVaccin"),"bean.TypeObjet","id","VACCINPOUSSIN","","");

    TypeObjet typeVaccination = new TypeObjet("typevaccination");
    TypeObjet modeAdministration = new TypeObjet("modeadministrationvaccin");
    Liste[] listesFille = new Liste[2];
    listesFille[0] = new Liste("idTypeVaccination", typeVaccination, "val", "id");
    listesFille[1] = new Liste("idModeAdministration", modeAdministration, "val", "id");
    pi.getFormufle().changerEnChamp(listesFille);
    pi.getFormufle().getChamp("idTypeVaccination_0").setLibelle("Type de vaccination");
    pi.getFormufle().getChamp("idModeAdministration_0").setLibelle("Mode d'administration");

    String classeMere = "ferme.vaccination.VaccinationPoussin";
    String classeFille = "ferme.vaccination.VaccinationPoussinDetail";
    String butApresPost = "ferme/vaccination/vaccinationpoussin-fiche.jsp";
    String colonneMere = "idMere";
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <%
        if (request.getParameter("acte")!=null && request.getParameter("acte")!=""){
            out.println("<h1>Modification de la vaccination des poussins</h1>");
        }else{
            out.println("<h1>Saisie d'une vaccination des poussins</h1>");
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