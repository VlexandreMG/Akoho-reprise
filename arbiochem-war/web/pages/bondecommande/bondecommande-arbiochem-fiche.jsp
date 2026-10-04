<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 10/08/2026
  Time: 23:41
  To change this template use File | Settings | File Templates.
--%>
<%@page import="faturefournisseur.*"%>
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
  try {

    As_BonDeCommandeCpl f = new As_BonDeCommandeCpl();
    f.setNomTable("AS_BONDECOMMANDE_MERETRAITE");
    PageConsulte pc = new PageConsulte(f, request, u);
    String lien = (String) session.getValue("lien");
    pc.setTitre("Fiche d'un bon de commande fournisseur");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("date");
    pc.getChampByName("dateLimite").setLibelle("Date limite de livraison");
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("designation").setLibelle("d&eacute;signation");
    pc.getChampByName("fournisseurlib").setLibelle("Fournisseur");
    pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
    pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
    pc.getChampByName("idDeviselib").setLibelle("Devise");
    pc.getChampByName("montantTVA").setLibelle("Montant TVA");
    pc.getChampByName("montantHT").setLibelle("Montant HT");
    pc.getChampByName("montantTTC").setLibelle("Montant TTC");
    pc.getChampByName("montantTTCAriary").setLibelle("Montant TTC Ariary");
    pc.getChampByName("sommeAcompte").setLibelle("Somme acompte");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("idServiceLib").setLibelle("D&eacute;partement");
    pc.getChampByName("iddmdachat").setLibelle("Demande d'achat");
    pc.getChampByName("refproforma").setLibelle("R&eacute;f&eacute;rence proforma");
    pc.getChampByName("iddmdachat").setLien(lien+"?but=facturefournisseur/dmdachat/dmdachat-arbiochem-fiche.jsp","id=");
    pc.getChampByName("etatlib").setVisible(false);
    pc.getChampByName("idTraite").setVisible(false);
    pc.getChampByName("traite").setLibelle("Livraison");
    pc.getChampByName("idDevise").setVisible(false);
    pc.getChampByName("fournisseur").setVisible(false);
    pc.getChampByName("modepaiement").setVisible(false);
    String pageActuel = "bondecommande/bondecommande-arbiochem-fiche.jsp";

    String pageModif = "bondecommande/bondecommande-arbiochem-saisie.jsp";
    String classe = "faturefournisseur.As_BonDeCommande";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/bondecommande-liste-detail", "");
    map.put("inc/as-bondelivraison", "");
    map.put("inc/achat-cpl-visee", "");
    map.put("inc/details-facture", "");
    map.put("inc/facturation-multiple", "");
    //map.put("inc/ff-liee", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
      tab = "inc/bondecommande-liste-detail";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    As_BonDeCommandeCpl bc = (As_BonDeCommandeCpl) pc.getBase();
    int etat = bc.getEtat();
%>

<div class="content-wrapper">
  <h1 class="box-title"><a href=<%= lien + "?but=bondecommande/bondecommande-arbiochem-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
              <%
                if( etat < 11 ){ %>
              <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=bondecommande/bondecommande-arbiochem-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
              <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
              <a class="btn btn-danger pull-left"  href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=annuler&id=" + request.getParameter("id") + "&bute=bondecommande/bondecommande-arbiochem-fiche.jsp&classe=" + classe %>" >Annuler</a>
              <%    }
              %>
              <% if(etat >= 11) {%>
              <a style="margin-left: 8px;" class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-sortie.jsp&idf="+bc.getFournisseur()+"&idbc=" + request.getParameter("id")+"&idModePaiement="+pc.getChampByName("modepaiement").getValeur()+"&action=acompte"%> ">Acompte</a>
              <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison/bondelivraison-arbiochem-saisie.jsp&id=" + request.getParameter("id")%> " style="margin-right: 10px">R&eacute;ceptionner</a>
              <!-- <a class="btn btn-info pull-right"  href="<%=(String) session.getValue("lien") + "?but=bondecommande/apresFacturer.jsp&id=" + id%>"style="margin: 5px 10px 0 0">Facturer</a> -->
              <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=facturefournisseur/facturefournisseur-saisie.jsp&idbc="+pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">Insertion Facture Fournisseur</a>
              <%--                            <a class="btn btn-danger pull-left"  href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=annulerVisa&id=" + request.getParameter("id") + "&bute=bondecommande/bondecommande-arbiochem-fiche.jsp&classe=" + classe %>" >Annuler Visa</a>--%>
              <% } %>
              <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDFARBIOCHEM?action=fiche_bc&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer</a>
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
          <li class="<%=map.get("inc/bondecommande-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-liste-detail">Détails</a></li>
          <li class="<%=map.get("inc/as-bondelivraison")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/as-bondelivraison">D&eacute;tails de r&eacute;ception</a></li>
          <li class="<%=map.get("inc/achat-cpl-visee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/achat-cpl-visee">Rapprochement</a></li>
          <li class="<%=map.get("inc/details-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/details-facture">Facture fournisseur</a></li>
          <li class="<%=map.get("inc/facturation-multiple")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facturation-multiple">Facturation multiple</a></li>
          <!---<li class="<%=map.get("inc/ff-liee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ff-liee">Facture fournisseur</a></li>---->
        </ul>
        <div class="tab-content">
          <jsp:include page="<%= tab %>" >
            <jsp:param name="idFactureFournisseur" value="<%= id %>" />
          </jsp:include>
        </div>
      </div>

    </div>
  </div>
</div>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }
%>
