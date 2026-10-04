<%@page import="faturefournisseur.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="vente.BonDeCommandeCpl"%>
<%@ page import="java.net.URLEncoder" %>

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
    pc.getChampByName("idProforma").setLien(lien+"?but=vente/proforma/proforma-arbiochem-fiche.jsp", "id=");
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("idproforma").setLien(lien+"?but=vente/proforma/proforma-arbiochem-fiche.jsp", "id=");
    pc.getChampByName("idproforma").setLibelle("Proforma");
    pc.getChampByName("modelivraisonlib").setLibelle("Mode de livraison");
        pc.getChampByName("nbfacture").setLibelle("Nombre de facture");
        pc.getChampByName("facturelib").setLibelle("Statut");
    pc.getChampByName("numeroBc").setLibelle("Num&eacute;ro du bon de commande");
    pc.getChampByName("nbfacture").setVisible(false);
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("montantTTC").setLibelle("Montant TTC");
    pc.getChampByName("montantTTCAr").setLibelle("Montant TTC en Ar");
    pc.getChampByName("modepaiement").setVisible(false);
    pc.getChampByName("lieuLivraison").setLibelle("Lieu de livraison");
    pc.getChampByName("dateLivraison").setLibelle("Date de livraison");

    String pageActuel = "vente/bondecommande/bondecommande-arbiochem-fiche.jsp";

    String pageModif = "vente/bondecommande/bondecommande-arbiochem-saisie.jsp";
    String classe = "vente.BonDeCommande";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/bondecommande-detail-arbiochem", "");
    map.put("inc/bondecommande-liste-detail", "");
    map.put("inc/bondecommande-besoin", "");
    map.put("inc/livraisondetail-bc-arbiochem", "");
    map.put("inc/fabricationdetail-bc", "");
    map.put("inc/vente-cpl-visee-arbiochem", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/bondecommande-detail-arbiochem";
    }

    map.put(tab, "active");
    tab = tab + ".jsp";
    f = (BonDeCommandeCpl)pc.getBase();
    boolean estFacturee = f.estFacture(null);
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=bondecommande/bondecommande-arbiochem-fiche.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-12 mb-5">
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
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/bondecommande/bondecommande-arbiochem-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <% if (f.getEtat() == ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison-client/bondelivraison-client-arbiochem-saisie.jsp&idbc_client=" + request.getParameter("id") + "&classe=" + classe+"&idMagasin="+f.getIdMagasin()%> " style="margin-right: 10px">Livrer</a>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree-vente-arbiochem.jsp&idbc=" + request.getParameter("id") + "&idclient="+f.getIdClient()%> " style="margin-right: 10px">Avancer</a>
                                <!--a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/bondecommande/bondecommande-arbiochem-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Cl&ocirc;turer</a-->
                            <% }if (f.getEtat() == ConstanteEtat.getEtatValider()&&!estFacturee) {%>
                                <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/vente-arbiochem-saisie.jsp&idBC=" + request.getParameter("id")%> " style="margin-right: 10px">Facturer</a>
                            <% } %>
<%--                            <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDFARBIOCHEM?action=bc_client&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer en PDF</a>--%>
                            <%
                                // inline=1 -> ExportPDF sert le PDF en Content-Disposition: inline (+ application/pdf), ce qui permet le rendu dans l'iframe du modal.
                                // Sans le parametre : disposition attachment, comportement d'origine.
                                String pdfBase = request.getContextPath() + "/ExportPDFARBIOCHEM?action=bc_client&id="
                                        + URLEncoder.encode(id, "UTF-8");
                                String pdfApercu = pdfBase + "&inline=1";
                            %>
                            <button type="button" class="btn btn-tertiary pull-right"
                                    data-url="<%= pdfApercu %>"
                                    data-dl="<%= pdfBase %>"
                                    data-kind="pdf"
                                    data-name="Bon de commande <%= id %>"
                                    onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"
                                    style="margin-right: 10px">Imprimer en PDF
                            </button>
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
                    <li class="<%=map.get("inc/bondecommande-detail-arbiochem")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-detail-arbiochem">Détails </a></li>
<%--                    <li class="<%=map.get("inc/bondecommande-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-liste-detail">Détails de Fabrication</a></li>--%>
<%--                    <li class="<%=map.get("inc/bondecommande-besoins")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-besoins">Besoins</a></li>--%>
                    <li class="<%=map.get("inc/livraisondetail-bc-arbiochem")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/livraisondetail-bc-arbiochem">Livraisons</a></li>
<%--                    <li class="<%=map.get("inc/fabricationdetail-bc")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabricationdetail-bc">Fabrications</a></li>--%>
<%--                    <li class="<%=map.get("inc/ordre-fabrication-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-details">Ordre de Fabrication</a></li>--%>
                    <li class="<%=map.get("inc/vente-cpl-visee-arbiochem")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/vente-cpl-visee-arbiochem">Factures</a></li>
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
