<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.formation.CoutFormationLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    CoutFormationLib o = new CoutFormationLib();
    o.setNomTable("COUT_FORMATION_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une cout de fromation");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("intitule").setLibelle("Intitul&eacute;");
    pc.getChampByName("idDeviseLib").setLibelle("Devise");
    pc.getChampByName("coutTotal").setLibelle("Co&ucirc;t total");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("coutpedagogiquehoraire").setLibelle("Co&ucirc;t p&eacute;dagogique horaire");
    pc.getChampByName("coutpedagogiquetotal").setLibelle("Co&ucirc;t p&eacute;dagogique total");
    pc.getChampByName("coutdeplacement").setLibelle("Co&ucirc;t d&eacute;placement");
    pc.getChampByName("couthebergement").setLibelle("Co&ucirc;t h&eacute;bergement");
    pc.getChampByName("coutrestauration").setLibelle("Co&ucirc;t restauration");
    pc.getChampByName("autrecout").setLibelle("Autre co&ucirc;t");
    pc.getChampByName("coutparstagiaire").setLibelle("Co&ucirc;t par stagiaire");
    pc.getChampByName("totalheurestagiaire").setLibelle("Total heures stagiaire");
    pc.getChampByName("coutindirecte").setLibelle("Co&ucirc;t indirect");
    pc.getChampByName("iddevise").setLibelle("Id devise");
    pc.getChampByName("idactionformation").setLibelle("Action de formation");
      pc.getChampByName("idactionformation").setLien(lien+"?but=paie/formation/action/actionformation-fiche.jsp","id=");
   // pc.getChampByName("idactionformation").setVisible(false);
    pc.getChampByName("iddevise").setVisible(false);

    String[] ordre = {"id","reference","intitule","idactionformation","totalheurestagiaire","coutpedagogiquehoraire","coutpedagogiquetotal","coutdeplacement","couthebergement","coutrestauration","coutparstagiaire","autrecout","coutTotal","idDeviseLib","coutindirecte"};
    pc.setOrdre(ordre);

    String pageRetour = "paie/formation/cout/coutformation-liste.jsp";
    String pageModif = "paie/formation/cout/coutformation-saisie.jsp&acte=update";
    String pageApresDelete = "paie/formation/cout/coutformation-liste.jsp";
    String classe = "paie.formation.CoutFormationLib";

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

