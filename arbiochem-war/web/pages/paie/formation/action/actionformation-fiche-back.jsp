<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.formation.action.ActionFormationLib" %>
<%@ page import="constante.ConstanteEtat" %>
<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ActionFormationLib o = new ActionFormationLib();
    o.setNomTable("ACTION_FORMATION_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un action de formation");
    String id = pc.getBase().getTuppleID();
    o = (ActionFormationLib) pc.getBase();
    pc.getChampByName("idplanformationlib").setLibelle("Plan de formation");
    pc.getChampByName("idtypeformationlib").setLibelle("Type de formation");
    pc.getChampByName("idcategorieformationlib").setLibelle("Cat&eacute;gorie de formation");
    pc.getChampByName("idsemestrelib").setLibelle("Semestre");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idplanformation").setLibelle("Id plan formation");
    pc.getChampByName("idtypeformation").setLibelle("Id type formation");
    pc.getChampByName("idcategorieformation").setLibelle("Id cat&eacute;gorie formation");
    pc.getChampByName("formateur").setLibelle("Formateur");
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("intitule").setLibelle("Intitul&eacute;");
    pc.getChampByName("typeprestataire").setLibelle("Type prestataire");
    pc.getChampByName("idsemestre").setLibelle("Id semestre");
    pc.getChampByName("nbsessionprevus").setLibelle("Nb sessions pr&eacute;vues");
    pc.getChampByName("dureestagiaireheure").setLibelle("Dur&eacute;e stagiaire heure");
    pc.getChampByName("nbouvriersprevue").setLibelle("Nb ouvriers pr&eacute;vus");
    pc.getChampByName("nbcadreprevue").setLibelle("Nb cadres pr&eacute;vus");
    pc.getChampByName("objectif").setLibelle("Objectif");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("estrealiseelib").setLibelle("Achev&eacute;e");
    pc.getChampByName("idplanformation").setLien(lien+"?but=paie/formation/plan/planformation-fiche.jsp","id=");
    pc.getChampByName("idtypeformation").setLien(lien+"?but=paie/formation/configuration/typeformation-fiche.jsp","id=");

    String[] ordre = {"idplanformationlib","idtypeformationlib","idcategorieformationlib","idsemestrelib","id","idplanformation","idtypeformation","idcategorieformation","formateur","reference","intitule","typeprestataire","idsemestre","nbsessionprevus","dureestagiaireheure","nbouvriersprevue","nbcadreprevue","objectif","etat","estrealiseelib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "paie/formation/action/actionformation-saisie-back.jsp&acte=update";
    String pageApresDelete = "paie/formation/action/actionformation-liste.jsp";
    String pageCoutFormation = "paie/formation/cout/coutformation-saisie.jsp";
    String pageSessionFormation = "paie/formation/session/sessionformation-saisie.jsp";
    String classe = "paie.formation.action.ActionFormation";

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
                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                         <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/formation/action/actionformation-fiche-back.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                     <% } else { %>
                        <a class="btn btn-default pull-right"  href="<%= lien + "?but="+ pageCoutFormation +"&idActionFormation=" + id %>" style="margin-right: 10px">Co&ucirc;t de formation</a>
                            <a class="btn btn-default pull-right"  href="<%= lien + "?but="+ pageSessionFormation +"&idActionFormation=" + id %>" style="margin-right: 10px">Session de formation</a>
                                                    <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=paie/formation/action/apresAction-back.jsp&acte=marquerOui&id=" + request.getParameter("id") + "&bute=paie/formation/action/actionformation-fiche-back.jsp&classe=" + classe %>" style="margin-right: 10px"> Marquer comme realis&eacute;e</a>
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

