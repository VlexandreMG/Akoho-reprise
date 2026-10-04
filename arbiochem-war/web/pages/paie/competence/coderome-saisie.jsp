<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.competence.CodeRome" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.competence.CodeRome";
    String nomTable = "code_rome";
    String apres = "paie/competence/coderome-fiche.jsp";

    CodeRome o = new CodeRome();
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'une code rome");


    pi.getFormu().getChamp("code").setLibelle("Code");
    pi.getFormu().getChamp("idsousfamille").setLibelle("Sous-famille");
    pi.getFormu().getChamp("idsousfamille").setPageAppelComplete("paie.competence.SousFamillePro","id","sous_famille_pro","","");


    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un code");
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
