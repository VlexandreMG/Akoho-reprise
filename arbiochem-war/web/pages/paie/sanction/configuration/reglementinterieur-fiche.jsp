<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>

<%@ page import="paie.employe.sanction.RegleInterieur" %>

<%
    try {
        String lien = (String) session.getValue("lien");
        UserEJB u = (UserEJB) session.getAttribute("u");

        String id = request.getParameter("id");
        String nomTable = "REGLEMENTINTERIEUR";
        String classe = "paie.employe.sanction.RegleInterieur";
        String pageActuel = "paie/sanction/configuration/reglementinterieur-fiche.jsp";

        RegleInterieur tpf = new RegleInterieur();
        tpf.setNomTable(nomTable);

        PageConsulte pc = new PageConsulte(tpf, request, u);

        pc.setTitre("Fiche d'une r&eagrave;gle int&eacute;rieure");
        pc.getChampByName("descriptionRegle").setLibelle("D&eacute;scription de la r&egrave;gle");
        pc.getChampByName("numeroRegle").setLibelle("Numero de la r&egrave;gle");
        pc.getChampByName("niveau").setLibelle("Niveau");
        tpf = (RegleInterieur) pc.getBase();

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
                        <a class="btn btn-secondary pull-right"  href="<%=(String) session.getValue("lien") + "?but=paie/sanction/configuration/reglementinterieur-saisie.jsp&acte=update&id=" + pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">Modifier</a>
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
