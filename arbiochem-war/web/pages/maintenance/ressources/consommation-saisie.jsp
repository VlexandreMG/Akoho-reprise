<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="maintenance.ressources.Consommation" %>
<%@ page import="maintenance.ressources.ConsommationDetails" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="produits.Ingredients" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "maintenance.ressources.Consommation";
    String classeFille = "maintenance.ressources.ConsommationDetails";
    String nomTableFille = "CONSOMMATIONDETAILS";
    String colonneMere = "idMere";
    String apres = "maintenance/ressources/consommation-fiche.jsp";

    Consommation mere = new Consommation();
    mere.setNomTable("CONSOMMATION");
    ConsommationDetails fille = new ConsommationDetails();
    fille.setNomTable("CONSOMMATIONDETAILS");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une consommation");

    Liste[] liste = new Liste[1];
    liste[0] = new Liste("idTypeMaintenance",new TypeObjet("TYPEMAINTENANCE"),"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idTypeMaintenance").setLibelle("Type de Maintenance");

    pi.getFormu().getChamp("idMachine").setLibelle("Machine");
    pi.getFormu().getChamp("idMachine").setPageAppelComplete("maintenance.ressources.IngredientMaintenance","id","AS_INGREDIENT_MAINTENANCE");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("etat").setVisible(false);

    pi.getFormufle().getChamp("idIngredients_0").setLibelle("Ingr&eacute;dients");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("idUnite_0").setLibelle("Unit&eacute;");
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idIngredients"),"produits.Ingredients","id","AS_INGREDIENTS","unite","idUnite");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idMere").getListeChamp(),false);
    Champ.setAutre(pi.getFormufle().getChampMulitple("idUnite").getListeChamp(),"readonly");

    String[] colOrdre = {"idIngredients","qte","idUnite"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modificaiton de la consommation");
    }

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
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
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

