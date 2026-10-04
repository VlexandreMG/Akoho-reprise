<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.production.ReceptionOAC" %>
<%@ page import="ferme.production.ReceptionOACDetail" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.Parquet" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="affichage.Liste" %>
<%@ page import="affichage.Champ" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.production.ReceptionOAC";
    String classeFille = "ferme.production.ReceptionOACDetail";
    String nomTableFille = "RECEPTIONOACDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/production/receptionoac-fiche.jsp";

    ReceptionOAC mere = new ReceptionOAC();
    mere.setNomTable("RECEPTIONOAC");
    ReceptionOACDetail fille = new ReceptionOACDetail();
    fille.setNomTable("RECEPTIONOACDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie reception OAC");

    Liste[] liste = new Liste[1];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("NUMEROCOLLECTE");
    liste[0] = new Liste("idnumerocollecte",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("datereception").setLibelle("Date de r&eacute;ception");
    pi.getFormu().getChamp("dateponte").setLibelle("Date de ponte");
    pi.getFormu().getChamp("datecollecte").setLibelle("Date de collecte");
    pi.getFormu().getChamp("idnumerocollecte").setLibelle("Num&eacute;ro de collecte");
    pi.getFormu().getChamp("heuredepartferme").setLibelle("Heure de d&eacute;part ferme");
    pi.getFormu().getChamp("heurearriveecouvoir").setLibelle("Heure d'arriv&eacute;e couvoir");
    pi.getFormu().getChamp("idresponsable").setLibelle("Responsable");
    pi.getFormu().getChamp("idchambrefroide").setLibelle("Chambre froide");
    pi.getFormu().getChamp("idchauffeur").setLibelle("Chauffeur");
    pi.getFormu().getChamp("idvehicule").setLibelle("V&eacute;hicule");
    pi.getFormu().getChamp("idProvenance").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("temperatureminvehicule").setLibelle("Temp&eacute;rature minimale du v&eacute;hicule");
    pi.getFormu().getChamp("temperaturemaxvehicule").setLibelle("Temp&eacute;rature maximale du v&eacute;hicule");
    pi.getFormu().getChamp("idresponsable").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL","id","id");
    pi.getFormu().getChamp("idchambrefroide").setPageAppelComplete("magasin.Magasin","id","MAGASIN2","id","id");
    pi.getFormu().getChamp("idchauffeur").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL","id","id");
    pi.getFormu().getChamp("idvehicule").setPageAppelComplete("ferme.configuration.Vehicule","id","VEHICULE","id","id");

    Liste[] listeFille = new Liste[3];
    ParquetBatiment listeFille1 = new ParquetBatiment();
    listeFille[1] = new Liste("idparquet",listeFille1,"val","id");
    Batiment listeFille0 = new Batiment();
    listeFille0.setNomTable("BATIMENT");
    listeFille[0] = new Liste("idbatiment",listeFille0,"nomBatiment","id");
    listeFille[0].ajouterVide();
    listeFille[0].setDeroulanteDependante(listeFille[1],"idbatiment","onchange");
    TypeObjet listeFille2 = new TypeObjet();
    listeFille2.setNomTable("QUALITETRIAGEOEUF");
    listeFille[2] = new Liste("idqualitetriageoeuf",listeFille2,"val","id");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idlot_0").setLibelle("Lot");
    pi.getFormufle().getChamp("idbatiment_0").setLibelle("B&acirc;timent");
    pi.getFormufle().getChamp("idparquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("idqualitetriageoeuf_0").setLibelle("Qualit&eacute; triage œuf");
    pi.getFormufle().getChamp("qterecus_0").setLibelle("Qt&eacute; re&ccedil;us");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idlot"),"ferme.lot.Lot","id","LOT","id","id");

    String[] colOrdre = {"idlot","idbatiment","idparquet","idqualitetriageoeuf","qterecus"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification reception OAC");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

