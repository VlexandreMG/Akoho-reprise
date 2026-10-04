
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.competence.EmploiLib" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    EmploiLib o = new EmploiLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un emploi");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Libell&eacute;");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("idCodeRomeLib").setLibelle("Code ROME");
    pc.getChampByName("idmetierlib").setLibelle("M&eacute;tier");
    pc.getChampByName("idmetier").setVisible(false);
    pc.getChampByName("idFamilleProLib").setLibelle("Famille professionnelle");
    pc.getChampByName("idsousFamilleProLib").setLibelle("Sous-famille professionnelle");


    String pageRetour = "paie/competence/emploi-liste.jsp";
    String pageModif = "paie/competence/emploi-saisie.jsp&acte=update";
    String pageApresDelete = "paie/competence/emploi-liste.jsp";
    String classe = "paie.competence.Emploi";

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

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
