<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire" %>
<%@page import="java.sql.Date" %>
<%@page import="mg.cnaps.compta.*" %>
<%@page import="affichage.PageInsert" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="utilitaire.UtilDB" %>
<%
    ComptaEtatGrandLivreGenerator grandLivre = null;
    String date1 = null;
    String date2 = null;
    try{
        String lang = String.valueOf(session.getAttribute("lang"));
        String[] mots = {"Grand livre du compte", "au", "Compte", "Libelle du compte", "Journal", "Date", "Libelle", "Lettrage", "Mouvement", "Debit", "Credit", "Solde", "exporter"};
        String[] ret = Utilitaire.transformerLangue(mots, lang);

        ComptaEtatGrandLivreGenerator gl = new ComptaEtatGrandLivreGenerator();
        gl.setNomTable("v_compta_etat_balance");
        PageInsert pi=new PageInsert();
        pi.setBase(gl);
        pi.setReq(request);
        grandLivre = (ComptaEtatGrandLivreGenerator)pi.getObjectAvecValeur();
        grandLivre.normalizeComptes();
        grandLivre.fillComptesWithMouvementAndReport(null);
        date1 = request.getParameter("dateDebut");
        date2 = request.getParameter("dateFin");

        Connection c = new UtilDB().GetConn();

%>

<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<jsp:include page='../../elements/css.jsp'/>
<div class="" style="margin: 0;padding: 20px">
    <div class="row">
        <div class="row col-md-12">
            <div class="box box-solid">
                <div class="content">
                    <div id="table-container">
                        <div class="d-flex align-items-center col-12">
                            <div class="box-header with-border">
                                <h3 class="title " id="titre-export">
                                    <%
                                        String compteDebut = grandLivre.getCompteDebut();
                                        String compteFin = grandLivre.getCompteFin();
                                        if (compteDebut != null && compteFin != null && compteDebut.equals(compteFin)) {
                                    %>
                                    Grand livre du compte <%=compteDebut%>
                                    <%
                                        } else {
                                    %>
                                    Grand livre du compte du <%=compteDebut%> au <%=compteFin%>
                                    <%
                                        }
                                    %>
                                </h3>
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
                                    <input type="button" class="btn btn-info" value="Exporter" onclick="exporter()"/>
                                </div>
                            </div>
                        </div>
                        <div class="box-body table-responsive no-padding">
                            <table id="export" border="1" class="table table-hover table-bordered">
                                <tbody>
                                <%  //String v = "<table><thead><tr><td>Grand livre du compte " + grandLivre.getCompteDebut() + " au " + grandLivre.getCompteFin() + "</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr></thead><tbody>";
                                    for (Map.Entry<String,ComptaCompte> listeComptes : grandLivre.getComptes().entrySet()) {
                                        ComptaCompte cc = listeComptes.getValue();
                                        List<ComptaSousEcriture> mouvements = cc.getMouvements();
                                %>
                                <%
                                    if (cc.getReportDebit() != 0 ||  cc.getReportCredit() != 0||(mouvements != null && mouvements.size() > 0)) {
                                %>



                                <tr class="head">
                                    <th colspan="11">COMPTE : <%= cc.getCompte()%> </th>
                                </tr>
                                <tr>
                                    <th>Compte</th>
                                    <th>ID Mouvement</th>
                                    <th>Date</th>
                                    <th>Jrn/Folio</th>
                                    <th>Contrep.</th>
                                    <th>Libell&eacute; Oper.</th>
                                    <th>D&eacute;bit</th>
                                    <th>Cr&eacute;dit</th>
                                    <th>Lettre</th>
                                    <%
                                        if (grandLivre.getTypeCompte().compareToIgnoreCase("1") == 0)/* compte general*/ {
                                    %>
                                    <th>Compte analytique</th>
                                    <%
                                    } else {
                                    %>
                                    <th>Compte g&eacute;n&eacute;rale</th>
                                    <%
                                        }
                                    %>
                                    <th>&Eacute;tat</th>
                                </tr>
                                <tr>
                                    <td colspan="5"></td>
                                    <td>Ancien cumul...</td>
                                    <td>
                                        <%if (cc.getReportDebit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(cc.getReportDebit()));
                                        }
                                        %>
                                    </td>
                                    <td>
                                        <% if (cc.getReportCredit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(cc.getReportCredit()));
                                        }
                                        %>
                                    </td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <%

                                    System.out.println("size="+mouvements.size());
                                    //if (mouvements != null && mouvements.size() > 0)
                                    {
                                        String color = "black";
                                        for (ComptaSousEcriture comptaEcriture : mouvements) {
                                            if (comptaEcriture != null) {
                                                if (comptaEcriture.getEtat() == 1) {
                                                    color = "red";
                                                } else if (comptaEcriture.getEtat() >= 11) {
                                                    color = "black";
                                                }
                                %>
                                <tr>
                                    <td>
                                        <%= cc.getCompte()%>
                                    </td>
                                    <td>
                                        <a href="<%=(String) session.getAttribute("lien")%>/../../../module.jsp?but=compta/ecriture/ecriture-fiche.jsp&id=<%=comptaEcriture.getIdMere()%>" target="_blank"><%=comptaEcriture.getIdMere()%></a>
                                    </td>
                                    <td>
                                        <%= Utilitaire.formatterDaty(comptaEcriture.getDaty())%>
                                    </td>
                                    <td>
                                        <%= comptaEcriture.getJournal()%>/<%= comptaEcriture.getFolio()%>
                                    </td>
                                    <td>
                                        <%= comptaEcriture.getContrep()%>
                                    </td>
                                    <td>
                                        <%= comptaEcriture.getRemarque()%>
                                    </td>
                                    <td style="text-align: right">
                                        <%if (comptaEcriture.getDebit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(comptaEcriture.getDebit()));
                                        }%>
                                    </td>
                                    <td style="text-align: right">
                                        <%if (comptaEcriture.getCredit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(comptaEcriture.getCredit()));
                                        }%>
                                    </td>
                                    <td>
                                        <%= comptaEcriture.getLettrage()%>
                                    </td>
                                    <td><%= comptaEcriture.getReference_engagement()%></td>
                                    <!----    <td>
                                                    <%if (comptaEcriture.getEtat() == 1) {
                                                            out.print("NON VISE");
                                                        } else if (comptaEcriture.getEtat() == 11) {
                                                            out.print("VISE");
                                                        }%>
                                                </td> ----!>
                                </tr>
                                <%
                                    }
                                %>
                                <% }
                                }
                                %>

                                <tr>
                                    <td colspan="5"></td><td><b>TOTAL</b></td>
                                    <td style="text-align: right">
                                        <b><%= Utilitaire.formaterAr(cc.getTotalDebit())%></b>
                                    </td>
                                    <td style="text-align: right">
                                        <b><%= Utilitaire.formaterAr(cc.getTotalCredit())%></b>
                                    </td>
                                    <td></td>
                                    <td></td>
                                </tr>

                                <tr>
                                    <td colspan="5"></td>
                                    <td><b>CUMUL</b></td>
                                    <td style="text-align: right">
                                        <b><%= Utilitaire.formaterAr(cc.getReportDebit())%></b>
                                    </td>
                                    <td style="text-align: right">
                                        <b><%= Utilitaire.formaterAr(cc.getReportCredit())%></b>
                                    </td><td></td><td></td>
                                </tr>

                                <tr class="table-apj-footer">
                                    <td colspan="5"></td>
                                    <td><b>SOLDE</b></td>
                                    <td style="text-align: right">
                                        <b > <%if (cc.getSoldeDebit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(cc.getSoldeDebit()));
                                        }%></b>
                                    </td>
                                    <td  style="text-align: right">
                                        <b><%if (cc.getSoldeCredit() == 0) {
                                            out.print("");
                                        } else {
                                            out.print(Utilitaire.formaterAr(cc.getSoldeCredit()));
                                        }%></b>
                                    </td>
                                    <td colspan="3"></td>
                                </tr>



                                <% } %>
                                <% }%>

                                <tr>
                                    <th colspan="5"></th>
                                    <th>Total</th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(grandLivre.getTotalCredit()) %></th>
                                    <th style="text-align: right"> <%= Utilitaire.formaterAr(grandLivre.getTotalDebit())%></th>
                                    <th colspan="3"></th>
                                </tr>
                                <tr>
                                    <td colspan="11"></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <input id="date1" type="hidden" value="<%= date1%>" />
                    <input id="date2" type="hidden" value="<%= date2%>" />
                    <input id="plage1" type="hidden" value="<%= grandLivre.getCompteDebut()%>" />
                    <input id="plage2" type="hidden" value="<%= grandLivre.getCompteFin()%>" />
                    <input id="exercice" type="hidden" value="<%= grandLivre.getExercice()%>" />
                    <input id="typecompte" type="hidden" value="<%= grandLivre.getTypeCompte()%>" />
                    <input id="etat" type="hidden" value="<%= grandLivre.getEtat()%>" />


                    <div class="box box-primary box-solid">
                        <div id="export-body" class="box-body" style="display: block;">
                            <form id="form-export" action="../../../download" method="post">
                                <input type="hidden" name="ext"  value="xls"  checked="checked">
                                <input type="hidden" name="donnee" value="0" checked="checked">
                                <input type="hidden" name="specific_xls" value="true"/>
                                <input id="excel-input"  type="hidden" name="table">
                            </form>

                            <form id="form-export-pdf" action="../../../balanceExport?action=exportGrandLivrePDF&date1=<%=grandLivre.getDateDebut()%>&date2=<%=grandLivre.getDateFin()%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteDebut()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>" method="post">
                                <input id="excel-input-pdf"  type="hidden" name="table" value="">
                                <input type="hidden" name="ext"  value="pdf"  checked="checked">
                                <input type="hidden" name="donnee" value="0" checked="checked">
                                <input type="hidden" value="Exporter" class="btn btn-default">
                            </form>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%
    if(c!=null){
        c.close();
    }
    } catch (Exception e) {
    e.printStackTrace();
}%>

