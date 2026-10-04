<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.competence.PersonnelCompetence" %>
<%@ page import="affichage.Liste"%>
<%@ page import="paie.competence.CompetenceVal" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.competence.PersonnelCompetence";
    String nomTable = "PERSONNEL_COMPETENCE";
    String apres = "paie/competence/personnelcompetence-fiche.jsp";

    PersonnelCompetence o = new PersonnelCompetence();
    o.setNomTable("PERSONNEL_COMPETENCE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une affectation competence");

    Liste[] liste = new Liste[1];
    String[] valeurs = {"1","2","3","4"};
    String[] affiches = {"DEBUTANT","INTERMEDIAIRE","AVANCE&Eacute;","EXPERT"};
    liste[0] = new Liste("niveau" ,affiches,valeurs);
    CompetenceVal liste0 = new CompetenceVal();
    //liste0.setNomTable("COMPETENCEVAL");
    //liste[0] = new Liste("niveau",liste0,"description","val");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("idcompetence").setLibelle("Comp&eacute;tence");
    pi.getFormu().getChamp("niveau").setLibelle("Niveau");
    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");
    pi.getFormu().getChamp("idcompetence").setPageAppelComplete("paie.competence.Competance","id","COMPETENCE","id","id");
 
    String[] ordre = {"idpersonnel","idcompetence","niveau"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une affectation competence");
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

