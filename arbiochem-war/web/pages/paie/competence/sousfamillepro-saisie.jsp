<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.competence.SousFamillePro" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.competence.SousFamillePro";
    String nomTable = "sous_famille_pro";
    String apres = "paie/competence/sousfamillepro-fiche.jsp";

    SousFamillePro o = new SousFamillePro();
    o.setNomTable("sous_famille_pro");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'une sous famille professionnelle");


    pi.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("idfamille").setPageAppelComplete("paie.competence.FamilleProfessionnelle","id","famille_professionnelle","","");
    pi.getFormu().getChamp("idfamille").setLibelle("Famille");

    String[] ordre = {"val","desce","idfamille"};
    pi.getFormu().setOrdre(ordre);


    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un sous famille professionnelle");
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
