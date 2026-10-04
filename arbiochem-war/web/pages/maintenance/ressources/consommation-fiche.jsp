<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="maintenance.ressources.ConsommationLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ConsommationLib o = new ConsommationLib();
    o.setNomTable("CONSOMMATIONLIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche Consommation");
    String id = pc.getBase().getTuppleID();
    o = (ConsommationLib) pc.getBase();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idTypeMaintenanceLib").setLibelle("Type de maintenance");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idMachineLib").setLibelle("Machine");
    pc.getChampByName("idTypeMaintenance").setVisible(false);
    pc.getChampByName("idMachine").setVisible(false);
    pc.getChampByName("etat").setVisible(false);

    String[] ordre = {"id","desce","daty","idTypeMaintenanceLib","idMachineLib"};
    pc.setOrdre(ordre);

    String pageActuel = "maintenance/ressources/consommation-fiche.jsp";
    String pageRetour = "maintenance/ressources/consommation-liste.jsp";
    String pageModif = "maintenance/ressources/consommation-saisie.jsp&acte=update";
    String pageApresDelete = "maintenance/ressources/consommation-liste.jsp";
    String classe = "maintenance.ressources.Consommation";

    Map<String, String> map = new HashMap<>();
    map.put("inc/consommation-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/consommation-details";
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
                        <div class="box-footer">
                            <% if (o.getEtat() < ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                                <a class="btn btn-danger pull-left"  href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>" style="margin-right: 10px">Supprimer</a>
                                <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute="+pageActuel+"&classe=" + classe%>" style="margin-right: 10px">Viser</a>
                            <% }%>
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
                        <li class="<%=map.get("inc/consommation-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/consommation-details">D&eacute;tails</a></li>
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
</div>
<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

