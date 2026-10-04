<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.evaluation.EvaluationAChaud" %>
<%@ page import="paie.evaluation.EvaluationAChaudFille" %>
<%@ page import="paie.evaluation.CritereEvalAChaud" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="affichage.Champ" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="poste.TypeCompetencesFP" %>
<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.evaluation.EvaluationAChaud";
    String classeFille = "paie.evaluation.EvaluationAChaudFille";
    String nomTableFille = "EVALUATION_A_CHAUD_FILLE";
    String colonneMere = "idEvaluationChaud";
    String apres = "paie/evaluation/evaluationchaud-fiche.jsp";

    EvaluationAChaud mere = new EvaluationAChaud();
    EvaluationAChaudFille fille = new EvaluationAChaudFille();
    EvaluationAChaudFille[] evaluationAChaudFilles = fille.getEvaluationCritere();
    int taille = 10;
    if (evaluationAChaudFilles != null) {
        taille = evaluationAChaudFilles.length;
    }
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'un &eacute;valuation &agrave; chaud");

    if (evaluationAChaudFilles != null) {
        for (int i = 0; i < evaluationAChaudFilles.length; i++) {
            pi.getFormufle().getChamp("idEvaluationCritere_" + i).setDefaut(evaluationAChaudFilles[i].getIdEvaluationCritere());
        }
    }

    pi.getFormu().getChamp("idFormationSuivie").setLibelle("Formation");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("dateFormation").setLibelle("Date de formation");
    pi.getFormu().getChamp("idPersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("idintervenant").setLibelle("Intervenant");
    pi.getFormu().getChamp("idFormationSuivie").setPageAppelComplete("paie.formation.action.ActionFormation","id","action_formation","id","id");
    pi.getFormu().getChamp("idPersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");
    pi.getFormu().getChamp("idintervenant").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");

    Champ.setVisible(pi.getFormufle().getChampMulitple("idEvaluationChaud").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);

    Liste[] listes = new Liste[2];
    listes[0] = new Liste("idEvaluationCritere", new CritereEvalAChaud(), "val", "id");
    String[] aff1f = {"1","2","3","4"};
    String[] val1f = {"1","2","3","4"};
    listes[1] = new Liste("note",aff1f, val1f);
    pi.getFormufle().changerEnChamp(listes);

    pi.getFormufle().getChamp("idEvaluationCritere_0").setLibelle("Crit&egrave;re");
    pi.getFormufle().getChamp("note_0").setLibelle("Note");
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un &eacute;valuation &agrave; chaud");
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

