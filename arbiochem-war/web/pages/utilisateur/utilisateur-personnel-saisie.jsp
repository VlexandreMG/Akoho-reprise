<%@page import="utilisateur.Role"%>
<%@page import="utilisateursocobis.UtilisateurStation"%>
<%@page import="paie.employe.UtilisateurPersonnel"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%
    try{
    UtilisateurPersonnel a = new UtilisateurPersonnel();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("idutilisateur").setLibelle("Utilisateur");
        pi.getFormu().getChamp("idutilisateur").setPageAppelComplete("utilisateursocobis.UtilisateurStation","refuser","utilisateur");
        pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
        pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel", "id", "log_personnel");
    //Variables de navigation
    String classe = "paie.employe.UtilisateurPersonnel";
    String butApresPost = "utilisateur/utilisateur-personnel-saisie.jsp";
    String nomTable = "utilisateur_personnel";
    //Generer les affichages
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Relier utilisateur et personnel</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
} %>

