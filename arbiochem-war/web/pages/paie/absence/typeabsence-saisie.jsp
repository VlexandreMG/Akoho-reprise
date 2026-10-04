<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.absence.TypeAbsence" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.absence.TypeAbsence";
    String nomTable = "TYPE_ABSENCE";
    String apres = "paie/absence/typeabsence-fiche.jsp";

    TypeAbsence o = new TypeAbsence();
    o.setNomTable("TYPE_ABSENCE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un type absence");

    Liste[] listes = new Liste[1];
    TypeObjet frequence = new TypeObjet();
    frequence.setNomTable("FREQUENCE_CONGE");
    listes[0] = new Liste("frequence", frequence, "val", "id");

    pi.getFormu().changerEnChamp(listes);
    pi.getFormu().getChamp("val").setLibelle("Nom");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("frequence").setLibelle("Frequence");
    pi.getFormu().getChamp("nbJour").setLibelle("Nombre de jour ");
    pi.getFormu().getChamp("etat").setVisible(false);
 
    String[] ordre = {"val","desce","frequence","nbJour"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un type absence");
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

