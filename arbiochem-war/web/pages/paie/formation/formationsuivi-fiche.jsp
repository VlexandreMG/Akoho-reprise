<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.formation.FormationSuiviLib" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    FormationSuiviLib o = new FormationSuiviLib();
    o.setNomTable("FORMATION_SUIVILIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un formation suivi");
    String id = pc.getBase().getTuppleID();
    o = (FormationSuiviLib) pc.getBase();
    String idFormationPlan = o.getIdformation();
    request.setAttribute("idFormationPlan", idFormationPlan);
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idformation").setLibelle("Id formation");
    pc.getChampByName("idpersonnel").setLibelle("Id Personnel");
    pc.getChampByName("idpersonnellib").setLibelle("Nom & pr&eacute;nom");
    pc.getChampByName("idformationlib").setLibelle("Formation");
    pc.getChampByName("datedebut").setLibelle("Datedebut");
    pc.getChampByName("datefin").setLibelle("Datefin");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("persMatricule").setLibelle("Matricule");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idformation").setLien(lien+"?but=paie/formation/formation-fiche.jsp","id=");
    pc.getChampByName("idpersonnel").setLien(lien+"paie/employe/personnel-fiche-portrait.jsp","id=");

    String[] ordre = {"id","idformation","idformationlib","idpersonnel","idpersonnellib","datedebut","datefin","etat"};
    pc.setOrdre(ordre);

    String pageActuel = "paie/formation/formationsuivi-fiche.jsp";
    String pageRetour = "paie/formation/formationsuivi-liste.jsp";
    String pageModif = "paie/formation/formationsuivi-saisie.jsp&acte=update";
    String pageApresDelete = "paie/formation/formationsuivi-liste.jsp";
    String classe = "paie.formation.FormationSuivi";

    Map<String, String> map = new HashMap<>();
    map.put("inc/foramtion-details-suivi", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/foramtion-details-suivi";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

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
                         <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/formation/formationsuivi-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                     <% }%>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
</div>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- Exemple d'onglet -->
                    <li class="<%=map.get("inc/foramtion-details-suivi")%>"><a href="<%= lien %>?but=<%= pageActuel %>&idFormationPlan=<%= idFormationPlan %>&tab=inc/foramtion-details-suivi">D&eacute;tails</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
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

