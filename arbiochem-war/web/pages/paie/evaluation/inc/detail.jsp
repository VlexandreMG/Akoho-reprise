<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.evaluation.EvaluationDetailLib" %>

<%
    try {

        EvaluationDetailLib o = new EvaluationDetailLib();
        o.setNomTable("EVALUATION_DETAIL_LIB");

        String[] listeCrt = {};
        String[] listeInt = {};

        String[] libEntete = {
                "id",
                "idTypeCompetenceFPLib",
                "competence",
                "autoEvaluation",
                "evaluationSuperieur",
                "synthese",
                "appreciation"
        };

        PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);

        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        // Filter by evaluation id if provided
        if (request.getParameter("id") != null && !request.getParameter("id").trim().isEmpty()) {
            pr.setAWhere(" AND IDEVALUATION = '" + request.getParameter("id") + "'");
        }

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        // Labels displayed in table header
        String[] libEnteteAffiche = {
                "Id",
                "Type de competence",
                "Competence",
                "Auto evaluation",
                "Evaluation superieur",
                "Synthese",
                "Appreciation"
        };

        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

%>

<div class="box-body">
    <%
        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %>
    <center><h4>Aucune donnée trouvée</h4></center>
    <%
        }
    %>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript">
    alert('<%= e.getMessage() %>');
    history.back();
</script>

<%
    }
%>