<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="compteur.CompteurCpl" %>
<%@ page import="utils.ConstanteSocobis" %>

<% try{ 
    CompteurCpl o = new CompteurCpl();
    o.setNomTable("compteurcpl");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","daty","idLigneLib","idCategorieLib","ecart"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        pr.setApres("ligne/ligne-fiche.jsp&id="+request.getParameter("id"));
        pr.setAWhere(" and IDLIGNE='"+request.getParameter("id")+"' and idcategorie = '" + ConstanteSocobis.gazoil + "'");
    }


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Date","Ligne","Cat&eacute;gorie","&Eacute;cart"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String[] lienTableau = {pr.getLien() + "?but=compteur/releve-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
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

