<%@page import="affichage.PageRecherche"%>
<%@page import="bean.TypeObjet" %>
<%@page import="ferme.configuration.Eclosoir" %>

<% try{
    Eclosoir t = new Eclosoir();
    String listeCrt[] = {"id","val","desce"};
    String listeInt[] = {};
    String libEntete[] = {"id","val","desce","capacite"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;closoirs");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/configuration/eclosoir-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("Nom de l'&eacute;closoir");
    pr.getFormu().getChamp("desce").setLibelle("Remarque");
    String[] colSomme = {"capacite"};
    String[] labelRecap = { "","Nombres","Somme des capacit&eacute;s"};
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableauRecap().setLibeEntete(labelRecap);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=ferme/configuration/eclosoir-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Nom de l'&eacute;closoir", "Remarque","Capacit&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=ferme/configuration/eclosoir-saisie.jsp\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un &eacute;closoir</a>"
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
