<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formateur.ModulePrestataire" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.formateur.ModulePrestataire";
    String nomTable = "MODULE_PRESTATAIRE";
    String apres = "paie/formateur/formateur-fiche.jsp";

    String idFormateur = request.getParameter("idFormateur");

    ModulePrestataire o = new ModulePrestataire();
    o.setNomTable("MODULE_PRESTATAIRE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une module formateur");

    if (idFormateur != null){
        pi.getFormu().getChamp("idformateur").setDefaut(idFormateur);
        pi.getFormu().getChamp("idformateur").setAutre("readonly");
    }


    pi.getFormu().getChamp("idformateur").setLibelle("Formateur");
    pi.getFormu().getChamp("module").setLibelle("Module");
    pi.getFormu().getChamp("idformateur").setPageAppelComplete("paie.formateur.Formateur","id","FORMATEUR","id","id");
 
    String[] ordre = {"idformateur","module"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une module formateur");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=paie/formateur/apresFormateurModule.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
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

