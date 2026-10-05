<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 10/08/2026
  Time: 23:41
  To change this template use File | Settings | File Templates.
--%>
<%--
  ============================================================================
  bondecommande-arbiochem-fiche.jsp : FICHE D'UN BON DE COMMANDE FOURNISSEUR
  ============================================================================

  ENTREES (ce que la page reçoit)
    - Paramètre HTTP "id"  : identifiant du bon de commande (ex. BC000893)
    - Paramètre HTTP "tab" : onglet à afficher (par défaut : Détails)
    - Session : "u" (utilisateur connecté) et "lien" (URL de base : module.jsp)

  SOURCE DES DONNEES : la vue Oracle AS_BONDECOMMANDE_MERETRAITE
    (le BC + montants + statut de livraison "traite")

  SORTIES (ce que la page affiche / où elle mène)
    - Les informations du bon de commande (en-tête, montants HT / TVA / TTC, état, livraison)
    - Les boutons changent selon l'ETAT du bon :
        etat < 11  (créé)  : Viser      -> apresTarif.jsp?acte=valider
                             Modifier   -> bondecommande-arbiochem-saisie.jsp?acte=update
                             Annuler    -> apresTarif.jsp?acte=annuler
        etat >= 11 (visé)  : Acompte    -> caisse/mvt/mvtCaisse-saisie-sortie.jsp
                             Réceptionner -> bondelivraison/bondelivraison-arbiochem-saisie.jsp
                             Insertion Facture Fournisseur -> facturefournisseur/facturefournisseur-saisie.jsp
        toujours           : Imprimer   -> ExportPDFARBIOCHEM?action=fiche_bc
    - 5 onglets (chacun est un autre JSP inclus dans la page) :
        Détails              -> inc/bondecommande-liste-detail.jsp
        Détails de réception -> inc/as-bondelivraison.jsp
        Rapprochement        -> inc/achat-cpl-visee.jsp
        Facture fournisseur  -> inc/details-facture.jsp
        Facturation multiple -> inc/facturation-multiple.jsp
    - Après Viser ou Annuler, on revient sur cette même fiche (paramètre "bute")

  A SAVOIR
    - "Traité" n'est pas un état stocké : c'est la colonne "traite" de la vue,
      calculée à partir des réceptions (onglet "Détails de réception")
    - En cas d'erreur : trace dans server.log seulement, rien n'est affiché à l'écran
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
  // Utilisateur connecté (lu en session)
  UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
  try {

    // 1. Charger le bon de commande depuis la vue, à partir du paramètre "id" de l'URL
    As_BonDeCommandeCpl f = new As_BonDeCommandeCpl();
    f.setNomTable("AS_BONDECOMMANDE_MERETRAITE");
    PageConsulte pc = new PageConsulte(f, request, u);
    String lien = (String) session.getValue("lien");
    pc.setTitre("Fiche d'un bon de commande fournisseur");
    pc.getBase();
    String id=pc.getBase().getTuppleID();

    // 2. Libellés affichés, champs masqués, lien vers la demande d'achat
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

    // 3. Pages utilisées par les boutons et les onglets
    String pageActuel = "bondecommande/bondecommande-arbiochem-fiche.jsp";

    String pageModif = "bondecommande/bondecommande-arbiochem-saisie.jsp";
    String classe = "faturefournisseur.As_BonDeCommande";

    // 4. Onglets : "active" est mis sur l'onglet demandé (par défaut Détails) ;
    //    "tab" devient le nom du JSP à inclure plus bas
    //    Attention : la valeur du paramètre "tab" sert directement de nom de fichier
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

    // 5. ETAT du bon : décide des boutons affichés (< 11 : créé, >= 11 : visé)
    As_BonDeCommandeCpl bc = (As_BonDeCommandeCpl) pc.getBase();
    int etat = bc.getEtat();
%>

<div class="content-wrapper">
  <%-- Titre avec flèche de retour vers la liste --%>
  <h1 class="box-title"><a href=<%= lien + "?but=bondecommande/bondecommande-arbiochem-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

  <div class="row m-0">
    <div class="col-md-3"></div>
    <div class="col-md-6">
      <div class="box-fiche">
        <div class="box">

          <div class="box-body">
            <%-- Informations du bon de commande --%>
            <%
              out.println(pc.getHtml());
            %>
            <br/>
            <div class="box-footer">
              <%-- Boutons avant le visa (créé) : Viser, Modifier, Annuler --%>
              <%
                if( etat < 11 ){ %>
              <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=bondecommande/bondecommande-arbiochem-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
              <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
              <a class="btn btn-danger pull-left"  href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=annuler&id=" + request.getParameter("id") + "&bute=bondecommande/bondecommande-arbiochem-fiche.jsp&classe=" + classe %>" >Annuler</a>
              <%    }
              %>
              <%-- Boutons après le visa (visé) : Acompte, Réceptionner, Facture fournisseur --%>
              <% if(etat >= 11) {%>
              <a style="margin-left: 8px;" class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-sortie.jsp&idf="+bc.getFournisseur()+"&idbc=" + request.getParameter("id")+"&idModePaiement="+pc.getChampByName("modepaiement").getValeur()+"&action=acompte"%> ">Acompte</a>
              <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison/bondelivraison-arbiochem-saisie.jsp&id=" + request.getParameter("id")%> " style="margin-right: 10px">R&eacute;ceptionner</a>
              <!-- <a class="btn btn-info pull-right"  href="<%=(String) session.getValue("lien") + "?but=bondecommande/apresFacturer.jsp&id=" + id%>"style="margin: 5px 10px 0 0">Facturer</a> -->
              <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=facturefournisseur/facturefournisseur-saisie.jsp&idbc="+pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">Insertion Facture Fournisseur</a>
              <%--                            <a class="btn btn-danger pull-left"  href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=annulerVisa&id=" + request.getParameter("id") + "&bute=bondecommande/bondecommande-arbiochem-fiche.jsp&classe=" + classe %>" >Annuler Visa</a>--%>
              <% } %>
              <%-- Bouton Imprimer : toujours visible (génère le PDF de la fiche) --%>
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
        <%-- Onglets : chaque lien recharge cette fiche avec un autre "tab" --%>
        <ul class="nav nav-tabs">
          <!-- a modifier -->
          <li class="<%=map.get("inc/bondecommande-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-liste-detail">Détails</a></li>
          <li class="<%=map.get("inc/as-bondelivraison")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/as-bondelivraison">D&eacute;tails de r&eacute;ception</a></li>
          <li class="<%=map.get("inc/achat-cpl-visee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/achat-cpl-visee">Rapprochement</a></li>
          <li class="<%=map.get("inc/details-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/details-facture">Facture fournisseur</a></li>
          <li class="<%=map.get("inc/facturation-multiple")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facturation-multiple">Facturation multiple</a></li>
          <!---<li class="<%=map.get("inc/ff-liee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ff-liee">Facture fournisseur</a></li>---->
        </ul>
        <%-- Contenu de l'onglet choisi : JSP inclus avec l'id du bon (paramètre idFactureFournisseur) --%>
        <div class="tab-content">
          <jsp:include page="<%= tab %>" >
            <jsp:param name="idFactureFournisseur" value="<%= id %>" />
          </jsp:include>
        </div>
      </div>

    </div>
  </div>
</div>
<%-- En cas d'erreur : trace dans server.log seulement --%>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }
%>
