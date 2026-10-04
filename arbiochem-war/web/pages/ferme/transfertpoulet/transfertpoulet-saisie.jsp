<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="ferme.transfertpoulet.*"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageInsert"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%@ page import="java.util.Date" %>
<%
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    TransfertPoulet mere = new TransfertPoulet();
    TransfertPouletDetail fille = new TransfertPouletDetail();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idLot").setLibelle("Lot");
    pi.getFormu().getChamp("idLot").setPageAppelComplete("ferme.lot.Lot","id","LOT");
    pi.getFormu().getChamp("etat").setVisible(false);

    pi.getFormufle().getChamp("idControleur_0").setLibelle("Controleur");
    pi.getFormufle().getChamp("idChauffeur_0").setLibelle("Chauffeur");
    pi.getFormufle().getChamp("idVehicule_0").setLibelle("V&eacute;hicule");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMere"), false);
    affichage.Liste[] listef = new Liste[7];
    TypeObjet sexe=new TypeObjet();
    sexe.setNomTable("SEXE");
    listef[0]=new Liste("idSexe",sexe,"val","id");

    // Depart : ferme -> batiment -> parquet
    ParquetBatiment parquetDepart = new ParquetBatiment();
    listef[3] = new Liste("idParquetDepart",parquetDepart,"val","id");
    Batiment batimentDepart = new Batiment();
    batimentDepart.setNomTable("BATIMENT");
    listef[2] = new Liste("idBatimentDepart",batimentDepart,"nomBatiment","id");
    listef[2].ajouterVide();
    listef[2].setDeroulanteDependante(listef[3],"idbatiment","onchange");
    Magasin fermeDepart = new Magasin();
    fermeDepart.setNomTable("MAGASIN2");
    listef[1] = new Liste("idFermeDepart",fermeDepart,"val","id");
    listef[1].ajouterVide();
    listef[1].setDeroulanteDependante(listef[2],"idferme","onchange");

    // Arrivee : ferme -> batiment -> parquet
    ParquetBatiment parquetArrive = new ParquetBatiment();
    listef[6] = new Liste("idParquetArrive",parquetArrive,"val","id");
    Batiment batimentArrive = new Batiment();
    batimentArrive.setNomTable("BATIMENT");
    listef[5] = new Liste("idBatimentArrive",batimentArrive,"nomBatiment","id");
    listef[5].ajouterVide();
    listef[5].setDeroulanteDependante(listef[6],"idbatiment","onchange");
    Magasin fermeArrive = new Magasin();
    fermeArrive.setNomTable("MAGASIN2");
    listef[4] = new Liste("idFermeArrive",fermeArrive,"val","id");
    listef[4].ajouterVide();
    listef[4].setDeroulanteDependante(listef[5],"idferme","onchange");

    pi.getFormufle().changerEnChamp(listef);
    pi.getFormufle().getChamp("idSexe_0").setLibelle("Sexe");
    pi.getFormufle().getChamp("idFermeDepart_0").setLibelle("Ferme de d&eacute;part");
    pi.getFormufle().getChamp("idFermeArrive_0").setLibelle("Ferme d'arriv&eacute;e");
    pi.getFormufle().getChamp("idBatimentDepart_0").setLibelle("Batiment de d&eacute;part");
    pi.getFormufle().getChamp("idBatimentArrive_0").setLibelle("Batiment d'arriv&eacute;e");
    pi.getFormufle().getChamp("idParquetDepart_0").setLibelle("Parquet de d&eacute;part");
    pi.getFormufle().getChamp("idParquetArrive_0").setLibelle("Parquet d'arriv&eacute;e");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idControleur"),"paie.log.LogPersonnel","id","LOG_PERSONNEL","","");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idChauffeur"),"paie.log.LogPersonnel","id","LOG_PERSONNEL","","");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idVehicule"),"ferme.configuration.Vehicule","id","VEHICULE","","");


    String classeMere = "ferme.transfertpoulet.TransfertPoulet";
    String classeFille = "ferme.transfertpoulet.TransfertPouletDetail";
    String butApresPost = "ferme/transfertpoulet/transfertpoulet-fiche.jsp";
    String colonneMere = "idMere";
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <%
        if (request.getParameter("acte")!=null && request.getParameter("acte")!=""){
            out.println("<h1>Modification du transfert de poulet</h1>");
        }else{
            out.println("<h1>Saisie d'une tranfert de poulet</h1>");
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
