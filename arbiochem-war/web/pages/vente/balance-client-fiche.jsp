<%@page import="vente.VenteLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@page import="fichier.AttacherFichier"%>
<%@page import="configuration.*"%>
<%@page import="uploadbean.*"%>
<%@ page import="vente.StatMere" %>

<%
    try {

    //Information sur les navigations via la page
    String lien = (String) session.getValue("lien");
    String pageActuel = "vente/balance-client-fiche.jsp";

    //Information sur la fiche
    StatMere dp = new StatMere();
    PageConsulte pc = new PageConsulte(dp, request, (user.UserEJB) session.getValue("u"));

    String id = request.getParameter("id");
    pc.getChampByName("id").setLibelle("Id");

    pc.setTitre("Fiche balance client");
    Onglet onglet = new Onglet("page1");
    onglet.setDossier("inc");
    Map<String, String> map = new HashMap<String, String>();
    map.put("balance-client-details", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "balance-client-details";
    }
    map.put(tab, "active");
    tab = "inc/" + tab + ".jsp";

%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=vente/balance-client.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("vente-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=vente-details">D&eacute;tail(s)</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>

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

<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
