<%-- 
    Document   : produit-recherche
    Created on : 26 janv. 2024, 10:25:56
    Author     : Angela
--%>




<%@page import="annexe.ProduitLib"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Unite"%>
<%@page import="annexe.Categorie"%>
<%@page import="annexe.Produit"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="produits.IngredientsLib" %>
<%@page import="bean.TypeObjet"%>

<% try{ 
    IngredientsLib t = new IngredientsLib();
    t.getTypeProduitLib();
    t.setNomTable("AS_INGREDIENTS_LIB");
    String listeCrt[] = {"id", "libelle","categorieingredient","typeProduitLib","idunite","idDepartementLib", "typeStock","actif"};
    String listeInt[] = {};
    String libEntete[] = {"id", "libelle","categorieingredient","typeProduitLib","unite","idDepartementLib","typeStock"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des produits");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("annexe/produit/produit-liste-arbiochem.jsp");
    Liste[] liste = new Liste[4];
    TypeObjet unite = new TypeObjet();
    unite.setNomTable("as_unite");
    liste[0] = new Liste("idunite", unite, "val", "id");
    TypeObjet categorie=new TypeObjet();
    categorie.setNomTable("V_CATEGORIEINGREDIENT");
    liste[1] = new Liste("categorieingredient",categorie,"val","val");
    TypeObjet tp=new TypeObjet();
    tp.setNomTable("V_TYPE_PRODUIT");
    liste[2] = new Liste("typeProduitLib",tp,"val","val");
    liste[3] = new Liste("actif");
    liste[3].makeListeOuiNon();
    liste[3].setDefaut("1");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("categorieingredient").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idDepartementLib").setLibelle("D&eacute;partement");
    pr.getFormu().getChamp("idunite").setLibelle("Unit&eacute;");
    pr.getFormu().getChamp("typeProduitLib").setLibelle("Type de produit");
    pr.getFormu().getChamp("typeStock").setLibelle("Type de stock");

    String[] colSomme = null;
    pr.setNpp(100);
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-arbiochem-fiche.jsp"};
    String colonneLien[] = {"id"};
    Map<String,String> lienTab=new HashMap<>();
    lienTab.put("modifier",pr.getLien() + "?but=produits/as-ingredients-saisie.jsp?acte=update");
//    lienTab.put("Rendre indisponible",pr.getLien() + "?but=rdv/rdv-saisie.jsp");
//    lienTab.put("Rendre disponible",pr.getLien() + "?but=rdv/rdv-saisie.jsp");
    pr.getTableau().setLienClicDroite(lienTab);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Libell&eacute;", "Cat&eacute;gorie", "Type de produit", "Unit&eacute;", "D&eacute;partement", "Type de stock"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=produits/as-ingredients-arbiochem-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un produit</a>"
    );
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



