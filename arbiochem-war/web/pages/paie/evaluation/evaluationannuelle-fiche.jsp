<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.evaluation.EvaluationAnnuelleLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="constante.ConstanteEtat" %>
<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    EvaluationAnnuelleLib o = new EvaluationAnnuelleLib();
    o.setNomTable("EVALUATION_ANNUELLE_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un evaluation annuelle");
    String id = pc.getBase().getTuppleID();
    o = (EvaluationAnnuelleLib) pc.getBase();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idpersonnel").setLibelle("Personnel");
    pc.getChampByName("idpersonnellib").setLibelle("Nom & pr&eacute;nom");
    pc.getChampByName("annee").setLibelle("Ann&eacute;e");
    pc.getChampByName("noteglobale").setLibelle("Note globale");
    pc.getChampByName("commentaire").setLibelle("Commentaire");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("IdFonctionLib").setLibelle("Fonction");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("IdFonction").setVisible(false);
    pc.getChampByName("noteglobale").setVisible(false);
    pc.getChampByName("idpersonnel").setLien(lien+"?but=paie/employe/personnel-fiche-portrait.jsp","id=");

    String[] ordre = {"id","idpersonnel","idpersonnellib","annee","noteglobale","commentaire","etat"};
    pc.setOrdre(ordre);

    String pageActuel = "paie/evaluation/evaluationannuelle-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = "paie/evaluation/evaluationannuelle-saisie.jsp&acte=update";
    String pageApresDelete = "paie/evaluation/evaluationannuelle-liste.jsp";
    String classe = "paie.evaluation.EvaluationAnnuelle";

    Map<String, String> map = new HashMap<>();
    map.put("inc/exemple-page-detail", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/detail";
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
                     <% if (o.getEtat() < ConstanteEtat.getEtatValider()) {%>
                        <% if (!"dg".equalsIgnoreCase(u.getUser().getIdrole())) { %>
<%--                             <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>--%>
                        <% }%>
<%--                        <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>--%>
<%--                         <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/evaluation/evaluationannuelle-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>--%>
                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                        <a  class="btn btn-secondary pull-right" href="<%= lien + "?but=paie/evaluation/evaluationannuelle-saisie.jsp&id=" + id+"&acte=update&bute="+pageActuel+"&classe="+classe %>">Modifier</a>
                         <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/evaluation/evaluationannuelle-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                    <% }%>
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
                <li class="<%=map.get("inc/detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/detail">D&eacute;tails</a></li>
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

