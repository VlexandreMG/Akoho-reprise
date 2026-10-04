<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="vente.Vente" %>
<%@ page import="declaration.LiaisonCodeImpot" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="utils.ImportContext" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String[] tId;
    String idMere = null;
    String typeavance = null;
%>
<%
    try {
        nomtable = request.getParameter("nomtable");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
        String classe = request.getParameter("classe");
        tId = request.getParameterValues("ids");
        String classefille = request.getParameter("classefille");
        ClassMAPTable mere = null;
        ClassMAPTable fille = null;
        String nombreDeLigne = request.getParameter("nombreLigne");
        int nbLine = Utilitaire.stringToInt(nombreDeLigne);
        idMere = request.getParameter("idMere");
        bute += "&id=" + request.getParameter("idFichePoste");
        if (acte != null && acte.compareToIgnoreCase("insertFilleSeul") == 0) {
            mere = (ClassMAPTable) (Class.forName(classe).newInstance());
            fille = (ClassMAPTable) (Class.forName(classefille).newInstance());
            PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
            ClassMAPTable[] cfille = p.getObjectFilleAvecValeur();
            u.createObject(cfille);

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<% }
} catch (Exception ex) {
    ex.printStackTrace(); %>
<script type="text/javascript">alert("<%=ex.getMessage()%>"); history.back();</script>
<% return; } %>
</html>