<%@page import="java.sql.Date"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="ferme.aliment.*"%>
<%@page import="affichage.PageRecherche"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    try {
        DistributionAlimentLib base = new DistributionAlimentLib();
        String listeCrt[] = {"idFermeLib","idLotLib","daty"};
        String listeInt[] = {"daty"};
        String libEntete[] = {"id","daty", "idFermelib","idLotLib", "idSoucheLib", "etatLib"};
        PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.getFormu().getChamp("idFermeLib").setLibelle("Ferme");
        pr.getFormu().getChamp("idLotLib").setLibelle("Lot");
        pr.getFormu().getChamp("daty1").setLibelle("Date min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.setApres("ferme/aliment/distributionaliment-liste.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().setLienFille("ferme/aliment/inc/distributionaliment-details.jsp&id=");
        pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=ferme/aliment/distributionaliment-saisie.jsp&currentMenu=MEN000690\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir une distribution d'aliment</a>"
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
        <form action='<%=pr.getLien() + "?but=ferme/aliment/distributionaliment-liste.jsp" %>' method="post" name="liste" id="liste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
               <%
            String lienTableau[] = {pr.getLien() + "?but=ferme/aliment/distributionaliment-fiche.jsp"};
            String colonneLien[] = {"id"};
            String attLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setAttLien(attLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br/>
        <%
            String libelleAffiche[] = {"Id","Date","Ferme", "Nom du Lot", "Souche", "&Eacute;tat"};
            pr.getTableau().setLibelleAffiche(libelleAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<% } catch (Exception e) {
        e.printStackTrace();
    }%>

