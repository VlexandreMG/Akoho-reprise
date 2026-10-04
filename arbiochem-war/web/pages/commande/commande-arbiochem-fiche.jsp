<%@page import="faturefournisseur.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="vente.CommandeFille"%>
<%@page import="fichier.AttacherFichier"%>
<%@page import="uploadbean.UploadService"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>
<%
    try{
    String lien = (String) session.getValue("lien");
    vente.CommandeCpl f = new vente.CommandeCpl();
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("Fiche de la demande client");
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("reference").setLibelle("Référence");
    pc.getChampByName("FraisLivraison").setLibelle("Frais de Livraison (Par kg)");
    pc.getChampByName("FraisLivraison").setVisible(false);
    pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("designation").setLibelle("Désignation");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idDevise").setLibelle("Devise");
    pc.getChampByName("idDevise").setVisible(false);
    pc.getChampByName("modePaiementLib").setVisible(false);
    pc.getChampByName("idClient").setLibelle("Client");
    pc.getChampByName("Montantttc").setLibelle("Montant");
    pc.getChampByName("Montantttc").setVisible(false);
    pc.getChampByName("idMagasin").setLibelle("Magasin");
    pc.getChampByName("idProforma").setLibelle("ID Proforma");
    pc.getChampByName("idProforma").setVisible(false);
    pc.getChampByName("modeLivraison").setVisible(false);
    pc.getChampByName("lieuLivraison").setLibelle("Lieu de livraison");
    pc.getChampByName("dateLivraison").setLibelle("Date de livraison");
    pc.getChampByName("dateBesoin").setVisible(false);

    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("idClientLib").setLibelle("Client");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("modelivraisonLib").setLibelle("Mode de livraison");

        pc.getChampByName("idMagasin").setVisible(false);
        pc.getChampByName("idClient").setVisible(false);
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("modelivraison").setVisible(false);
        pc.getChampByName("modePaiement").setVisible(false);

    String pageActuel = "commande/commande-arbiochem-fiche.jsp";
    String pageModif = "commande/commande-arbiochem-saisie.jsp";
    String classe = "vente.Commande";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/commande-fille-arbiochem", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/commande-fille-arbiochem";
    }

    map.put(tab, "active");
    tab = tab + ".jsp";
    f = (vente.CommandeCpl)pc.getBase();

    // Récupération des fichiers attachés
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
    String dossier = "commande/files/" + projectName;
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=commande/commande-arbiochem-fiche.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <% if (f.getEtat() < 11) {%>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresMultiple.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=commande/commande-arbiochem-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Valider</a>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <%if( f.getEtat() >= 11){ %>
                                <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/proforma/proforma-arbiochem-saisie.jsp&idCommande="+id%> " style="margin-right: 10px">Créer un proforma</a>
                                <!--a class="btn btn-info pull-right"  href="<%= lien + "?but=vente/bondecommande/bondecommande-saisie.jsp&idCommande=" + id%>" style="margin-right: 10px">Cr&eacute;er BC</a-->
                            <%}%>
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
                    <li class="<%=map.get("inc/commande-fille-arbiochem")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/commande-fille-arbiochem">Détails </a></li>
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

<!-- Section des fichiers attachés -->
<div class="content-wrapper">
    <div class="col-md-12 nopadding">
        <div class="box">
            <h2 class="box-title" style="margin-left: 10px;">Les fichiers attachés</h2>
            <div class="box-body" style="padding: 0 20px 20px 20px;">
                <table class="table table-striped table-bordered table-condensed tree" style="color: #4e4e4e;">
                    <thead>
                    <tr>
                        <th class='contenuetable'></th>
                        <th class='contenuetable'>Libellé</th>
                        <th class='contenuetable'>Fichier</th>
                        <th class='contenuetable'>Date d'upload</th>
                        <th class='contenuetable'>Télécharger</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%if (fichiers == null || fichiers.length == 0) { %>
                    <tr>
                        <td colspan="5" style="text-align: center;"><strong>Aucun fichier</strong></td>
                    </tr>
                    <%} else {
                        for (AttacherFichier fichier : fichiers) {%>
                    <tr class="treegrid-1 treegrid-expanded">
                        <td><span class="treegrid-expander glyphicon glyphicon-minus"></span></td>
                        <td><%=fichier.getChemin()%></td>
                        <td><%=Utilitaire.champNull(fichier.getLibelle())%></td>
                        <td><%=fichier.getDaty()%></td>
                        <td>
                            <a href="../FileManager2?parent=<%= "/" + dossier + "/" + fichier.getChemin() %>" class="btn btn-success">Télécharger</a>
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

<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>

