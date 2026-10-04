<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.transfertpoulet.TransfertPouletLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    TransfertPouletLib o = new TransfertPouletLib();
    o.setNomTable("TRANSFERTPOULET_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche du transfert poulet");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idLotLib").setLibelle("Lot");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idLot").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idsouchelib").setLibelle("Souche");

    String[] ordre = {"id","idLotLib", "idsouchelib","daty","remarque","etatLib"};
    pc.setOrdre(ordre);

    String pageActuel = "ferme/transfertpoulet/transfertpoulet-fiche.jsp";
    String pageRetour = "ferme/transfertpoulet/transfertpoulet-liste.jsp";
    String pageModif = "ferme/transfertpoulet/transfertpoulet-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/transfertpoulet/transfertpoulet-liste.jsp";
    String classe = "ferme.transfertpoulet.TransfertPoulet";

    Map<String, String> map = new HashMap<>();
    map.put("inc/transfetpoulet-det", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/transfetpoulet-det";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    o = (TransfertPouletLib) pc.getBase();
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
                <li class="<%=map.get("inc/transfetpoulet-det")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/transfetpoulet-det">D&eacute;tails</a></li>
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

