<%-- 
    Document   : decalage-prevision-saisie
    Created on : 23 ao�t 2024, 17:32:14
    Author     : Mendrika
--%>

<%@page import="prevision.mapping.DecalagePrevision"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="caisse.ReportCaisse"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%> 
<%@page import="bean.TypeObjet"%> 
<%@page import="affichage.Liste"%>
<%@ page import="affichage.PageInsertMultiple" %>

<%
    try{
    String autreparsley = "data-parslsey-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "prevision.mapping.DecalagePrevision",
            nomtable = "DECALAGEPREVISION",
            apres = "prevision/prevision-fiche.jsp",
            titre = "Decalage prevision";
    
    DecalagePrevision  decalage = new DecalagePrevision();
    int taille = 10;
    decalage.setNomTable("DECALAGEPREVISION");
    PageInsertMultiple pi = new PageInsertMultiple(decalage, decalage, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormufle().getChamp("idPrevision_0").setLibelle("Prevision");
    pi.getFormufle().getChamp("debit_0").setLibelle("D&eacute;bit");
    pi.getFormufle().getChamp("debit_0").setDefaut(request.getParameter("debit"));
    pi.getFormufle().getChamp("credit_0").setLibelle("Cr&eacute;dit");
//    pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
//    pi.getFormufle().getChamp("idDevise_0").setDefaut(request.getParameter("devise"));
    pi.getFormufle().getChamp("datyNouveau_0").setLibelle("Date");

    affichage.Champ.setAutre(pi.getFormufle().getChampFille("idPrevision"), "readonly");
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("credit"), request.getParameter("credit"));
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("idPrevision"), request.getParameter("id"));
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("datyNouveau"), Utilitaire.dateDuJour());
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);

    pi.preparerDataFormu();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>
    
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%
        out.println(pi.getFormufle().getHtmlTableauInsert());
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
