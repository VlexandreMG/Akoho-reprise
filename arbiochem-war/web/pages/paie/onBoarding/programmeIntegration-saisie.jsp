<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.onBoarding.ProgrammeIntegration" %>
<%@ page import="paie.onBoarding.ProgrammeIntegrationDetail" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.onBoarding.ProgrammeIntegration";
    String classeFille = "paie.onBoarding.ProgrammeIntegrationDetail";
    String nomTableFille = "PROGRAMME_INTEGRATION_DETAIL";
    String colonneMere = "idProgrameDetail";
    String apres = "paie/onBoarding/programmeIntegration-fiche.jsp";

    ProgrammeIntegration mere = new ProgrammeIntegration();
    mere.setNomTable("PROGRAMME_INTEGRATION");
    ProgrammeIntegrationDetail fille = new ProgrammeIntegrationDetail();
    fille.setNomTable("PROGRAMME_INTEGRATION_DETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une programme d'integration");


    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");

    Liste[] listeFille = new Liste[1];
    String[] aff0 = {"Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"};
    String[] val0 = {"1","2","3","4","5","6","7"};
    listeFille[0] = new Liste("jourdelasemaine",aff0, val0);
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idintervenant_0").setLibelle("Intervenant");
    pi.getFormufle().getChamp("jourdelasemaine_0").setLibelle("Jour de la semaine");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure");
    pi.getFormufle().getChamp("duree_0").setLibelle("Dur&eacute;e");
    pi.getFormufle().getChamp("actiontheme_0").setLibelle("Th&egrave;me d'action");
    pi.getFormufle().getChamp("contenue_0").setLibelle("Contenu");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idprogramedetail").getListeChamp(),false);
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idintervenant"),"paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");
    for(int i=0;i<taille;i++){
         pi.getFormufle().getChamp("heure_"+i).setType("time");
        pi.getFormufle().getChamp("actiontheme_"+i).setType("textarea");
        pi.getFormufle().getChamp("contenue_"+i).setType("textarea");
    }
    String[] colOrdre = {"idintervenant","jourdelasemaine","heure","duree","actiontheme","contenue"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une programme d'integration");
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

