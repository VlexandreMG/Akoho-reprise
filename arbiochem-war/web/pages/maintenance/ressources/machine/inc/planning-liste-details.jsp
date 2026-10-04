<%@page import="maintenance.planning.DemandeTravauxCpl"%>
<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<%@ page import="piece.PieceMachineLib" %>
<%@ page import="maintenance.planning.PlanningCpl" %>
<% try{
    PlanningCpl t = new PlanningCpl();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idTypeMaintenanceLib","datedebut","duree","estPeriodiqueLib","etatLib"};;
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idMachine='"+request.getParameter("id")+"' ORDER BY datedebut DESC");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().transformerDataString();
    String[] lienTableau = {pr.getLien() + "?but=maintenance/planning/planning-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attLien);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"ID","Type de maintenance","Date de d&eacute;but","Dur&eacute;e","Est p&eacute;riodique","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }
%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

