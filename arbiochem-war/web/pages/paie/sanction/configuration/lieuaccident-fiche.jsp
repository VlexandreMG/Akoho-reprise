<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="paie.sanction.configuration.LieuAccident" %>


<%
    try {
        String lien = (String) session.getValue("lien");
        UserEJB u = (UserEJB) session.getAttribute("u");

        String id = request.getParameter("id");
        String nomTable = "LIEU_ACCIDENT_TRAVAIL";
        String pageActuel = "paie/sanction/configuration/lieuaccident-fiche.jsp";

        LieuAccident tpf = new LieuAccident();
        tpf.setNomTable(nomTable);

        PageConsulte pc = new PageConsulte(tpf, request, u);

        pc.setTitre("Fiche d'un lieu d'accident'");
        pc.getChampByName("val").setLibelle("Valeur");
        pc.getChampByName("desce").setLibelle("D&eacute;scription");
        tpf = (LieuAccident) pc.getBase();

%>

<div class="content-wrapper">
    <h1 class="box-title">
        <%=pc.getTitre()%>
    </h1>
    <div class="row m-0">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                    </div>
                    <div class="box-footer">
                        <a class="btn btn-secondary pull-right"  href="<%=(String) session.getValue("lien") + "?but=paie/sanction/configuration/lieuaccident-saisie.jsp&acte=update&id=" + pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">Modifier</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>


<%
} catch (Exception e) {
    e.printStackTrace();
%>
<% }%>
