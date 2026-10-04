<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.accident.Accident" %>
<%@ page import="affichage.Liste"%>
<%@ page import="magasin.TypeMagasin" %>
<%@ page import="mg.cnaps.compta.TypeCompte" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="paie.log.LogPersonnel" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="paie.accident.ArretTravail" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.accident.ArretTravail";
    String nomTable = "ARRET_TRAVAIL";
    String apres = "paie/accident/arret-travail-fiche.jsp";

    ArretTravail o = new ArretTravail();
    o.setNomTable("ARRET_TRAVAIL");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'un repos m&eacute;dicale");
    String idAccident = request.getParameter("idAccident");
    if(idAccident!=null) {
        pi.getFormu().getChamp("id_Accident").setDefaut(idAccident);
    }

    pi.getFormu().getChamp("id_Accident").setPageAppelComplete("paie.accident.Accident","id","ACCIDENT","","");
    pi.getFormu().getChamp("date_Debut_Arret").setLibelle("Date de début");
    pi.getFormu().getChamp("date_Fin_Arret").setLibelle("Date de fin");
    pi.getFormu().getChamp("nombre_Jour").setLibelle("Nombre de jour");
    pi.getFormu().getChamp("id_Accident").setLibelle("ID de l'accident");
    pi.getFormu().getChamp("daty").setLibelle("Date de saisie");


    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un repos m&eacute;dicale");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

