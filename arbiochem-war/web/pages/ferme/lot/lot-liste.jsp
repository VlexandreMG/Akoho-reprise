<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.lot.LotLib" %>

<% try{ 
    LotLib o = new LotLib();
    o.setNomTable("LOT_LIB");
    String[] listeCrt = {"id","idOrigineLib","idProgrammeLib","nomlot","reference","dateeclosion","datearrivee","idSoucheLib"};
    String[] listeInt = {"dateeclosion","datearrivee"};
    String[] libEntete = {"id","nomlot","reference","source","idFermeLib","idArticleLib","idCategorielotLib","idSoucheLib","idOrigineLib","idProgrammeLib","dateeclosion","datearrivee","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des lots");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/lot/lot-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idOrigineLib").setLibelle("Id Origine");
    pr.getFormu().getChamp("idProgrammeLib").setLibelle("Id Programme");
    pr.getFormu().getChamp("nomlot").setLibelle("Nom du lot");
    pr.getFormu().getChamp("idSoucheLib").setLibelle("Souche");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("dateeclosion1").setLibelle("Date d'&eacute;closion min");
    pr.getFormu().getChamp("dateeclosion2").setLibelle("Date d'&eacute;closion max");
    pr.getFormu().getChamp("datearrivee1").setLibelle("Date d'arriv&eacute;e min");
    pr.getFormu().getChamp("datearrivee2").setLibelle("Date d'arriv&eacute;e max");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=ferme/lot/lot-fiche.jsp", pr.getLien() + "?but=stock/mvtstock-fiche.jsp"};
    String[] colonneLien = {"id","source"};
    String[] attributLien = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Nom du lot","R&eacute;f&eacute;rence","Source","Ferme","Article","Cat&eacute;gorie du lot","Souche","Origine","Programme","Date d'&eacute;closion","Date d'arriv&eacute;e","&Eacute;tat"};
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
