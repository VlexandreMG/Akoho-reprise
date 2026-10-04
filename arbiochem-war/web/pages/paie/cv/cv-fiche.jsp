<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.cv.CVLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    CVLib o = new CVLib();
    o.setNomTable("CV_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une cv");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("Date de dėp&ocirc;t");
    pc.getChampByName("nomcandidat").setLibelle("Nom du candidat");
    pc.getChampByName("prenomcandidat").setLibelle("Pr&eacute;nom du candidat");
    pc.getChampByName("titrecv").setLibelle("Titre du re&ccedil;u");
    pc.getChampByName("resumeprofil").setLibelle("R&eacute;sum&eacute; du profil");
    pc.getChampByName("idFichePoste").setLibelle("ID Fiche de poste");
    pc.getChampByName("idFichePoste").setLien(lien+"?but=poste/ficheposte-fiche.jsp", "id=");
    pc.getChampByName("idFichePosteLib").setLibelle("Fiche de poste");

    String[] ordre = {"id","daty","nomcandidat","prenomcandidat","titrecv","resumeprofil"};
    pc.setOrdre(ordre);

    String pageActuel = "paie/cv/cv-fiche.jsp";
    String pageRetour = "paie/cv/cv-liste.jsp";
    String pageApresDelete = "paie/cv/cv-liste.jsp";
    String classe = "paie.cv.CV";
    String pageModif = "paie/cv/cv-saisie.jsp&acte=update";
    String pageCompetance = "paie/cv/competencecv-saisie.jsp";
    String pageLangue = "paie/cv/languecv-saisie.jsp";
    String pageCertification = "paie/cv/certificationcv-saisie.jsp";
    String pageFormation = "paie/cv/formationcv-saisie.jsp";
    String pageExperience = "paie/cv/experiencecv-saisie.jsp";

    Map<String, String> map = new HashMap<>();
    map.put("inc/cv-experience", "");
    map.put("inc/cv-formation", "");
    map.put("inc/cv-competence", "");
    map.put("inc/cv-langue", "");
    map.put("inc/cv-certification", "");
    map.put("inc/cv-matching", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/cv-experience";
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
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageCompetance +"&idcv=" + id %>" style="margin-right: 10px">Comp&eacute;tences</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageExperience +"&idcv=" + id %>" style="margin-right: 10px">&Eacute;xp&eacute;rience</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageFormation +"&idcv=" + id %>" style="margin-right: 10px">Formation</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageLangue +"&idcv=" + id %>" style="margin-right: 10px">Langues</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageCertification +"&idcv=" + id %>" style="margin-right: 10px">Certifications</a>
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
                <li class="<%=map.get("inc/cv-experience")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/cv-experience">&Eacute;xp&eacute;rience</a></li>
                <li class="<%=map.get("inc/cv-formation")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/cv-formation">Formation</a></li>
                <li class="<%=map.get("inc/cv-competence")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/cv-competence">Comp&eacute;tences</a></li>
                <li class="<%=map.get("inc/cv-langue")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/cv-langue">Langues</a></li>
                <li class="<%=map.get("inc/cv-certification")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/cv-certification">Certifications</a></li>
                <li class="<%=map.get("inc/cv-matching")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/cv-matching">Matching des comp&eacute;tences</a></li>
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

