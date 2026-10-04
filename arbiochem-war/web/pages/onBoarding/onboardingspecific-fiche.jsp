<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="onBoarding.OnboardingMere" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="onBoarding.OnboardingMereLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    OnboardingMereLib o = new OnboardingMereLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un on boarding");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("description").setLibelle("Description");
    pc.getChampByName("idFonctionLib").setLibelle("Fonction");

    String[] ordre = {"id","nom","description","idFonctionLib"};
    pc.setOrdre(ordre);

    String pageActuel = "onBoarding/onBoarding-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = "onBoarding/onBoarding-saisie.jsp&acte=update";
    String pageApresDelete = "onBoarding/onBoarding-liste.jsp";
    String classe = "onBoarding.OnboardingMere";

    Map<String, String> map = new HashMap<>();
    map.put("inc/onBoarding-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/onBoarding-details";
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
                        <!--<a class="btn btn-primary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>-->
                        <a  class="btn btn-secondary pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
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
                <li class="<%=map.get("inc/onBoarding-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/onBoarding-details">T&acirc;ches &agrave; faire</a></li>
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

