<%@page import="magasin.Magasin"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="magasin.MagasinLibCompta" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="magasin.MagasinLib" %>

<% try{
    MagasinLib magasin = new MagasinLib();
    magasin.setNomTable("magasinlib");
    String listeCrt[] = {"id", "val","desce","idpointlib","idTypeMagasinlib","idProduitlib", "idLigneLib"};
    String listeInt[] = {};
    String libEntete[] = {"id", "val","desce","idpointlib","idTypeMagasinlib","idProduitlib", "idLigneLib"};
    PageRecherche pr = new PageRecherche(magasin, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des magasins");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("magasin/magasin-liste.jsp");

    Liste[] liste = new Liste[3];
    TypeObjet idLigneLib = new TypeObjet("ligne");
    liste[0] = new Liste("idLigneLib", idLigneLib, "val", "val");

    TypeObjet idTypeMagasinLib = new TypeObjet();
    idTypeMagasinLib.setNomTable("TYPEMAGASIN");
    liste[1] = new Liste("idTypeMagasinlib", idTypeMagasinLib, "val", "val");

    TypeObjet point = new TypeObjet();
    point.setNomTable("POINT");
    liste[2] = new Liste("idpointlib", point, "val", "val");

    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("desce").setLibelle("D&eacute;scription");
    pr.getFormu().getChamp("idpointlib").setLibelle("Point");
    pr.getFormu().getChamp("idTypeMagasinlib").setLibelle("Type");
    pr.getFormu().getChamp("idProduitlib").setLibelle("Produit");
    pr.getFormu().getChamp("idLigneLib").setLibelle("Ligne");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=magasin/magasin-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=magasin/magasin-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence", "Libell&eacute;","D&eacute;scription","Point","Type","Produit", "Ligne"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=magasin/magasin-saisie.jsp&currentMenu=MNDN0000000201\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un magasin</a>"
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
</div>
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



