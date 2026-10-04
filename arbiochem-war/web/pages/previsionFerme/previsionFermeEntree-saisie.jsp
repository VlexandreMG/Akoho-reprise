<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="previsionFerme.PrevisionFerme" %>
<%@ page import="affichage.Champ" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getAttribute("u");
    String classeFille = "previsionFerme.PrevisionFerme";
    String apres = "previsionFerme/previsionFermeEntree-liste.jsp";

    PrevisionFerme fille = new PrevisionFerme();
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(fille, fille, request, taille, u);
    pi.setLien((String) session.getAttribute("lien"));

    Liste[] liste = new Liste[1];
    Magasin magasin = new Magasin();
    magasin.setNomTable("magasin2");
    liste[0] = new Liste("idMagasin", magasin, "val", "id" ," and actif = 1");
    pi.getFormufle().changerEnChamp(liste);
    pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
    pi.getFormufle().getChamp("idMagasin_0").setLibelle("Magasin");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
    pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
    pi.getFormufle().getChamp("entree_0").setLibelle("Entr&eacute;e");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date");
    pi.getFormufle().getChamp("idTiers_0").setLibelle("Tiers");
    Champ.setDefaut(pi.getFormufle().getChampFille("designation"),"Prévision du "+utilitaire.Utilitaire.dateDuJour());
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idTiers"),"pertegain.Tiers","id","tiers");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTO","pu","pu");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idMvtStockFille").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("sortie").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("etat").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("idOrigine").getListeChamp(),false);

    String[] colOrdre = {"daty","idProduit","designation","entree","pu","idMagasin","idTiers"};
    pi.getFormufle().setColOrdre(colOrdre);

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=previsionFerme/apresPrevisionFerme.jsp" method="post" >
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classeFille" type="hidden" id="classeFille" value="<%=classeFille%>">
        <input name="classe" type="hidden" id="classe" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

