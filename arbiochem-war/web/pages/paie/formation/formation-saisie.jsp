<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formation.FormationPlan" %>
<%@ page import="paie.formation.Formation" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="rapport.Utilitaire" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.formation.FormationPlan";
    String classeFille = "paie.formation.Formation";
    String nomTableFille = "FORMATION";
    String colonneMere = "idPlan";
    String apres = "paie/formation/formation-fiche.jsp";

    FormationPlan mere = new FormationPlan();
    mere.setNomTable("FORMATION_PLAN");
    Formation fille = new Formation();
    fille.setNomTable("FORMATION");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une formation");


    pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pi.getFormu().getChamp("annee").setDefaut(utilitaire.Utilitaire.getAnneeEnCours());
    pi.getFormu().getChamp("description").setLibelle("Description");
    pi.getFormu().getChamp("description").setType("textarea");
    pi.getFormu().getChamp("etat").setLibelle("&Eacute;tat");
    pi.getFormu().getChamp("etat").setVisible(false);

    Liste[] liste = new Liste[1];
    TypeObjet type = new TypeObjet();
    type.setNomTable("formation_Type");
    liste[0] = new Liste("type", type, "id", "val");
    pi.getFormufle().changerEnChamp(liste);

    pi.getFormufle().getChamp("titre_0").setLibelle("Titre");
    pi.getFormufle().getChamp("description_0").setLibelle("Description");
    pi.getFormufle().getChamp("datedebut_0").setLibelle("Date de d&eacute;but");
    pi.getFormufle().getChamp("datefin_0").setLibelle("Date de fin");
    pi.getFormufle().getChamp("type_0").setLibelle("Type");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idplan").getListeChamp(),false);
    for (int i = 0; i < taille; i++) {
        pi.getFormufle().getChamp("titre_"+i).setType("textarea");
        pi.getFormufle().getChamp("description_" + i).setType("textarea");
    }

    String[] colOrdre = {"titre","description", "type", "datedebut","datefin"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une formation");
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

