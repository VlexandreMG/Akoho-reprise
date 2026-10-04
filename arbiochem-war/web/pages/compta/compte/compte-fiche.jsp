<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="mg.cnaps.compta.*" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="utilitaire.Utilitaire" %>
<%@page import="java.sql.Date" %>
<%@page import="mg.cnaps.compta.*" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="utilitaire.UtilDB" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%
    try{
        ComptaCompte compte = new ComptaCompte();
        compte.setNomTable("COMPTA_COMPTE_LIBELLE");
        String[] libelleCompteFiche = {"Id", "Compte", "Libell&eacute;", "Type Compte","Classe","Journal"};
        PageConsulte pc = new PageConsulte(compte, request, (user.UserEJB) session.getValue("u"));
        pc.setLibAffichage(libelleCompteFiche);
        pc.getChampByName("idtypecompte").setVisible(false);
        pc.setTitre("Fiche Compte");
        String lien = (String) session.getValue("lien");
        ComptaCompte base=(ComptaCompte)pc.getBase();
%>

<div class="content-wrapper">
    <h1 class="box-title">
        <a href=<%= lien + "?but=compta/compte/compte-liste.jsp"%>> <i class="fa fa-arrow-circle-left"></i></a>
        <%=pc.getTitre()%>
    </h1>
    <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%= pc.getHtml() %>
                    </div>
                     <div class="box-footer">
                        <a  href="<%=(String) session.getValue("lien") + "?but=compta/compte/compte-saisie.jsp&acte=update&id=" +  request.getParameter("id")%>" class="btn btn-secondary pull-right">Modifier</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

<%
    String lang = session.getAttribute("lang") != null ? session.getAttribute("lang").toString() : "fr";
    // Clés pour les filtres
    String[] mots = {"Generer etats", "Exercice", "Type de compte", "Type etat", "Mois debut", "Mois fin", "Compte", "Au compte", "Balance comparative", "Afficher"};
    String[] ret = Utilitaire.transformerLangue(mots, lang);
    if (ret == null) ret = mots;
    // Clés pour le tableau Grand Livre
    String[] motsGL = {"Grand livre du compte", "au", "Compte", "Libelle du compte", "Journal", "Date", "Libelle", "Lettrage", "Mouvement", "Debit", "Credit", "Solde", "exporter"};
    String[] retGL = Utilitaire.transformerLangue(motsGL, lang);
    if (retGL == null) retGL = motsGL;
    String date1 = request.getParameter("dateDebut");
    String date2 = request.getParameter("dateFin");
    String compteParam = base.getCompte();
    ComptaCompte cmc =(ComptaCompte) new ComptaCompte().getById(base.getTuppleID(),"COMPTA_COMPTE",null);
    String typeCompteParam = cmc.getTypeCompte();
    ComptaEtatGrandLivreGenerator grandLivre = null;
    String dateJour= Utilitaire.dateDuJour();
    String moisMaxGl = Utilitaire.getMois(dateJour);
    Connection c = null;
    String errorMsg = null;
    // On ne charge les données QUE si les paramètres de date sont présents
    if (date1 != null && !date1.isEmpty() && date2 != null && !date2.isEmpty()) {
        try {
            grandLivre = new ComptaEtatGrandLivreGenerator();
            grandLivre.setNomTable("v_compta_etat_balance");

            PageInsert pi = new PageInsert();
            pi.setBase(grandLivre);
            pi.setReq(request);
            grandLivre = (ComptaEtatGrandLivreGenerator) pi.getObjectAvecValeur();

            if (grandLivre != null) {
                grandLivre.normalizeComptes();
                grandLivre.fillComptesWithMouvementAndReport(null);
                c = new UtilDB().GetConn();
            }
        } catch (Exception e) {
            errorMsg = "Erreur lors du chargement des données : " + e.getMessage();
            e.printStackTrace();
        }
    }
%>
    <div class="row m-0">
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <jsp:include page='../../elements/css.jsp'/>
    <% if (errorMsg != null) { %>
    <style>
        .error-box { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 15px; margin: 20px; border-radius: 5px; font-family: monospace; }
    </style>
    <% } %>
    <script>
        function getLastDayOfMonth(year, month) {
            return new Date(year, month, 0).getDate();
        }
        function afficherGrandLivre() {
            var exercice = $('#exercice').val();
            var typecompte = $('#typecompte').val();
            var compte = $('#compte').val();
            var moisMin = $('#moisMin').val();
            var moisMax = $('#moisMax').val();
            if (!exercice || !typecompte || !compte || !moisMin || !moisMax) {
                alert('Veuillez remplir tous les champs.');
                return;
            }
            if (parseInt(moisMin) > parseInt(moisMax)) {
                alert('Le mois de début doit être inférieur ou égal au mois de fin.');
                return;
            }
            var mMin = (moisMin.length === 1) ? '0' + moisMin : moisMin;
            var mMax = (moisMax.length === 1) ? '0' + moisMax : moisMax;
            var dateDebut = exercice + "-" + mMin + "-01";
            var lastDay = getLastDayOfMonth(parseInt(exercice), parseInt(moisMax));
            var dFin = (lastDay < 10) ? '0' + lastDay : lastDay;
            var dateFin = exercice + "-" + mMax + "-" + dFin;
            var url = "module.jsp?but=compta/compte/compte-fiche.jsp&&compte=" + encodeURIComponent(compte) +
                               "&id=" + encodeURIComponent('<%=base.getTuppleID()%>') +
                               "&compteDebut=" + encodeURIComponent(compte) +
                               "&compteFin=" + encodeURIComponent(compte) +
                               "&dateDebut=" + dateDebut +
                               "&dateFin=" + dateFin +
                               "&exercice=" + exercice +
                               "&typeCompte=" + typecompte +
                               "&moisMin=" + moisMin +
                               "&moisMax=" + moisMax;

            window.location.href = url;
        }
    </script>

       <div class="col-md-12 cardradius">
        <h1 class="box-title"><%=ret[0]%></h1>
            <h1 class="box-title"><%= ret[0] %></h1>
            <div class="input-container">
                 <!-- Compte -->
                <input type="hidden" id="compte" name="compte" class="form-control" placeholder="Ex: 411000"
                       value="<%= compteParam != null ? compteParam : "" %>"/>
                <!-- Exercice -->
                <div class="form-input">
                    <label class="input-label" for="exercice"><%= ret[1] %></label>
                    <span class="d-flex gap-2">
                        <input type="text" id="exercice" name="exercice" class="form-control"
                               value="<%= request.getParameter("exercice") != null ? request.getParameter("exercice") : Utilitaire.getAnneeEnCours() %>">
                    </span>
                </div>
                <!-- Mois min -->
                <div class="form-input">
                    <label class="input-label" for="moisMin"><%= ret[4] %></label>
                    <span class="d-flex gap-2">
                        <select name="moisMin" id="moisMin" class="form-control">
                            <%
                                String selectedMin = request.getParameter("moisMin");
                                if (selectedMin == null) selectedMin = String.valueOf(Integer.parseInt(moisMaxGl));
                                String[] moisNoms = {"", "Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                                                     "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"};
                                for (int i = 1; i <= 12; i++) {
                                    String val = String.valueOf(i);
                                    String isSelected = (val.equals(selectedMin)) ? "selected" : "";
                            %>
                                <option value="<%=val%>" <%=isSelected%>><%=moisNoms[i]%></option>
                            <% } %>
                        </select>
                    </span>
                </div>
                <!-- Mois max -->
                <div class="form-input">
                    <label class="input-label" for="moisMax"><%= ret[5] %></label>
                    <span class="d-flex gap-2">
                        <select name="moisMax" id="moisMax" class="form-control">
                            <%
                                String selectedMax = request.getParameter("moisMax");
                                if (selectedMax == null) selectedMax = String.valueOf(Integer.parseInt(moisMaxGl));
                                for (int i = 1; i <= 12; i++) {
                                    String val = String.valueOf(i);
                                    String isSelected = (val.equals(selectedMax)) ? "selected" : "";
                            %>
                                <option value="<%=val%>" <%=isSelected%>><%=moisNoms[i]%></option>
                            <% } %>
                        </select>
                    </span>
                </div>
                <div class="form-input">
                    <label class="input-label" for="typecompte"><%= ret[2] %></label>
                    <span class="d-flex gap-2">
                        <select name="typecompte" id="typecompte" class="form-control">
                            <option value="1" <%= "1".equals(typeCompteParam) ? "selected" : "" %>>Général</option>
                            <option value="3" <%= "3".equals(typeCompteParam) ? "selected" : "" %>>Analytique</option>
                        </select>
                    </span>
                </div>
            </div>
            <div class="box-footer borderless nopadding" style="margin-top: 1rem;">
                <button type="button" class="btn btn-primary pull-right" style="margin-right: 0;" onclick="afficherGrandLivre()">
                    <%= ret[9] %>
                </button>
            </div>
        </div>
    </div>
    <br>
    <br>
    <br>
    <% if (grandLivre != null) { %>
    <div class="row m-0" style="margin-top: 300px;">
    <div class="row" style="margin-top: 300px;">
        <div class="col-md-12" style="margin-top: 30px;">
            <div class="box box-solid">
                <div class="content">
                    <div id="table-container">
                        <div class="d-flex align-items-center col-12">
                            <div class="box-header with-border">
                                <h3 class="title" id="titre-export">
                            </div>
                            <div style="display: flex; gap: 30px; margin-left: auto; margin-right: 20px;">
                                <div style="display: flex; align-items: center;">
                                    <div class="form-group mb-0">
                                        <label style="margin-right: 10px; margin-bottom: 0;">Format</label>
                                        <select name="ext" id="ext" class="form-control" style="width: 150px;">
                                            <option value="xls">Excel</option>
                                            <option value="pdf">PDF</option>
                                        </select>
                                    </div>
                                </div>
                                <div style="border-left: 2px solid #ddd; padding-left: 30px; padding: 15px; padding-top: 25px;">
                                    <input type="button" class="btn btn-info" value="<%= retGL[12] %>" onclick="exporter()"/>
                                </div>
                            </div>
                        </div>
                        <div class="box-body table-responsive no-padding">
                            <table id="export" border="1" class="table table-hover table-bordered">
                                <tbody>
                                <%
                                    for (Map.Entry<String,ComptaCompte> listeComptes : grandLivre.getComptes().entrySet()) {
                                        ComptaCompte cc = listeComptes.getValue();
                                        List<ComptaSousEcriture> mouvements = cc.getMouvements();

                                        if (cc.getReportDebit() != 0 || cc.getReportCredit() != 0 || (mouvements != null && mouvements.size() > 0)) {
                                %>
                                <tr class="head">
                                    <th colspan="11"><%= retGL[2] %> : <%= cc.getCompte()%> </th>
                                </tr>
                                <tr>
                                    <th><%= retGL[2] %></th>
                                    <th>ID Mouvement</th>
                                    <th><%= retGL[5] %></th>
                                    <th><%= retGL[4] %>/Folio</th>
                                    <th>Contrep.</th>
                                    <th><%= retGL[6] %> Oper.</th>
                                    <th><%= retGL[9] %></th>
                                    <th><%= retGL[10] %></th>
                                    <th><%= retGL[7] %></th>
                                    <% if (grandLivre.getTypeCompte().compareToIgnoreCase("1") == 0) { %>
                                        <th>Compte analytique</th>
                                    <% } else { %>
                                        <th>Compte g&eacute;n&eacute;ral</th>
                                    <% } %>
                                    <th>&Eacute;tat</th>
                                </tr>
                                <tr>
                                    <td colspan="5"></td>
                                    <td>Ancien cumul...</td>
                                    <td><%= (cc.getReportDebit() == 0) ? "" : Utilitaire.formaterAr(cc.getReportDebit()) %></td>
                                    <td><%= (cc.getReportCredit() == 0) ? "" : Utilitaire.formaterAr(cc.getReportCredit()) %></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <%
                                    if (mouvements != null) {
                                        for (ComptaSousEcriture comptaEcriture : mouvements) {
                                            if (comptaEcriture != null) {
                                                String color = (comptaEcriture.getEtat() == 1) ? "red" : "black";
                                %>
                                <tr>
                                    <td><%= cc.getCompte()%></td>
                                    <td>
                                        <a href="<%=(String) session.getAttribute("lien")%>/../../../module.jsp?but=compta/ecriture/ecriture-fiche.jsp&id=<%=comptaEcriture.getIdMere()%>" target="_blank">
                                            <%=comptaEcriture.getIdMere()%>
                                        </a>
                                    </td>
                                    <td><%= Utilitaire.formatterDaty(comptaEcriture.getDaty())%></td>
                                    <td><%= comptaEcriture.getJournal()%>/<%= comptaEcriture.getFolio()%></td>
                                    <td><%= comptaEcriture.getContrePartie(c)%></td>
                                    <td><%= comptaEcriture.getRemarque()%></td>
                                    <td style="text-align: right"><%= (comptaEcriture.getDebit() == 0) ? "" : Utilitaire.formaterAr(comptaEcriture.getDebit()) %></td>
                                    <td style="text-align: right"><%= (comptaEcriture.getCredit() == 0) ? "" : Utilitaire.formaterAr(comptaEcriture.getCredit()) %></td>
                                    <td><%= comptaEcriture.getLettrage()%></td>
                                    <td><%= comptaEcriture.getReference_engagement()%></td>
                                    <td>
                                        <% if (comptaEcriture.getEtat() == 1) { out.print("NON VISE"); }
                                           else if (comptaEcriture.getEtat() >= 11) { out.print("VISE"); } %>
                                    </td>
                                </tr>
                                <%
                                            }
                                        }
                                    }
                                %>
                                <tr>
                                    <td colspan="5"></td><td><b>TOTAL</b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(cc.getTotalDebit())%></b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(cc.getTotalCredit())%></b></td>
                                    <td></td><td></td>
                                </tr>
                                <tr>
                                    <td colspan="5"></td>
                                    <td><b>CUMUL</b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(cc.getReportDebit())%></b></td>
                                    <td style="text-align: right"><b><%= Utilitaire.formaterAr(cc.getReportCredit())%></b></td>
                                    <td></td><td></td>
                                </tr>
                                <tr class="table-apj-footer">
                                    <td colspan="5"></td>
                                    <td><b><%= retGL[11] %></b></td>
                                    <td style="text-align: right"><b><%= (cc.getSoldeDebit() == 0) ? "" : Utilitaire.formaterAr(cc.getSoldeDebit()) %></b></td>
                                    <td style="text-align: right"><b><%= (cc.getSoldeCredit() == 0) ? "" : Utilitaire.formaterAr(cc.getSoldeCredit()) %></b></td>
                                    <td colspan="3"></td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                                <tr>
                                    <th colspan="5"></th>
                                    <th>Total</th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(grandLivre.getTotalDebit()) %></th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(grandLivre.getTotalCredit()) %></th>
                                    <th colspan="3"></th>
                                </tr>
                                <tr><td colspan="11"></td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Champs cachés pour l'export -->
                    <input id="date1" type="hidden" value="<%= date1 %>" />
                    <input id="date2" type="hidden" value="<%= date2 %>" />
                    <input id="plage1" type="hidden" value="<%= grandLivre.getCompteDebut() %>" />
                    <input id="plage2" type="hidden" value="<%= grandLivre.getCompteFin() %>" />
                    <input id="exercice" type="hidden" value="<%= grandLivre.getExercice() %>" />
                    <input id="typecompte" type="hidden" value="<%= grandLivre.getTypeCompte() %>" />
                    <input id="etat" type="hidden" value="<%= grandLivre.getEtat() %>" />
                    <div class="box box-primary box-solid">
                        <div id="export-body" class="box-body" style="display: block;">
                            <form id="form-export" action="../../../download" method="post">
                                <input type="hidden" name="ext" value="xls" checked="checked">
                                <input type="hidden" name="donnee" value="0" checked="checked">
                                <input type="hidden" name="specific_xls" value="true"/>
                                <input id="excel-input" type="hidden" name="table">
                            </form>
                            <form id="form-export-pdf" action="../../../EtatComptable?action=exportGrandLivrePDF&date1=<%=grandLivre.getDateDebut()%>&date2=<%=grandLivre.getDateFin()%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteFin()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>" method="post">
                                <input id="excel-input-pdf" type="hidden" name="table" value="">
                                <input type="hidden" name="ext" value="pdf" checked="checked">
                                <input type="hidden" name="donnee" value="0" checked="checked">
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
    <% } // Fin du if (grandLivre != null) %>
</div>
<%
    // Fermeture propre de la connexion
    if (c != null) {
        try { c.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>
<script>
    function exporter(){
        let exp = $('#ext').val();
        if(exp === 'xls'){
            document.location.replace("${pageContext.request.contextPath}/ExportExcel?action=grand_livre&date1=<%=date1%>&date2=<%=date2%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteFin()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>&type=xls");
        }
        if(exp === 'pdf'){
            document.location.replace("${pageContext.request.contextPath}/EtatComptable?action=exportGrandLivrePDF&date1=<%=date1%>&date2=<%=date2%>&plage1=<%=compteParam%>&plage2=<%=compteParam%>&typecompte=<%=typeCompteParam%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>");
        }
    }
    function chargerExport() {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var excel = titre + $('#table-container').html();
        var excelInput = document.getElementById("excel-input");
        excelInput.value = excel;
    }
    function exporterCsv() {
        chargerExport();
        var form = $("#form-export");
        form.submit();
    }
    function ecranEcritureComptable(id) {
        url = 'compta/etat/ecritureComptable-etat.jsp?id=' + id;
        window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
    }
</script>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>