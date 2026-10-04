<%@page import="user.UserEJB"%>
<%@page import="bean.*"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.hs.HsMoisCpl" %>
<%
    try{
        HsMoisCpl hmc = new HsMoisCpl();
        hmc.setNomTable("HS_FABBRICATION_SEMAINECPL");
        String listeCrt[] = {"matricule", "nompersonnel","datedebutsemaine","datefinsemaine","semaine"};
        String listeInt[] = {"datedebutsemaine","datefinsemaine"};
        String libEntete[] = {"matricule", "nompersonnel", "MN", "HD", "JF", "IF", "HS","Semaine","datedebutsemaine","datefinsemaine"};
        String libEnteteAffiche[] = { "Matricule", "Personnel", "MN", "HD", "JF", "IF", "HS","Semaine","Date de d&eacute;but de semaine","Date de fin de semaine"};
        PageRecherche pr = new PageRecherche(hmc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setAWhere(" ORDER BY TO_NUMBER(REGEXP_SUBSTR(matricule, '^[0-9]+')) ASC");
        pr.setTitre("Liste heures par semaine");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("paie/hs/heure-par-semaine-liste.jsp");
        pr.getFormu().getChamp("nompersonnel").setLibelle("Personnel");
        pr.getFormu().getChamp("datedebutsemaine1").setLibelle("Date de d&eacute;but de semaine min");
        pr.getFormu().getChamp("datedebutsemaine2").setLibelle("Date de d&eacute;but de semaine max");

        pr.getFormu().getChamp("datefinsemaine1").setLibelle("Date de fin de semaine min");
        pr.getFormu().getChamp("datefinsemaine2").setLibelle("Date de fin de semaine max");

        String[] colSomme = {"MN","HD","JF","IF","HS"};
        pr.creerObjetPage(libEntete, colSomme);
//        String lienTableau[] = {pr.getLien() + "?but=paie/hs/hsmois-fiche.jsp"};
//        String colonneLien[] = {"id"};
//        pr.getTableau().setLien(lienTableau);
//        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
%>
<div class="content-wrapper">
    <div class="row">
        <section class="content-header">
            <h1><%= pr.getTitre() %></h1>
        </section>
    </div>

    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <form action="<%= pr.getLien() %>?but=<%= pr.getApres() %>" method="post" name="recap" id="recap">
                    <%= pr.getFormu().getHtmlEnsemble() %>
                </form>

                <%= pr.getTableauRecap().getHtml() %>
                <br>

                <%= pr.getTableau().getHtml() %>
                <%= pr.getBasPage() %>
            </div>
        </div>
    </section>
</div>

<script>
    function changerDesignation() {
        document.recap.submit();
    }
</script>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>