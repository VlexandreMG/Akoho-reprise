<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="depense.DepenseDiversFilleLib" %>
<%@ page import="bean.AdminGen" %>

<% try{ 
    DepenseDiversFilleLib o = new DepenseDiversFilleLib();
    o.setNomTable("DEPENSEDIVERSFILLELIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","designation","quantite","pu"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    pr.setAWhere(" and idMere = '" + request.getParameter("id")+"'");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","D&eacute;signation","Quantit&eacute;","Prix unitaire"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null) { %>
        <%= pr.getTableau().getHtml() %>
    <% } else{ %>
        <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <% } %>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

