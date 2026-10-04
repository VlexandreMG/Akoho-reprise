<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="previsionFerme.PrevisionFermeLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>

<% try{ 
    PrevisionFermeLib o = new PrevisionFermeLib();
    String[] listeCrt = {"daty","idProduitLib","designation","idProduit","idMagasin"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","idProduit","idProduitLib","daty","designation","idMagasinLib","pu","entree","entreeEffective","ecartEntree"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setNpp(50);
    pr.setUtilisateur((user.UserEJB) session.getAttribute("u"));
    pr.setLien((String) session.getAttribute("lien"));
    pr.setApres("previsionFerme/previsionFermeEntree-liste.jsp");
    pr.setAWhere(" AND entree > 0");

    Liste[] liste = new Liste[1];
    Magasin magasin = new Magasin();
    magasin.setNomTable("magasin2");
    liste[0] = new Liste("idMagasin", magasin, "val", "id" ," and actif = 1");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idProduit").setLibelle("Id Produit");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");

    pr.creerObjetPage(libEntete, null);

    String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-arbiochem-fiche.jsp",pr.getLien() + "?but=previsionFerme/previsionFerme-fiche.jsp"};
    String[] colonneLien = {"idProduit","id"};
    String[] attributLien = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Id Produit","Produit","Date","D&eacute;signation","Magasin","Prix unitaire","Pr&eacute;vision","Effectif","&Eacute;cart"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=previsionFerme/previsionFermeEntree-saisie.jsp\">\n" +
        " <i class=\"material-symbols-rounded\">add</i>Saisie des entr&eacute;es pr&eacute;visionnelles</a>");
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

