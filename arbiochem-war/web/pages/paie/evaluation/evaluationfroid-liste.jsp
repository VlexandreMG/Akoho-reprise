<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.evaluation.EvaluationFroidLib" %>

<% try{ 
    EvaluationFroidLib o = new EvaluationFroidLib();
    String[] listeCrt = {"id","idformationsuivi","personnel","commentaire","dateevaluation"};
    String[] listeInt = {"dateevaluation"};
    String[] libEntete = {"id","idformationsuivi","idpersonnel","personnel","matricule","note","commentaire","dateevaluation"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;valuations froid");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/evaluation/evaluationfroid-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idformationsuivi").setLibelle("Formation suivie");
    pr.getFormu().getChamp("personnel").setLibelle("Personnel");
    pr.getFormu().getChamp("commentaire").setLibelle("Commentaire");
    pr.getFormu().getChamp("dateevaluation1").setLibelle("Date d'&eacute;valuation min");
    pr.getFormu().getChamp("dateevaluation2").setLibelle("Date d'&eacute;valuation max");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=paie/evaluation/evaluationfroid-fiche.jsp",pr.getLien() + "?but=paie/formation/formationsuivi-fiche.jsp",pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp"};
    String[] colonneLien = {"id","idformationsuivi","idpersonnel"};
    String[] attributLien = {"id","idformationsuivi","idpersonnel"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Formation suivie","ID Personnel","Personnel","Matricule","Note","Commentaire","Date d'&eacute;valuation"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=paie/evaluation/evaluationfroid-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir une évaluation à froid\n" +
                    "                </a>"
    );
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

