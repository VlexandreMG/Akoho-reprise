<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.vaccination.VaccinationPoussinDetailLib" %>
<% try{
    VaccinationPoussinDetailLib o = new VaccinationPoussinDetailLib();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idBatimentLib","idParquetLib","idTypeVaccinationLib","idMaladiePoussinLib","idVaccinLib","idModeAdministrationLib","qteDose","heureDebut","heureFin","dateExpiration"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String[] libEnteteAffiche = {"Batiment","Parquet","Type de vaccination","Maladie","Vaccin","Mode d'administration","Quantit&eacute; Dose","Heure de  d&eacute;but","Heure de fin","Date d'&eacute;xpiration"};
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