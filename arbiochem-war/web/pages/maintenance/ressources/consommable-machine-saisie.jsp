<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="maintenance.ressources.ConsommableMachine" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="maintenance.ressources.ConsommableMachineLib" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "maintenance.ressources.ConsommableMachine";
    String nomTable = "CONSOMMABLEMACHINE";
    String apres = "maintenance/ressources/consommable-machine-fiche.jsp";

    ConsommableMachineLib o = new ConsommableMachineLib();
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d’un Consommable Machine");

    Liste[] liste = new Liste[2];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("TYPEMAINTENANCE");
    liste[0] = new Liste("idTypeMaintenance",liste0,"val","id");
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("UNITEMAINTENANCE");
    liste[1] = new Liste("frequence",liste1,"val","id");
    pi.getFormu().changerEnChamp(liste);

    String idMachine = request.getParameter("idMachine");
    if (idMachine != null) {
        pi.getFormu().getChamp("idMachine").setAutre("readonly");
        pi.getFormu().getChamp("idMachine").setDefaut(idMachine);
    }

    pi.getFormu().getChamp("idMachine").setLibelle("Machine");
    pi.getFormu().getChamp("idConsommable").setLibelle("Consommable");
    pi.getFormu().getChamp("idTypeMaintenance").setLibelle("Type de maintenance");
    pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("idUniteLib").setLibelle("Unit&eacute;");
    pi.getFormu().getChamp("idUniteLib").setAutre("readonly");
    pi.getFormu().getChamp("idUnite").setVisible(false);
    pi.getFormu().getChamp("idTypeMaintenanceLib").setVisible(false);
    pi.getFormu().getChamp("idMachineLib").setVisible(false);
    pi.getFormu().getChamp("idConsommableLib").setVisible(false);
    pi.getFormu().getChamp("frequenceLib").setVisible(false);

    pi.getFormu().getChamp("frequence").setLibelle("Fr&eacute;quence");
    pi.getFormu().getChamp("idMachine").setPageAppelComplete("maintenance.ressources.IngredientMaintenance","id","AS_INGREDIENT_MAINTENANCE","","");
    pi.getFormu().getChamp("idConsommable").setPageAppelComplete("produits.IngredientsLib","id","AS_INGREDIENTS_LIB2","unite;unitelib","idUnite;idUniteLib");
 
    String[] ordre = {"idMachine","idConsommable","idTypeMaintenance","qte","idUnite","idUniteLib","frequence"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d’un Consommable Machine");
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

