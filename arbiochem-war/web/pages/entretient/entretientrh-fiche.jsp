<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="entretien.EntretienRHLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    EntretienRHLib o = new EntretienRHLib();
    o.setNomTable("ENTRETIENRH_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une entretien RH");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("typeEntretientLib").setLibelle("Type d'entretien");
    pc.getChampByName("idFonctionLib").setLibelle("Fonction");
    pc.getChampByName("idDirectionLib").setLibelle("Direction");
    pc.getChampByName("nomPrenomCandidat").setLibelle("Nom et pr&eacute;nom du candidat");
    pc.getChampByName("idPersonnel").setLibelle("Id Personnel");
    pc.getChampByName("idEvaluateur").setVisible(false);
    pc.getChampByName("motivationCandidat").setLibelle("Motivation du candidat");
    pc.getChampByName("ambitionProfessionel").setLibelle("Ambition professionnelle");
    pc.getChampByName("pretentionSalariale").setLibelle("Pr&eacute;tention salariale");
    pc.getChampByName("remunerationActuel").setLibelle("R&eacute;mun&eacute;ration actuelle");
    pc.getChampByName("appreciationCandidat").setLibelle("Appr&eacute;ciation du candidat");
    pc.getChampByName("commentaires").setLibelle("Commentaires");
    pc.getChampByName("experienceCandidat").setLibelle("Exp&eacute;rience du candidat");
    pc.getChampByName("atout").setLibelle("Atout");
    pc.getChampByName("faiblesses").setLibelle("Faiblesses");
    pc.getChampByName("pointVigilance").setLibelle("Point de vigilance");
    pc.getChampByName("conclustion").setLibelle("Conclusion");
    pc.getChampByName("idEvaluateurLib").setLibelle("&Eacute;valuateur");
    pc.getChampByName("typeEntretient").setVisible(false);
    pc.getChampByName("idFonction").setVisible(false);
    pc.getChampByName("idDirection").setVisible(false);

    String[] ordre = {"id","typeEntretientLib","idFonctionLib","idDirectionLib","nomPrenomCandidat","idPersonnel","idEvaluateurLib","motivationCandidat","ambitionProfessionel","pretentionSalariale","remunerationActuel","appreciationCandidat","commentaires","experienceCandidat","atout","faiblesses","pointVigilance","conclustion"};
    pc.setOrdre(ordre);

    String pageActuel = "entretientrh-fiche.jsp";
    String pageRetour = "entretient/entretienrh-liste.jsp";
    String pageModif = "entretient/entretientrh-saisie.jsp&acte=update";
    String pageApresDelete = "entretient/entretienrh-liste.jsp";
    String classe = "entretien.EntretienRHLib";

    Map<String, String> map = new HashMap<>();
    map.put("inc/entretientrh-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/entretientrh-details";
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
                <li class="<%=map.get("inc/entretientrh-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/entretientrh-details">D&eacute;tails</a></li>
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

