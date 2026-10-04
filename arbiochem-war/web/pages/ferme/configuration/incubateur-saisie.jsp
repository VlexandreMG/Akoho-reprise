<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="ferme.configuration.Incubateur" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "ferme.configuration.Incubateur",
                nomtable = "INCUBATEUR",
                apres = "ferme/configuration/incubateur-fiche.jsp",
                titre = "Cr&eacute;ation d'un incubateur";

        if(request.getParameter("acte")!=null){
            titre = "Modification d'un incubateur";
        }

        Incubateur s = new Incubateur();
        s.setNomTable("INCUBATEUR");
        PageInsert pi = new PageInsert(s, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("val").setLibelle("Nom de l'incubateur");
        pi.getFormu().getChamp("desce").setLibelle("Remarque");
        pi.getFormu().getChamp("capacite").setLibelle("Capacit&eacute;");
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
