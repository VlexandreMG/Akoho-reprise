<%@page import="facture.ReferenceFacture"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="mg.cnaps.compta.ConstanteCompta" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "facture.ReferenceFacture",
                nomtable = "REFERENCEFACTURE",
                apres = "facture/reference-facture-fiche.jsp",
                titre = "Saisie d'une r&eacute;f&eacute;rence de la facture";
        ReferenceFacture  rf = new ReferenceFacture();
        rf.setNomTable("REFERENCEFACTURE");
        PageInsert pi = new PageInsert(rf, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("idFacture").setLibelle("facture");
        if(request.getParameter("id")!=null){
            pi.getFormu().getChamp("idfacture").setDefaut(request.getParameter("id"));
        }
        pi.getFormu().getChamp("idFacture").setAutre("readonly");
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
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
