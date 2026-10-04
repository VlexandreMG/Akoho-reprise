<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.cv.CVScoreGlobale" %>

<% try{ 
    CVScoreGlobale o = new CVScoreGlobale();
    o.setNomTable("V_CV_SCORE_GLOBAL");
    String[] listeCrt = {"idcv","idficheposte"};
    String[] listeInt = {};
    String[] libEntete = {"idcv","idficheposte","nbcompetences","nbcompetencesvalides","nbcompetencesnonvalides","score"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Score Global CV - Fiche de Poste");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/cv/cv-score-global.jsp");
    pr.getFormu().getChamp("idcv").setLibelle("Identifiant CV");
    pr.getFormu().getChamp("idficheposte").setLibelle("Identifiant fiche de poste");
    
    String[] colSomme = {"nbcompetences","nbcompetencesvalides","nbcompetencesnonvalides","score"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme du nbr de comp&eacute;tences","Somme du nbr de comp&eacute;tences valid&eacute;es","Somme du nbr de comp&eacute;tences non valid&eacute;es","Somme du score"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=paie/cv/cv-fiche.jsp",pr.getLien() + "?but=poste/ficheposte-fiche.jsp"};
    String[] colonneLien = {"idcv","idficheposte"};
    String[] attributLien = {"idcv","idficheposte"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id CV","Id fiche poste","Nombre de comp&eacute;tences","Nombre de comp&eacute;tences valid&eacute;es","Nombre de comp&eacute;tences non valid&eacute;es","Score"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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

