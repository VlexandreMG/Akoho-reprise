<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="maintenance.tempOuverture.TempsOuvertureLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    TempsOuvertureLib o = new TempsOuvertureLib();
    o.setNomTable("TEMPSOUVERTURELIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un temps d'ouverture");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idMachine").setLibelle("Id Machine");
    pc.getChampByName("idMachinelib").setLibelle("Machine");
    pc.getChampByName("temps").setLibelle("Temps");
    pc.getChampByName("IdUnite").setVisible(false);
    //pc.getChampByName("motsclesss").setVisible(false);
    pc.getChampByName("IdUnitelib").setLibelle("Unit&eacute;");
    pc.getChampByName("Capacite").setLibelle("Capacit&eacute;");
    pc.getChampByName("idMachine").setLien("?but=maintenance/ressources/machine/machine-fiche.jsp","id=");
    String[] ordre = {"id","idMachine","idMachinelib","temps"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "tempsOuverture/tempsOuverture-saisie.jsp&acte=update";
    String pageApresDelete = "tempsOuverture/tempsOuverture-liste.jsp";
    String classe = "maintenance.tempOuverture.TempsOuvertureLib";

%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

<div class="row m-0">
    <div class="col-md-3"></div>
    <div class="col-md-12 nopadding">
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

