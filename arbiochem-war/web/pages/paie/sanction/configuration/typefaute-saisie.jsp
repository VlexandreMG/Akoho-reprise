
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@ page import="paie.sanction.configuration.TypeFaute" %>
<%
    try {
        TypeFaute a = new TypeFaute();
        a.setNomTable("TYPEFAUTE");
        String titre="Saisie d'un type de faute";
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification du type de faute";
        }
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("val").setLibelle("Valeur");
        pi.getFormu().getChamp("desce").setLibelle("D&eacute;scription");

        String classe = "paie.sanction.configuration.TypeFaute";

        String butApresPost = "paie/sanction/configuration/typefaute-fiche.jsp";
        String nomTable = "TYPEFAUTE";
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
