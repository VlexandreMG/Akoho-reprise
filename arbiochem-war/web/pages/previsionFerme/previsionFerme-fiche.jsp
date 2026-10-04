<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="previsionFerme.PrevisionFermeLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getAttribute("u");
    String lien = (String) session.getAttribute("lien");
    PrevisionFermeLib o = new PrevisionFermeLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("idMagasinLib").setLibelle("Magasin");
    pc.getChampByName("idTiersLib").setLibelle("Tiers");
    pc.getChampByName("idProduitLib").setLibelle("Produit");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("pu").setLibelle("Prix unitaire");
    pc.getChampByName("entree").setLibelle("Entr&eacute;e");
    pc.getChampByName("sortie").setLibelle("Sortie");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("sortieEffective").setLibelle("Sortie effective");
    pc.getChampByName("entreeEffective").setLibelle("Entr&eacute;e effective");
    pc.getChampByName("ecartEntree").setLibelle("&Eacute;cart entr&eacute;e");
    pc.getChampByName("ecartSortie").setLibelle("&Eacute;cart sortie");
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idMagasin").setVisible(false);
    pc.getChampByName("idMvtStockFille").setVisible(false);
    pc.getChampByName("idProduit").setVisible(false);
    pc.getChampByName("idOrigine").setVisible(false);
    pc.getChampByName("idTiers").setVisible(false);

    String[] ordre = {"idMagasinLib","idTiersLib","idProduitLib","designation","pu","entree","sortie","daty"};
    pc.setOrdre(ordre);

    String pageRetour = "previsionFerme/previsionFerme-liste.jsp";
    String pageModif = "previsionFerme/previsionFerme-modif.jsp";
    String pageApresDelete = "previsionFerme/previsionFerme-liste.jsp";
    String classe = "previsionFerme.PrevisionFerme";

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
                    <div class="box-footer">
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
<%--                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>--%>
                    </div>
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

