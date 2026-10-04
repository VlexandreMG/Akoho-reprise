<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.*" %>
<%@ page import="produits.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.DepenseSaisie" %>
<%@ page import="faturefournisseur.DepenseFilleSaisie" %>
<%@ page import="paie.formation.action.ActionFormationBack" %>

<%  try {
    String[] tId;
    String nomtable = request.getParameter("nomtable");
    String lien = (String) session.getValue("lien");
    UserEJB u = (UserEJB) session.getAttribute("u");
    String acte = request.getParameter("acte");
    String bute = request.getParameter("bute");
    String classe = request.getParameter("classe");
    String id = request.getParameter("id");
    ClassMAPTable actionformation = null;

    if (acte != null && acte.compareToIgnoreCase("marquerOui") == 0) {
        actionformation = (ClassMAPTable) (Class.forName(classe).newInstance());
        ActionFormationBack actionformations = (ActionFormationBack) actionformation;
        actionformations.setId(id);
        actionformations.marquerOui(u.getUser().getTuppleID());
         %>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<% }

} catch (Exception e) {
    e.printStackTrace(); %>
<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");history.back();</script>
<% } %>