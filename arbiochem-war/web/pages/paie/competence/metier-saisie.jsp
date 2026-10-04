<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.competence.Metier" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.competence.Metier";
    String nomTable = "metier";
    String apres = "paie/competence/metier-fiche.jsp";

    Metier o = new Metier();
    o.setNomTable("Metier");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'un m&eacute;tier");


    pi.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("idcoderome").setPageAppelComplete("paie.competence.CodeRome","id","code_rome","","");
    pi.getFormu().getChamp("idcoderome").setLibelle("Code ROME");
    pi.getFormu().getChamp("idFonction").setLibelle("Fonction");
    pi.getFormu().getChamp("idFonction").setPageAppelComplete("paie.edition.PaieFonction","id","paie_fonction","","");

    String[] ordre = {"val","desce","idcoderome"};
    pi.getFormu().setOrdre(ordre);


    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un M&eacute;tier");
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
