<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.formation.FormationPlanLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    FormationPlanLib o = new FormationPlanLib();
    o.setNomTable("V_FORMATION_PLAN");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Formation fiche");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("annee").setLibelle("Ann&eacute;e");
    pc.getChampByName("description").setLibelle("Description");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("etat").setVisible(false);

    String[] ordre = {"id","annee","description","etatLib"};
    pc.setOrdre(ordre);

    String pageActuel = "paie/formation/formation-fiche.jsp";
    String pageRetour = "paie/formation/formation-liste.jsp";
    String pageModif = "paie/formation/formation-saisie.jsp&acte=update";
    String pageApresDelete = "paie/formation/formation-liste.jsp";
    String pageApresValider = "paie/formation/formation-fiche.jsp";
    String classe = "paie.formation.FormationPlanLib";
    String nomTable = "FORMATION_PLAN";

    Map<String, String> map = new HashMap<>();
    map.put("inc/foramtion-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/foramtion-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    o = (FormationPlanLib) pc.getBase();
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
                        <% if (o.getEtat() <= ConstanteEtat.getEtatCreer()) {%>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute="+pageApresValider+"&classe="+classe+"&nomtable="+ nomTable%>">Valider</a>
                        <% } %>
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
                <!-- Exemple d'onglet -->
                <li class="<%=map.get("inc/foramtion-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/foramtion-details">D&eacute;tails</a></li>
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

