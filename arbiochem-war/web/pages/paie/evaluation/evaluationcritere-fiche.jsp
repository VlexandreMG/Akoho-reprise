<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.evaluation.EvaluationCritere" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    EvaluationCritere o = new EvaluationCritere();
    o.setNomTable("EVALUATION_CRITERE");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un crit&egrave;re d’&eacute;valuation");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("val").setLibelle("Valeur");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("id").setLibelle("Identifiant");

    String[] ordre = {"val","desce","id"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "paie/evaluation/evaluationcritere-saisie.jsp&acte=update";
    String pageApresDelete = "paie/evaluation/evaluationcritere-liste.jsp";
    String classe = "paie.evaluation.EvaluationCritere";

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
                        <% }%>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
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

