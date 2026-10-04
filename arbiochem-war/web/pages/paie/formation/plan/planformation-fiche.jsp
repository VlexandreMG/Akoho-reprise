<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.formation.plan.PlanFormationAnnuelLib" %>
<%@ page import="constante.ConstanteEtat" %>
<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    PlanFormationAnnuelLib o = new PlanFormationAnnuelLib();
    o.setNomTable("PLANFORMATIONANNUELLELIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un plan de formation");
    String id = pc.getBase().getTuppleID();
     o = (PlanFormationAnnuelLib) pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("annee").setLibelle("Ann&eacute;e");
    pc.getChampByName("libelle").setLibelle("Libell&eacute;");
    pc.getChampByName("budgettotalprevisionel").setLibelle("Budget total pr&eacute;visionnel");
    pc.getChampByName("budgettotalprevisionel").setVisible(false);
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
     pc.getChampByName("etat").setVisible(false);

    String[] ordre = {"id","annee","libelle","budgettotalprevisionel","daty","etat"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "paie/formation/plan/planformation-saisie.jsp&acte=update";
    String pageApresDelete = "paie/formation/plan/planformation-liste.jsp";
    String classe = "paie.formation.plan.PlanFormationAnnuel";

%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

<div class="row m-0">
    <div class="col-md-3"></div>
    <div class="col-md-6">
        <div class="box-fiche">
            <div class="box">
                <div class="box-body">
                    <%
                        out.println(pc.getHtml());
                    %>
                    <br/>
                    <div class="box-footer">
                      <% if (o.getEtat() < ConstanteEtat.getEtatValider()) {%>
                        <% if (!"dg".equalsIgnoreCase(u.getUser().getIdrole())) { %>
                                <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <% }%>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/formation/plan/planformation-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                     <% } %>
                      <% if (o.getEtat() == ConstanteEtat.getEtatValider()) {%>
                        <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=paie/formation/action/actionformation-saisie.jsp&idplanformation=" + id%> " style="margin-right: 10px">Action de formation</a>
                  
                     <% } %>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

