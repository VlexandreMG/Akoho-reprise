<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.suiviJournalier.SuiviJournalier" %>
<%@ page import="ferme.suiviJournalier.SuiviJournalierDetail" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="magasin.Magasin" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.suiviJournalier.SuiviJournalier";
    String classeFille = "ferme.suiviJournalier.SuiviJournalierDetail";
    String nomTableFille = "SUIVIJOURNALIERDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/suiviJournalier/suivijournalier-fiche.jsp";

    SuiviJournalier mere = new SuiviJournalier();
    mere.setNomTable("SUIVIJOURNALIER");
    SuiviJournalierDetail fille = new SuiviJournalierDetail();
    fille.setNomTable("SUIVIJOURNALIERDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie suivi journalier");


    Liste[] listes = new Liste[1];
    listes[0] = new Liste("idferme", new Magasin(), "val", "id");
    pi.getFormu().changerEnChamp(listes);
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idferme").setLibelle("Ferme");
    pi.getFormu().getChamp("idferme").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("idlot").setLibelle("Lot");
    pi.getFormu().getChamp("etat").setVisible(false);
//    pi.getFormu().getChamp("idferme").setPageAppelComplete("magasin.Magasin","id","MAGASIN2","id","id");
    pi.getFormu().getChamp("idlot").setPageAppelComplete("ferme.lot.Lot","id","LOT","id","id");


    String apr = "";
    if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
        String idMag = request.getParameter("idferme");
        if(!Utilitaire.champNull(idMag).isEmpty()){
            apr = " AND idferme='"+idMag+"'";
        }

    }

    Liste[] liste = new Liste[2];
    ParquetBatiment parquet = new ParquetBatiment();
    liste[1] = new Liste("idparquet", parquet, "val", "id");
    if (!Utilitaire.champNull(apr).isEmpty()){
        liste[0] = new Liste("idbatiment", new Batiment(), "nomBatiment", "id",apr);
    } else {
        liste[0] = new Liste("idbatiment", new Batiment(), "nomBatiment", "id");
    }
    liste[0].ajouterVide();
    liste[0].setDeroulanteDependante(liste[1],"idbatiment","onchange");
    pi.getFormufle().changerEnChamp(liste);

    pi.getFormufle().getChamp("idbatiment_0").setLibelle("B&acirc;timent");
    pi.getFormufle().getChamp("idparquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("agejour_0").setLibelle("&Acirc;ge en jour");
    pi.getFormufle().getChamp("entree_0").setLibelle("Entr&eacute;e");
    pi.getFormufle().getChamp("tri_0").setLibelle("Tri");
    pi.getFormufle().getChamp("mortalite_0").setLibelle("Mortalit&eacute;");
    pi.getFormufle().getChamp("culls_0").setLibelle("Culls");
    pi.getFormufle().getChamp("consignesuraliment_0").setLibelle("Consigne sur aliment (g/poussin)");
    pi.getFormufle().getChamp("eau_0").setLibelle("Eau");
    pi.getFormufle().getChamp("temperaturemin_0").setLibelle("Temp&eacute;rature min");
    pi.getFormufle().getChamp("temperaturemax_0").setLibelle("Temp&eacute;rature max");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
//    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idbatiment"),"ferme.configuration.Batiment","id","BATIMENT","id","id");
//    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idparquet"),"ferme.configuration.Parquet","id","PARQUET","id","id");

    String[] colOrdre = {"idbatiment","idparquet","agejour","entree","tri","mortalite","culls","consignesuraliment","eau","temperaturemin","temperaturemax"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification suivi journalier");
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

