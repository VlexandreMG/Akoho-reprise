<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formation.FormationAffectation" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.formation.FormationAffectation";
    String nomTable = "FORMATION_AFFECTATION";
    String apres = "paie/formation/affectation/formationaffectation-fiche.jsp";

    FormationAffectation o = new FormationAffectation();
    o.setNomTable("FORMATION_AFFECTATION");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une affectation formation");


    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("idformation").setLibelle("Formation");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");
    pi.getFormu().getChamp("idformation").setPageAppelComplete("paie.formation.Formation","id","FORMATION","id","id");
 
    String[] ordre = {"idpersonnel","idformation"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une affectation formation");
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

