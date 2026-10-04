<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.vaccination.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");
    VaccinationPoussinLib o = new VaccinationPoussinLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une vaccination de poussins");
    String id = pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idLotLib").setLibelle("Lot");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idLot").setLibelle("id Lot");
    pc.getChampByName("idLot").setLien(lien+"?but=ferme/lot/lot-fiche.jsp", "id=");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    String[] ordre = {"id","idLot","idLotLib","daty","remarque","etatLib"};
    pc.setOrdre(ordre);
    String pageActuel = "ferme/vaccination/vaccinationpoussin-fiche.jsp";
    String pageRetour = "ferme/vaccination/vaccinationpoussin-liste.jsp";
    String pageApresDelete = "ferme/vaccination/vaccinationpoussin-liste.jsp";
    String classe = "ferme.vaccination.VaccinationPoussin";
    String pageModif = "ferme/vaccination/vaccinationpoussin-saisie.jsp&acte=update";
    Map<String, String> map = new HashMap<>();
    map.put("inc/vaccinationpoussin-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/vaccinationpoussin-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    o = (VaccinationPoussinLib) pc.getBase();
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
                <li class="<%=map.get("inc/vaccinationpoussin-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/vaccinationpoussin-details">D&eacute;tails</a></li>
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