<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.couvoir.TriageQualitePoussin" %>
<%@ page import="ferme.couvoir.TriageQualitePoussinDetail" %>
<%@ page import="ferme.configuration.Eclosoir" %>
<%@ page import="ferme.configuration.Incubateur" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%@ page import="ferme.configuration.QualitePoussin" %>
<%@ page import="affichage.Liste" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.couvoir.TriageQualitePoussin";
    String classeFille = "ferme.couvoir.TriageQualitePoussinDetail";
    String nomTableFille = "TRIAGEQUALITEPOUSSINDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/couvoir/triagequalitepoussin-fiche.jsp";

    TriageQualitePoussin mere = new TriageQualitePoussin();
    mere.setNomTable("TRIAGEQUALITEPOUSSIN");
    TriageQualitePoussinDetail fille = new TriageQualitePoussinDetail();
    fille.setNomTable("TRIAGEQUALITEPOUSSINDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie triage qualite poussin");

    Liste[] liste = new Liste[2];
    Eclosoir liste0 = new Eclosoir();
    liste0.setNomTable("ECLOSOIR");
    liste[0] = new Liste("ideclosoir",liste0,"val","id");
    Incubateur liste1 = new Incubateur();
    liste1.setNomTable("INCUBATEUR");
    liste[1] = new Liste("idincubateur",liste1,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idlot").setLibelle("Lot");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("qtepoussinacontroler").setLibelle("Quantit&eacute; de poussins &agrave; contr&ocirc;ler");
    pi.getFormu().getChamp("ideclosoir").setLibelle("&Eacute;closoir");
    pi.getFormu().getChamp("idincubateur").setLibelle("Incubateur");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idlot").setPageAppelComplete("ferme.lot.Lot","id","LOT","id","id");

    Liste[] listeFille = new Liste[3];
    ParquetBatiment listeFille1 = new ParquetBatiment();
    listeFille1.setNomTable("PARQUET_BATIMENT_LIB");
    listeFille[1] = new Liste("idparquet",listeFille1,"val","id");
    Batiment listeFille0 = new Batiment();
    listeFille0.setNomTable("BATIMENT");
    listeFille[0] = new Liste("idbatiment",listeFille0,"nomBatiment","id");
    listeFille[0].ajouterVide();
    listeFille[0].setDeroulanteDependante(listeFille[1],"idbatiment","onchange");
    QualitePoussin listeFille2 = new QualitePoussin();
    listeFille2.setNomTable("QUALITEPOUSSIN");
    listeFille[2] = new Liste("idqualite",listeFille2,"val","id");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idbatiment_0").setLibelle("B&acirc;timent");
    pi.getFormufle().getChamp("idparquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("idqualite_0").setLibelle("Qualit&eacute;");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);

    String[] colOrdre = {"idbatiment","idparquet","idqualite","qte"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification triage qualite poussin");
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

