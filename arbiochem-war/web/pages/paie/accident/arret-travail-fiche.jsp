<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.accident.AccidentLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="paie.accident.ArretTravailLib" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ArretTravailLib o = new ArretTravailLib();
    o.setNomTable("V_ARRETTRAVAIL_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un repos m&eacute;dicale");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("ID");

    pc.getChampByName("nomPersonnel").setLibelle("Personnel");
    pc.getChampByName("matricule").setLibelle("Matricule");
    pc.getChampByName("dateAccident").setLibelle("Date de l'accident");
    pc.getChampByName("nomPersonnel").setLibelle("Personnel");
    pc.getChampByName("id_Accident").setLibelle("ID de l'accident");
    pc.getChampByName("date_Debut_Arret").setLibelle("Date de début");

    pc.getChampByName("date_Fin_Arret").setLibelle("Date de fin");
    pc.getChampByName("nombre_Jour").setLibelle("Nombre de jour");
    pc.getChampByName("daty").setLibelle("Date de saisie");
    pc.getChampByName("id_Personnel").setLibelle("ID du personnel");

    pc.getChampByName("id_Accident").setLien(lien+"?but=paie/accident/accident-fiche.jsp", "id=");
    pc.getChampByName("id_Personnel").setLien(lien+"?but=paie/employe/personnel-fiche-portrait.jsp", "id=");

    String[] ordre = {"id","daty","id_Personnel","nomPersonnel","matricule","id_Accident","dateAccident","date_Debut_Arret","date_Fin_Arret", "nombre_Jour"};
    pc.setOrdre(ordre);

    String pageRetour = "paie/accident/arretTravail-liste.jsp";
    String pageModif = "paie/accident/arret-travail-saisie.jsp&acte=update";
    String pageApresDelete = "paie/accident/arretTravail-liste.jsp";
    String classe = "paie.accident.ArretTravail";

    String pageActuel = "paie/accident/arret-travail-fiche.jsp";

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
                            <a  class="pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
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

