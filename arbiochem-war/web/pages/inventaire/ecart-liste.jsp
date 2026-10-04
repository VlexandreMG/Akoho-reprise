<%@page import="inventaire.InventaireFilleLib"%>
<%@page import="inventaire.InventaireLib"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="magasin.Magasin"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@page import="user.UserEJB"%>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    InventaireFilleLib inventaire = new InventaireFilleLib();
    inventaire.setNomTable("v_inventaireFilleCpl");
    String listeCrt[] = {"idInventaire", "dateInv","idproduitlib","idProduit","idMagasin"};
    String listeInt[] = {"dateInv"};
    String libEntete[] = {"idInventaire","id","dateInv","idMagasinLib","idProduit","idproduitlib", "uniteLib","quantiteTheorique","quantite","ecart","montantTheorique","montantReelle","ecartMontant"};
    PageRecherche pr = new PageRecherche(inventaire, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des ecarts d'inventaires");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("inventaire/ecart-liste.jsp");

    Liste[] dropDowns = new Liste[1];
    dropDowns[0] = new Liste("idMagasin", new Magasin(), "val" , "id" );
    pr.getFormu().changerEnChamp(dropDowns);

    pr.getFormu().getChamp("idInventaire").setLibelle("Id");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idProduit").setLibelle("Id produit");
    pr.getFormu().getChamp("idproduitlib").setLibelle("Produit");
    pr.getFormu().getChamp("dateInv1").setLibelle("Date d'inventaire min");
    pr.getFormu().getChamp("dateInv1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("dateInv2").setLibelle("Date d'inventaire max");
    pr.getFormu().getChamp("dateInv2").setDefaut(utilitaire.Utilitaire.dateDuJour());
  
    String[] colSomme = {"ecart" , "ecartMontant"};
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=inventaire/inventaire-fiche.jsp" , pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idInventaire", "idProduit"};
    String varColonneLien[] = {"id", "id"};
    String valeurLien[] = {"idInventaire", "idProduit"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(varColonneLien);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setValeurLien(valeurLien);
    
    String libEnteteAffiche[] = {"Id inventaire","ID Inventaire Fille","Date inventaire", "Magasin","ID Produit","Produit", "Unit&eacute;","Quantit&eacute; th&eacute;orique","quantit&eacute; d' Inventaire"," &Eacute;cart de quantit&eacute;","valeur th&eacute;orique","valeur d'inventaire","&Eacute;cart de valeur"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      
%>
<script>
    function changerDesignation() {
        document.invliste.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="invliste"  id="invliste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            </form>
        <%
            String[] recapEntete = { "", "Nombre", "somme des &eacute;carts en quantit&eacute;", "somme des &eacute;carts en montant"};
            pr.getTableauRecap().setLibeEntete(recapEntete);
         
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



