<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.inspection.HistoriqueInspectionLib" %>
<%@ page import="maintenance.inspection.HistoriqueInspectionMere" %>

<% try{ 
    HistoriqueInspectionLib o = new HistoriqueInspectionLib();
    o.setNomTable("HISTORIQUEINSPECTIONLIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idInspecteurLib","daty","heure","remarque"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        String id = request.getParameter("id");
        pr.setAWhere(" and idElement ='"+id+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Inspecteur","Date","Heure","Remarque"};
    pr.getTableau().setLienFille("maintenance/ressources/machine/inc/historique-inspection-fille.jsp&id=");
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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

