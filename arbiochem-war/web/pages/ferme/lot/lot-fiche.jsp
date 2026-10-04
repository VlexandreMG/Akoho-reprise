<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.lot.LotLib" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    LotLib o = new LotLib();
    o.setNomTable("LOT_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Diche du lot");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idFermeLib").setLibelle("Ferme");
    pc.getChampByName("idArticleLib").setLibelle("Article");
    pc.getChampByName("idOrigineLib").setLibelle("Origine");
    pc.getChampByName("idProgrammeLib").setLibelle("Programme");
    pc.getChampByName("nomlot").setLibelle("Nom du lot");
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("dateeclosion").setLibelle("Date d'&eacute;closion");
    pc.getChampByName("datearrivee").setLibelle("Date d'arriv&eacute;e");
    pc.getChampByName("source").setLibelle("Source");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idarticle").setLibelle("Id Article");
    pc.getChampByName("idSoucheLib").setLibelle("Souche");
    pc.getChampByName("idcategorielotlib").setLibelle("cat&eacute;gorie du lot");
    pc.getChampByName("datecloture").setLibelle("Date cl&ocirc;ture");
    pc.getChampByName("ageJour").setLibelle("Age en jours");
    pc.getChampByName("ageSemaine").setLibelle("Age en semaines");
    pc.getChampByName("datecloture").setLibelle("Date cl&ocirc;ture");
    pc.getChampByName("idferme").setVisible(false);
    pc.getChampByName("idorigine").setVisible(false);
    pc.getChampByName("idprogramme").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idarticle").setLien(lien+"produits/as-ingredients-arbiochem-fiche.jsp.jsp","id=");

    String[] ordre = {"idarticle","id","idArticleLib","nomlot","reference","idferme","idFermeLib","idcategorielotlib","idSoucheLib","idorigine","idOrigineLib","idprogramme","idProgrammeLib","dateeclosion","datearrivee","datecloture","ageJour","ageSemaine","source","etatLib"};
    pc.setOrdre(ordre);

    String pageRetour = "ferme/lot/lot-liste.jsp";
    String pageActuel = "ferme/lot/lot-fiche.jsp";
    String pageReception = "ferme/receptionaeroport/receptionaeroport-saisie.jsp";
    String pageModif = "ferme/lot/lot-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/lot/lot-liste.jsp";
    String classe = "ferme.lot.Lot";
    o = (LotLib) pc.getBase();

    Map<String, String> map = new HashMap<>();
    map.put("../programme/inc/programmezoodet", "");
    map.put("../receptionaeroport/inc/receptionaeroport-details", "");
    map.put("../triagebatiment/inc/triagebatimentparquet-det", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "../programme/inc/programmezoodet";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    String idAEnvoyer = id;
    if (tab.equals("../programme/inc/programmezoodet.jsp")) {
        idAEnvoyer = o.getIdprogramme();
    } else if (tab.equals("../receptionaeroport/inc/receptionaeroport-details.jsp") || tab.equals("../triagebatiment/inc/triagebatimentparquet-det")) {
        idAEnvoyer = id;
    }
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
                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                        <% if (o.getEtat() < ConstanteEtat.getEtatValider()){%>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-primary pull-right"  href="<%=lien + "?but=apresTarif.jsp&acte=valider&classe="+classe+"&bute="+pageActuel+"&id=" + o.getId() %>"  style="margin-right: 10px">Viser</a>
                        <% }%>
                        <% if (o.getEtat() == ConstanteEtat.getEtatValider()){%>
                        <!-- <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=cloturer&id=" + o.getId() + "&bute="+pageActuel+"&classe=" + classe%> " style="margin-right: 10px">Cl&ocirc;turer</a> -->
                        <a class="btn btn-primary pull-right" href="<%= lien + "?but="+pageReception+"&idLot=" + o.getId() + "&classe=" + classe%> " style="margin-right: 10px">R&eacute;ception &agrave; l'a&eacute;roport</a>
                        <% } %>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get("../programme/inc/programmezoodet")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../programme/inc/programmezoodet">Programme zootechnique</a></li>
                    <li class="<%=map.get("../receptionaeroport/inc/receptionaeroport-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../receptionaeroport/inc/receptionaeroport-details">Effectifs</a></li>
                    <li class="<%=map.get("../triagebatiment/inc/triagebatimentparquet-det")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=../triagebatiment/inc/triagebatimentparquet-det">R&eacute;partitions</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= idAEnvoyer %>" />
                        <jsp:param name="isLot" value="true" />
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
