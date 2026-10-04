<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.triageBatiment.TriageBatimentParquetLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@page import="utilitaire.ConstanteEtat"%>
<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    TriageBatimentParquetLib o = new TriageBatimentParquetLib();
    o.setNomTable("TRIAGEBATIMENTPARQUET_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche triage batiment par parquet");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idLotLib").setLibelle("Nom du lot");
    pc.getChampByName("IdSoucheLib").setLibelle("Souche");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idlot").setLibelle("ID Lot");
    pc.getChampByName("idlot").setLien(lien+"?but=ferme/lot/lot-fiche.jsp", "id=");
    pc.getChampByName("dispomale").setLibelle("Disponibilit&eacute; m&acirc;le");
    pc.getChampByName("dispofemelle").setLibelle("Disponibilit&eacute; femelle");
    pc.getChampByName("ecartFemelle").setLibelle("&Eacute;cart femele");
    pc.getChampByName("ecartMale").setLibelle("&Eacute;cart m&acirc;le");

    String[] ordre = {"id","idlot","idLotLib","IdSoucheLib","daty","dispomale","dispofemelle","ecartMale","ecartFemelle","etatLib"};
    pc.setOrdre(ordre);

    String pageActuel = "ferme/triagebatiment/triagebatimentparquet-fiche.jsp";
    String pageRetour = "ferme/triagebatiment/triagebatimentparquet-liste.jsp";
    String pageModif = "ferme/triagebatiment/triagebatimentparquet-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/triagebatiment/triagebatimentparquet-liste.jsp";
    String classe = "ferme.triageBatiment.TriageBatimentParquet";

    Map<String, String> map = new HashMap<>();
    map.put("inc/triagebatimentparquet-det", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/triagebatimentparquet-det";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    TriageBatimentParquetLib base = (TriageBatimentParquetLib)pc.getBase();
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
                <!-- Exemple d'onglet -->
                <li class="<%=map.get("inc/triagebatimentparquet-det")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/triagebatimentparquet-det">D&eacute;tails</a></li>
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
