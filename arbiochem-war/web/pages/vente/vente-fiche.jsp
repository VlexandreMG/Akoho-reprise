<%@page import="vente.VenteLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@page import="fichier.AttacherFichier"%>
<%@page import="configuration.*"%>
<%@page import="uploadbean.*"%>
<%@ page import="utils.ConstanteSocobis" %>

<%
    try {
        // Vérifier s'il y a une erreur de génération PDF
        String erreur = (String) session.getAttribute("erreur");
        if (erreur != null && !erreur.isEmpty()) {
            session.removeAttribute("erreur");
%>
<script type="text/javascript">
    alert("Erreur : <%= erreur %>");
</script>
<%
        }

        //Information sur les navigations via la page
        String lien = (String) session.getValue("lien");
        String pageModif = "vente/vente-saisie.jsp&acte=update";
        String classe = "vente.Vente";
        String pageActuel = "vente/vente-fiche.jsp";

        //Information sur la fiche
        VenteLib dp = new VenteLib();
        PageConsulte pc = new PageConsulte(dp, request, (user.UserEJB) session.getValue("u"));
        dp = (VenteLib) pc.getBase();
        request.setAttribute("vente", dp);
        String id = request.getParameter("id");
        pc.getChampByName("id").setLibelle("Id");
        pc.getChampByName("estPrevulib").setLibelle("Est pr&eacute;vu");
        pc.getChampByName("designation").setLibelle("D&eacute;signation");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("modelivraisonlib").setLibelle("Mode de livraison");
        pc.getChampByName("fraislivraison").setLibelle("Total Frais de livraison(par kg)");
        pc.getChampByName("modelivraison").setVisible(false);
        pc.getChampByName("frais").setLibelle("Frais de livraison(par kg)");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("idMagasin").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("idDevise").setVisible(false);
        pc.getChampByName("idMagasinLib").setLibelle("Magasin");
        pc.getChampByName("provincelib").setLibelle("Province");
        pc.getChampByName("idClient").setVisible(false);
        pc.getChampByName("idClientLib").setLibelle("Client");
        pc.getChampByName("montanttotal").setLibelle("Montant HT");
        pc.getChampByName("montanttva").setLibelle("Montant TVA");
        pc.getChampByName("montantttc").setLibelle("Montant TTC");
        pc.getChampByName("montantTtcAr").setVisible(false);
        pc.getChampByName("idecriture").setLibelle("&Eacute;criture");
        pc.getChampByName("Montantpaye").setLibelle("Montant Pay&eacute;");
        pc.getChampByName("Montantreste").setLibelle("Reste &agrave; payer");
        pc.getChampByName("Tauxdechange").setVisible(false);
        pc.getChampByName("montantRevient").setVisible(false);
        pc.getChampByName("idprovince").setVisible(false);
        pc.getChampByName("datyprevu").setLibelle("Ech&eacute;ance de paiement");
        pc.getChampByName("margeBrute").setVisible(false);
        pc.getChampByName("montant").setVisible(false);
        pc.getChampByName("modepaiement").setVisible(false);
        pc.getChampByName("referencefact").setVisible(false);
        pc.getChampByName("idOrigine").setLibelle("Bon de Commande");
        pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
        pc.getChampByName("montantremise").setLibelle("Montant de la Remise");
        pc.getChampByName("poids").setLibelle("Poids (Kg)");
        pc.getChampByName("referencefacture").setLibelle("R&eacutef&eacute;rence de la facture");
        pc.getChampByName("numerofacture").setLibelle("Num&eacute;ro de la facture");
        pc.getChampByName("lieuLivraison").setLibelle("Lieu de livraison");
        pc.getChampByName("dateLivraison").setLibelle("Date de livraison");
        pc.getChampByName("annee").setLibelle("Annn&eacute;e");
        pc.getChampByName("idOrigine").setLien(lien + "?but=vente/bondecommande/bondecommande-fiche.jsp", "id=");
        pc.getChampByName("idEcriture").setLien(lien + "?but=compta/ecriture/ecriture-fiche.jsp", "id=");

        pc.setTitre("Fiche facture client");
        Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("vente-details", "");
        map.put("encaissement-vise-liste", "");
        map.put("livraison-detail", "");
        map.put("liste-prevision", "");
        if(dp.getEtat() >= ConstanteEtat.getEtatValider()) {
            map.put("mvtcaisse-details", "");
            map.put("ecriture-detail", "");
            map.put("avoirfc-details", "");
            map.put("paiementFacture-details.jsp", "");
        }
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "vente-details";
        }
        map.put("avoir-details", "");
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp";
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
        String dossierTemp = "vente/files/"+projectName;
        String dossier = dossierTemp;

        boolean isApro = false;
        String[] listApro = ConstanteSocobis.CLIENT_APPRO_VENTE;
        for (String client : listApro) {
            if (client.equals(dp.getIdClient())) {
                isApro = true;
                break;
            }
        }
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=vente/vente-liste.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <%=pc.getDuplicateButtonJS(pageModif,id)%>
                        <div class="box-footer">
                            <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                                <% if(dp.getMontantttc() > dp.getAvoir()) { %>
                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=avoir/avoirFC-saisie.jsp&idvente="+dp.getId()+"&classe=" + classe%> " style="margin-right: 10px; margin-bottom: 10px">G&eacute;n&eacute;rer avoir</a>
                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=avoir/avoirFC-saisie.jsp&idvente="+dp.getId()+"&sidtypeavoir="+ConstanteSocobis.typeavoiravecstock+"&classe=" + classe%> " style="margin-right: 10px; margin-bottom: 10px">G&eacute;n&eacute;rer avoir avec Stock</a>
                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=avoir/avoirFC-saisie.jsp&idvente="+dp.getId()+"&sidtypeavoir="+ConstanteSocobis.typeavoirengager+"&classe=" + classe%> " style="margin-right: 10px; margin-bottom: 10px">G&eacute;n&eacute;rer avoir avec Stock Engag&eacute;</a>

                                <% } %>

                                <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/paiement-facture-par-avoir.jsp&idvente="+dp.getId()%> " style="margin-right: 10px; margin-bottom: 10px">Payer par Ristourne/Avoir</a>
                               <!--<a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/paiement-facture-par-traite.jsp&idvente="+dp.getId()%> " style="margin-right: 10px; margin-bottom: 10px">Payer par une Traite</a>-->
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/planPaiement-saisie.jsp&idvt="+id+"&classe=vente.Vente&table="+dp.getNomTable()+"&bute="+pageActuel%>" style="margin-right: 10px; margin-bottom: 10px">Plan de Paiement</a>
                            <% }%>
                            <% if (dp.getEtat() < ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/vente-fiche.jsp&classe=" + classe%> " style="margin-right: 10px; margin-bottom: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=" + pageModif + "&id=" + id%>" style="margin-right: 10px; margin-bottom: 10px">Modifier</a>
                            <a class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute=vente/vente-fiche.jsp&classe=" + classe%>">Annuler</a>
                            <% }%>
                            <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=facturefournisseur/fraisaccessoire-saisie.jsp&idorigine=" + id+"&&idclient="+dp.getIdClient()%> " style="margin-right: 10px; margin-bottom: 10px">R&eacute;partition frais accessoire</a>
                            <% }%>
                            <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
