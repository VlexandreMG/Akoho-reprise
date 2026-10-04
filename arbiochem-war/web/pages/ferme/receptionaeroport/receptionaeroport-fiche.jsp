<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.receptionaeroport.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@page import="utilitaire.ConstanteEtat"%>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ReceptionPoussinAeroportLib o = new ReceptionPoussinAeroportLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un reception de poussins aeroport");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idLot").setLibelle("Id Lot");
    pc.getChampByName("idLotLib").setLibelle("Lot");
    pc.getChampByName("Daty").setLibelle("Date");
    pc.getChampByName("Etat").setVisible(false);
    pc.getChampByName("nbrCartonMale").setLibelle("Nombre de cartons m&acirc;les");
    pc.getChampByName("nbrCartonFemelle").setLibelle("Nombre de cartons femelles");
    pc.getChampByName("nbrCartonTotal").setLibelle("Nombre de cartons total");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("qteRecus").setLibelle("Quantit&eacute; re&ccedil;ue");
    pc.getChampByName("qteRecus").setLibelle("Quantit&eacute;");
    pc.getChampByName("heureDepart").setLibelle("Heure de d&eacute;part");
    pc.getChampByName("heureArrive").setLibelle("Heure d'arriv&eacute;e");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idLot").setLien(lien+"?but=ferme/lot/lot-fiche.jsp", "id=");
    String[] ordre = {"id","idLot", "idLotLib","Daty","heureDepart","heureArrive", "remarque","nbrCartonMale","nbrCartonFemelle","nbrCartonTotal","qteRecus","etatlib"};
    pc.setOrdre(ordre);


    String pageActuel = "ferme/receptionaeroport/receptionaeroport-fiche.jsp";
    String pageRetour = "ferme/receptionaeroport/receptionaeroport-liste.jsp";
    String pageApresDelete = "ferme/receptionaeroport/receptionaeroport-liste.jsp";
    String classe = "ferme.receptionaeroport.ReceptionPoussinAeroport";
    String pageModif = "ferme/receptionaeroport/receptionaeroport-saisie.jsp&acte=update";

    Map<String, String> map = new HashMap<>();
    map.put("inc/receptionaeroport-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/receptionaeroport-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    ReceptionPoussinAeroportLib base = (ReceptionPoussinAeroportLib)pc.getBase();
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
                    <% if(base.getEtat() < ConstanteEtat.getEtatValider()) { %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute="+pageActuel+"&classe="+classe %>">Valider</a>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                        <% } else if(base.getEtat() >= ConstanteEtat.getEtatValider()) { %>
                            <a class="btn btn-secondary pull-right" href="<%= lien%>?but=ferme/triagebatiment/triagebatimentparquet-saisie.jsp&idLot=<%=base.getIdLot()%>">Trier par b&acirc;timent et par parquet</a>
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
                <li class="<%=map.get("inc/receptionaeroport-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/receptionaeroport-details">D&eacute;tails</a></li>
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
