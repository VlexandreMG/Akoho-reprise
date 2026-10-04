<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.cartographie.HierarchiePro" %>

<% try{ 
    HierarchiePro o = new HierarchiePro();
    o.setNomTable("V_HIERARCHIE_PROFESSIONNELLE");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"famillepro","sousfamille","coderome","metier","emploie","fonction"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
            pr.setAWhere(" and idfamillepro = '"+request.getParameter("id")+"' ");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Famille professionnelle","Sous-famille","Code ROME","M&eacute;tier","Emploi","Fonction"};
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

