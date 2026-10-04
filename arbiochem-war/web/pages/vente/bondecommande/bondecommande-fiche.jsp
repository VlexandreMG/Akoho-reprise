<%@page import="faturefournisseur.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="vente.BonDeCommandeCpl"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>
<%
    try{
    String lien = (String) session.getValue("lien");
    BonDeCommandeCpl f = new BonDeCommandeCpl();
    f.setNomTable("BONDECOMMANDE_CLIENT_CPL_M");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("Fiche du bon de commande client");
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("daty").setLibelle("date");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
    pc.getChampByName("designation").setLibelle("d&eacute;signation");
    pc.getChampByName("idclientlib").setLibelle("Client");
    pc.getChampByName("etatlib").setLibelle("Etat");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idclient").setVisible(false);
    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("idProforma").setLibelle("ID Proforma");
    pc.getChampByName("idProforma").setLien(lien+"?but=vente/proforma/proforma-fiche.jsp", "id=");
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("idproforma").setLien(lien+"?but=vente/proforma/proforma-fiche.jsp", "id=");
    pc.getChampByName("idproforma").setLibelle("Proforma");
    pc.getChampByName("modelivraisonlib").setLibelle("Mode de livraison");
        pc.getChampByName("nbfacture").setLibelle("Nombre de facture");
        pc.getChampByName("facturelib").setLibelle("Statut");
    pc.getChampByName("numeroBc").setLibelle("Num&eacute;ro du bon de commande");
    pc.getChampByName("nbfacture").setVisible(false);
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("modepaiement").setVisible(false);
    pc.getChampByName("lieuLivraison").setLibelle("Lieu de livraison");
    pc.getChampByName("dateLivraison").setLibelle("Date de livraison");

    String pageActuel = "vente/bondecommande/bondecommande-fiche.jsp";

    String pageModif = "vente/bondecommande/bondecommande-saisie.jsp";
    String classe = "vente.BonDeCommande";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/bondecommande-detail", "");
    map.put("inc/bondecommande-liste-detail", "");
    map.put("inc/bondecommande-besoin", "");
    map.put("inc/livraisondetail-bc", "");
    map.put("inc/fabricationdetail-bc", "");
    map.put("inc/vente-cpl-visee", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/bondecommande-detail";
    }

    map.put(tab, "active");
    tab = tab + ".jsp";
    f = (BonDeCommandeCpl)pc.getBase();
    boolean estFacturee = f.estFacture(null);
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=bondecommande/bondecommande-fiche.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
<%--                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=fabrication/fabrication-saisie.jsp&idBC=" + id + "&classe=" + classe%> " style="margin-right: 10px">Fabriquer</a>--%>
<%--                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=fabrication/ordre-fabrication-saisie.jsp&idBC=" + id + "&classe=" + classe%> " style="margin-right: 10px">Generer OF</a>--%>
                            <% if (f.getEtat() < ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/bondecommande/bondecommande-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <% if (f.getEtat() == ConstanteEtat.getEtatValider()) {%>
                                <!--a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/bondecommande/bondecommande-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Cl&ocirc;turer</a-->
                            <% }if (f.getEtat() == ConstanteEtat.getEtatValider()&&!estFacturee) {%>
                                <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/vente-saisie.jsp&idBC=" + request.getParameter("id")%> " style="margin-right: 10px">Facturer</a>
                            <% } %>
                            <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=bc_client&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer en PDF</a>
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
                    <li class="<%=map.get("inc/bondecommande-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-detail">Détails </a></li>
<%--                    <li class="<%=map.get("inc/bondecommande-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-liste-detail">Détails de Fabrication</a></li>--%>
<%--                    <li class="<%=map.get("inc/bondecommande-besoins")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-besoins">Besoins</a></li>--%>
                    <li class="<%=map.get("inc/livraisondetail-bc")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/livraisondetail-bc">Livraisons</a></li>
<%--                    <li class="<%=map.get("inc/fabricationdetail-bc")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabricationdetail-bc">Fabrications</a></li>--%>
<%--                    <li class="<%=map.get("inc/ordre-fabrication-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-details">Ordre de Fabrication</a></li>--%>
                    <li class="<%=map.get("inc/vente-cpl-visee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/vente-cpl-visee">Factures</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idbc" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>                    
</div>
<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>