<script>
    $(".btn-export").click(function() {
        $(".export-block").toggleClass("inactive");
    });

    function exporter(){
        let exp = $('#ext').val();
        if(exp === 'xls'){
            document.location.replace("${pageContext.request.contextPath}/ExportExcel?action=grand_livre&date1=<%=date1%>&date2=<%=date2%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteFin()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>&type=xls")
        }
        if(exp === 'pdf'){
          document.location.replace("${pageContext.request.contextPath}/EtatComptable?action=exportGrandLivrePDF&date1=<%=date1%>&date2=<%=date2%>&plage1=<%=grandLivre.getCompteDebut()%>&plage2=<%=grandLivre.getCompteFin()%>&typecompte=<%=grandLivre.getTypeCompte()%>&exercice=<%=grandLivre.getExercice()%>&etat=<%=grandLivre.getEtat()%>");
        }
    }

    function chargerExportPDF()
    {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var excel = titre + $('#table-container').html();

        var excelInput = document.getElementById("excel-input");
        excelInput.value = excel;
        document.location.replace('../../../ExportServlet?titre=' + titre + "&htmlcontent=" + excel);
    }
    function chargerExport()
    {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var excel = titre + $('#table-container').html();


        var excelInput = document.getElementById("excel-input");
        excelInput.value = excel;
        console.log("valeur de l'excel" + excelInput.value);
    }
    function changerExportExcel()
    {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var excel = titre + $('#table-container').html();


        var excelInput = document.getElementById("donnee");
        excelInput.value = excel;
        //console.log("valeur de l'excel" + excelInput.value);
    }



    function exporterCsv()
    {
        chargerExport();
        var form = $("#form-export");
        form.submit();
    }

    function ecranEcritureComptable(id) {
        url = 'compta/etat/ecritureComptable-etat.jsp?id=' + id;
        window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
    }
</script>