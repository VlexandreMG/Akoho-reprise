<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="poste.FicheCompetenceFPLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    FicheCompetenceFPLib o = new FicheCompetenceFPLib();
    o.setNomTable("FICHE_POSTE_COMPETENCES_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche competence poste");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("idtypecompetencesfplib").setLibelle("Type de comp&eacute;tence");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idficheposte").setLibelle("Fiche de poste");
    pc.getChampByName("description").setLibelle("Description");
    pc.getChampByName("niveaulib").setLibelle("Niveau");
    pc.getChampByName("idtypecompetencesfp").setVisible(false);
    pc.getChampByName("niveau").setVisible(false);
    pc.getChampByName("idficheposte").setLien(lien+"?but=poste/ficheposte-fiche.jsp","id=");

    String[] ordre = {"idtypecompetencesfplib","id","idficheposte","description","niveaulib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "poste/fpcompetences-saisie.jsp&acte=update";
    String pageApresDelete = "poste/fpcompetences-saisie.jsp";
    String classe = "poste.FicheCompetenceFPLib";

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

