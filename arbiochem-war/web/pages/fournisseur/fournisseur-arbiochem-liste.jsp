

<%@page import="faturefournisseur.Fournisseur"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="faturefournisseur.FournisseurLib" %>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    FournisseurLib t = new FournisseurLib();
    String listeCrt[] = {"id", "nom","nif","stat" , "adresse","codePostal","compte","idTypeFournisseur"};
    String listeInt[] = {};
    String libEntete[] = {"id", "nom","nif","stat","idTypeFournisseurLib", "adresse","codePostal","compte"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste fournisseur");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    Liste[] liste = new Liste[1];

    liste[0] = new Liste("idTypeFournisseur",new TypeObjet("TYPEFOURNISSEUR"),"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.setApres("fournisseur/fournisseur-arbiochem-liste.jsp");
     pr.getFormu().getChamp("codePostal").setLibelle("code postal");
     pr.getFormu().getChamp("idTypeFournisseur").setLibelle("Type fournisseur");

    String[] colSomme = null;
    pr.setNpp(25);
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=fournisseur/fournisseur-arbiochem-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id", "nom","nif","stat" ,"Type fournisseur", "adresse","code postal","Compte"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=fournisseur/fournisseur-arbiochem-saisie.jsp&currentMenu=MNDN0000508005\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un fournisseur</a>"
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



