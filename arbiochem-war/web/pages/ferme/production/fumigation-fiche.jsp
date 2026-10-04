<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.production.FumigationLib" %>
<%@ page import="ferme.production.Fumigation" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    FumigationLib o = new FumigationLib();
    o.setNomTable("FUMIGATION_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une fumigation");
    String id = pc.getBase().getTuppleID();
    Fumigation fumigation = (Fumigation) pc.getBase();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idNumeroVagueLib").setLibelle("Num&eacute;ro de vague");
    pc.getChampByName("idOperateurLib").setLibelle("Op&eacute;rateur");
    pc.getChampByName("idLotLib").setLibelle("Lot");
    pc.getChampByName("idLot").setLibelle("ID Lot");
    pc.getChampByName("idLot").setLien(lien+"?but=ferme/lot/lot-fiche.jsp", "id=");;
    pc.getChampByName("idBatimentLib").setLibelle("B&acirc;timent");
    pc.getChampByName("idParquetLib").setLibelle("Parquet");
    pc.getChampByName("idProduitLib").setLibelle("Produit utilis&eacute;");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("nombreoac").setLibelle("Nombre OAC");
    pc.getChampByName("heuredebutfumigation").setLibelle("Heure de d&eacute;but de fumigation");
    pc.getChampByName("heurefinfumigation").setLibelle("Heure de fin de fumigation");
    pc.getChampByName("heuredebutextraction").setLibelle("Heure de d&eacute;but d'extraction");
    pc.getChampByName("heurefinextraction").setLibelle("Heure de fin d'extraction");
    pc.getChampByName("qte").setLibelle("Quantit&eacute; du produit utilis&eacute;");
    pc.getChampByName("temperaturemin").setLibelle("Temp&eacute;rature minimale");
    pc.getChampByName("temperaturemax").setLibelle("Temp&eacute;rature maximale");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idnumerovague").setVisible(false);
    pc.getChampByName("idoperateur").setVisible(false);
    pc.getChampByName("idproduit").setVisible(false);
    pc.getChampByName("idBatiment").setVisible(false);
    pc.getChampByName("idParquet").setVisible(false);
    pc.getChampByName("etat").setVisible(false);

    String[] ordre = {"id","daty","idNumeroVagueLib", "idLot","idLotLib","idBatimentLib","idParquetLib","nombreoac","heuredebutfumigation","heurefinfumigation","heuredebutextraction","heurefinextraction","idOperateurLib","idProduitLib","qte","temperaturemin","temperaturemax","etatLib"};
    pc.setOrdre(ordre);

    String pageRetour = "ferme/production/fumigation-liste.jsp";
    String pageModif = "ferme/production/fumigationsimple-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/production/fumigation-liste.jsp";
    String classe = "ferme.production.Fumigation";
    String pageActuel = "ferme/production/fumigation-fiche.jsp";

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
                        <% if(fumigation.getEtat() ==1) { %>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+ pageActuel +"&classe=" + classe %> " style="margin-right: 10px">Valider</a>
                        <% }  %>
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

