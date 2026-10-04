<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.planning.PlanningCpl" %>

<% try{ 
    PlanningCpl o = new PlanningCpl();
    String nomTablePlan = "PLANNING_DUREENONPROGRAMME";
    if ("true".equals(request.getParameter("fromAnalyse"))) {
        nomTablePlan = "PLANNING_DUREENONPROGRAMME";
    }
    o.setNomTable(nomTablePlan);
    String[] listeCrt = {"id","idMachineLib","datedebut"};
    String[] listeInt = {"datedebut"};
    String[] libEntete = {"datedebut","id","idMachineLib","duree","dureeNonProgramme"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Planning par machine");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/planning/planning-machine-liste.jsp");
    pr.getFormu().getChamp("idMachineLib").setLibelle("Machine");
    pr.getFormu().getChamp("id").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("datedebut1").setLibelle("Date min");
    pr.getFormu().getChamp("datedebut2").setLibelle("Date max");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=maintenance/ressources/machine/machine-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String[] libEnteteAffiche = {"Date","R&eacute;f&eacute;rence","Machine","Dur&eacute;e programm&eacute;e","Dur&eacute;e non programm&eacute;e"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

