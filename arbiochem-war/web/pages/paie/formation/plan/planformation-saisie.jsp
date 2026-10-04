<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formation.plan.PlanFormationAnnuel" %>
<%@ page import="utilitaire.*" %>
<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.formation.plan.PlanFormationAnnuel";
    String nomTable = "PLAN_FORMATION_ANNUEL";
    String apres = "paie/formation/plan/planformation-fiche.jsp";

    PlanFormationAnnuel o = new PlanFormationAnnuel();
    o.setNomTable("PLAN_FORMATION_ANNUEL");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un plan de formation");


    pi.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
    pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("budgettotalprevisionel").setLibelle("Budget total pr&eacute;visionnel");
    pi.getFormu().getChamp("budgettotalprevisionel").setVisible(false);
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("etat").setVisible(false);

    String[] ordre = {"annee","libelle","budgettotalprevisionel","daty"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un plan de formation");
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

