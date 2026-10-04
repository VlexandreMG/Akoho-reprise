<%@page import="java.sql.Date"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="ferme.receptionaeroport.ReceptionPoussinAeroportLib"%>
<%@page import="affichage.PageRecherche"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    try {
        ReceptionPoussinAeroportLib base = new ReceptionPoussinAeroportLib();
        String listeCrt[] = {"idLotLib","daty"};
        String listeInt[] = {"daty"};
        String libEntete[] = {"id","idLotLib","daty","heureDepart","heureArrive","qteRecus","nbrcartonmale","nbrcartonfemelle","nbrcartontotal","etatlib"};
        PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.getFormu().getChamp("idLotLib").setLibelle("Lot");
        pr.getFormu().getChamp("daty1").setLibelle("date min");
        pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty2").setLibelle("date max");
        pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.setApres("ferme/receptionaeroport/receptionaeroport-liste.jsp");
        String[] colSomme = {"qteRecus"};
        String[] labelRecap = { "","Nombres","Somme des quantit&eacute;s re&ccedil;ues"};
            pr.creerObjetPage(libEntete, colSomme);
            pr.getTableau().setLienFille("ferme/receptionaeroport/inc/receptionaeroport-details.jsp&id=");
            pr.getTableauRecap().setLibeEntete(labelRecap);
        pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=ferme/receptionaeroport/receptionaeroport-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir une r&eacute;ception &agrave; l'a&eacute;roport</a>"
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
        <form action='<%=pr.getLien() + "?but=ferme/receptionaeroport/receptionaeroport-liste.jsp" %>' method="post" name="liste" id="liste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
               <%
            String lienTableau[] = {pr.getLien() + "?but=ferme/receptionaeroport/receptionaeroport-fiche.jsp"};
            String colonneLien[] = {"id"};
            String attLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            pr.getTableau().setAttLien(attLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br/>
        <%
            String libelleAffiche[] = {"ID","Lot","Date","Heure de d&eacute;part","Heure d'arriv&eacute;e","Quantit&eacute; re&ccedil;ue","Nombre de cartons m&acirc;les","Nombre de cartons femelles","Nombre de cartons total","&Eacute;tat"};
            pr.getTableau().setLibelleAffiche(libelleAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<% } catch (Exception e) {
        e.printStackTrace();
    }%>
