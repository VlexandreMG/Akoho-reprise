<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="poste.FicheCompetenceFP" %>
<%@ page import="affichage.Liste"%>
<%@ page import="poste.TypeCompetencesFP" %>
<%@ page import="affichage.Champ" %>
<%@ page import="paie.poste.ObjectifIndividuel" %>
<% try{ 
    String idficheposte = request.getParameter("idficheposte");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.poste.ObjectifIndividuel";
    String nomTable = "FP_OBJECTIF_INDIVIDUEL";
    String apres = "poste/ficheposte-fiche.jsp";
     int taille = 10;
    ObjectifIndividuel o = new ObjectifIndividuel();
    PageInsertMultiple pi = new PageInsertMultiple(o, o, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une fiche poste objectif individuel");

    for(int i=0;i<taille;i++){
               pi.getFormufle().getChamp("objectif_"+i).setType("textarea");
               pi.getFormufle().getChamp("kpi_"+i).setType("textarea");
    }
    pi.getFormu().getChamp("idficheposte").setVisible(false);
    pi.getFormufle().getChamp("objectif_0").setLibelle("Objectif");
    pi.getFormufle().getChamp("kpi_0").setLibelle("KPI");
    String[] ordre = {"idficheposte","objectif","kpi"};
    if(idficheposte != null){
        Champ.setDefaut(pi.getFormufle().getChampFille("idficheposte"),idficheposte);
        Champ.setVisible(pi.getFormufle().getChampFille("idficheposte"),false);
        ordre = new String[]{"objectif","kpi"};
    }

    pi.getFormufle().setColOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une fiche poste objectif individuel");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=poste/apresMultipleObjectif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());
          //  out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
          <input name="classefille" type="hidden" id="classefille" value="<%=mapping%>">
      <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
      <input name="idFichePoste" type="hidden" id="idFichePoste" value="<%=idficheposte%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

