<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="maintenance.capacitejournalier.CapaciteJournalier" %>
<%@ page import="affichage.Liste"%>
<%@ page import="machine.Ligne" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "maintenance.capacitejournalier.CapaciteJournalier";
    String nomTable = "";
    String apres = "maintenance/configuration/capacite-journalier-fiche.jsp";

    CapaciteJournalier o = new CapaciteJournalier();
    o.setNomTable("");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("");

    Liste[] liste = new Liste[1];
    Ligne liste0 = new Ligne();
    liste0.setNomTable("LIGNE");
    liste[0] = new Liste("idLigne",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idLigne").setLibelle("Ligne");
    pi.getFormu().getChamp("capacite").setLibelle("Capacit&eacute;");
 
    String[] ordre = {"idLigne","capacite"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("");
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

