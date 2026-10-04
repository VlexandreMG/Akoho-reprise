<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.configuration.BatimentLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    BatimentLib o = new BatimentLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un batiment");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idferme").setLibelle("Id ferme");
    pc.getChampByName("idfermelib").setLibelle("Ferme");
    pc.getChampByName("nombatiment").setLibelle("Nom du batiment");
    pc.getChampByName("Capacite").setLibelle("Capacit&eacute;");
    pc.getChampByName("densite").setLibelle("Densit&eacute;");
    pc.getChampByName("longueur").setLibelle("Longueur");
    pc.getChampByName("largeur").setLibelle("Largeur");
    pc.getChampByName("idferme").setLien(lien+"?but=magasin/magasin-fiche.jsp", "id=");

    pc.setOrdre(new String[]{"id", "idferme", "idfermelib", "nombatiment", "Capacite", "densite", "longueur", "largeur"});


    String pageActuel = "ferme/configuration/batiment-fiche.jsp";
    String pageRetour = "ferme/configuration/batiment-liste.jsp";
    String pageApresDelete = "ferme/configuration/batiment-liste.jsp";
    String classe = "ferme.configuration.Batiment";
    String pageModif = "ferme/configuration/batiment-saisie.jsp&acte=update";

    Map<String, String> map = new HashMap<>();
    map.put("inc/batiment-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/batiment-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
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
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
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
                <li class="<%=map.get("inc/batiment-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/batiment-details">D&eacute;tails</a></li>
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

