<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formation.action.ActionFormationBack" %>
<%@ page import="paie.formation.plan.PlanFormationAnnuel" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    String idplanformation = request.getParameter("idplanformation");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.formation.action.ActionFormation";
    String nomTable = "ACTION_FORMATION";
    String apres = "paie/formation/action/actionformation-fiche-back.jsp";
    ActionFormationBack actionforme=null;
    if(idplanformation!=null && !idplanformation.equals("")){
        PlanFormationAnnuel planF = new PlanFormationAnnuel();
        planF.setId(idplanformation);
        actionforme = planF.genererActionFormation(null);
    }
    ActionFormationBack o = new ActionFormationBack();
    o.setNomTable("ACTION_FORMATION");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un action formation");

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
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idplanformation").setLibelle("Plan formation");
    pi.getFormu().getChamp("idtypeformation").setLibelle("Type formation");
    pi.getFormu().getChamp("idcategorieformation").setLibelle("Cat&eacute;gorie formation");
    pi.getFormu().getChamp("formateur").setLibelle("Formateur");
    pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pi.getFormu().getChamp("intitule").setLibelle("Intitul&eacute;");
    pi.getFormu().getChamp("typeprestataire").setLibelle("Type prestataire");
    pi.getFormu().getChamp("idsemestre").setLibelle("semestre");
    pi.getFormu().getChamp("nbsessionprevus").setLibelle("Nombre de sessions pr&eacute;vues");
    pi.getFormu().getChamp("dureestagiaireheure").setLibelle("Dur&eacute;e stagiaire (heures)");
    pi.getFormu().getChamp("nbouvriersprevue").setLibelle("Nombre d'ouvriers pr&eacute;vus");
    pi.getFormu().getChamp("nbcadreprevue").setLibelle("Nombre de cadres pr&eacute;vus");
    pi.getFormu().getChamp("objectif").setLibelle("Objectif");
    pi.getFormu().getChamp("objectif").setType("textarea");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("estrealisee").setVisible(false);
    pi.getFormu().getChamp("idplanformation").setPageAppelComplete("paie.formation.plan.PlanFormationAnnuel","id","PLAN_FORMATION_ANNUEL","id","id");
   // pi.getFormu().getChamp("idtypeformation").setPageAppelComplete("paie.formation.TypeFormation","id","TYPE_FORMATION","id","id");
    //pi.getFormu().getChamp("idcategorieformation").setPageAppelComplete("paie.formation.configuration.CategorieFormation","id","CATEGORIE_FORMATION","id","id");
    pi.getFormu().getChamp("formateur").setPageAppelComplete("paie.formateur.Formateur","id","FORMATEUR","id","id");
    
    String[] ordre = {"idplanformation","idtypeformation","idcategorieformation","formateur","reference","intitule","typeprestataire","idsemestre","nbsessionprevus","dureestagiaireheure","nbouvriersprevue","nbcadreprevue","objectif"};
    pi.getFormu().setOrdre(ordre);
    if (actionforme != null)
    {
        pi.getFormu().setDefaut(actionforme);
        pi.getFormu().getChamp("idplanformation").setAutre("readonly");
    }
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un action formation");
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

