<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="ferme.configuration.QualitePoussin" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "ferme.configuration.QualitePoussin",
                nomtable = "QUALITEPOUSSIN",
                apres = "ferme/configuration/qualitepoussin-fiche.jsp",
                titre = "Cr&eacute;ation d'une qualit&eacute; poussin";

        if(request.getParameter("acte")!=null){
            titre = "Modification d'une qualit&eacute; poussin";
        }

        QualitePoussin s = new QualitePoussin();
        s.setNomTable("QUALITEPOUSSIN");
        PageInsert pi = new PageInsert(s, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("val").setLibelle("Libell&eacute;");
        pi.getFormu().getChamp("desce").setLibelle("Remarque");
        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
