<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="fabrication.ResultatFabrication" %>

<% try{ 
    ResultatFabrication o = new ResultatFabrication();
    o.setNomTable("RESULTATFABRICATION");
    String[] listeCrt = {"idOffille","idFabrication","idProduit","idProduitLib","idIngredients","idLigne","daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"idOffille","idFabrication","daty","idProduit","idProduitLib","qte","idIngredients","qteIngredients","idLigne","entreeDechet"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("");
    pr.setUtilisateur((user.UserEJB) session.getAttribute("u"));
    String lien = (String) session.getAttribute("lien");
    pr.setLien(lien);
    pr.setApres("fabrication/resultat-fabrication.jsp");
    pr.getFormu().getChamp("idFabrication").setLibelle("Id Fabrication");
    pr.getFormu().getChamp("idProduit").setLibelle("Id Produit");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idIngredients").setLibelle("Id Ingr&eacute;dients");
    pr.getFormu().getChamp("idOffille").setLibelle("D&eacute;tail OF");
    pr.getFormu().getChamp("idLigne").setLibelle("Id Ligne");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");

    String[] colSomme = {"qte"};
    pr.creerObjetPage(libEntete, colSomme);
    String[] enteteRecap = {"","Nombre","Somme des quantit&eacute;s"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {lien + "?but=fabrication/ordre-fabrication-details-fiche.jsp",lien + "?but=fabrication/fabrication-fiche.jsp", lien + "?but=produits/as-ingredients-fiche.jsp",lien + "?but=produits/as-ingredients-fiche.jsp"};
    String[] colonneLien = {"idOffille","idFabrication","idProduit", "idingredients"};
    String[] attributLien = {"id","id", "id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"D&eacute;tail OF","Id Fabrication","Date","Id Produit","Produit","Quantit&eacute;","Id Ingr&eacute;dients","Quantit&eacute; ingr&eacute;dients","Ligne","Entr&eacute;e D&eacute;chets"};
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

