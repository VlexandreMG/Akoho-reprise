<%--
    Created by IntelliJ IDEA.
  User: nomenjanhary ramarokoto
  Date: 01/12/2025
  Time: 22:28
  To change this template use File | Settings | File Templates.
--%>

<%@page import="client.Client"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.ressources.IngredientMaintenanceLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>

<% try{
    IngredientMaintenanceLib t = new IngredientMaintenanceLib();
    String listeCrt[] = {"id","libelle","numeroSerieObjet"};
    String listeInt[] = {};
    String libEntete[] = {"id","libelle",
    "numeroSerieObjet","descriptionObjet"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des outils");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/ressources/outils/outils-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("libelle").setLibelle("libell&eacute;");
    String apreswhere = " and idEntite = '"+ ConstanteMaintenance.ENTITE_OUTILS + "'";
     if(pr.getUtilisateur().getPersonnel()!=null)apreswhere+=" and iddepartement='"+pr.getUtilisateur().getPersonnel().getIdDepartement()+"'";
    pr.setAWhere(apreswhere);
    pr.getFormu().getChamp("numeroSerieObjet").setLibelle("Num&eacutero de s&eacute;rie");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=maintenance/ressources/outils/outils-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Libell&eacute;","Num&eacutero de s&eacute;rie",
    "Description"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    pr.getFormu().setAnotherButton(
        "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/ressources/outils/outils-saisie.jsp&currentMenu=MENDYN1764615021923191\">\n" +
        "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un composant" +
        "                </a>"
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




