<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="user.UserEJB"%>
<%@ page import="paie.sanction.configuration.TypeFaute" %>
<%@ page import="paie.sanction.configuration.TypeAccident" %>

<%
    try {
        UserEJB u = (user.UserEJB) session.getValue("u");

        String nomTable = "TYPE_ACCIDENT";
        String lien = (String) session.getAttribute("lien");
        String apres = "paie/sanction/configuration/typeaccident-liste.jsp";
        String lienFiche = "paie/sanction/configuration/typeaccident-fiche.jsp";

        TypeAccident tpf = new TypeAccident();
        tpf.setNomTable(nomTable);

        String[] listeCritere = { "id", "val" , "desce"};
        String[] libEntete = { "id", "val" , "desce" };
        // String[] libEnteteAffiche = {"ID","Valeur","D&eacute;scription"};
        String[] listeIntervalle = {};
        String[] colSomme = null;

        PageRecherche pr = new PageRecherche(tpf, request, listeCritere, listeIntervalle, 3, libEntete, libEntete.length);

        pr.setTitre("Liste des types d'accident");
        pr.setUtilisateur(u);
        pr.setLien(lien);

        pr.getFormu().getChamp("val").setLibelle("Valeur");
        pr.getFormu().getChamp("desce").setLibelle("D&eacute;scription");

        pr.setApres(apres);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getFormu().setAnotherButton(
                "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/sanction/configuration/typeaccident-saisie.jsp&currentMenu=ELM0006587\">\n" +
                        "                    <i class=\"material-symbols-rounded\">add</i> Saisir un type d'accident" +
                        "                </a>"
        );
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= apres %>" method="post" name="listeaccident" id="listeaccident">
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
            String libEnteteAffiche[] =  { "ID","Valeur","D&eacute;scription"};
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
