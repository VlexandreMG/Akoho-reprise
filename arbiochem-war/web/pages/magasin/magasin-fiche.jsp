<%@page import="magasin.Magasin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="magasin.MagasinLibCompta" %>
<%@ page import="magasin.MagasinLib" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
try{
    MagasinLib unite = new MagasinLib();
    unite.setNomTable("magasinlib");
    PageConsulte pc = new PageConsulte(unite, request, u);
    pc.setTitre("Fiche Magasin");
    pc.getBase();
    Magasin magasin = (Magasin)pc.getBase();
    String id = magasin.getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Libell&eacute;");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("idPointlib").setLibelle("Point");
    pc.getChampByName("idTypeMagasinlib").setLibelle("Type magasin");
    pc.getChampByName("idProduitlib").setLibelle("Produit");
    pc.getChampByName("idLigne").setVisible(false);
    pc.getChampByName("idLigneLib").setLibelle("Ligne");
    String lienModif = "&acte=update";

    pc.getChampByName("idPoint").setVisible(false);
    pc.getChampByName("idTypeMagasin").setVisible(false);
    pc.getChampByName("idProduit").setVisible(false);
    String lien = (String) session.getValue("lien");
    String pageModif = "magasin/magasin-saisie.jsp"+lienModif;
    String classe = "magasin.Magasin";

    String pageActuel = "magasin/magasin-fiche.jsp";
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/compte-magasin", "");
    map.put("inc/etat-stock", "");
    map.put("inc/etat-stock-seuil", "");
    map.put("inc/a", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/compte-magasin";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=magasin/magasin-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=magasin/magasin-liste.jsp&classe="+classe %>">Supprimer</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=magasin/magasin-compte-saisie.jsp&val=" + id %>" style="margin-right: 10px">Ajouter Compte</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=demande/demandetransfert-saisie.jsp&idMagasin=" + id %>" style="margin-right: 10px">G&eacute;n&eacute;rer demande transfert de stock</a>
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
                    <li class="<%=map.get("inc/compte-magasin")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/compte-magasin">Comptes li&eacute; au magasin</a></li>
                    <li class="<%=map.get("inc/etat-stock")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/etat-stock">&Eacute;tat stock</a></li>
                    <li class="<%=map.get("inc/etat-stock-seuil")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/etat-stock-seuil">&Eacute;tat stock en dessous de seuil</a></li>
                    <li class="<%=map.get("inc/mvt-stock-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/mvt-stock-liste">Mouvement de stock aujourd&apos;hui</a></li>
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

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>

