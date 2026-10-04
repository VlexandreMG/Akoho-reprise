<%-- 
    Document   : depense-fiche
    Created on : 10 mai 2024, 11:24:32
    Author     : CMCM
--%>

<%@page import="depense.Depense"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="depense.DepenseLib" %>

<%
    try{
    UserEJB u = (user.UserEJB) session.getValue("u");

%>
<%    DepenseLib objet = new DepenseLib();
    objet.setNomTable("DEPENSELIB");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche Depense");
    pc.getBase();
    String id = pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idOrigine").setLibelle("ID Origine");
    pc.getChampByName("idOp").setLibelle("ID OP");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idCaisse").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idCaisseLib").setLibelle("Caisse");
    String lien = (String) session.getValue("lien");
    String pageModif = "depense/depense-saisie.jsp&acte=update";
    String classe = "depense.Depense";
    String idEncaissement = request.getParameter("idEncaissement");
%>

<div class="content-wrapper">
       <div class="row">
              <div class="col-md-3"></div>
              <div class="col-md-6">
                     <div class="box-fiche">
                            <div class="box">
                                   <div class="box-title with-border">
                                          <% if (idEncaissement == null) {%>
                                          <h1 class="box-title"><a href=<%= lien + "?but=depense/depense-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                                                 <% } else {%>
                                          <h1 class="box-title"><a href=<%= lien + "?but=encaissement/encaissement-fiche.jsp&id=" + idEncaissement%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                                                 <% }%>
                                   </div>
                                   <div class="box-body">
                                          <%
                                              out.println(pc.getHtml());
                                          %>
                                          <br/>
                                          <div class="box-footer">
                                                 <% if (!"11".equals(pc.getChampByName("etat").getValeur())) {%>
                                                 <a class="btn btn-warning pull-right" href="<%= lien + "?but=" + pageModif + "&id=" + id+ ( idEncaissement==null ? "" : ("&idEncaissement="+idEncaissement) )%>" style="margin-right: 10px">Modifier</a>
                                                 <a class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute=depense/depense-fiche.jsp&classe=" + classe%>"><button class="btn btn-danger" style="margin-right: 10px">Annuler</button></a>
                                                 <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=depense/depense-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                                                 <% }%>
                                          </div>
                                          <br/>

                                   </div>
                            </div>
                     </div>
              </div>
       </div>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>

