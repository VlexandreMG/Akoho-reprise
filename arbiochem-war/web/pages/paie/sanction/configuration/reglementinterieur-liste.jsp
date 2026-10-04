<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="user.UserEJB"%>
<%@ page import="paie.employe.sanction.RegleInterieur" %>


<%
    try {
        UserEJB u = (user.UserEJB) session.getValue("u");

        String nomTable = "REGLEMENTINTERIEUR";
        String lien = (String) session.getAttribute("lien");
        String apres = "paie/sanction/configuration/reglementinterieur-liste.jsp";
        String lienFiche = "paie/sanction/configuration/reglementinterieur-fiche.jsp";

        RegleInterieur tpf = new RegleInterieur();
        tpf.setNomTable(nomTable);

        String[] listeCritere = { "id", "descriptionRegle" , "numeroRegle"};
        String[] libEntete = { "id", "numeroRegle" , "descriptionRegle","niveau" };
        // String[] libEnteteAffiche = {"ID","Valeur","D&eacute;scription"};
        String[] listeIntervalle = {};
        String[] colSomme = null;

        PageRecherche pr = new PageRecherche(tpf, request, listeCritere, listeIntervalle, 3, libEntete, libEntete.length);

        pr.setTitre("Liste des r&egrave;gles int&eacute;rieures");
        pr.setUtilisateur(u);
        pr.setLien(lien);


        pr.getFormu().getChamp("numeroRegle").setLibelle("Numero de la r&egrave;gle");
        pr.getFormu().getChamp("descriptionRegle").setLibelle("D&eacute;scription de la r&egrave;");

        pr.setApres(apres);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getFormu().setAnotherButton(
                "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/sanction/configuration/reglementinterieur-saisie.jsp&currentMenu=ELM0006587\">\n" +
                        "                    <i class=\"material-symbols-rounded\">add</i> Saisir une r&egrave;gle" +
                        "                </a>"
        );
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= apres %>" method="post" name="listeregle" id="listeregle">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <%
            String lienTableauStr = pr.getLien() + "?but=";
            String lienTableau[] = { lienTableauStr + lienFiche };
            String colonneLien[] = { "id" };
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());
        %>

        </br>

        <%
            String libEnteteAffiche[] =  { "ID","Numero de la r&egrave;gle","D&eacute;scription de la r&egrave;gle","Niveau"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>

    </section>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% } %>
