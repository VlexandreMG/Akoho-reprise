<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.formateur.Formateur" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    Formateur o = new Formateur();
    o.setNomTable("FORMATEUR");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un formateur");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("libelle").setLibelle("Nom");
    pc.getChampByName("email").setLibelle("Email");
    pc.getChampByName("telephone").setLibelle("T&eacute;l&eacute;phone");

    String[] ordre = {"id","libelle","email","telephone"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "paie/formateur/formateur-saisie.jsp&acte=update";
    String pageModule = "paie/formateur/formateurmodule-saisie.jsp&idFormateur=" + id;
    String pageApresDelete = "paie/formateur/formateur-liste.jsp";
    String classe = "paie.formateur.Formateur";

    String pageActuel = "paie/formateur/formateur-fiche.jsp";

    Map<String, String> map = new HashMap<>();
    map.put("inc/module-formateur", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/module-formateur";
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
                        <% if (!"dg".equalsIgnoreCase(u.getUser().getIdrole())) { %>
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <% }%>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModule %>" style="margin-right: 10px">Ajouter Module</a>
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
                    <li class="<%=map.get("inc/module-formateur")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/module-formateur">Modules</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
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

