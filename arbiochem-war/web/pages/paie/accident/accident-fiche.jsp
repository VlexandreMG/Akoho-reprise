<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.accident.AccidentLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    AccidentLib o = new AccidentLib();
    o.setNomTable("V_ACCIDENT_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un accident");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("id_machine_lib").setLibelle("Machine");
    pc.getChampByName("id_type_accident_lib").setLibelle("Type d'accident");
    pc.getChampByName("id_gravite_lib").setLibelle("Gravit&eacute;");
    pc.getChampByName("id_personnel_lib").setLibelle("Personnel");
    pc.getChampByName("id_personnel").setLibelle("Id Personnel");
    pc.getChampByName("id_personnel").setLien(lien+"?but=paie/employe/personnel-fiche-portrait.jsp", "id=");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("date_Declaration").setVisible(false);
    if (pc.getChampByName("etat_lib").getValeur().equals("Déclaré")) {
        pc.getChampByName("date_Declaration").setVisible(true);
        pc.getChampByName("date_Declaration").setLibelle("Date de d&eacute;claration");
    }

    pc.getChampByName("heureAccident").setLibelle("Heure de l'accident");
    pc.getChampByName("horaireDebut").setLibelle("Heure début du service");
    pc.getChampByName("horaireFin").setLibelle("Heure fin du service");
    pc.getChampByName("activite").setLibelle("Activit&eacute; au moment de l'accident");
    pc.getChampByName("lesions").setLibelle("L&eacute;sions subies");
    pc.getChampByName("detailsTemoin1").setLibelle("Nom et adresses des témoins (1)");
    pc.getChampByName("detailsTemoin2").setLibelle("Nom et adresses des témoins (2)");
    pc.getChampByName("centreSoin").setLibelle("Centre de soins");

    pc.getChampByName("id_Type_Accident").setVisible(false);
    pc.getChampByName("cause").setLibelle("Cause");
    pc.getChampByName("id_lieu_lib").setVisible(false);
    pc.getChampByName("id_Lieu").setVisible(false);
    pc.getChampByName("id_Gravite").setVisible(false);
    pc.getChampByName("id_Machine").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("etat_lib").setLibelle("&Eacute;tat");

    String[] ordre = {"id","id_machine_lib","id_type_accident_lib","id_gravite_lib","id_personnel","id_personnel_lib","daty","id_Type_Accident","cause", "etat_lib"};
    pc.setOrdre(ordre);

    String pageRetour = "paie/accident/accident-liste.jsp";
    String pageModif = "paie/accident/accident-saisie.jsp&acte=update";
    String pageApresDelete = "paie/accident/accident-liste.jsp";
    String classe = "paie.accident.Accident";

    String pageActuel = "paie/accident/accident-fiche.jsp";


    Map<String, String> map = new HashMap<>();
    map.put("inc/arret-travail", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/arret-travail";
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
                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a  class="pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        <%
                            if (pc.getChampByName("etat").getValeur().equals("1")){
                        %>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/accident/accident-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">D&eacute;clarer</a>
                        <%
                            }
                        %>
                        <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=paie/accident/arret-travail-saisie.jsp&idAccident=" + request.getParameter("id") + "&classe=" + classe%> " style="margin-right: 10px">Repos M&eacute;dical</a>
                        <a class="btn btn-tertiary pull-right"href="${pageContext.request.contextPath}/ExportPDF?action=accident&id=<%= request.getParameter("id")%>">Imprimer</a>
                        <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + pc.getBase().getClass().getSimpleName() + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") %>" style="margin-right: 10px;">Attacher carte AT</a>
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
                    <li class="<%=map.get("inc/arret-travail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id_accident=<%= id %>&tab=inc/arret-travail">D&eacute;tails</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
        </div>
    </div>
</div>
<%
    out.println(pc.getHtmlAttacherFichier());
%>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

