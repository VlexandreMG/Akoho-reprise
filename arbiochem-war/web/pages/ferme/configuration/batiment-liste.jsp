<%@page import="java.sql.Date"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="ferme.configuration.BatimentLib"%>
<%@page import="affichage.PageRecherche"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    try {
        BatimentLib base = new BatimentLib();
        String listeCrt[] = {"idFermeLib","nomBatiment"};
        String listeInt[] = {};
        String libEntete[] = {"id", "idFermelib","nomBatiment", "surface", "capacite","densite", "longueur", "largeur"};
        PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.getFormu().getChamp("idFermeLib").setLibelle("Ferme");
        pr.getFormu().getChamp("nomBatiment").setLibelle("Nom du batiment");
        pr.setApres("ferme/configuration/batiment-liste.jsp");
        String[] colSomme = {"surface","capacite","densite"};
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().setLienFille("ferme/configuration/inc/batiment-details.jsp&id=");
        String[] labelRecap = { "","Nombres","Somme des surfaces", "Somme des capacit&eacute;s", "Somme des densit&eacute;s" };
        pr.getTableauRecap().setLibeEntete(labelRecap);
        pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=ferme/configuration/batiment-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir un batiment</a>"
        );
%>
<script>
    function changerDesignation() {
        document.liste.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des traites</h1>
    </section>
    <section class="content">
        <form action='<%=pr.getLien() + "?but=ferme/configuration/batiment-liste.jsp" %>' method="post" name="liste" id="liste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
               <%
            String lienTableau[] = {pr.getLien() + "?but=ferme/configuration/batiment-fiche.jsp",pr.getLien() + "?but=magasin/magasin-fiche.jsp"};
            String colonneLien[] = {"id","idFerme"};
            String attLien[] = {"id","id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setAttLien(attLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br/>
        <%
            String libelleAffiche[] = {"ID", "Ferme","Nom du batiment","Surface","Capacit&eacute;","Densit&eacute;", "Longueur", "Largeur"};
            pr.getTableau().setLibelleAffiche(libelleAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<% } catch (Exception e) {
        e.printStackTrace();
    }%>

