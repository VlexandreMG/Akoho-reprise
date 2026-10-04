<%--
    Document   : point-fiche
    Created on : 22 mars 2024, 09:26:43
    Author     : Angela
--%>

<%@page import="compteur.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="maintenance.configuration.CompteurMaintenance" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>


<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    String pageModif = "compteur/releve-saisie.jsp&acte=update";
    CompteurMaintenance compteur = new CompteurMaintenance();
    compteur.setNomTable("CompteurCPL");
    PageConsulte pc = new PageConsulte(compteur, request, u);
    pc.setTitre("Fiche d'un compteur Maintenance");
    compteur = (CompteurMaintenance) pc.getBase();
    String id=compteur.getTuppleID();
    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("idLigneLib").setLibelle("Ligne");
    pc.getChampByName("daty").setLibelle("Date de saisie");
    pc.getChampByName("idCategorieLib").setLibelle("Cat&eacute;gorie");
    pc.getChampByName("valeur").setLibelle("valeur");
    pc.getChampByName("ecart").setLibelle("&Eacute;cart");
    pc.getChampByName("idCategorie").setVisible(false);
    pc.getChampByName("idLigne").setVisible(false);
    pc.getChampByName("idMagasin").setVisible(false);
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");

    String lien = (String) session.getValue("lien");
    String classe = "maintenance.configuration.CompteurMaintenance";
    String pageActuel = "compteur/releve-fiche.jsp";

    Map<String, String> map = new HashMap<String, String>();
        map.put("fabrication-petri-rattache", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "fabrication-petri-rattache";
        }
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp";
        int etat = compteur.getEtat();
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href="#"> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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

                            <% if(compteur.getEtat()<ConstanteEtat.getEtatValider()){%>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=apresTarif.jsp&id=" + id %>&acte=valider&bute=<%=pageActuel%>&classe=<%=classe%>" style="margin-right: 10px">Viser</a>
                            <% } %>
                            <% if(compteur.getEtat()<3){%>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=compteur/releve-liste.jsp&classe="+classe %>">
                                Supprimer
                            </a>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=" + pageModif + "&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <%}%>
                            <% if(compteur.getEtat()== 3){%>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=maintenance/ressources/fabrication-petri.jsp&idCompteur=" + id+"&idligne="+compteur.getIdLigne()+"&date="+compteur.getDaty() %>" style="margin-right: 10px">Rattacher Fabrication</a>
                            <%}%>
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
                    <li class="<%=map.get("fabrication-petri-rattache")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&etat=<%= etat%>&tab=fabrication-petri-rattache">Fabrication rattach&eacute;e</a></li>
                    <li class="<%=map.get("mouvementStockRattache")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=mouvementStockRattache">Mouvement Stock rattach&eacute;</a></li>
                </ul>
                <div class="tab-content">       
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="id" value="<%= id%>" />
                        <jsp:param name="etat" value="<%= etat%>" />
                        <jsp:param name="type" value="consommable" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>


