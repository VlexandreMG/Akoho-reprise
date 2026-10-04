<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="maintenance.inspection.HistoriqueInspectionLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");
    String pageActuel = "maintenance/historiqueInspection/historiqueInspection-fiche.jsp";


    HistoriqueInspectionLib o = new HistoriqueInspectionLib();
    o.setNomTable("HISTORIQUEINSPECTIONLIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une historique d'inspection");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("idInspecteurLib").setLibelle("Inspecteur");
    pc.getChampByName("idElementLib").setLibelle("&Eacute;l&eacute;ment");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("heure").setLibelle("Heure");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idElement").setVisible(false);
    pc.getChampByName("etat").setVisible(false);

    String[] ordre = {"idInspecteurLib","idElementLib","id","daty","heure","remarque"};
    pc.setOrdre(ordre);


    Map<String, String> map = new HashMap<>();
    map.put("inc/historiqueInspectionFille", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/historiqueInspectionFille";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    String pageRetour = "maintenance/historiqueInspection/historiqueInsepction-liste.jsp";
    String pageModif = "maintenance/historiqueInspection/historiqueInsepction-saisie.jsp&acte=update";
    String pageApresDelete = "maintenance/historiqueInspection/historiqueInsepction-liste.jsp";
    String classe = "maintenance.inspection.HistoriqueInspectionLib";

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
                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-danger pull-left"  href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>" style="margin-right: 10px">Supprimer</a>
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


                    <li class="<%=map.get("inc/historiqueInspectionFille")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/historiqueInspectionFille">D&eacute;tails</a></li>
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
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

