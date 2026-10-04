<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.evaluation.EvaluationFroid" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.evaluation.EvaluationFroid";
    String nomTable = "EVALUATION_FROID";
    String apres = "paie/evaluation/evaluationfroid-fiche.jsp";

    EvaluationFroid o = new EvaluationFroid();
    o.setNomTable("EVALUATION_FROID");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un &eacute;valuation froid");


    pi.getFormu().getChamp("idformationsuivi").setLibelle("Formation suivie");
    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("note").setLibelle("Note");
    pi.getFormu().getChamp("commentaire").setLibelle("Commentaire");
    pi.getFormu().getChamp("commentaire").setType("textarea");
    pi.getFormu().getChamp("dateevaluation").setLibelle("Date d'&eacute;valuation");
    pi.getFormu().getChamp("idformationsuivi").setPageAppelComplete("paie.formation.FormationSuivi","id","FORMATION_SUIVI","id","id");
    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");
 
    String[] ordre = {"idformationsuivi","idpersonnel","note","commentaire","dateevaluation"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un &eacute;valuation froid");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

