<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.onBoarding.ProgrammeIntegrationDetailLib" %>

<% try{ 
    ProgrammeIntegrationDetailLib o = new ProgrammeIntegrationDetailLib();
    o.setNomTable("V_PROG_INTEGRATION_DETAIL_LIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idintervenantlib","idintervenantfonctionlib","idintervenantservicelib","duree_effective","jourdelasemaine","heure","duree","actiontheme","contenue","idintervenant"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Intervenant","Fonction intervenant","Service intervenant","Dur&eacute;e effective","Jour de la semaine","Heure","Dur&eacute;e","Th&egrave;me d'action","Contenu","Id intervenant"};
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

