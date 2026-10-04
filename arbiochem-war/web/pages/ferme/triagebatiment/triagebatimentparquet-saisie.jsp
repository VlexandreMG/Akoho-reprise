<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.triageBatiment.TriageBatimentParquet" %>
<%@ page import="ferme.triageBatiment.TriageBatimentParquetDetail" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="ferme.configuration.Parquet" %>
<%@ page import="ferme.utils.ConstanteFerme" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%@ page import="ferme.configuration.QualitePoussin" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.triageBatiment.TriageBatimentParquet";
    String classeFille = "ferme.triageBatiment.TriageBatimentParquetDetail";
    String nomTableFille = "TRIAGEBATIMENTPARQUETDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/triagebatiment/triagebatimentparquet-fiche.jsp";

    String idLot = request.getParameter("idLot");

    TriageBatimentParquet mere = new TriageBatimentParquet();
    mere.setNomTable("TRIAGEBATIMENTPARQUET");
    TriageBatimentParquetDetail fille = new TriageBatimentParquetDetail();
    fille.setNomTable("TRIAGEBATIMENTPARQUETDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie triage batiment par parquet");


    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idlot").setLibelle("lot");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("dispomale").setLibelle("M&acirc;les disponibles");
    pi.getFormu().getChamp("dispofemelle").setLibelle("Femelles disponibles");
    pi.getFormu().getChamp("idlot").setPageAppelComplete("ferme.lot.Lot","id","LOT","id","id");
    if(idLot != null && !idLot.isEmpty()){
        pi.getFormu().getChamp("idlot").setDefaut(idLot);
        pi.getFormu().getChamp("idlot").setAutre("readonly");
        double femelleDispo= mere.getDisponnibleLib(idLot,ConstanteFerme.IDSEXEFEMELLE, ConstanteFerme.qualiteConforme,null);
        double maleDispo= mere.getDisponnibleLib(idLot,ConstanteFerme.IDSEXEMALE,ConstanteFerme.qualiteConforme,null);
        pi.getFormu().getChamp("dispomale").setDefaut(Double.toString(maleDispo));
        pi.getFormu().getChamp("dispofemelle").setDefaut(Double.toString(femelleDispo));
        pi.getFormu().getChamp("dispomale").setAutre("readonly");
        pi.getFormu().getChamp("dispofemelle").setAutre("readonly");
    }


    Liste[] liste = new Liste[4];
    TypeObjet sexe = new TypeObjet();
    sexe.setNomTable("SEXE");
    liste[0] = new Liste("idsexe", sexe, "val", "id");
    ParquetBatiment parquet = new ParquetBatiment();
    liste[2] = new Liste("idparquet", parquet, "val", "id");
    liste[1] = new Liste("idbatiment", new Batiment(), "nomBatiment", "id");
    liste[1].setDeroulanteDependante(liste[2],"idbatiment","onchange");
    QualitePoussin qualitePoussin = new QualitePoussin();
    liste[3] = new Liste("idqualite", qualitePoussin, "val", "id");
    pi.getFormufle().changerEnChamp(liste);
    pi.getFormufle().getChamp("idbatiment_0").setLibelle("B&acirc;timent");
    pi.getFormufle().getChamp("idparquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("idsexe_0").setLibelle("Sexe");
    pi.getFormufle().getChamp("idqualite_0").setLibelle("Qualit&eacute;");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
//    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idbatiment"),"ferme.configuration.Batiment","id","BATIMENT","id","id");
//    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idparquet"),"ferme.configuration.Parquet","id","PARQUET","id","id");
//    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idsexe"),"bean.TypeObjet","id","SEXE","id","val");
//    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idqualite"),"ferme.configuration.QualitePoussin","id","QUALITEPOUSSIN","id","id");

    String[] colOrdre = {"idbatiment","idparquet","idsexe","idqualite","qte"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification triage batiment par parquet");
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

