<%-- 
    Document   : bondelivraison-client-fiche
    Created on : 29 juil. 2024, 17:39:44
    Author     : drana
--%>
  
<%@page import="java.util.*"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="annexe.Unite"%>
<%@page import="magasin.Magasin"%> 
<%@page import="user.*"%> 
<%@page import="vente.*"%> 
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%> 
 
<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");
%>
<%
try{
    As_BondeLivraisonClient_Cpl f = new As_BondeLivraisonClient_Cpl();
    f.setNomTable("AS_BONDELIVRAISON_CLIENT_CPL");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("Fiche de bon de livraison client");
    As_BondeLivraisonClient_Cpl blf=(As_BondeLivraisonClient_Cpl)pc.getBase();
    String id=blf.getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("date");
    pc.getChampByName("idclientlib").setLibelle("Client");
    pc.getChampByName("idClient").setLibelle("ID Client");
    pc.getChampByName("idVente").setLien(lien+"?but=vente/vente-arbiochem-fiche.jsp", "id=");
    pc.getChampByName("remarque").setLibelle("Remarque");   
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("idVente").setLibelle("ID vente");
    pc.getChampByName("idClient").setLien(lien+"?but=client/client-arbiochem-fiche.jsp", "id=");
    pc.getChampByName("idBC").setLibelle("ID Bon de Commande");
    pc.getChampByName("magasin").setLibelle("Magasin");
    pc.getChampByName("vehicule").setLibelle("Num&eacute;ro de voiture");
    pc.getChampByName("chauffeur").setLibelle("Liste des livreurs");
    pc.getChampByName("description").setLibelle("Description");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("etat").setAutre("readonly");
     pc.getChampByName("idVente").setAutre("readonly"); 
     pc.getChampByName("idBC").setAutre("readonly"); 
     pc.getChampByName("idMagasin").setAutre("readonly"); 
     pc.getChampByName("idMagasin").setVisible(false); 
     pc.getChampByName("idBC").setLien(lien+"?but=vente/bondecommande/bondecommande-arbiochem-fiche.jsp", "id=");
    String pageActuel = "bondelivraison-client/bondelivraison-client-arbiochem-fiche.jsp";

    String pageModif = "bondelivraison-client/bondelivraison-client-arbiochem-saisie.jsp";
    String classe = "vente.As_BondeLivraisonClient";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/bondelivraisonclient-liste-detail", ""); 

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/bondelivraisonclient-liste-detail";
    } 
    map.put(tab, "active");
    tab = tab + ".jsp";
    String idBc = pc.getChampByName("idBC").getValeur();
%>

<div class="content-wrapper">

    <h1 class="box-title"><a href=<%= lien + "?but=bondelivraison-client/bondelivraison-client-arbiochem-fiche.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
                            <% if(blf.getEtat() < ConstanteEtat.getEtatValider()){%>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=bondelivraison-client/bondelivraison-client-arbiochem-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Valider</a>
                            <% } %>
                            <% if(blf.getEtat() < ConstanteEtat.getEtatValider()){%>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <% } %>

                            <% if(blf.getEtat() >= ConstanteEtat.getEtatValider()){ %>
                                <a class="btn btn-primary pull-right"  href="<%=(String) session.getValue("lien") + "?but=stock/mvtstock-arbiochem-saisie.jsp?idBLC=" + id%>" >G&eacute;n&eacute;rer mouvement de stock</a>

                              <%  if(blf.getIdvente()==null||blf.getIdvente().compareTo("")==0) {
                            %>
                                <a class="btn btn-primary pull-right" href="<%= lien + "?but=vente/vente-arbiochem-saisie.jsp&id="+pc.getChampByName("id").getValeur()+"&idClient="+pc.getChampByName("idClient").getValeur()+"&idPoint="+pc.getChampByName("idMagasin").getValeur()+"&idOrigine="+idBc%>" style="margin-right: 10px">Facturer</a>
<%--                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/vente-arbiochem-saisie.jsp&idBC=" + idBc%> " style="margin-right: 10px">Facturer</a>--%>
                            <% }} %>
                            <!--a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDFARBIOCHEM?action=fiche_bl&id=<%=request.getParameter("id")%>" >Imprimer</a-->
                            <%-- <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDFARBIOCHEM?action=fiche_vente_nouveau_bl&idbl=<%=request.getParameter("id")%>&type=simple&id=<%=pc.getChampByName("idVente").getValeur()%>" style="margin-right: 10px; margin-bottom: 10px">Imprimer</a> --%>
                            <%
                                // inline=1 -> ExportPDF sert le PDF en Content-Disposition: inline (+ application/pdf), ce qui permet le rendu dans l'iframe du modal.
                                // Sans le parametre : disposition attachment, comportement d'origine.
                                String idVenteVal = pc.getChampByName("idVente") != null ? pc.getChampByName("idVente").getValeur() : "";
                                String pdfBase = request.getContextPath() + "/ExportPDFARBIOCHEM?action=fiche_vente_nouveau_bl&idbl=" + URLEncoder.encode(id, "UTF-8") + "&type=simple&id=" + URLEncoder.encode(idVenteVal, "UTF-8");
                                String pdfApercu = pdfBase + "&inline=1";
                            %>
                            <button type="button" class="btn btn-tertiary pull-right"
                                    data-url="<%= pdfApercu %>"
                                    data-dl="<%= pdfBase %>"
                                    data-kind="pdf"
                                    data-name="Bon de livraison <%= id %>"
                                    onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"
                                    style="margin-right: 10px; margin-bottom: 10px">Imprimer
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
                    <li class="<%=map.get("inc/bondelivraisonclient-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondelivraisonclient-liste-detail">D&eacute;tails</a></li>
                    <li class="<%=map.get("inc/mouvementstock-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/mouvementstock-liste-detail">Mouvement de Stock</a></li>
<%--                    <li class="<%=map.get("inc/vente-cpl-visee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/vente-cpl-visee">Facture</a></li>--%>
                    <li class="<%=map.get("inc/rapprochement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/rapprochement">Rapprochement</a></li>
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
</div>



<%
	} catch (Exception e) {
		e.printStackTrace();

            }%>