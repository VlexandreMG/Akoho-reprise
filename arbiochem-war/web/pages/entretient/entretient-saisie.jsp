<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="entretien.Entretient" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");

    String mapping = "entretien.Entretient";
    String nomTable = "ENTRETIENT";
    String apres = "entretient/entretient-fiche.jsp";

    Entretient o = new Entretient();
    o.setNomTable("ENTRETIENT");

    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un entretien");

    pi.getFormu().getChamp("idCandidature").setLibelle("Candidature");
    pi.getFormu().getChamp("idCandidature").setDefaut(request.getParameter("idCandidature"));
    pi.getFormu().getChamp("idInterviewer").setLibelle("Responsable de l'entretien");
    pi.getFormu().getChamp("dateEntretient").setLibelle("Date de l'entretien");
    pi.getFormu().getChamp("score").setLibelle("Score sur 20");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("etat").setVisible(false);

    pi.getFormu().getChamp("idCandidature").setPageAppelComplete("paie.recrutement.Candidatures","id","CANDIDATURES","id","id");
    pi.getFormu().getChamp("idInterviewer").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");

    String[] ordre = {
        "idCandidature",
        "idInterviewer",
        "dateEntretient",
        "score",
        "remarque"
    };
    pi.getFormu().setOrdre(ordre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un entretien");
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

        <input name="acte" type="hidden" value="insert">
        <input name="bute" type="hidden" value="<%=apres%>">
        <input name="classe" type="hidden" value="<%=mapping%>">
        <input name="nomtable" type="hidden" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script>
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>