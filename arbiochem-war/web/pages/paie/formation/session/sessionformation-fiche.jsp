<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.formation.session.SessionFormationLib" %>
<%@ page import="constante.ConstanteEtat" %>
<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    SessionFormationLib o = new SessionFormationLib();
    o.setNomTable("SESSION_FORMATION_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une session de formation");
    String id = pc.getBase().getTuppleID();
    o = (SessionFormationLib) pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idactionformation").setLibelle("Id Action de Formation");
    pc.getChampByName("idactionformationlib").setLibelle("Action de Formation");
    pc.getChampByName("datedebut").setLibelle("Date de d&eacute;but");
    pc.getChampByName("datefin").setLibelle("Date de fin");
    pc.getChampByName("nbheureprevue").setLibelle("Nombre d'heures pr&eacute;vues");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
     pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idactionformation").setLien(lien+"?but=paie/formation/action/actionformation-fiche-back.jsp","id=");

    String[] ordre = {"id","idactionformation","idactionformationlib","datedebut","datefin","nbheureprevue","remarque","etatlib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "paie/formation/session/sessionformation-saisie.jsp&acte=update";
    String pageApresDelete = "paie/formation/session/sessionformation-liste.jsp";
    String classe = "paie.formation.session.SessionFormation";

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
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <% }%>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/formation/session/sessionformation-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                     <% } %>
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

