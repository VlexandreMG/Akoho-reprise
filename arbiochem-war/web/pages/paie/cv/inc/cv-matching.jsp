<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.MatchingCVFichePoste" %>

<% try{ 
    MatchingCVFichePoste o = new MatchingCVFichePoste();
    o.setNomTable("V_MATCHING_CV_FP");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idcv","typecompetencelib","competence","niveaurequis","niveaucandidat","ecart","estvalide","resultat"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idcv='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id CV","Type de comp&eacute;tence","Comp&eacute;tence","Niveau requis","Niveau candidat","&Eacute;cart","Valid&eacute;","R&eacute;sultat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        } else{ %>
            <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

