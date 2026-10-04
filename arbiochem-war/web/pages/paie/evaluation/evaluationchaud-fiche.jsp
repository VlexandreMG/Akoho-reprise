<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.evaluation.EvaluationAChaudLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="constante.ConstanteEtat" %>
<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    EvaluationAChaudLib o = new EvaluationAChaudLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un &eacute;valuation &agrave; chaud");
    String id = pc.getBase().getTuppleID();
    o = (EvaluationAChaudLib) pc.getBase();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idpersonnel").setLibelle("ID Personnel");
    pc.getChampByName("idpersonnel").setLien(lien+"?but=paie/employe/personnel-fiche-portrait.jsp", "id=");
    pc.getChampByName("IdPersonnelLib").setLibelle("Personnel");
    pc.getChampByName("IdIntervenantLib").setLibelle("Intervenant");
    pc.getChampByName("MatriculePersonnel").setLibelle("Matricule");
    pc.getChampByName("IdIntervenant").setLibelle("ID Intervenant");
    pc.getChampByName("IdIntervenant").setLien(lien+"?but=paie/employe/personnel-fiche-portrait.jsp", "id=");
    pc.getChampByName("DateFormation").setLibelle("Date de formation");
    pc.getChampByName("IdFonctionLib").setLibelle("Fonction");
    pc.getChampByName("Daty").setLibelle("Date");
    pc.getChampByName("IdFormationSuivie").setVisible(false);
    pc.getChampByName("IdFonctionIntervenant").setVisible(false);
    pc.getChampByName("IdFonction").setVisible(false);


    String pageActuel = "paie/evaluation/evaluationchaud-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = "paie/evaluation/evaluationchaud-saisie.jsp&acte=update";
    String pageApresDelete = "paie/evaluation/evaluationchaud-liste.jsp";
    String classe = "paie.evaluation.EvaluationAChaud";

    Map<String, String> map = new HashMap<>();
    map.put("inc/evaluationchaud-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/evaluationchaud-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
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
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_evaluation_vf&type=vf&id=<%=request.getParameter("id")%>" >Imprimer VF</a>
                        <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_evaluation_vf&type=vm&id=<%=request.getParameter("id")%>" >Imprimer VM</a>

                    
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
                <li class="<%=map.get("inc/evaluationchaud-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/evaluationchaud-details">Crit&egrave;res</a></li>
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

