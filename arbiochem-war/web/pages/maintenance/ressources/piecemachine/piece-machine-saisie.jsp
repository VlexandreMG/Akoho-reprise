<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="piece.PieceMachine" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "piece.PieceMachine";
    String nomTable = "PIECEMACHINE";
    String idPiece = request.getParameter("idPiece");
    String idMachine = request.getParameter("idMachine");
    String apres = "maintenance/ressources/machine/machine-fiche.jsp&id="+idMachine+"&tab=inc/piece-liste";

    PieceMachine o = new PieceMachine();
    o.setNomTable("PIECEMACHINE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Attribuer une pi&egrave;ce &agrave; une machine");


    pi.getFormu().getChamp("idPiece").setLibelle("Pi&egrave;ce");
    pi.getFormu().getChamp("idMachine").setLibelle("Machine");
    //pi.getFormu().getChamp("idPiece").setPageAppelComplete("maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_PIECE","","");
    pi.getFormu().getChamp("idMachine").setPageAppelComplete("maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_MAINTENANCE","","");
    pi.getFormu().getChamp("idPiece").setPageAppelComplete("maintenance.ressources.IngredientMaintenanceLib","id","AS_INGREDIENT_PIECE","","");
    if (idPiece != null && !idPiece.isEmpty()){
        pi.getFormu().getChamp("idPiece").setDefaut(idPiece);
        pi.getFormu().getChamp("idPiece").setAutre("readonly");
        apres="maintenance/ressources/outils/outils-fiche.jsp&id="+idPiece+"&tab=inc/liste-machine";
    }
    if (idMachine != null && !idMachine.isEmpty()){
        pi.getFormu().getChamp("idMachine").setDefaut(idMachine);
        pi.getFormu().getChamp("idMachine").setAutre("readonly");
        apres="maintenance/ressources/machine/machine-fiche.jsp&id="+idMachine+"&tab=inc/piece-liste";
    }

 
    String[] ordre = {"idPiece","idMachine"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modifier l’attribution d’une pi&egrave;ce &agrave; une machine");
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

