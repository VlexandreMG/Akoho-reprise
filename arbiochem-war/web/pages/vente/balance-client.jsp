<%--
    Document   : vente-liste
    Created on : 25 mars 2024, 09:57:03
    Author     : Angela
--%>

<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.Vente" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="vente.EtatVenteDetailsLib" %>
<%@ page import="vente.*" %>

<% try{
    StatMere bc = new StatMere();

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    String mondayStr = Utilitaire.datetostring(Date.valueOf(monday));


    String[] listeCrt = {"famille", "idclient","idprovince","daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"famille","qte","montant"};
    String[] libEnteteAffiche = {"Famille", "Quantit&eacute;","Montant"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);

    pr.setTitre("Balance client");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/balance-client.jsp");
    //pr.setOrdre(" order by daty desc");

    pr.getFormu().getChamp("idClient").setLibelle("Client");
    pr.getFormu().getChamp("idprovince").setLibelle("Province");
    pr.getFormu().getChamp("idClient").setPageAppelComplete("client.Client", "id", "CLIENT");
    pr.getFormu().getChamp("idprovince").setPageAppelComplete("bean.TypeObjet", "id", "PROVINCE");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(mondayStr);
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

//  TypeObjet prov = new TypeObjet();
//  prov.setNomTable("province");

//  Liste[] liste = new Liste[1];
//  liste[0] = new Liste("idProvince",prov,"val","id");
//  liste[0].setLibelle("Province");
    //pr.getFormu().getChamp("provincelib").setLibelle("Province");
//  pr.getFormu().changerEnChamp(liste);

    String[] colSomme = {"qte","montant"};
    pr.creerObjetPage(libEntete, colSomme);

    //String[] lienTableau = {pr.getLien() + "?but=vente/balance-client-fiche.jsp"};
    //String[] colonneLien = {"id"};
    //pr.getTableau().setLien(lienTableau);
    //pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String link = "vente/inc/balance-client-details.jsp";

    String famille = request.getParameter("famille");
    String idprovince = request.getParameter("idprovince");
    String idclient = request.getParameter("idclient");
    String daty1 = request.getParameter("daty1");
    String daty2 = request.getParameter("daty2");
    if (famille != null && !famille.equalsIgnoreCase("null") && !famille.trim().isEmpty()) {
        link += "&famille=" + famille;
    }
    if (idprovince != null && !idprovince.equalsIgnoreCase("null") && !idprovince.trim().isEmpty()) {
        link += "&idprovince=" + idprovince;
    }
    if (idclient != null && !idclient.equalsIgnoreCase("null") && !idclient.trim().isEmpty()) {
        link += "&idclient=" + idclient;
    }
    if (daty1 != null && !daty1.equalsIgnoreCase("null") && !daty1.trim().isEmpty()) {
        link += "&daty1=" + daty1;
    }
    if (daty2 != null && !daty2.equalsIgnoreCase("null") && !daty2.trim().isEmpty()) {
        link += "&daty2=" + daty2;
    }
    System.err.println("==============IDCLIENT==========="+idclient);
    System.err.println("====="+link);
    pr.getTableau().setLienFille(link + "&id=");
    //pr.getTableau().setLienFille("vente/inc/balance-client-details.jsp&famille="+request.getParameter("famille")+"&idprovince="+request.getParameter("idprovince")+"&idclient="+request.getParameter("idclient")+"&daty1="+request.getParameter("daty1")+"&daty2="+request.getParameter("daty2")+"&id=");
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String enteteRecap[] = {"","Nombre","Somme des Quantit&eacute;s","Somme des montants"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    if(idclient!=null && !idclient.trim().isEmpty()){
        pr.getFormu().setAnotherButton(
                        "                <a id='export-btn-statistique-vente' class='btn btn-secondary  btn-bg-white btn-small' href='#' onclick='exportPDFStatistiqueVente()'>\n" +
                        "                    <i class='material-symbols-rounded'>download</i> Imprimer statistiques de vente\n" +
                        "                </a>\n"
        );
    }else{
        pr.getFormu().setAnotherButton(
                "                <a id='export-btn' class='btn btn-secondary  btn-bg-white btn-small' href='#' onclick='exportPDFChiffreAffaire()'>\n" +
                        "                    <i class='material-symbols-rounded'>download</i> Imprimer chiffres d'affaires par article\n" +
                        "                </a>\n"
        );
    }


%>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>

        <%
            out.println(pr.getTableau().getHtml());
        %>
                <div class="row justify-content-center d-none">
            <div class="col-md-12 d-flex justify-content-right">
                <div class="box box-primary">
                    <div class="box-body text-center">
                        <a id="export-btn" class="btn btn-warning pull-right" href="#">
                            Exporter en pdf <i class="fa fa-download"></i>
                        </a>
                           <a id="export-btn-statistique-vente" class="btn btn-warning pull-right" href="#">
                            Exporter en pdf <i class="fa fa-download"></i>
                        </a>
                   
                    </div>
                </div>
            </div>
        </div>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
  function exportPDFChiffreAffaire() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;


        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=chiffre_affaire_par_article"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)


        var exportButton = document.getElementById("export-btn");
        exportButton.href = exportUrl;
    }
  function exportPDFStatistiqueVente() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idclientValue = document.getElementById("idclient").value;
        var familleValue = document.getElementById("famille").value;

        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=statistique_vente"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&idclient=" + encodeURIComponent(idclientValue)
            + "&famille=" + encodeURIComponent(familleValue)


        var exportButton = document.getElementById("export-btn-statistique-vente");
        exportButton.href = exportUrl;
    }
</script>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




