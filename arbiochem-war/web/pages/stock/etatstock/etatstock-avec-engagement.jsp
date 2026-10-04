<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="stock.EtatStockAvecEngagement" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    Magasin mag = u.getMagasin();
    EtatStockAvecEngagement t = new EtatStockAvecEngagement();
    t.setNomTable("v_etatstock_ing_eng");
    String[] listeCrt = {"idProduit","idProduitLib","idMagasin","idTypeProduitLib", "daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"idProduit","idProduitLib","idUniteLib","idTypeProduitLib","idMagasinLib","pu","invquantite","invdaty","entree","sortie","reste","montantReste"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(mag != null){
        pr.setAWhere("AND IDMAGASIN='"+mag.getId()+"'");
    }
    pr.setTitre("&Eacute;tat de Stock");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-avec-engagement.jsp");

    Liste[] dropDowns = new Liste[1];
    Magasin m = new Magasin();
    m.setNomTable("magasinpoint");
    dropDowns[0] = new Liste("idMagasin", m, "val", "id");

    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("daty1").setDefaut("01/01/2001");
    pr.getFormu().getChamp("daty1").setVisible(false);
    pr.getFormu().getChamp("daty1").setLibelle("-");
    pr.getFormu().getChamp("daty2").setLibelle("Date");
    pr.getFormu().getChamp("idProduit").setLibelle("Id Produit");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idTypeProduitLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    if(mag != null){
        pr.getFormu().getChamp("idMagasin").setAutre("disabled");
        pr.getFormu().getChamp("idMagasin").setDefaut(mag.getId());
    }
    String[] colSomme = {"invquantite","entree","sortie","reste","montantReste"};
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienFiltre = pr.getLien() + "?but=stock/mvtstockfille-liste.jsp";
    String[] lienTableau = {pr.getLien() +"?but=produits/as-ingredients-fiche.jsp",lienFiltre, lienFiltre};
    String[] colonneLien = {"idProduit"};
    String[] varColonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(varColonneLien);

    String[] libEnteteAffiche = {"ID Produit","Produit","Unit&eacute;","Cat&eacute;gorie","Magasin","Prix unitaire","Quantit&eacute; d&rsquo;inventaire","Date d&rsquo;inventaire","entr&eacute;e","sortie","reste","Montant Restant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] enteteRecap = {"","Nombre","Inventaire","Somme des entr&eacute;es","Somme des sorties","Somme des restes","Somme des montants restants"};
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



