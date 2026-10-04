<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.Champ" %>
<%@ page import="faturefournisseur.PlanCommande" %>
<%@ page import="faturefournisseur.DmdAchat" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="faturefournisseur.DmdAchatFille" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "faturefournisseur.DmdAchat";
    String classeFille = "faturefournisseur.PlanCommande";
    String nomTableFille = "PLANCOMMANDE";
    String colonneMere = "iddmdachat";

    String idDmdAchat = request.getParameter("iddmdachat");

    DmdAchat dmdAchat = new DmdAchat();
    dmdAchat.setId(idDmdAchat);
    DmdAchatFille[] dfs = dmdAchat.getDmdAchatFille();

    String apres = "facturefournisseur/dmdachat/dmdachat-fiche.jsp&id=" + idDmdAchat + "&tab=inc/plancommande-details";

    PlanCommande mere = new PlanCommande();
    mere.setNomTable("PLANCOMMANDE");
    PlanCommande fille = new PlanCommande();
    fille.setNomTable("PLANCOMMANDE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie Plan de Commande");


    pi.getFormufle().getChamp("iddmdachat_0").setLibelle("Demande d'achat");
    pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
    pi.getFormufle().getChamp("designation_0").setLibelle("Designation");
    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date de Commande");

    pi.setDefautFille(dfs);

    Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);

    Champ.setVisible(pi.getFormufle().getChampMulitple("iddmdachat").getListeChamp(),false);
    Champ.setDefaut(pi.getFormufle().getChampMulitple("iddmdachat").getListeChamp(), idDmdAchat);

    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","id;libelle;pu","idproduit;designation;pu");


    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification Plan de Commande");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insertFille">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTableFille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        <input name="idMere" type="hidden" id="idMere" value="<%= idDmdAchat %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= taille %>">
    </form>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

