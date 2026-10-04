<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.production.ReceptionOACLib" %>
<%@ page import="ferme.production.ImportOAC" %>

<% try{ 
    ImportOAC o = new ImportOAC();
    String[] listeCrt = {"id","datereception","dateponte","datecollecte","idNumeroCollecteLib","idResponsableLib","idChauffeurLib","idVehiculeLib"};
    String[] listeInt = {"datereception","dateponte","datecollecte"};
    String[] libEntete = {"id","idNumeroCollecteLib","datecollecte","dateponte","datereception","heuredepartferme","heurearriveecouvoir","idResponsableLib","idChauffeurLib","idVehiculeLib","temperatureminvehicule","temperaturemaxvehicule","idProvenanceLib","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des reception oac");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/production/receptionoac-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("datereception1").setLibelle("Date de r&eacute;ception min");
    pr.getFormu().getChamp("datereception2").setLibelle("Date de r&eacute;ception max");
    pr.getFormu().getChamp("dateponte1").setLibelle("Date de ponte min");
    pr.getFormu().getChamp("dateponte2").setLibelle("Date de ponte max");
    pr.getFormu().getChamp("datecollecte1").setLibelle("Date de collecte min");
    pr.getFormu().getChamp("datecollecte2").setLibelle("Date de collecte max");
    pr.getFormu().getChamp("idNumeroCollecteLib").setLibelle("Num&eacute;ro de collecte");
    pr.getFormu().getChamp("idResponsableLib").setLibelle("Responsable");
    pr.getFormu().getChamp("idChauffeurLib").setLibelle("Chauffeur");
    pr.getFormu().getChamp("idVehiculeLib").setLibelle("V&eacute;hicule");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().setLienFille("ferme/production/inc/receptionoac-details.jsp&id=");

    String[] lienTableau = {pr.getLien() + "?but=ferme/production/importoac-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Num&eacute;ro de collecte","Date de collecte","Date de ponte","Date de r&eacute;ception","Heure de d&eacute;part ferme","Heure d'arriv&eacute;e au couvoir","Responsable","Chauffeur","V&eacute;hicule","Temp&eacute;rature minimale du v&eacute;hicule","Temp&eacute;rature maximale du v&eacute;hicule","Provenance","&Eacute;tat"};
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

