
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.competence.FamilleProfessionnelle" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    FamilleProfessionnelle o = new FamilleProfessionnelle();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une Famille professionnelle");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Libell&eacute;");
    pc.getChampByName("desce").setLibelle("Description");

    String[] ordre = {"id","val","desce"};
    pc.setOrdre(ordre);
    String pageActuel = "aie/competence/famillepro-fiche.jsp";
    String pageRetour = "paie/competence/famillepro-liste.jsp";
    String pageModif = "paie/competence/famillepro-saisie.jsp&acte=update";
    String pageApresDelete = "paie/competence/famillepro-liste.jsp";
    String classe = "paie.competence.FamilleProfessionnelle";

    Map<String, String> map = new HashMap<>();
    map.put("inc/hierarchie", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/hierarchie";
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
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
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
                <li class="<%=map.get("inc/hierarchie")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/hierarchie">Hi&eacute;rarchie</a></li>
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
