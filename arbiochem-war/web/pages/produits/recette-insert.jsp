<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="produits.RecetteMere" %>
<%@ page import="produits.RecetteFilleLib" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "produits.RecetteMere";
    String classeFille = "produits.RecetteFille";
    String nomTableFille = "RECETTE_FILLE";
    String colonneMere = "idMere";

    RecetteMere mere = new RecetteMere();
    mere.setNomTable("RECETTE_MERE");
    RecetteFilleLib fille = new RecetteFilleLib();
    fille.setNomTable("RECETTE_FILLE_LIB");
    int taille = 3;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("insert");


    pi.getFormu().getChamp("idProduit").setLibelle("Produit");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("nomRecette").setLibelle("Nom de la recette");
    pi.getFormu().getChamp("version").setLibelle("Version");
    pi.getFormu().getChamp("idProduit").setDefaut(request.getParameter("id"));
    pi.getFormu().getChamp("idProduit").setAutre("readonly");

    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idIngredient"),"produits.IngredientVente","id","as_ingredients_lib","idUnite;unite","idUnite;idUniteLib");

    pi.getFormufle().getChamp("idIngredient_0").setLibelle("Ingr&eacute;dient");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("idUnite_0").setLibelle("Id Unit&eacute;");
    pi.getFormufle().getChamp("idUniteLib_0").setLibelle("Unit&eacute;");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idIngredientLib").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("idMere").getListeChamp(),false);

    String[] colOrdre = {"idIngredient","qte","idUnite","idUniteLib"};
    pi.getFormufle().setColOrdre(colOrdre);


    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-fiche.jsp&id=<%=request.getParameter("id")%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

