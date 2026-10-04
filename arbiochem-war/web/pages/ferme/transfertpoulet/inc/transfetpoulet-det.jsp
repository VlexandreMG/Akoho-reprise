<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.transfertpoulet.TransfertPouletDetailLib" %>

<% try{ 
    TransfertPouletDetailLib o = new TransfertPouletDetailLib();
    o.setNomTable("TRANSFERTPOULETDETAIL_LIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idSexeLib","qte","idFermeDepartLib","idBatimentDepartLib","idParquetDepartLib","idFermeArriveLib","idBatimentArriveLib","idParquetArriveLib","idControleurLib","idChauffeurLib","idVehiculeLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Sexe","Quantit&eacute;","Ferme de d&eacute;part","B&acirc;timent de d&eacute;part","Parquet de d&eacute;part","Ferme d'arriv&eacute;e","B&acirc;timent d'arriv&eacute;e","Parquet d'arriv&eacute;e","Contr&ocirc;leur","Chauffeur","V&eacute;hicule"};
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

