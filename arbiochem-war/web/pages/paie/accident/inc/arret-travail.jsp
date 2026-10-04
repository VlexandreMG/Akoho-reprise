<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.accident.ArretTravail" %>

<% try{ 
    ArretTravail o = new ArretTravail();
    o.setNomTable("ARRET_TRAVAIL");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","id_Accident","daty","date_Debut_Arret","date_Fin_Arret","nombre_Jour"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if (request.getParameter("id") != null) {
        String id = request.getParameter("id");
        pr.setAWhere(" AND id_accident = '" + id + "' ");
    }


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Accident","Date","Date de d&eacute;but d'arr&ecirc;t","Date de fin d'arr&ecirc;t","Nombre de jours"};
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

