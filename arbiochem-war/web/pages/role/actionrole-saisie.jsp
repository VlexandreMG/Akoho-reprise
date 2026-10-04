<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="utilisateur.ActionRole" %>
<%@ page import="affichage.Liste" %>
<%@ page import="utilitaire.ConstanteUser" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="lc.Direction" %>
<%@ page import="java.util.Arrays" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "utilisateur.ActionRole";
    String nomTable = "ACTIONROLE";
    String apres = "role/role-fiche.jsp";

    ActionRole o = new ActionRole();
    o.setNomTable("ACTIONROLE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Ajouts d'une Gestion de r&ocirc;les");

    Liste[] liste = new Liste[3];

    Direction liste0 = new Direction();
    liste0.setNomTable("DIRECTION_LISTE");
    liste[0] = new Liste("direction",liste0,"libelledir","idDir");

    liste[1] = new Liste("action", ConstanteUser.actionParRole, ConstanteUser.actionParRole);

    liste[2] = new Liste("groupeTable", ConstanteUser.listePacquet, ConstanteUser.listePacquetID);
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("nomTableObjet").setLibelle("Nom Table");
    pi.getFormu().getChamp("nomTableObjet").setPageAppelComplete("bean.TypeObjet","id","listeTable");

    pi.getFormu().getChamp("action").setLibelle("Action");
    pi.getFormu().getChamp("roleminimum").setLibelle("R&ocirc;le minimum");
    pi.getFormu().getChamp("direction").setLibelle("Direction");
    pi.getFormu().getChamp("utilisateur").setLibelle("Utilisateur");
    pi.getFormu().getChamp("utilisateur").setPageAppelComplete("utilisateur.Utilisateur","refuser","utilisateur");

    pi.getFormu().getChamp("groupeTable").setLibelle("Groupe");
 
    String[] ordre = {"nomTableObjet","action","groupeTable","direction","utilisateur","roleminimum",};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("");
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

