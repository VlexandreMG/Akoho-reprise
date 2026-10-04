<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.accident.ArretTravail" %>

<% try{
    ArretTravail o = new ArretTravail();
    o.setNomTable("ARRET_TRAVAIL");
    String[] listeCrt = {"id", "id_Accident","date_Debut_Arret","date_Fin_Arret","nombre_Jour"};
    String[] listeInt = {"date_Debut_Arret","date_Fin_Arret","nombre_Jour"};
    String[] libEntete = {"id","id_Accident","daty","date_Debut_Arret","date_Fin_Arret","nombre_Jour"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/accident/arretTravail-liste.jsp");
    pr.getFormu().getChamp("id_Accident").setLibelle("Id accident");
    pr.getFormu().getChamp("date_Debut_Arret1").setLibelle("Date de d&eacute;but d'arr&ecirc;t min");
    pr.getFormu().getChamp("date_Debut_Arret2").setLibelle("Date de d&eacute;but d'arr&ecirc;t max");
    pr.getFormu().getChamp("date_Fin_Arret1").setLibelle("Date de fin d'arr&ecirc;t min");
    pr.getFormu().getChamp("date_Fin_Arret2").setLibelle("Date de fin d'arr&ecirc;t max");
    pr.getFormu().getChamp("nombre_Jour1").setLibelle("Nombre de jours min");
    pr.getFormu().getChamp("nombre_Jour2").setLibelle("Nombre de jours max");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=paie/accident/arret-travail-fiche.jsp",pr.getLien() + "?but=paie/accident/accident-fiche.jsp"};
    String[] colonneLien = {"id","id_Accident"};
    String[] attributLien = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Id Accident","Date","Date de D&eacute;but Arr&ecirc;t","Date de Fin d'Arr&ecirc;t","Nombre de jours"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

