<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formation.action.ActionFormation" %>
<%@ page import="paie.formation.action.ActionFormationDetail" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="paie.formation.plan.PlanFormationAnnuel" %>
<%@ page import="caisse.Devise" %>
<%@ page import="utils.ConstanteAxelle" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.formation.action.ActionFormation";
    String classeFille = "paie.formation.action.ActionFormationDetail";
    String nomTableFille = "ACTION_FORMATION_DETAIL";
    String colonneMere = "idactionformation";
    String apres = "paie/formation/action/actionformation-fiche.jsp";

    ActionFormation mere = new ActionFormation();
    mere.setNomTable("ACTION_FORMATION");
    ActionFormationDetail fille = new ActionFormationDetail();
    fille.setNomTable("ACTION_FORMATION_DETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une action formation");

    String idplanformation = request.getParameter("idplanformation");
    ActionFormation actionforme=null;
    if(idplanformation!=null && !idplanformation.equals("")){
        PlanFormationAnnuel planF = new PlanFormationAnnuel();
        planF.setId(idplanformation);
        actionforme = planF.genererActionFormation(null);
    }

    Liste[] liste = new Liste[4];
    String[] valeurs = {"0","1"};
    String[] affiches = {"INTERNE","EXTERNE"};
    liste[0] = new Liste("typeprestataire" ,affiches,valeurs);
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("semestre");
    liste[1] = new Liste("idsemestre",liste1,"val","id");
    TypeObjet liste2 = new TypeObjet();
    liste2.setNomTable("TYPE_FORMATION");
    liste[2] = new Liste("idtypeformation",liste2,"val","id");
    TypeObjet liste3 = new TypeObjet();
    liste3.setNomTable("CATEGORIE_FORMATION");
    liste[3] = new Liste("idcategorieformation",liste3,"val","id");
//    Liste estRealisee=new Liste("estrealisee");
//    estRealisee.makeListeOuiNon();
//    liste[4] = estRealisee;
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idplanformation").setLibelle("Plan de formation");
    pi.getFormu().getChamp("idtypeformation").setLibelle("Type de formation");
    pi.getFormu().getChamp("idcategorieformation").setLibelle("Cat&eacute;gorie de formation");
    pi.getFormu().getChamp("formateur").setLibelle("Formateur");
    pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pi.getFormu().getChamp("intitule").setLibelle("Intitul&eacute;");
    pi.getFormu().getChamp("typeprestataire").setLibelle("Type de prestataire");
    pi.getFormu().getChamp("idsemestre").setLibelle("semestre");
    pi.getFormu().getChamp("nbsessionprevus").setLibelle("Nombre de sessions pr&eacute;vues");
    pi.getFormu().getChamp("dureestagiaireheure").setLibelle("Dur&eacute;e en heure des stagiaires");
    pi.getFormu().getChamp("nbouvriersprevue").setLibelle("Nombre d'ouvriers pr&eacute;vus");
    pi.getFormu().getChamp("nbcadreprevue").setLibelle("Nombre de cadres pr&eacute;vus");
    pi.getFormu().getChamp("estrealisee").setLibelle("Est r&eacute;lis&eacute;");
    pi.getFormu().getChamp("objectif").setLibelle("Objectif");
    pi.getFormu().getChamp("objectif").setType("textarea");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("estrealisee").setVisible(false);
    pi.getFormu().getChamp("idplanformation").setPageAppelComplete("paie.formation.plan.PlanFormationAnnuel","id","PLAN_FORMATION_ANNUEL","id","id");
    // pi.getFormu().getChamp("idtypeformation").setPageAppelComplete("paie.formation.TypeFormation","id","TYPE_FORMATION","id","id");
    //pi.getFormu().getChamp("idcategorieformation").setPageAppelComplete("paie.formation.configuration.CategorieFormation","id","CATEGORIE_FORMATION","id","id");
    pi.getFormu().getChamp("formateur").setPageAppelComplete("paie.formateur.Formateur","id","V_FORMATEUR_FF","id","id");

    String[] ordre = {"idplanformation","idtypeformation","idcategorieformation","formateur","reference","intitule","typeprestataire","idsemestre","nbsessionprevus","dureestagiaireheure","nbouvriersprevue","nbcadreprevue","objectif"};
    pi.getFormu().setOrdre(ordre);
    if (actionforme != null)
    {
        pi.getFormu().setDefaut(actionforme);
        pi.getFormu().getChamp("idplanformation").setAutre("readonly");
    }


    Liste[] listeF = new Liste[1];
    TypeObjet typrCout = new TypeObjet();
    typrCout.setNomTable("TYPE_COUT_FORMATION");
//    listeF[0] = new Liste("idtypecout", typrCout, "val", "id");
    listeF[0] = new Liste("iddevise", new Devise(), "val", "id");
    pi.getFormufle().changerEnChamp(listeF);
    pi.getFormufle().getChamp("idtypecout_0").setLibelle("Co&ucirc;t de formation");
    pi.getFormufle().getChamp("cout_0").setLibelle("Co&ucirc;t");
    pi.getFormufle().getChamp("iddevise_0").setLibelle("devise");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idactionformation").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
    Champ.setDefaut(pi.getFormufle().getChampMulitple("iddevise").getListeChamp(), ConstanteAxelle.idDeviseAr);
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idtypecout"),"paie.formation.action.TypeCoutFormation","id","TYPE_COUT_FORMATION","","");


    String[] colOrdre = {"id","idtypecout","cout","iddevise"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une action formation");
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

