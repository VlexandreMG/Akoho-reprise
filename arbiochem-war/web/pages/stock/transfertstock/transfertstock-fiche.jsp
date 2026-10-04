<%@page import="stock.TransfertStockCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="fichier.AttacherFichier"%>
<%@page import="configuration.*"%>
<%@page import="uploadbean.*"%>
<%@page import="java.net.URLEncoder"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
try {
    String lien = (String) session.getValue("lien");
    TransfertStockCpl unite = new TransfertStockCpl();
    PageConsulte pc = new PageConsulte(unite, request, u);
    pc.setTitre("Fiche transfert de stock");
    pc.getBase();
    unite=(TransfertStockCpl)pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("Id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("idMagasinDepartlib").setLibelle("Magasin de d&eacute;part");
    pc.getChampByName("idMagasinDepart").setVisible(false);
    pc.getChampByName("idMagasinArrivelib").setLibelle("Magasin d&apos;arriv&eacute;e");
    pc.getChampByName("idMagasinArrive").setVisible(false);
    pc.getChampByName("etatlib").setVisible(false);
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("idOf").setLibelle("Ordre de fabrication associé");
    String idOf = pc.getChampByName("idOf").getValeur();
    if(!Utilitaire.champNull(idOf).isEmpty()){
        pc.getChampByName("idOf").setLien(lien+"?but=fabrication/ordre-fabrication-fiche.jsp", "id=");
    }
 
    String pageActuel = "stock/transfertstock/transfertstock-fiche.jsp";

    String pageModif = "stock/transfertstock/transfertstock-saisie.jsp&acte=update";
    String classe = "stock.TransfertStock";
    
    Map<String, String> map = new HashMap<String, String>();
    map.put("transfertstockdetails-liste", "");
    map.put("mvtstock-details", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "transfertstockdetails-liste";
    }
    map.put(tab, "active");
    tab ="inc/"+ tab + ".jsp";
    AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
    String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
    String projectName = pc.getChampByName("designation").getValeur()
                .replace("'","_")                
                .replace("/","_")
                .replace("-","_")
                .replace(":", "_")
                .replace("*", "_")
                .replace(" ", "_");
    String dossierTemp = "mvtstock/files/"+projectName;
    String dossier = dossierTemp;

%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=stock/mvtstock-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row">
         <div class="col-md-12 mb-5" >
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body ">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (unite.getEtat() < 11) { %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=stock/transfertstock/transfertstock-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=annexe/unite/unite-liste.jsp&classe="+classe %>">Supprimer</a>
                            <% } %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px; margin-bottom: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
                            <%
                                // inline=1 -> ExportPDF sert le PDF en Content-Disposition: inline
                                // (+ application/pdf), ce qui permet le rendu dans l'iframe du modal.
                                // Sans le parametre : disposition attachment, comportement d'origine.
                                String pdfBase = request.getContextPath() + "/ExportPDFARBIOCHEM?action=fiche_transfert_stock&id="
                                        + URLEncoder.encode(id, "UTF-8");
                                String pdfApercu = pdfBase + "&inline=1";
                            %>
                            <button type="button" class="btn btn-tertiary pull-right"
                                    data-url="<%= pdfApercu %>"
                                    data-dl="<%= pdfBase %>"
                                    data-kind="pdf"
                                    data-name="Transfert de stock <%= id %>"
                                    onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"
                                    style="margin-right: 10px">Imprimer PDF
                            </button>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("transfertstockdetails")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=transfertstockdetails-liste">Détails du transfert</a></li>
                    <li class="<%=map.get("mvtstock-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=mvtstock-details">Mouvement de stock</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idTransfertStock" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>      
    
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

<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>