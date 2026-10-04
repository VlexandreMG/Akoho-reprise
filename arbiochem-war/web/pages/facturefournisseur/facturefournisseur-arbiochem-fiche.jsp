<%@page import="fichier.AttacherFichier"%>
<%@page import="uploadbean.UploadService"%>
<%@page import="faturefournisseur.FactureFournisseurCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="depense.DepenseDivers" %>
<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    try{
    FactureFournisseurCpl f = new FactureFournisseurCpl();
    f.setNomTable("FACTUREFOURNISSEURCPL");
    PageConsulte pc = new PageConsulte(f, request, u);
    f=(FactureFournisseurCpl)pc.getBase();

    request.setAttribute("factureFournisseur", f);
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("idServiceLib").setLibelle("D&eacute;partement");
    pc.getChampByName("idMagasinLib").setVisible(false);
    pc.getChampByName("numero").setLibelle("Num&eacute;ro");
    pc.getChampByName("typeAchatLib").setLibelle("Type d'achat");
    pc.getChampByName("idFournisseurLib").setLibelle("Fournisseur");
    pc.getChampByName("designation").setLibelle("d&eacute;signation");
    pc.getChampByName("reference").setLibelle("r&eacute;f&eacute;rence");
    pc.getChampByName("idModePaiementLib").setLibelle("Mode de paiement");
    pc.getChampByName("montantPaye").setLibelle("Montant Pay&eacute;");
    pc.getChampByName("montantReste").setLibelle("Montant Restant");
    pc.getChampByName("dateEcheancePaiement").setLibelle("Date pr&eacutevisionnelle de paiement");
    pc.getChampByName("idDevise").setLibelle("Devise");
    pc.getChampByName("montanttva").setLibelle("Montant TVA");
    pc.getChampByName("idecriture").setLibelle("&Eacute;criture");
    pc.getChampByName("montantttc").setLibelle("Montant TTC");
    pc.getChampByName("montantht").setLibelle("Montant Hors Taxe");
    pc.getChampByName("montantttcAr").setLibelle("Montant TTC en Ar");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("tauxdechange").setLibelle("Taux de change");
    pc.getChampByName("typefacture").setLibelle("Type de Facture"); 
	pc.getChampByName("idBc").setLibelle("R&eacute;f&eacute;rence du bon de commande");
    pc.getChampByName("idfactureprincipale").setLibelle("Facture principale");
    pc.getChampByName("estPrevuLib").setLibelle("Est Pr&eacute;vu");
    
    
    
    pc.getChampByName("idfactureprincipale").setVisible(false);
    pc.getChampByName("service").setVisible(false);
    pc.getChampByName("taux").setVisible(false);
	pc.getChampByName("idMagasin").setVisible(false);
	pc.getChampByName("idFournisseur").setVisible(false);
	pc.getChampByName("idModePaiement").setVisible(false);
	pc.getChampByName("etatLib").setVisible(false);
    pc.getChampByName("devise").setVisible(false);
    pc.getChampByName("idPrevision").setVisible(false);
    pc.getChampByName("idObjet").setVisible(false);
    pc.getChampByName("idref").setVisible(false);
    pc.getChampByName("typeachat").setVisible(false);
    pc.getChampByName("idtypefacture").setVisible(false);
    pc.getChampByName("typeFactureFournisseurLib").setVisible(false);
    pc.getChampByName("typeFactureFournisseur").setVisible(false);
    //pc.getChampByName("motsclesss").setVisible(false);
    String[] ordre={"daty"};
    pc.setOrdre(ordre);

    String pageActuel = "facturefournisseur/facturefournisseur-arbiochem-fiche.jsp";

    String lien = (String) session.getValue("lien");
    String pageModif = "facturefournisseur/facturefournisseur-arbiochem-saisie.jsp";
    pc.getChampByName("idBc").setLien(lien+"?but=bondecommande/bondecommande-arbiochem-fiche.jsp", "id=");
    if(pc.getChampByName("idfactureprincipale").getValeur() != null && !pc.getChampByName("idfactureprincipale").getValeur().equals("")) {
        pc.getChampByName("idfactureprincipale").setVisible(true);
        if(pc.getChampByName("idfactureprincipale").getValeur().startsWith("VNT")) {
            pc.getChampByName("idfactureprincipale").setLien(lien+"?but=vente/vente-fiche.jsp", "id=");
        }else{
            pc.getChampByName("idfactureprincipale").setLien(lien+"?but=facturefournisseur/facturefournisseur-arbiochem-fiche.jsp", "id=");
        }
    }
    if(pc.getChampByName("idtypefacture").getValeur().equals(ConstanteSocobis.TYPE_FRAIS_ACCESSOIRE)) {
        pageModif = "facturefournisseur/fraisaccessoire-saisie.jsp";
    }
    String ref = null;
    if(f.getIdRef() != null && !f.getIdRef().equals("")) {
        DepenseDivers dep = new DepenseDivers();
        dep.setId(f.getIdRef());
        DepenseDivers[] deps = (DepenseDivers[]) CGenUtil.rechercher(dep, null, null, null, "");
        System.out.println("ETO");
        if(deps.length>0){
            System.out.println("DEP TROUVE");
            ref = deps[0].getCompteCheque();
        }
    }
    System.out.println(ref);

    String pageRepartition= "facturefournisseur/repartition-frais-divers.jsp";
    String classe = "faturefournisseur.FactureFournisseur";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/facture-fournisseur-liste-detail", "");
    map.put("inc/mvtcaisse-details", "");
    map.put("inc/ecriture-detail", "");
    map.put("inc/facture-fournisseur-bl.jsp", "");
    map.put("inc/avoir.jsp", "");
        map.put("inc/facturefournisseur-lier", "");
        map.put("inc/comparaisonPrixFactBC", "");
    //map.put("inc/encaissement-vise-liste", "");
    if (f.getTypeFactureFournisseur() != null && f.getTypeFactureFournisseur().equalsIgnoreCase(ConstanteSocobis.typeFactureFournisseurFAE)) {
        pc.setTitre("Fiche de proforma");
        map.put("inc/facture-definitive", "");
    } else {

        if (f.getTypefacture() != null && f.getTypefacture().equalsIgnoreCase("Frais accessoire")) {
            pc.setTitre("Fiche du frais accessoire");
        } else {
            pc.setTitre("Fiche de facture d&eacute;finitive");
        }

        map.put("inc/facture-proforma", "");
    }

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/facture-fournisseur-liste-detail";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    String idDevise = ((FactureFournisseurCpl)pc.getBase()).getIdDevise();
    request.setAttribute("idDevise", idDevise);
    boolean farExist = f.getDefinitive(null, null) == null;

        AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
        configuration.CynthiaConf.load();
        String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
        String projectName = pc.getChampByName("designation").getValeur()
                    .replace("'","_")                
                    .replace("/","_")
                    .replace("-","_")
                    .replace(":", "_")
                    .replace("*", "_")
                    .replace(" ", "_");
        String dossierTemp = "achat/files/"+projectName;
        String dossier = dossierTemp;

%>

<div class="content-wrapper">
   
    <h1 class="box-title"><a href=<%= lien + "?but=facturefournisseur/facturefournisseur-arbiochem-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                   
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
<%--                        <%=pc.getDuplicateButtonJS(pageModif,id)%>--%>
                        <div class="box-footer">
                            <% if (f.getEtat() < 11) { %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=facturefournisseur/facturefournisseur-arbiochem-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                                <% if(f.getTypeFactureFournisseur()!=null && f.getTypeFactureFournisseur().compareToIgnoreCase(ConstanteSocobis.typeFactureDepenses)!=0) { %>
                                    <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                                <% }%>
                            <% }
                            %>
                            <% if (f.getEtat() >= 11) { %>
                                <!--<a class="btn btn-primary pull-right" href="<%= lien + "?but="+ "facturefournisseur/apresLivraisonFacture.jsp" +"&id=" + id%>" style="margin-right: 10px">R&eacute;ceptionner</a>-->
                                <!--<a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison/bondelivraison-saisie.jsp&idfacture="+id%> " style="margin-right: 10px">R&eacute;ceptionner</a>-->
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ "facturefournisseur/avoir/avoirachat-arbiochem-saisie.jsp&idFactureFournisseur=" + id %>" style="margin-right: 10px">G&eacute;n&eacute;rer Avoir</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ "caisse/mvt/mvtCaisse-saisie-sortie-fc.jsp" +"&idOrigine=" + id+"&devise="+f.getIdDevise()+"&montant="+f.getMontantreste()+"&tiers="+f.getIdFournisseur()+"&idPrevision="+f.getIdPrevision()+"&reference="+ref + "&taux=" + f.getTauxdechange()%>" style="margin-right: 10px">D&eacute;caisser</a>
                                <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/planPaiement-saisie.jsp&idvt="+id+"&classe=faturefournisseur.FactureFournisseur&table="+f.getNomTable()+"&bute="+pageActuel%>" style="margin-right: 10px">Plan de Paiement</a>
                                <% if (f.getTypeFactureFournisseur() != null && f.getTypeFactureFournisseur().equalsIgnoreCase(ConstanteSocobis.typeFactureFournisseurFAE) && farExist) { %>
                                    <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=facturefournisseur/facturefournisseur-arbiochem-saisie.jsp&idP=" + id%>" style="margin-right: 10px">&Eacute;diter facture d&eacute;finitive</a>
                                <% } else { %>
<%--                                    <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/liaison-facture-fournisseurs.jsp&id=" + id%>" style="margin-right: 10px;">Lier Frais accessoire</a>--%>

                                    <% if (f.getIdtypefacture() != null && !f.getIdtypefacture().equals(ConstanteSocobis.TYPE_FRAIS_ACCESSOIRE))  {%>
                                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/fraisaccessoire-arbiochem-saisie.jsp&currentMenu=MENDYN1776685361607657&idFactureFournisseur=" + id%>" style="margin-right: 10px;">Ajouter Frais accessoire</a>
                                        <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageRepartition +"&id=" + id%>" style="margin-right: 10px">R&eacute;partition frais accessoire</a>
                                        <a class="btn btn-secondary pull-right"  href="<%= (String) session.getValue("lien") + "?but=facturefournisseur/apresRecalculer.jsp&id=" + request.getParameter("id") + "&bute=facturefournisseur/facturefournisseur-arbiochem-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Re-Calculer frais accessoire</a>
                                    <% }%>

                                <% } %>
                            <% } %>
                            <% if (f.getTypeFactureFournisseur() == null || !f.getTypeFactureFournisseur().equalsIgnoreCase(ConstanteSocobis.typeFactureFournisseurFAE)) { %>
                            <a class="btn btn-secondary pull-right"  href="<%= (String) session.getValue("lien") + "?but=facture/reference-facture-saisie.jsp&id="+id%>" style="margin-right: 10px">Ajouter r&eacute;f&eacute;rence Facture</a>
                            <% } %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
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
                    <li class="<%=map.get("inc/facture-fournisseur-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-fournisseur-liste-detail">Détails</a></li>
                    <li class="<%=map.get("inc/facture-fournisseur-bl")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-fournisseur-bl">Bon de r&eacute;ception rattach&eacute;</a></li>
                    <li class="<%=map.get("inc/ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/ecriture-detail">Écriture</a></li>
                       
                    <li class="<%=map.get("inc/mvtcaisse-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/mvtcaisse-details">Mouvement de caisse</a></li>
                    <li class="<%=map.get("inc/liste-prevision")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/liste-prevision">Plan de paiements</a></li>
                    <% if (f.getIdtypefacture() != null && !f.getIdtypefacture().equals(ConstanteSocobis.TYPE_FRAIS_ACCESSOIRE)) {   %>
                        <li class="<%=map.get("inc/facturefournisseur-lier")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/facturefournisseur-lier">Frais Accessoire</a></li>
                    <% }   %>
                    <li class="<%=map.get("inc/as-bondelivraison")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/as-bondelivraison">Détails de r&eacute;ception</a></li>
                    <li class="<%=map.get("inc/comparaisonPrixFactBC")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/comparaisonPrixFactBC">Comparaison de prix </a></li>
                    <li class="<%=map.get("inc/avoir")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/avoir">Avoir(s) </a></li>
                    <!--<li class="<%=map.get("inc/encaissement-vise-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/encaissement-vise-liste">Paiement(s)</a></li>--->
                    <% if (f.getTypeFactureFournisseur() != null && f.getTypeFactureFournisseur().equalsIgnoreCase(ConstanteSocobis.typeFactureFournisseurFAE)) { %>
                        <li class="<%=map.get("inc/facture-definitive")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-definitive">Facture D&eacute;finitive</a></li>
                    <% } else { %>
                        <li class="<%=map.get("inc/facture-proforma")%>"><a href="<%= lien %>?but=<%= pageActuel %>&idFactPrincipale=<%= f.getIdfactureprincipale() %>&tab=inc/facture-proforma">Proforma</a></li>
                    <% } %>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idFactureFournisseur" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
    <div class="row m-0">
        <%--        <div class="col-md-1"></div>--%>
        <div class="col-md-12 bottom-vente-fiche nopadding">
            <div class="box">
                <h2 class="box-title" style="margin-left: 10px;">Les fichiers attach&eacute;s</h2>
                <div class="box-body" style="padding: 0 20px 20px 20px;">
                    <table class="table table-striped table-bordered table-condensed tree" style="color: #4e4e4e;">
                        <thead>
                        <tr>
                            <th class='contenuetable'></th>
                            <th class='contenuetable'>Libell&eacute;</th>
                            <th class='contenuetable'>Fichier</th>
                            <th class='contenuetable'>Date d`upload</th>
                            <th class='contenuetable'>T&eacute;l&eacute;charger</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%if (fichiers == null || fichiers.length == 0) { %>
                        <tr>
                            <td colspan="3" style="text-align: center;"><strong>Aucun fichier</strong></td>
                        </tr>
                        <%} else {
                            for (AttacherFichier fichier : fichiers) {%>
                        <tr class="treegrid-1 treegrid-expanded">
                            <td><span class="treegrid-expander glyphicon glyphicon-minus"></span></td>
                            <td><%=fichier.getChemin()%></td>
                            <td><%=Utilitaire.champNull(fichier.getLibelle())%></td>
                            <td><%=fichier.getDaty()%></td>
                            <td>
                                <!--                                    <form action="../UploadDownloadFileServlet" method="get">
                                            <input type="submit" value="download">
                                            <input type="hidden" name="fileName" value="<%=cdn + dossier + "/" + fichier.getChemin()%>">
                                        </form>-->
                                <a href="../FileManager2?parent=<%= "/"+dossier + "/" +fichier.getChemin()  %>" class="btn btn-success" >T&eacute;l&eacute;charger</a>
                            </td>
                        </tr>
                        <%}
                        }%>

                        </tbody>

                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<style>
    .bottom-vente-fiche {
        padding: 0 30px 0 30px; !important;
    }
</style>

<% } catch(Exception e) { 
    e.printStackTrace();
    throw e;
} %>