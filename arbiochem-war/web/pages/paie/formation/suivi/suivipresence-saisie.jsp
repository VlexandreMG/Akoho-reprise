<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formation.suivi.SuiviPresenceMere" %>
<%@ page import="paie.formation.suivi.SuiviPresenceFille" %>
<%@ page import="paie.formation.suivi.SuiviPresenceFilleLib" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.formation.ParticipationFormation" %>
<%@ page import="paie.formation.session.SessionFormation" %>
<%@ page import="paie.formation.action.ActionFormation" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.formation.suivi.SuiviPresenceMere";
    String classeFille = "paie.formation.suivi.SuiviPresenceFille";
    String nomTableFille = "SUIVI_PRESENCE_FILLE";
    String colonneMere = "idsuivipresencemere";
    String apres = "paie/formation/suivi/suivipresence-fiche.jsp";

    SuiviPresenceMere mere = new SuiviPresenceMere();
    mere.setNomTable("SUIVI_PRESENCE_MERE");
    SuiviPresenceFilleLib fille = new SuiviPresenceFilleLib();
    fille.setNomTable("SUIVI_PRESENCE_FILLE_LIB");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une suivie de formation");

    if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")) {
//        String idsessionformation = request.getParameter("idsessionformationlibelle");
//        if (idsessionformation != null && idsessionformation.contains(" - ")) {
//            idsessionformation = idsessionformation.split(" - ")[0];
//        }

        String idsessionformation = request.getParameter("idsessionformation");
        
        SessionFormation sessionFormation = new SessionFormation();
        sessionFormation = sessionFormation.getSessionFormationById(idsessionformation);
        ActionFormation actionFormation = new ActionFormation();
        actionFormation = actionFormation.getActionFormationById(sessionFormation.getIdactionformation());
        ParticipationFormation participationFormation = new ParticipationFormation();
        ParticipationFormation[] participationFormations = participationFormation.getParticipationFormationByIdActionFormation(actionFormation.getId());
        taille = participationFormations.length;
        if (taille > 0) {
            pi = new PageInsertMultiple(mere, fille, request, taille, u);
            for (int i = 0; i < participationFormations.length; i++) {
                pi.getFormufle().getChamp("idparticipationformation_" + i).setDefaut(participationFormations[i].getId());
                pi.getFormufle().getChamp("idactionformation_" + i).setDefaut(participationFormations[i].getIdactionformation());
                pi.getFormufle().getChamp("idpersonnel_" + i).setDefaut(participationFormations[i].getIdpersonnel());
                pi.getFormufle().getChamp("actionFormationLib_" + i).setDefaut(actionFormation.getIntitule());
            }
        }
    }


    pi.getFormu().getChamp("idsessionformation").setLibelle("Session formation");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idsessionformation").setPageAppelComplete("paie.formation.session.SessionFormation","id","SESSION_FORMATION","id","id");
    pi.getFormu().getChamp("idsessionformation").setAutre("onchange=\"updateFille(event, 'formId')\"");

    Champ[] liste = new Liste[1];
    String[] aff = {"PRESENT", "ABSENT"};
    liste[0] = new Liste("presence", aff, aff);
    liste[0].setDefaut("PRESENT");
    pi.getFormufle().changerEnChamp(liste);

    pi.getFormufle().getChamp("idparticipationformation_0").setLibelle("Participation formation");
    pi.getFormufle().getChamp("idpersonnel_0").setLibelle("Personnel");
    pi.getFormufle().getChamp("idactionformation_0").setLibelle("Action formation");
    pi.getFormufle().getChamp("dateseance_0").setLibelle("Date de s&eacute;ance");
    pi.getFormufle().getChamp("presence_0").setLibelle("Pr&eacute;sence");
    pi.getFormufle().getChamp("nbheureeffectue_0").setLibelle("Nb heures effectu&eacute;es");
    pi.getFormufle().getChamp("actionFormationLib_0").setLibelle("Libell&eacute; Act. Formation");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idsuivipresencemere").getListeChamp(),false);
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idparticipationformation"),"paie.formation.ParticipationFormationLib","id","PARTICIPATION_FORMATION_LIB","id;matricule;idactionformation;idactionFormationLib","id;idpersonnel;idactionformation;actionFormationLib");
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idpersonnel"),"paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idactionformation"),"paie.formation.action.ActionFormation","id","ACTION_FORMATION","id","id");
    Champ.setAutre(pi.getFormufle().getChampFille("idpersonnel"), "readonly");
    Champ.setAutre(pi.getFormufle().getChampFille("idactionformation"), "readonly");

    String[] colOrdre = {"idparticipationformation","idpersonnel","idactionformation","actionFormationLib","dateseance","presence","nbheureeffectue"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une suivie de formation");
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
        %>
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        </div>
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

