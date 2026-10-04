<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.production.FumigationLib" %>

<% try{ 
    FumigationLib o = new FumigationLib();
    o.setNomTable("FUMIGATION_LIB");
    String[] listeCrt = {"daty","idNumeroVagueLib","idOperateurLib","idLotLib","idBatimentLib","idParquetLib","etatLib","idProduitLib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","idNumeroVagueLib","idLotLib","idBatimentLib","idParquetLib","daty","idOperateurLib","idProduitLib","nombreoac","qte","heuredebutfumigation","heurefinfumigation","heuredebutextraction","heurefinextraction","temperaturemin","temperaturemax","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des fumigation");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/production/fumigation-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idNumeroVagueLib").setLibelle("Num&eacute;ro de vague");
    pr.getFormu().getChamp("idOperateurLib").setLibelle("Op&eacute;rateur");
    pr.getFormu().getChamp("idLotLib").setLibelle("Lot");
    pr.getFormu().getChamp("idBatimentLib").setLibelle("B&acirc;timent");
    pr.getFormu().getChamp("idParquetLib").setLibelle("Parquet");
    pr.getFormu().getChamp("etatLib").setLibelle("&Eacute;tat");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    
    String[] colSomme = {"nombreoac"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme des nombres d’&oelig;ufs OAC fumiger"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=ferme/production/fumigation-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Num&eacute;ro de vague","Lot","B&acirc;timent","Parquet","Date","Op&eacute;rateur","Produit","Nombre OAC","Quantit&eacute;","Heure d&eacute;but fumigation","Heure fin fumigation","Heure d&eacute;but extraction","Heure fin extraction","Temp&eacute;rature minimale","Temp&eacute;rature maximale","&Eacute;tat"};
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

