<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.aliment.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    DistributionAlimentLib o = new DistributionAlimentLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une distribution d'aliment");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idFerme").setLibelle("Id Ferme");
    pc.getChampByName("idfermelib").setLibelle("Ferme");
    pc.getChampByName("idLotLib").setLibelle("Lot");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idLot").setLibelle("id Lot");
    pc.getChampByName("IdSoucheLib").setLibelle("Souche");
    pc.getChampByName("idLot").setLien(lien+"?but=ferme/lot/lot-fiche.jsp", "id=");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("etatLib").setVisible(false);
    String[] ordre = {"id","idFerme","idfermelib","idLot","idLotLib","IdSoucheLib","daty","etat"};
    pc.setOrdre(ordre);


    String pageActuel = "ferme/aliment/distributionaliment-fiche.jsp";
    String pageRetour = "ferme/aliment/distributionaliment-liste.jsp";
    String pageApresDelete = "ferme/aliment/distributionaliment-liste.jsp";
    String classe = "ferme.aliment.DistributionAliment";
    String pageModif = "ferme/aliment/distributionaliment-saisie.jsp&acte=update";

    Map<String, String> map = new HashMap<>();
    map.put("inc/distributionaliment-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/distributionaliment-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    o = (DistributionAlimentLib) pc.getBase();
%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
                        <% System.out.println("Etatttttt; " + o.getEtat());
                            System.out.println("IDDDDDD: " + o.getId());
                            if(o.getEtat() < ConstanteEtat.getEtatValider()) { %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute="+pageActuel+"&classe="+classe %>">Valider</a>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                        <% } %>
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
                <li class="<%=map.get("inc/distributionaliment-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/distributionaliment-details">D&eacute;tails</a></li>
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

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
