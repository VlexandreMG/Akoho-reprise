<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="maintenance.tempOuverture.TempsOuverture" %>
<%@ page import="affichage.Liste" %>
<%@ page import="annexe.Unite" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "maintenance.tempOuverture.TempsOuverture";
    String nomTable = "TEMPSOUVERTURE";
    String apres = "tempsOuverture/tempsOuverture-fiche.jsp";

    TempsOuverture o = new TempsOuverture();
    o.setNomTable("TEMPSOUVERTURE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un temps d'ouverture");


    pi.getFormu().getChamp("idMachine").setLibelle("Machine");
    pi.getFormu().getChamp("temps").setLibelle("Temps");
    pi.getFormu().getChamp("idMachine").setPageAppelComplete("maintenance.ressources.IngredientMaintenance","id","AS_INGREDIENT_MAINTENANCE","descriptionObjet","id");

    Liste[] liste = new Liste[1];
    Unite unite = new Unite();
    unite.setNomTable("AS_UNITE");
    liste[0] = new Liste("idUnite",unite,"val","id");

    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idUnite").setLibelle("Unit&eacute;");
    pi.getFormu().getChamp("capacite").setLibelle("Capacit&eacute;");

    String[] ordre = {"idMachine","temps"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un temps d'ouverture");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

