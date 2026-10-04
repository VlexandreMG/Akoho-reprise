<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.production.ReceptionOACLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="ferme.production.ImportOAC" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ImportOAC o = new ImportOAC();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche reception OAC");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idNumeroCollecteLib").setLibelle("Collecte");
    pc.getChampByName("idResponsableLib").setLibelle("Responsable");
    pc.getChampByName("idChauffeurLib").setLibelle("Chauffeur");
    pc.getChampByName("idVehiculeLib").setLibelle("V&eacute;hicule");
    pc.getChampByName("datereception").setLibelle("Date de r&eacute;ception");
    pc.getChampByName("dateponte").setLibelle("Date de ponte");
    pc.getChampByName("datecollecte").setLibelle("Date de collecte");
    pc.getChampByName("idnumerocollecte").setLibelle("Id num&eacute;ro de collecte");
    pc.getChampByName("heuredepartferme").setLibelle("Heure de d&eacute;part ferme");
    pc.getChampByName("idProvenanceLib").setLibelle("Provenance");
    pc.getChampByName("heurearriveecouvoir").setLibelle("Heure d'arriv&eacute;e couvoir");
    pc.getChampByName("temperatureminvehicule").setLibelle("Temp&eacute;rature minimale du v&eacute;hicule");
    pc.getChampByName("temperaturemaxvehicule").setLibelle("Temp&eacute;rature maximale du v&eacute;hicule");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idresponsable").setVisible(false);
    pc.getChampByName("idchambrefroide").setVisible(false);
    pc.getChampByName("idchauffeur").setVisible(false);
    pc.getChampByName("idvehicule").setVisible(false);
    pc.getChampByName("idProvenance").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idnumerocollecte").setVisible(false);

    String[] ordre =  {"id","idnumerocollecte", "idNumeroCollecteLib","datecollecte","dateponte","heuredepartferme","heurearriveecouvoir","datereception","idResponsableLib","idChauffeurLib","idVehiculeLib","temperatureminvehicule","temperaturemaxvehicule","idProvenanceLib","etatLib"};
    pc.setOrdre(ordre);

    String pageActuel = "ferme/production/importoac-fiche.jsp";
    String pageRetour = "ferme/produtcion/importoac-liste.jsp";
    String pageModif = "ferme/produtcion/importoac-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/produtcion/importoac-liste.jsp";
    String classe = "ferme.production.ReceptionOAC";

    Map<String, String> map = new HashMap<>();
    map.put("inc/receptionoac-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/receptionoac-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    o = (ImportOAC) pc.getBase();
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
                        <% if (o.getEtat() < ConstanteEtat.getEtatValider()) { %>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute="+pageActuel+"&classe="+classe %>" style="margin-right: 10px">Valider</a>
                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                        <% } %>
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
                <li class="<%=map.get("inc/receptionoac-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/receptionoac-details">D&eacute;tails</a></li>
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

