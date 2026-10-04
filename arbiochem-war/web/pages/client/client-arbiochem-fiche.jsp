<%-- 
    Document   : client-fiche
    Created on : 22 mars 2024, 14:50:51
    Author     : SAFIDY
--%>

<%@page import="client.Client"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="client.ClientLib" %>
<%@ page import="client.ClientLibArbiochem" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>
<%
    try{
    String pageActuel = "client/client-arbiochem-fiche.jsp";
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/client-arbiochem-facture", "");
    map.put("inc/client-arbiochem-bc", "");
    map.put("inc/client-arbiochem-proforma", "");
    map.put("inc/releve-client-arbiochem-opt", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/client-arbiochem-facture";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";


    ClientLibArbiochem client = new ClientLibArbiochem();
    client.setNomTable("CLIENTLIB");

    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche Client");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("codeclient").setLibelle("Code client");
    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("telephone").setLibelle("T&eacute;l&eacute;phone");
    pc.getChampByName("mail").setLibelle("Adresse e-mail");
    pc.getChampByName("adresse").setLibelle("Adresse");
    pc.getChampByName("datecarte").setLibelle("Date d ’ &eacute;mission de la carte");
    pc.getChampByName("telfixe").setLibelle("T&eacute;l&eacute;phone personnel");
    pc.getChampByName("echeance").setLibelle("Ech&eacute;ance de paiement");

    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("compte").setLibelle("Compte G&eacute;n&eacute;ral");
    pc.getChampByName("compteauxiliaire").setLibelle("Compte Auxiliaire");
    pc.getChampByName("compteauxiliaire").setVisible(false);
    pc.getChampByName("idTypeClient").setVisible(false);
    pc.getChampByName("idProvince").setVisible(false);
    pc.getChampByName("idTypeClientLib").setLibelle("Type de client");
    pc.getChampByName("provinceLib").setLibelle("Province");
    pc.getChampByName("taxe").setLibelle("Taxe (%)");
    pc.getChampByName("seuil").setLibelle("Seuil maximum des factures non pay&eacute;es");

        String lien = (String) session.getValue("lien");
    String pageModif = "client/client-modif.jsp";
    String classe = "client.Client";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=client/client-arbiochem-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <!--a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a-->
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=client/client-arbiochem-saisie.jsp&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=client/client-liste.jsp&classe="+classe %>">Supprimer</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/client-arbiochem-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/client-arbiochem-facture">Liste des Factures</a></li>
                    <li class="<%=map.get("inc/client-arbiochem-bc")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/client-arbiochem-bc">Liste des Bon de Commandes</a></li>
                    <li class="<%=map.get("inc/releve-client-arbiochem-opt")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/releve-client-arbiochem-opt">Relev&eacute; client</a></li>
                    <li class="<%=map.get("inc/client-arbiochem-proforma")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/client-arbiochem-proforma">Liste des Proformas</a></li>
                    <li class="<%=map.get("inc/tarif-ingredients-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/tarif-ingredients-liste">Tarifs</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="numbl" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>
<%}catch (Exception e){
        e.printStackTrace();
}%>
