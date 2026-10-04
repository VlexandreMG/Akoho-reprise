<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.formation.RecapGlobalFormation" %>
<%@ page import="affichage.Liste"%>
<%@ page import="paie.formation.TypeFormation" %>
<%@ page import="paie.formation.configuration.CategorieFormation" %>
<%@ page import="paie.formateur.Formateur" %>
<%@ page import="paie.formation.action.TypeCoutFormation" %>

<% try{ 
    RecapGlobalFormation o = new RecapGlobalFormation();
    o.setNomTable("V_RECAP_GLOBAL_FORMATION");
    String[] listeCrt = {"annee","ref_formation","intitule","type_formation","semestre","formateur","type_cout_id"};
    String[] listeInt = {};
    String[] libEntete = {"annee","ref_formation","type_formationlib","categorielib","intitule","semestrelib","interne_externe","formateurlib","type_cout_lib","montant_cout","nombre_session","nb_participant_ouvriers","nb_participant_cadres","nb_participant_total","duree_par_stagiaire","duree_totale_heure"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Bilan de formation globale");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/formation/recap-global-formation.jsp");
    
    Liste[] liste = new Liste[4];
    TypeFormation liste0 = new TypeFormation();
    liste0.setNomTable("TYPE_FORMATION");
    liste[0] = new Liste("type_formation",liste0,"val","id");
    CategorieFormation liste1 = new CategorieFormation();
    liste1.setNomTable("SEMESTRE");
    liste[1] = new Liste("semestre",liste1,"val","id");
    Formateur liste2 = new Formateur();
    liste2.setNomTable("FORMATEUR");
    liste[2] = new Liste("formateur",liste2,"libelle","id");
    TypeCoutFormation liste3 = new TypeCoutFormation();
    liste3.setNomTable("TYPE_COUT_FORMATION");
    liste[3] = new Liste("type_cout_id",liste3,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pr.getFormu().getChamp("ref_formation").setLibelle("R&eacute;f&eacute;rence formation");
    pr.getFormu().getChamp("intitule").setLibelle("Intitul&eacute;");
    pr.getFormu().getChamp("type_formation").setLibelle("Type de formation");
    pr.getFormu().getChamp("semestre").setLibelle("Semestre");
    pr.getFormu().getChamp("formateur").setLibelle("Formateur");
    pr.getFormu().getChamp("type_cout_id").setLibelle("Type de co&ucirc;t");
    
    String[] colSomme = {"montant_cout","nb_participant_total"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme des couts","Nombre total de participants"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] libEnteteAffiche = {"Ann&eacute;e","R&eacute;f&eacute;rence formation","Type de formation","Cat&eacute;gorie","Intitul&eacute;","Semestre","Interne ou externe","Formateur","Type de co&ucirc;t","Montant du co&ucirc;t","Nombre de sessions","Nombre de participants ouvriers","Nombre de participants cadres","Nombre total de participants","Dur&eacute;e par stagiaire","Dur&eacute;e totale en heures"};
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

