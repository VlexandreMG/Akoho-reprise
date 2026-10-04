<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.suiviJournalier.SuiviJournalieLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    SuiviJournalieLib o = new SuiviJournalieLib();
    o.setNomTable("SUIVIJOURNALIER_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche du suivi journalier");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idFermeLib").setLibelle("Ferme");
    pc.getChampByName("idlot").setLibelle("ID Lot");
    pc.getChampByName("idLotLib").setLibelle("Nom du lot");
    pc.getChampByName("IdSoucheLib").setLibelle("Souche");
    pc.getChampByName("idlot").setLien(lien+"?but=ferme/lot/lot-fiche.jsp","id=");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("idferme").setVisible(false);
    pc.getChampByName("etatLib").setVisible(false);



    String[] ordre = {"id", "idFermeLib", "idlot", "idLotLib", "IdSoucheLib","daty", "etat"};
    pc.setOrdre(ordre);

    String pageActuel = "ferme/suiviJournalier/suivijournalier-fiche.jsp";
    String pageRetour = "ferme/suiviJournalier/suivijournalier-liste.jsp";
    String pageModif = "ferme/suiviJournalier/suivijournalier-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/suiviJournalier/suivijournalier-liste.jsp";
    String classe = "ferme.suiviJournalier.SuiviJournalier";

    Map<String, String> map = new HashMap<>();
    map.put("inc/suivijournlier-det", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/suivijournlier-det";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    o = (SuiviJournalieLib) pc.getBase();
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
                <li class="<%=map.get("inc/suivijournlier-det")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/suivijournlier-det">D&eacute;tails</a></li>
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

