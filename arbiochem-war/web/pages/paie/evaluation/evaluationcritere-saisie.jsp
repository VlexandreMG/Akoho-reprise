<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.evaluation.EvaluationCritere" %>
<%@ page import="affichage.Champ" %>
<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.evaluation.EvaluationCritere";
    String nomTable = "EVALUATION_CRITERE";
    String apres = "paie/evaluation/evaluationcritere-fiche.jsp";

    EvaluationCritere o = new EvaluationCritere();
    o.setNomTable("EVALUATION_CRITERE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un crit&egrave;re d’&eacute;valuation");


    pi.getFormu().getChamp("val").setLibelle("Valeur");
    pi.getFormu().getChamp("desce").setLibelle("Description");
 
    String[] ordre = {"val","desce"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un crit&egrave;re d’&eacute;valuation");
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

