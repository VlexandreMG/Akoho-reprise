<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.cv.CVCompetence" %>
<%@ page import="paie.cv.CVCompetence" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    String idcv = request.getParameter("idcv");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.cv.CVCompetence";
    String classeFille = "paie.cv.CVCompetence";
    String nomTableFille = "CV_COMPETENCE";
    String colonneMere = "idcv";
    String apres = "paie/cv/competencecv-saisie.jsp&idcv"+"="+idcv;

    CVCompetence mere = new CVCompetence();
    mere.setNomTable("CV_COMPETENCE");
    CVCompetence fille = new CVCompetence();
    fille.setNomTable("CV_COMPETENCE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie des compétences CV");


    pi.getFormu().getChamp("idcv").setVisible(false);
    pi.getFormu().getChamp("competence").setVisible(false);
    pi.getFormu().getChamp("niveau").setVisible(false);


    pi.getFormufle().getChamp("competence_0").setLibelle("Competence");
    pi.getFormufle().getChamp("idtypecompetencesfp_0").setLibelle("Type Competence");
    pi.getFormufle().getChamp("niveau_0").setLibelle("Niveau");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idcv").getListeChamp(),false);
    if(idcv != null){
        CVCompetence cv = new CVCompetence();
        CVCompetence[] cvCompetences = cv.getCVCompetenceByFichePoste(idcv);
        if (cvCompetences != null && cvCompetences.length > 0) {
            pi.setDefautFille(cvCompetences);
            Champ.setAutre(pi.getFormufle().getChampFille("competence"),"readonly");
            Champ.setAutre(pi.getFormufle().getChampFille("idtypecompetencesfp"), "readonly");
        }
        Champ.setDefaut(pi.getFormufle().getChampFille("idcv"),idcv);
        Champ.setVisible(pi.getFormufle().getChampFille("idcv"),false);
        Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idtypecompetencesfp"), "poste.TypeCompetencesFP", "id", "TYPE_COMPETENCES_FP", "id;val", "idtypecompetencesfp;competence");
    }
    String[] colOrdre = {"idtypecompetencesfp","competence","niveau"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une compétence CV");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=paie/avance/apresMultipleAvance.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTableFille%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="idMere" type="hidden" id="idMere" value="<%= idcv %>">
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

