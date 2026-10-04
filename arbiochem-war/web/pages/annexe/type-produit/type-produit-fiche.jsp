<%--
    Document   : produit-fiche
    Created on : 21 mars 2024, 09:44:57
    Author     : Angela
--%>


<%@page import="annexe.TypeProduit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    TypeProduit objet = new TypeProduit();
    objet.setNomTable("Type_Produit");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche du type de produit");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("D&eacute;signation");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("idligne").setLibelle("ID Ligne");
    String lien = (String) session.getValue("lien");
    String pageModif = "annexe/type-produit/type-produit-saisie.jsp&acte=update";
    String classe = "annexe.TypeProduit";
     Map<String, String> map = new HashMap<String, String>();
        map.put("listeproduit", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "listeproduit";
        }
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp";
%>

<div class="content-wrapper">
    <div class="box-title with-border">
        <h1 class="box-title"><a href=<%= lien + "?but=annexe/type-produit/type-produit-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=annexe/type-produit/type-produit-liste.jsp&classe="+classe %>">Supprimer</a>
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
                    <!-- a modifier -->
                    <li class="<%=map.get("listeproduit")%>"><a href="<%= lien%>?but=annexe/type-produit/type-produit-fiche.jsp&id=<%= id%>&tab=listeproduit">Produits</a></li>
                </ul>
                <div class="tab-content">       
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>

