<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire" %>
<%@page import="java.sql.Date" %>
<%@page import="java.util.*" %>
<%@page import="affichage.PageInsert" %>
<%@page import="bean.AdminGen"%>
<%@ page import="mg.cnaps.compta.*" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>

<%
    String lang = String.valueOf(session.getAttribute("lang"));
    String[] ret = {"Balance des comptes", "au", "Compte", "Intitule du compte", "Cumul DB", "Cumul CR", "Mouvement DB", "Mouvement CR", "Solde DB", "Solde CR", "exporter"};

    String journal = request.getParameter("journal");
    String mois = request.getParameter("mois");
    String annee = request.getParameter("annee");

    JournalLib temp = new JournalLib(journal, Integer.parseInt(mois),Integer.parseInt(annee));

    ComptaSousEcritureLibJournal [] detail = temp.getDetail();
    detail = temp.formaterData(detail);
    String moislib = Utilitaire.nbToMois(Integer.parseInt(mois));
    String nomTable = "COMPTA_SOUSECRITURE_LIB_J";
    String awhere = " AND idjournal= '"+journal+"' AND mois="+mois+" AND annee="+annee;
    String requete = "select * from (select id,numero,compte,journal,idJournal,ecriture,daty,credit,debit,dateComptable,exercice,remarque,etat,idMere,horsExercice,od,origine,libellePiece,compte_aux,folio,lettrage,analytique,designationmere,jour,annee,rowNum as r from (select * from "+nomTable+" where 1<2 "+awhere+" order by IDMERE))";
    Gson gson = new Gson();
    String[] libEntete = {"idMere","jour","designationmere","daty", "compte", "debit","credit"};
    String[] libEnteteAffiche = {"No Ecriture", "Jour", "D&eacute;signation", "Date" ,"Compte","D&eacute;bit","Cr&eacute;dit"};

%>

<meta charset="UTF-8">
<title>Journaux du <%= moislib %> <%= annee %></title>
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<jsp:include page='../../elements/css.jsp'/>
<style>
    .btnpagination{
        display: flex;
        align-content: center;
        justify-content: space-between;
        align-items: center;
    }
    .title{
        text-transform: uppercase;
    }
    .idmere{
        cursor: pointer;
        color: blue;
    }
</style>
<div style="margin: 0;padding: 20px">
    <div class="row">
        <div class="row col-md-12">
            <div class="box box-solid">
                <div class="content">
                    <div id="table-container">
                        <div class="align-items-center col-12">
                            <div class="box-header with-border d-flex row btnpagination">
                                <div class="col-md-6">
                                    <h3 class="title uppercase">
                                        Journaux du <%= moislib %> <%= annee %>
                                    </h3>
                                </div>
                                <div class="col-md-6" style="text-align: right">
                                    <div style="margin-left: 20px;">
                                        <a class="btn btn-default btn-sm"
                                           href="?journal=<%= journal %>&mois=<%= (Integer.parseInt(mois) == 1 ? 12 : Integer.parseInt(mois) - 1) %>&annee=<%= (Integer.parseInt(mois) == 1 ? Integer.parseInt(annee) - 1 : Integer.parseInt(annee)) %>">
                                            Précédent
                                        </a>

                                        <a class="btn btn-default btn-sm"
                                           href="?journal=<%= journal %>&mois=<%= (Integer.parseInt(mois) == 12 ? 1 : Integer.parseInt(mois) + 1) %>&annee=<%= (Integer.parseInt(mois) == 12 ? Integer.parseInt(annee) + 1 : Integer.parseInt(annee)) %>">
                                            Suivant
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group me-3">
                                                <label>Format</label>
                                                <select name="ext" id="ext" class="form-control">
                                                    <option value="xls">Excel</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            </br>
                                            <div class="form-group">
                                                <input type="button" class="btn btn-info" value="Exporter" onclick="exporter()"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6"></div>compta/compte/compte-liste.jsp
                            </div>
                        </div>

                        <div class="box-body no-padding">
                            <table class="table table-hover table-bordered">
                                <thead>
                                <tr class="head">
                                    <th>N° Ecr</th>
                                    <th>Jour</th>
                                    <th>Libell&eacute;</th>
                                    <th>Date</th>
                                    <th>Compte</th>
                                    <th>DEBIT</th>
                                    <th>CREDIT</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    for (int i = 0; i < detail.length; i++) {
                                        try {
                                            out.println(detail[i].makeLigne());
                                        } catch (Exception e) {
                                            throw new RuntimeException(e);
                                        }
                                    }
                                %>
                                <tr>
                                    <td colspan="3"><b><%= temp.getTotal() %> &eacute;critures</b></td>
                                    <td colspan="2"><b>Totaux journal <%= mois %>/<%= annee %></b></td>
                                    <td><b><%= Utilitaire.formaterAr(AdminGen.calculSommeDouble(detail,"debit")) %></b></td>
                                    <td><b><%= Utilitaire.formaterAr(AdminGen.calculSommeDouble(detail,"credit")) %></b></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <form id="form-export" action="<%= request.getContextPath() %>/download" method="post" target="_blank">
                        <input id="excel-input" type="hidden" name="table" value="">
                            <input type="hidden" name="ext" value="xls" checked="checked">
                            <input type="hidden" name="donnee" value="0" checked="checked">
                            <input type="hidden" name="specific_xls" value="true"/>
                            <input type="hidden" name="className" value="mg.cnaps.compta.ComptaSousEcritureLibJournal"/>
                            <input type="hidden" name="nomTable" value="<%=nomTable%>"/>
                            <input type="hidden" name="requete" value="<%=requete%>"/>
                            <input type="hidden" name="colonneExcel" value="<%= StringEscapeUtils.escapeHtml4(gson.toJson(libEntete)) %>"/>
                            <input type="hidden" name="libColonneExcel" value="<%= StringEscapeUtils.escapeHtml4(gson.toJson(libEnteteAffiche)) %>"/>
                            <input type="hidden" name="titre" value="Journaux du <%= moislib %> <%= annee %>"/>
                        </form>

                        <form id="form-export-pdf" action="<%= (String) session.getValue("lien") %>/../../EtatComptable?action=etatComptablePDF" method="post">
                            <input id="excel-input-pdf" type="hidden" name="table" value="">
                            <input type="hidden" name="ext" value="pdf" checked="checked">
                            <input type="hidden" name="donnee" value="0" checked="checked">
                            <input type="hidden" name="className" value="mg.cnaps.compta.ComptaSousEcritureLibJournal"/>

                            <input type="hidden" value="Exporter" class="btn btn-default">
                        </form>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>

    function openEcriture(content) {
        url = '/socobis/pages/module.jsp?but=compta/ecriture/ecriture-fiche.jsp&id=' + content;
        window.open(url, "", "titulaireresizable=no,scrollbars=yes,location=no,width=1009,height=532,top=0,left=0");
    }