<%--                                <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree-fc.jsp&idOrigine=" + request.getParameter("id") + "&montant="+dp.getMontantreste()+"&devise=" + dp.getIdDevise()+"&tiers="+dp.getIdClient()+"&taux="+dp.getTauxdechange() %> " style="margin-right: 10px; margin-bottom: 10px">Encaisser</a>--%>
                            <% }%>
                            <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                            <!--a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison-client/apresLivraisonFacture.jsp&id=" + request.getParameter("id") + "&bute=vente/encaissement-modif.jsp&classe=" + classe%> " style="margin-right: 10px; margin-bottom: 10px">Livrer</a-->
<%--                            <% if(isApro == true){%>--%>
                                <!--a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=stock/transfertstock/transfertstock-saisie.jsp&idfc_client=" + request.getParameter("id") + "&classe=" + classe%> " style="margin-right: 10px; margin-bottom: 10px">Transfert</a-->
                            <%  if(isApro == false) { %>
                                <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=bondelivraison-client/bondelivraison-client-saisie.jsp&idfc_client=" + request.getParameter("id") + "&classe=" + classe%> " style="margin-right: 10px; margin-bottom: 10px">Livrer</a>
                            <% }%>
                            <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvtcaisse-saisie-multiple.jsp&origine=" + id%> " style="margin-right: 10px; margin-bottom: 10px">Payer</a>
                            <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/paiement-mvtcaisse.jsp&id=" + request.getParameter("id") + "&idClient=" + dp.getIdClient()%> " style="margin-right: 10px; margin-bottom: 10px">Payer par portefeuille</a>
                                <% if(dp.getMontantttc() > dp.getAvoir()) { %>
                                    <a class="btn btn-danger pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/apres-annuler.jsp&id=" + request.getParameter("id") + "&bute=vente/vente-fiche.jsp" %> " style="margin-right: 10px; margin-bottom: 10px">Annuler</a>
                                <% }%>
                            <% }%>
                            <% if (dp.getEtat() > 11) {%>
<%--                                <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/bondelivraison-client/facturer-livraison.jsp&idVente=" + request.getParameter("id")%>" style="margin-right: 10px; margin-bottom: 10px">Attacher BL</a>--%>
                            <% } %>
                                <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_vente_nouveau&type=simple&id=<%=request.getParameter("id")%>" style="margin-right: 10px; margin-bottom: 10px">Imprimer</a>
                                <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_vente_nouveau&type=duplicata&id=<%=request.getParameter("id")%>" style="margin-right: 10px; margin-bottom: 10px">Imprimer avec duplicata</a>

                                <a class="btn btn-tertiary pull-right"  href="<%= (String) session.getValue("lien") + "?but=facture/reference-facture-saisie.jsp&id="+id%>" style="margin-right: 10px; margin-bottom: 10px">Ajouter r&eacute;f&eacute;rence Facture</a>


                                    <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px; margin-bottom: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
                                           
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
                                                        <li class="<%=map.get("vente-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=vente-details">D&eacute;tail(s)</a></li>
                                                        <li class="<%=map.get("ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=ecriture-detail">&Eacute;critures</a></li>
                                                            <li class="<%=map.get("livraison-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=livraison-details">Livraison D&eacute;tails</a></li>
                                                            <li class="<%=map.get("liste-prevision")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%=id%>&tab=liste-prevision">Plan de paiement</a></li>
                                                            <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                                                        
                                                        <li class="<%=map.get("facturefournisseur-lier")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=facturefournisseur-lier">Frais accessoire</a></li>
                                                        <li class="<%=map.get("encaissement-vise-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=encaissement-vise-liste">Paiement(s)</a></li>
                                                        <li class="<%=map.get("avoirfc-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=avoirfc-details">Avoir(s)</a></li>
                                                        <li class="<%=map.get("paiementFacture-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=paiementFacture-details">Liaison paiement(s)</a></li>   
                                                        <% }%>
                                                    </ul>
                                                    <div class="tab-content">       
                                                        <jsp:include page="<%= tab%>" >
                                                            <jsp:param name="idmere" value="<%= id%>" />
                                                        </jsp:include>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>

                                        <div class="row m-0">
                                    <%--<div class="col-md-1"></div>--%>
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
                                    <!--<form action="../UploadDownloadFileServlet" method="get">
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
</div>
</div>
<style>
    .bottom-vente-fiche {
        padding: 0 30px 0 30px; !important;
    }
</style>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
