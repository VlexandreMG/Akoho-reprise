<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="machine.ElementInspectionMachine" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "machine.ElementInspectionMachine";
    String nomTable = "ElementInspectionMachine";
    String apres = "maintenance/elementInspection/elementInspectionMachine-fiche.jsp";

    ElementInspectionMachine o = new ElementInspectionMachine();
    o.setNomTable("ElementInspectionMachine");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Attribution d’un &eacute;l&eacute;ment de contr&ocirc;le de la machine");


    pi.getFormu().getChamp("idElementInspection").setLibelle("&Eacute;l&eacute;ment &agrave; v&eacute;rifier");
    pi.getFormu().getChamp("idElementInspection").setPageAppelCompleteInsert("machine.ElementInspection", "id", "ELEMENTINSPECTION", "maintenance/elementInspection/elementInspection-saisie.jsp", "id;val");
    pi.getFormu().getChamp("idMachine").setLibelle("Machine");
    pi.getFormu().getChamp("idMachine").setPageAppelComplete("maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE_LIB","","");

    if(request.getParameter("idMachine")!=null&&request.getParameter("idMachine").compareToIgnoreCase("")!=0){
        apres="maintenance/ressources/machine/machine-fiche.jsp&id="+request.getParameter("idMachine")+"&tab=inc/element-inspection";
        pi.getFormu().getChamp("idMachine").setDefaut(request.getParameter("idMachine"));
        pi.getFormu().getChamp("idMachine").setAutre("readonly");
    }

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un &eacute;l&eacute;ments de contr&ocirc;");
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

