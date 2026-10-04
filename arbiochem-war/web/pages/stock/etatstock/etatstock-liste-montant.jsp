<%--
    Document   : etatcaisse-liste
    Created on : 2 avr. 2024, 10:11:22
    Author     : 26134
--%>


<%@page import="produits.CategorieIngredient"%>
<%@page import="utils.ConstanteStation"%>
<%@page import="stock.PageRechercheEtatStock"%>
<%@page import="stock.EtatStock"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Unite"%>
<%@page import="affichage.Liste"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="java.lang.reflect.Method" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    Magasin mag = u.getMagasin();
    EtatStock t = new EtatStock();
    t.setNomTable("V_ETATSTOCK_ING");
    String listeCrt[] = {"idProduit","idProduitLib","idTypeProduitLib","idMagasin", "daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"idProduit","idProduitLib","idTypeProduitLib","idMagasinLib","idUniteLib","pu","invquantite","invdaty","entree","sortie","reste","montantReste"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(mag != null){
        pr.setAWhere("AND IDMAGASIN='"+mag.getId()+"'");
    }
    pr.setTitre("&Eacute;tat de Stock avec montant");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-liste-montant.jsp");


    // Initialisation Liste
    Liste[] dropDowns = new Liste[1];
    Magasin m = new Magasin();
    m.setNomTable("magasinpoint");
    dropDowns[0] = new Liste("idMagasin", m, "val", "id");

    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("daty1").setDefaut("01/01/2001");
    pr.getFormu().getChamp("daty1").setVisible(false);
    pr.getFormu().getChamp("daty1").setLibelle("-");
    pr.getFormu().getChamp("daty2").setLibelle("Date");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idProduit").setLibelle("ID Produit");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idTypeProduitLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    if(mag != null){
        pr.getFormu().getChamp("idMagasin").setAutre("disabled");
        pr.getFormu().getChamp("idMagasin").setDefaut(mag.getId());
    }
    //pr.getFormu().getChamp("idUnite").setLibelle("Unite");
    //pr.getFormu().getChamp("puVente1").setLibelle("Prix de vente minimum");
    //pr.getFormu().getChamp("puVente2").setLibelle("Prix de vente maximum");
    String[] colSomme = {"invquantite","entree","sortie","reste","montantReste"};
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienFiltre = pr.getLien() + "?but=stock/mvtstockfille-liste.jsp";

    String lienTableau[] = {pr.getLien() +"?but=produits/as-ingredients-fiche.jsp",lienFiltre, lienFiltre};
    String colonneLien[] = {"idProduit","entree", "sortie"};
//    String[] attributLien = {"id", "", ""};
    String varColonneLien[] = {"id","",""};

    String[] urllien = new String[] {"idProduit","idMagasin-idProduit-invdaty-idProduit","idMagasin-idProduit-invdaty-idProduit"};
    String[] urllienAffiche = new String[] {"idProduit","idMagasin-idProduit-invdaty-clicStock","idMagasin-idProduit-invdaty-clicStock"};

    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setUrlLien(urllien);
    pr.getTableau().setUrlLienAffiche(urllienAffiche);
    pr.getTableau().setAttLien(varColonneLien);

    String libEnteteAffiche[] = {"ID Produit","Produit","Cat&eacute;gorie","Magasin","Unit&eacute;","Prix Unitaire","Quantit&eacute; d&rsquo;inventaire","Date d&rsquo;inventaire","Entr&eacute;e","Sortie","Reste","Montant Restant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String enteteRecap[] = {"","Nombre","Somme des quantit&eacute;s d&rsquo;inventaire","Somme des entr&eacute;es","Somme des sorties","Somme des restes","Somme des montants restants"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



