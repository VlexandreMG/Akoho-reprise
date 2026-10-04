<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.pesee.PeseePoussinLib" %>

<% try{ 
    PeseePoussinLib o = new PeseePoussinLib();
    o.setNomTable("PESEEPOUSSIN_LIB");
    String[] listeCrt = {"datepesee","idtypepeseelib","idresponsablelib","idfermelib","idbatimentlib","idlotlib","idparquetlib"};
    String[] listeInt = {"datepesee"};
    String[] libEntete = {"id","datepesee","idtypepeseelib","idresponsablelib","idfermelib","idbatimentlib","idlotlib","idparquetlib","agejour","nombreoiseauxpeses","poidsmoyen","coefficientvariation","uniformite","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des pesees poussin");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/pesee/peseepoussin-liste.jsp");
    pr.getFormu().getChamp("datepesee1").setLibelle("Date de pes&eacute;e min");
    pr.getFormu().getChamp("datepesee2").setLibelle("Date de pes&eacute;e max");
    pr.getFormu().getChamp("idtypepeseelib").setLibelle("Type de pes&eacute;e");
    pr.getFormu().getChamp("idresponsablelib").setLibelle("Responsable");
    pr.getFormu().getChamp("idfermelib").setLibelle("Ferme");
    pr.getFormu().getChamp("idbatimentlib").setLibelle("B&acirc;timent");
    pr.getFormu().getChamp("idlotlib").setLibelle("Lot");
    pr.getFormu().getChamp("idparquetlib").setLibelle("Parquet");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=ferme/pesee/peseepoussin-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Date de pes&eacute;e","Type de pes&eacute;e","Responsable","Ferme","B&acirc;timent","Lot","Parquet","&Acirc;ge (jours)","Nombre d’oiseaux pes&eacute;s","Poids moyen","Coefficient de variation","Uniformit&eacute;","&Eacute;tat"};
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

