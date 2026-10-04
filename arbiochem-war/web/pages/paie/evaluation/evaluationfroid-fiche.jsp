<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.evaluation.EvaluationFroid" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    EvaluationFroid o = new EvaluationFroid();
    o.setNomTable("EVALUATION_FROID");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un &eacute;valuation");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idformationsuivi").setLibelle("ID Formation suivie");
    pc.getChampByName("idpersonnel").setLibelle("Id personnel");
    pc.getChampByName("note").setLibelle("Note");
    pc.getChampByName("commentaire").setLibelle("Commentaire");
    pc.getChampByName("dateevaluation").setLibelle("Date d'&eacute;valuation");
    pc.getChampByName("idformationsuivi").setLien(lien+"?but=paie/formation/formationsuivi-fiche.jsp","id=");
    pc.getChampByName("idpersonnel").setLien(lien+"?but=paie/employe/personnel-fiche-portrait.jsp","id=");

    String[] ordre = {"id","idformationsuivi","idpersonnel","note","commentaire","dateevaluation"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "paie/evaluation/evaluationfroid-saisie.jsp&acte=update";
    String pageApresDelete = "paie/evaluation/evaluationfroid-liste.jsp";
    String classe = "paie.evaluation.EvaluationFroid";

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
                        <% if (!"dg".equalsIgnoreCase(u.getUser().getIdrole())) { %>
                                <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <% } %>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        <a class="btn btn-secondary pull-right"href="${pageContext.request.contextPath}/ExportPDF?action=fiche_evaluation_vf&id=<%= request.getParameter("id")%>">Imprimer fiche d' &eacute;valuation en VF</a>
                      <a class="btn btn-secondary pull-right"href="${pageContext.request.contextPath}/ExportPDF?action=fiche_evaluation_vm&id=<%= request.getParameter("id")%>">Imprimer fiche d' &eacute;valuation en VM</a>
                    </div>
                    <br/>
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

