<%@page import="fichier.AttacherFichier"%>
<%@page import="uploadbean.UploadService"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="faturefournisseur.FactureDeclarationCpl" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    try{
    FactureDeclarationCpl f = new FactureDeclarationCpl();
    f.setNomTable("FACTUREDECLARATIONCPL");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("Fiche facture de d&eacute;claration");
    f=(FactureDeclarationCpl)pc.getBase();
    request.setAttribute("facturedeclaration", f);
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("idMagasinLib").setLibelle("Point");
    pc.getChampByName("numero").setLibelle("Num&eacute;ro");
    pc.getChampByName("idFournisseurLib").setLibelle("Fournisseur");
    pc.getChampByName("designation").setLibelle("d&eacute;signation");
    pc.getChampByName("reference").setLibelle("r&eacute;f&eacute;rence");
    pc.getChampByName("idModePaiementLib").setLibelle("Mode de paiement");
    pc.getChampByName("montantPaye").setLibelle("Montant Pay&eacute;");
    pc.getChampByName("montantReste").setLibelle("Montant Restant");
    pc.getChampByName("dateEcheancePaiement").setLibelle("Date pr&eacutevisionnelle de paiement");
    pc.getChampByName("idDevise").setVisible(false);
    pc.getChampByName("montanttva").setVisible(false);
    pc.getChampByName("montantttc").setVisible(false);
    pc.getChampByName("montantht").setVisible(false);
    pc.getChampByName("montantttcAr").setLibelle("Montant");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("tauxdechange").setVisible(false);
    pc.getChampByName("typefacture").setVisible(false);
	pc.getChampByName("idBc").setVisible(false);
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

    String pageActuel = "facturefournisseur/facturedeclaration-fiche.jsp";

    String lien = (String) session.getValue("lien");
    pc.getChampByName("idBc").setLien(lien+"?but=bondecommande/bondecommande-fiche.jsp", "id=");

    String pageModif = "facturefournisseur/facturedeclaration-saisie.jsp";
    String pageRepartition= "facturefournisseur/repartition-frais-divers.jsp";
    String classe = "faturefournisseur.FactureDeclaration";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/facture-declaration-liste-detail", "");
    map.put("inc/mvtcaisse-details", "");
    map.put("inc/ecriture-detail", "");
    map.put("inc/facture-fournisseur-bl.jsp", "");
    map.put("inc/facturefournisseur-lier", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/facture-declaration-liste-detail";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    String idDevise = ((FactureDeclarationCpl)pc.getBase()).getIdDevise();
    request.setAttribute("idDevise", idDevise);
    
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
   
    <h1 class="box-title"><a href=<%= lien + "?but=facturefournisseur/Facturedeclaration-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
                            <% if (f.getEtat() < 11) { %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=facturefournisseur/facturedeclaration-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <% }
                            %>
                            <% if (f.getEtat() >= 11) { %>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ "caisse/mvt/mvtCaisse-saisie-sortie-fc.jsp" +"&idOrigine=" + id+"&devise="+f.getIdDevise()+"&montant="+f.getMontantreste()+"&tiers="+f.getIdFournisseur()+"&idPrevision="+f.getIdPrevision()%>" style="margin-right: 10px">D&eacute;caisser</a>
                            <% }
                            %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
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
                    <li class="<%=map.get("inc/facture-declaration-liste-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-declaration-liste-detail">Détails</a></li>
                    <li class="<%=map.get("inc/ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/ecriture-detail">Écriture</a></li>
                       
                    <li class="<%=map.get("inc/mvtcaisse-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=inc/mvtcaisse-details">Mouvement de caisse</a></li>

                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idFactureDeclaration" value="<%= id %>" />
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