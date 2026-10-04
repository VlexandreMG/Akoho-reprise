<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.evaluation.ObjectifAnnuel" %>
<%@ page import="paie.evaluation.ObjectifAnnuelDetail" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.evaluation.ObjectifAnnuel";
    String classeFille = "paie.evaluation.ObjectifAnnuelDetail";
    String nomTableFille = "OBJECTIF_ANNUEL_DETAIL";
    String colonneMere = "idObjectifannuel";
    String apres = "paie/evaluation/objectifannuel-fiche.jsp";

    ObjectifAnnuel mere = new ObjectifAnnuel();
    mere.setNomTable("OBJECTIF_ANNUEL");
    ObjectifAnnuelDetail fille = new ObjectifAnnuelDetail();
    fille.setNomTable("OBJECTIF_ANNUEL_DETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une objectif annuel");


    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idPersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("titre").setLibelle("Titre");
    pi.getFormu().getChamp("idPersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");


    pi.getFormufle().getChamp("objectif_0").setLibelle("Objectif");
    pi.getFormufle().getChamp("indicateurAtteinte_0").setLibelle("Indicateur d'atteinte");
    pi.getFormufle().getChamp("moyenAtteinte_0").setLibelle("Moyen d'atteinte");
    pi.getFormufle().getChamp("pourcentageAtteinte_0").setLibelle("Pourcentage d'atteinte");
    pi.getFormufle().getChamp("commentaire_0").setLibelle("Commentaire");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idObjectifannuel").getListeChamp(),false);

    String[] colOrdre = {"objectif","indicateurAtteinte","moyenAtteinte","pourcentageAtteinte","commentaire"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une objectif annuel");
    }
    for (int i = 0; i < taille; i++) {
        pi.getFormufle().getChamp("commentaire_" + i).setType("textarea");
        pi.getFormufle().getChamp("objectif_" + i).setType("textarea");
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

