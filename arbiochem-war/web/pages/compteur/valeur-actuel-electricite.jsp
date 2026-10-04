<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="compteur.CompteurElectriciteRecentCpl" %>
<%@ page import="affichage.Liste"%>
<%@ page import="machine.Ligne" %>

<% try{ 
    CompteurElectriciteRecentCpl o = new CompteurElectriciteRecentCpl();
    o.setNomTable("COMPTEURCPLRECENTELECTRICITE");
    String[] listeCrt = {"lignelib","machinelib"};
    String[] listeInt = {};
    String[] libEntete = {"daty","id","lignelib","machinelib","valeur"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Valeur actuel compteur");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compteur/valeur-actuel-electricite.jsp");
    
    Liste[] liste = new Liste[1];
    Ligne liste0 = new Ligne();
    liste0.setNomTable("LIGNE");
    liste[0] = new Liste("lignelib",liste0,"val","val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("lignelib").setLibelle("Ligne");
    pr.getFormu().getChamp("machinelib").setLibelle("Machine");
    pr.getFormu().getChamp("machinelib").setPageAppelComplete("maintenance.ressources.IngredientMaintenance", "libelle", "AS_INGREDIENT_MAINTENANCE");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=compteur/releve-electricite-multiple-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Date","ID","Ligne","Machine","Valeur"};
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

