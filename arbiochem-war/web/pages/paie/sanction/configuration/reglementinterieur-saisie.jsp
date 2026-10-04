
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@ page import="paie.employe.sanction.RegleInterieur" %>
<%
    try {
        RegleInterieur a = new RegleInterieur();
        String nomTable = "REGLEMENTINTERIEUR";
        a.setNomTable(nomTable);

        String titre="Saisie d'une r&egrave;gle int&eacute;rieure";
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification d'une r&egrave;gle int&eacute;rieure";
        }

        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("descriptionRegle").setLibelle("D&eacute;scription de la r&egrave;gle");
        pi.getFormu().getChamp("numeroRegle").setLibelle("Num&eacute;ro de la r&egrave;gle");
        pi.getFormu().getChamp("niveau").setLibelle("Niveau");
        pi.getFormu().getChamp("niveau").setDefaut("1");

        String classe = "paie.employe.sanction.RegleInterieur";

        String butApresPost = "paie/sanction/configuration/reglementinterieur-fiche.jsp";

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1 align="center"><%=titre %></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
    }catch (Exception e) {
        e.printStackTrace();

    } %>
