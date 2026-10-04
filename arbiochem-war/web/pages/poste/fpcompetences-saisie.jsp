<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="poste.FicheCompetenceFP" %>
<%@ page import="affichage.Liste"%>
<%@ page import="poste.TypeCompetencesFP" %>
<%@ page import="affichage.Champ" %>
<% try{ 
    String idficheposte = request.getParameter("idficheposte");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "poste.FicheCompetenceFP";
    String nomTable = "FICHE_POSTE_COMPETENCES";
    String apres = "poste/ficheposte-fiche.jsp&id"+"="+idficheposte;
     int taille = 10;
    FicheCompetenceFP o = new FicheCompetenceFP();
    o.setNomTable("FICHE_POSTE_COMPETENCES_VIDE");
    PageInsertMultiple pi = new PageInsertMultiple(o, o, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une fiche poste competence ");

    Liste[] liste = new Liste[2];
    TypeCompetencesFP liste0 = new TypeCompetencesFP();
    liste0.setNomTable("TYPE_COMPETENCES_FP");
    liste[0] = new Liste("idtypecompetencesfp",liste0,"val","id");
    String[] valeurs = {"1","2","3","4"};
    String[] affiches = {"1","2","3","4"};
    liste[1] = new Liste("niveau" ,affiches,valeurs);
    pi.getFormufle().changerEnChamp(liste);
    for(int i=0;i<taille;i++){
               pi.getFormufle().getChamp("description_"+i).setType("textarea");
    }
    pi.getFormu().getChamp("idficheposte").setVisible(false);
    pi.getFormu().getChamp("idtypecompetencesfp").setVisible(false);
    pi.getFormu().getChamp("description").setVisible(false);
    pi.getFormu().getChamp("niveau").setVisible(false);
    pi.getFormufle().getChamp("idficheposte_0").setLibelle("Fiche Poste");
    pi.getFormufle().getChamp("idtypecompetencesfp_0").setLibelle("Type des Comp&eacute;tences");
    pi.getFormufle().getChamp("description_0").setLibelle("Description");

    pi.getFormufle().getChamp("niveau_0").setLibelle("Niveau");
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idficheposte"), "poste.FichePoste","id","FICHE_POSTE","id","id");
    String[] ordre = {"idficheposte","idtypecompetencesfp","description","niveau"};
    if(idficheposte != null){
        Champ.setDefaut(pi.getFormufle().getChampFille("idficheposte"),idficheposte);
        Champ.setVisible(pi.getFormufle().getChampFille("idficheposte"),false);
        ordre = new String[]{"idtypecompetencesfp", "description", "niveau"};
    }

//    Champ.setVisible(pi.getFormufle().getChampFille("niveau"),false);

    pi.getFormufle().setColOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une fiche poste competence ");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=poste/apresMultipleObjectif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());
          //  out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
          <input name="classefille" type="hidden" id="classefille" value="<%=mapping%>">
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

