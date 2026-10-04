<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.suiviJournalier.SuiviJournalierDetailLib" %>

<% try{ 
    SuiviJournalierDetailLib o = new SuiviJournalierDetailLib();
    o.setNomTable("SUIVIJOURNALIERDETAIL_LIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idBatimentLib","idParquetLib","agejour","entree","tri","mortalite","culls","consignesuraliment","eau","temperaturemin","temperaturemax"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"B&acirc;timent","Parquet","&Acirc;ge du jour","Entr&eacute;e","Tri","Mortalit&eacute;","Culls","Consignes sur l'aliment","Eau","Temp&eacute;rature minimale","Temp&eacute;rature maximale"};
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

