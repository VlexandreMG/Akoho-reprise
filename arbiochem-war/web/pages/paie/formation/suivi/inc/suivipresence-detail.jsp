<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.evaluation.EvaluationDetailLib" %>
<%@ page import="paie.formation.FormationLib" %>
<%@ page import="paie.formation.suivi.SuiviPresenceFilleLib" %>

<% try{
    SuiviPresenceFilleLib o = new SuiviPresenceFilleLib();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","personnelLib","presence","dateseance", "nbheureeffectue"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idsuivipresencemere='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"ID","Personnel","Pr&eacute;sence","Date de s&eacute;ance", "Nombre d'heure &eacute;ffectu&eacute;es"};
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

