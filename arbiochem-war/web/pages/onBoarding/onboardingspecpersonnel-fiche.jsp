<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="onBoarding.EmployeOnBoardingSessionLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    EmployeOnBoardingSessionLib o = new EmployeOnBoardingSessionLib();
    o.setNomTable("emp_onboarding_spec");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("");
    String id = pc.getBase().getTuppleID();
    o = (EmployeOnBoardingSessionLib) pc.getBase();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("onboardinglib").setLibelle("Onboarding");
    pc.getChampByName("personnelLib").setLibelle("Personnel");
    pc.getChampByName("dateDebut").setLibelle("Date de d&eacute;but");
    pc.getChampByName("idFonctionLib").setLibelle("Fonction");
    pc.getChampByName("idFonction").setVisible(false);
    pc.getChampByName("dateFin").setVisible(false);
    pc.getChampByName("progression").setLibelle("Progression en %");
    pc.getChampByName("idPersonnel").setVisible(false);
    pc.getChampByName("idOnboarding").setVisible(false);
    pc.getChampByName("etat").setVisible(false);

    String[] ordre = {"id","onboardinglib","personnelLib","dateDebut","progression"};
    pc.setOrdre(ordre);

    String pageActuel = "onBoarding/employeeonboarding-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = "onBoarding/employeeonboarding-saisie.jsp&acte=update";
    String pageApresDelete = "onBoarding/employeeonboarding-liste.jsp";
    String classe = "onBoarding.EmployeOnBoardingSessionLib";

    Map<String, String> map = new HashMap<>();
    map.put("inc/employeeonboarding-detail", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/employeeonboarding-detail";
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
<%--                        <a  class="btn btn-secondary pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>--%>

                    
                        <% if (o.getProgression() >= 100) { %>
                            <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=imprimer_RapportEtonnementF&id=<%=id%>" style="margin-right: 10px">Imprimer en PDF</a>
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
                <li class="<%=map.get("inc/employeeonboarding-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/employeeonboarding-detail">D&eacute;tails</a></li>
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