</script>


<script>
    $(".btn-export").click(function() {
        $(".export-block").toggleClass("inactive");
    });

    function exporter() {
        let exp = $('#ext').val();
        if (exp === 'xls') {
            exporterCsv();
        }
        if (exp === 'pdf') {
            exporterPDF();
        }
    }

    function chargerExportPDF() {
        var titre = "<h1>" + $('#titre-export').html() + "</h1>";
        var excel = titre + $('#table-container').html();
        var excelInput = document.getElementById("excel-input-pdf");
        excelInput.value = excel;
        console.log("valeur de l'excel" + excelInput.value);
    }

        function chargerExport() {
        var titreTexte = $('#table-container .title').first().text() || 'Export';
        var $table = $('#table-container table').first().clone();

        $table.find('tr').each(function () {
        $(this).find('td:eq(5), td:eq(6), th:eq(5), th:eq(6)').addClass('right');
        $(this).find('td:eq(1), th:eq(1), td:eq(3), th:eq(3)').addClass('center');
    });


        var excelHtml = `
<!DOCTYPE html>
<html xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:x="urn:schemas-microsoft-com:office:excel"
      xmlns="http://www.w3.org/TR/REC-html40">
<head>
<meta charset="UTF-8">
<!--[if gte mso 9]>
<xml>
<x:ExcelWorkbook>
  <x:ExcelWorksheets>
    <x:ExcelWorksheet>
      <x:Name>Journal</x:Name>
      <x:WorksheetOptions>
        <x:Selected/>
        <x:ProtectContents>False</x:ProtectContents>
        <x:ProtectObjects>False</x:ProtectObjects>
        <x:ProtectScenarios>False</x:ProtectScenarios>
      </x:WorksheetOptions>
    </x:ExcelWorksheet>
  </x:ExcelWorksheets>
</x:ExcelWorkbook>
</xml>
<![endif]-->
<style>
  table { border-collapse: collapse; table-layout: fixed; width: 100%; }
  th, td { border: 1px solid #444; padding: 4px; vertical-align: top; }
  thead th { background: #f2f2f2; font-weight: bold; }
  .right { text-align: right; mso-number-format:"\\#\\,\\#\\#0.00"; }
  .center { text-align: center; }
  col.col-idx   { width: 60px;  }
  col.col-jour  { width: 50px;  }
  col.col-lib   { width: 400px; }
  col.col-date  { width: 90px;  }
  col.col-cpte  { width: 120px; }
  col.col-mont  { width: 120px; }
</style>
</head>
<body>
  <h2>` + titreTexte + `</h2>
  ` + (function () {
        var $t = $table;
        if ($t.find('colgroup').length === 0) {
        var colgroup = `
              <colgroup>
                <col class="col-idx">
                <col class="col-jour">
                <col class="col-lib">
                <col class="col-date">
                <col class="col-cpte">
                <col class="col-mont">
                <col class="col-mont">
              </colgroup>`;
        $t.prepend(colgroup);
    }
        return $('<div>').append($t).html();
    })() + `
</body>
</html>`;
        var excelInput = document.getElementById("excel-input");
        excelInput.value = excelHtml;
    }




    function exporterCsv() {
        chargerExport();
        var form = $("#form-export");
        form.submit();
    }

    function exporterPDF() {
        chargerExportPDF();
        var form = $("#form-export-pdf");
        form.submit();
    }


    function prePrint() {
        if (window.print) {
            window.print();
        } else {
            alert('Votre navigateur ne supporte pas cette action');
        }
    }
</script>


