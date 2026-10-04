<%@page import="faturefournisseur.FactureFournisseurCpl"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="depense.DepenseDiversLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="bean.CGenUtil" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    DepenseDiversLib o = new DepenseDiversLib();
    o.setNomTable("DEPENSEDIVERSLIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche du d&eacute;pense divers");
    String id = pc.getBase().getTuppleID();

    o=(DepenseDiversLib) pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("fournisseurLib").setLibelle("Fournisseur");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idModePaiementLib").setLibelle("Mode de paiement");
    pc.getChampByName("compteCheque").setLibelle("Compte ch&egrave;que");
    pc.getChampByName("acheteur").setLibelle("Acheteur");
    pc.getChampByName("idCategorieLib").setVisible(false);
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idMagasinLib").setVisible(false);
    pc.getChampByName("serviceLib").setLibelle("D&eacute;partement");
    pc.getChampByName("montantTotal").setLibelle("Montant Total");
    pc.getChampByName("surplusTotal").setLibelle("Surplus Total");
    pc.getChampByName("renduTotal").setLibelle("Rendu de Monnaie Total");
    pc.getChampByName("idSectionLib").setLibelle("Section");
    pc.getChampByName("service").setVisible(false);
    pc.getChampByName("idSection").setVisible(false);
    pc.getChampByName("fournisseur").setVisible(false);
    pc.getChampByName("idModepaiement").setVisible(false);
    pc.getChampByName("idMagasin").setVisible(false);
    pc.getChampByName("idCategorie").setVisible(false);
    pc.getChampByName("etat").setVisible(false);

    String[] ordre = {"id","daty","fournisseurLib","remarque","idModePaiementLib","compteCheque","acheteur","idCategorieLib","etatLib"};
    pc.setOrdre(ordre);

    String pageActuel = "depense/depense-divers-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = "depense/depense-divers-saisie.jsp&acte=update";
    String pageApresDelete = "depense/depense-divers-liste.jsp";
    String classe = "depense.DepenseDivers";

    Map<String, String> map = new HashMap<>();
    map.put("inc/depense-divers-detail", "");
    map.put("inc/as-bondelivraison", "");
    map.put("inc/facture-fournisseur", "");
    map.put("inc/mvtcaisse-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/depense-divers-detail";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    FactureFournisseurCpl facture = new FactureFournisseurCpl();
    facture.setNomTable("DEPENSEDFACTUREFOURNISSEUR");
    FactureFournisseurCpl[] factures = (FactureFournisseurCpl[]) CGenUtil.rechercher(facture, null, null, null, " and idDepenseDivers='"+id+"'");

    String role = u.getUser().getIdrole();
    int etat = o.getEtat();
    boolean chefDepartement = role.equalsIgnoreCase(ConstanteSocobis.ROLE_CHEF_DEP_BISC) || role.equalsIgnoreCase(ConstanteSocobis.ROLE_CHEF_DEP_CONF);
    boolean directeurDepartement = role.equalsIgnoreCase(ConstanteSocobis.ROLE_COMPTABLE);
    boolean directeur = role.equalsIgnoreCase(ConstanteSocobis.ROLE_DG);
    boolean controle = role.equalsIgnoreCase(ConstanteSocobis.ROLE_RESPACHAT);

    boolean afficher = (etat == ConstanteEtat.getEtatCreer() && chefDepartement)
        || (etat <= ConstanteSocobis.VALIDE_CHEF_DEPARTEMENT && directeurDepartement)
        || (etat <= ConstanteSocobis.VALIDE_DIRECTEUR_DEPARTEMENT && controle)
        || (etat <= ConstanteSocobis.VALIDE_DIRECTEUR && directeur);

%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
                        <% if (afficher) { %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=depense/depense-divers-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                        <% } %>
                        <% if (etat >= 4 && o.getEtat() < 11) { %>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a class="pull-left btn btn-primary" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute="+pageActuel+"&id=" + request.getParameter("id") %>">Annuler</a>
                        <% } if(o.getEtat()==11){%>
                          
                        <!---<a class="btn btn-secondary pull-right"  href="<%= lien + "?but=bondelivraison/bondelivraison-saisie.jsp&idDD=" + id%>" style="margin-right: 10px">Livrer</a>----->
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=depense/apresGenererFactureDefinitive.jsp&id=" + id%>" style="margin-right: 10px">G&eacute;n&eacute;rer facture d&eacute;finitive</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ "caisse/mvt/mvtCaisse-saisie-sortie-fc.jsp" +"&idOrigine=" + id+"&devise=AR&montant="+o.getMontantTotal()+"&tiers="+o.getFournisseur()+"&reference="%>" style="margin-right: 10px">D&eacute;caisser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ "caisse/mvt/mvtCaisse-saisie-sortie-fc.jsp" +"&idOrigine=" + id+"&devise=AR&tiers="+o.getFournisseur()+"&reference="%>" style="margin-right: 10px">Surplus</a>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=caisse/mvt/mvtCaisse-saisie-entree-fc.jsp&idOrigine=" + request.getParameter("id") + "&devise=AR&tiers="+o.getFournisseur()+"&taux=1"%> " style="margin-right: 10px">Rendu de monnaie</a>
                        <% } %>
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
                <li class="<%=map.get("inc/depense-divers-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/depense-divers-detail">D&eacute;tails</a></li>
                <li class="<%=map.get("inc/as-bondelivraison")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/as-bondelivraison">Détails de r&eacute;ception</a></li>
                <li class="<%=map.get("inc/facture-fournisseur")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/facture-fournisseur">Facture fournisseur</a></li>
                <% if(factures.length > 0) {%>
                    <li class="<%=map.get("inc/mvtcaisse-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&=<%= id%>&idFactureFournisseur=<%= factures[0].getId()%>&tab=inc/mvtcaisse-details">Mouvement de caisse</a></li>
                <% } %> 
                <% if(factures.length == 0) {%>
                    <li class="<%=map.get("inc/mvtcaisse-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&=<%= id%>&tab=inc/mvtcaisse-details">Mouvement de caisse</a></li>
                <% } %> 
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

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

