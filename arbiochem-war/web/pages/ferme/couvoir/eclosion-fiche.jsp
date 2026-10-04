<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.couvoir.EclosionLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    EclosionLib o = new EclosionLib();
    o.setNomTable("ECLOSION_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("FIche eclosion");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idIncubateurLib").setLibelle("Incubateur");
    pc.getChampByName("idBatimentLib").setLibelle("B&acirc;timent");
    pc.getChampByName("idParquetLib").setLibelle("Parquet");
    pc.getChampByName("dateeclosion").setLibelle("Date d'&eacute;closion");
    pc.getChampByName("nombreoeufinitial").setLibelle("Nombre d'œufs initial");
    pc.getChampByName("idEclosoirLib").setLibelle("&Eacute;closoir");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idlot").setVisible(false);
    pc.getChampByName("idincubateur").setVisible(false);
    pc.getChampByName("idbatiment").setLibelle("ID B&acirc;timent");
    pc.getChampByName("idbatiment").setLien(lien+"?but=ferme/configuration/batiment-fiche.jsp","id=");
    pc.getChampByName("idparquet").setLibelle("ID Parquet");
    pc.getChampByName("idparquet").setLien(lien+"?but=ferme/configuration/parquet-fiche.jsp","id=");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("ideclosoir").setVisible(false);

    String[] ordre = {"id","idIncubateurLib", "idbatiment","idBatimentLib", "idparquet","idParquetLib","idEclosoirLib","dateeclosion","nombreoeufinitial","etatLib"};
    pc.setOrdre(ordre);

    String pageActuel = "ferme/couvoir/eclosion-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = "ferme/couvoir/eclosion-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/couvoir/eclosion-liste.jsp";
    String classe = "ferme.couvoir.Eclosion";

    Map<String, String> map = new HashMap<>();
    map.put("inc/eclosion-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/eclosion-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    o = (EclosionLib) pc.getBase();
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
                        <% if(o.getEtat() < ConstanteEtat.getEtatValider()) { %>
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
                <li class="<%=map.get("inc/eclosion-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/eclosion-details">D&eacute;tails</a></li>
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

