<%--
    Document   : vente-liste
    Created on : 25 mars 2024, 09:57:03
    Author     : Angela
--%>

<%@page import="vente.VenteLib"%>
<%@page import="vente.Vente"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.Vente" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="vente.EtatVenteDetailsLib" %>

<% try{
  String idMagasinLib  = request.getParameter("idMagasinLib");
  String idCategorieLib  = request.getParameter("idCategorieLib");
  String idPointLib  = request.getParameter("idPointLib");
  String typeProduitLib  = request.getParameter("typeProduitLib");
  String idprovincelib  = request.getParameter("idprovincelib");


  EtatVenteDetailsLib bc = new EtatVenteDetailsLib();

  LocalDate today = LocalDate.now();
  LocalDate monday = today.with(previousOrSame(MONDAY));
  LocalDate sunday = today.with(nextOrSame(SUNDAY));

  String mondayStr = Utilitaire.datetostring(Date.valueOf(monday));


  String[] listeCrt = {
          "id","idVente",
          "idProduit", "idProduitLib","idClient","daty", "idMagasinLib", "idCategorieLib", "idPointLib", "typeProduitLib", "idprovincelib"};
  String[] listeInt = {"daty"};
  String[] libEntete = {
          "id","idVente",
          "idProduit", "idProduitLib", "qte", "montantTTC", "idMagasinLib", "idCategorieLib", "idPointLib", "typeProduitLib", "idprovincelib"};
  String[] libEnteteAffiche = {
          "ID D&eacute;tail", "ID Vente",
          "ID Produit", "Produit", "Quantit&eacute;","Montant", "Magasin", "Cat&eacute;gorie", "Point", "Type", "Province"};

  PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
  pr.setAWhere(pr.getAWhere()+" and etat>=11");

  pr.setTitre("Liste des factures client");
  pr.setUtilisateur((user.UserEJB) session.getValue("u"));
  pr.setLien((String) session.getValue("lien"));
  pr.setApres("vente/vente-details-liste.jsp");
  //pr.setOrdre(" order by daty desc");
  String[] colSomme = { "qte", "montantTTC"};

  pr.getFormu().getChamp("idMagasinLib").setLibelle("Magasin");
  if (idMagasinLib != null)
    pr.getFormu().getChamp("idMagasinLib").setDefaut(idMagasinLib);

  pr.getFormu().getChamp("idCategorieLib").setLibelle("Cat&eacute;gorie");
  if (idCategorieLib != null)
    pr.getFormu().getChamp("idCategorieLib").setDefaut(idCategorieLib);

  pr.getFormu().getChamp("idPointLib").setLibelle("Point");
  if (idPointLib != null)
    pr.getFormu().getChamp("idPointLib").setDefaut(idPointLib);

  pr.getFormu().getChamp("typeProduitLib").setLibelle("Produit");
  if (typeProduitLib != null)
    pr.getFormu().getChamp("typeProduitLib").setDefaut(typeProduitLib);

  pr.getFormu().getChamp("idprovincelib").setLibelle("Zone");
  if (idprovincelib != null)
    pr.getFormu().getChamp("idprovincelib").setDefaut(idprovincelib);


  pr.getFormu().getChamp("idProduit").setLibelle("ID");
  pr.getFormu().getChamp("idClient").setLibelle("Client");
  pr.getFormu().getChamp("idClient").setPageAppelComplete("client.Client", "id", "CLIENT");
  pr.getFormu().getChamp("idProduitLib").setLibelle("Produits");
  pr.getFormu().getChamp("daty1").setLibelle("Date Min");
  pr.getFormu().getChamp("daty1").setDefaut(mondayStr);
  pr.getFormu().getChamp("daty2").setLibelle("Date Max");
  pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

//  TypeObjet prov = new TypeObjet();
//  prov.setNomTable("province");

//  Liste[] liste = new Liste[1];
//  liste[0] = new Liste("idProvince",prov,"val","id");
//  liste[0].setLibelle("Province");
  //pr.getFormu().getChamp("provincelib").setLibelle("Province");
//  pr.getFormu().changerEnChamp(liste);
  pr.creerObjetPage(libEntete, colSomme);

  //Definition des lienTableau et des colonnes de lien
  String[] lienTableau = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
  String[] colonneLien = {"idVente"};
  pr.getTableau().setLien(lienTableau);
  pr.getTableau().setColonneLien(colonneLien);
  pr.getTableau().setLibelleAffiche(libEnteteAffiche);


  String[] enteteRecap = {"","Nombres", "Somme des Quantit&eacute;" , "Somme des Montant"};
  pr.getTableauRecap().setLibeEntete(enteteRecap);
%>
<div class="content-wrapper">
  <section class="content-header">
    <h1><%= pr.getTitre() %></h1>
  </section>
  <section class="content">
    <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
      <%
        out.println(pr.getFormu().getHtmlEnsemble());
      %>
    </form>
    <%
      out.println(pr.getTableauRecap().getHtml());%>
    <br>

    <%
      out.println(pr.getTableau().getHtml());
    %>
    <%
      out.println(pr.getBasPage());
    %>
  </section>
</div>
<%
  }catch(Exception e){

    e.printStackTrace();
  }
%>




