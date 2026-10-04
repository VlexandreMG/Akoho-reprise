<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.couvoir.Eclosion" %>
<%@ page import="ferme.couvoir.EclosionDetail" %>
<%@ page import="ferme.configuration.Incubateur" %>
<%@ page import="affichage.Champ" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.couvoir.Eclosion";
    String classeFille = "ferme.couvoir.EclosionDetail";
    String nomTableFille = "ECLOSIONDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/couvoir/eclosion-fiche.jsp";

    Eclosion mere = new Eclosion();
    mere.setNomTable("ECLOSION");
    EclosionDetail fille = new EclosionDetail();
    fille.setNomTable("ECLOSIONDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie eclosion");

    Liste[] liste = new Liste[4];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("ECLOSOIR");
    liste[0] = new Liste("ideclosoir",liste0,"val","id");
    Incubateur liste1 = new Incubateur();
    liste1.setNomTable("INCUBATEUR");
    liste[1] = new Liste("idincubateur",liste1,"val","id");
    ParquetBatiment parquet = new ParquetBatiment();
    liste[3] = new Liste("idparquet", parquet, "val", "id");
    liste[2] = new Liste("idbatiment", new Batiment(), "nomBatiment", "id");
    liste[2].ajouterVide();
    liste[2].setDeroulanteDependante(liste[3],"idbatiment","onchange");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idlot").setLibelle("Lot");
    pi.getFormu().getChamp("dateeclosion").setLibelle("Date d'&eacute;closion");
    pi.getFormu().getChamp("nombreoeufinitial").setLibelle("Nombre d'œufs initial");
    pi.getFormu().getChamp("ideclosoir").setLibelle("&Eacute;closoir");
    pi.getFormu().getChamp("idincubateur").setLibelle("Incubateur");
    pi.getFormu().getChamp("idbatiment").setLibelle("B&acirc;timent");
    pi.getFormu().getChamp("idparquet").setLibelle("Parquet");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idlot").setPageAppelComplete("ferme.lot.Lot","id","LOT","id","id");

    Liste[] listeFille = new Liste[1];
    TypeObjet listeFille0 = new TypeObjet();
    listeFille0.setNomTable("QUALITEECLOSION");
    listeFille[0] = new Liste("idqualiteeclosion",listeFille0,"val","id");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idqualiteeclosion_0").setLibelle("Qualit&eacute; &eacute;closion");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);

    String[] colOrdre = {"idqualiteeclosion","qte","remarque"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification eclosion");
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

