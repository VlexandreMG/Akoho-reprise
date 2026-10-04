<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="paie.configuration.LogDirection"%>

<%
    try {
        String lien = (String) session.getValue("lien");
        UserEJB u = (UserEJB) session.getAttribute("u");

        String id = request.getParameter("id");
        String nomTable = "LOG_DIRECTION";
        String classe = "paie.configuration.LogDirection";
        String pageActuel = "paie/configuration/direction-fiche.jsp";

        LogDirection direction = new LogDirection();
        direction.setNomTable(nomTable);

        PageConsulte pc = new PageConsulte(direction, request, u);

        pc.setTitre("Fiche de la direction");
        pc.getChampByName("val").setLibelle("Valeur");
        pc.getChampByName("desce").setLibelle("D&eacute;scription");
        direction = (LogDirection) pc.getBase();

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
