<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.travaux.ResultatMaintenanceLib" %>
<%@ page import="maintenance.travaux.OrdreTravaux" %>

<% try{ 
    ResultatMaintenanceLib o = new ResultatMaintenanceLib();
    o.setNomTable("RESULTATMAINTENANCELIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"daty","idpersonnellib","etatmachinelib","designation","prochainedaty","prochaineetape"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setAWhere(" and idordretravaux='"+request.getParameter("id")+"'");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Date","Responsable","&Eacute;tat","D&eacute;signation","Prochaine Date","Prochaine &eacute;tape"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
//    pr.creerObjetPage();
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        } else{ %>
            <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

