<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.formation.action.ActionFormationLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.formation.TypeFormation" %>
<%@ page import="paie.formation.configuration.CategorieFormation" %>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    ActionFormationLib o = new ActionFormationLib();
    o.setNomTable("ACTION_FORMATION_LIB");
    String[] listeCrt = {"idplanformationlib","idtypeformation","idcategorieformation","idsemestre","id","formateur","reference","intitule"};
    String[] listeInt = {};
    String[] libEntete = {"id","reference","intitule","idtypeformationlib","formateur","typeprestataire","idsemestrelib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des actions formations");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/formation/action/actionformation-liste.jsp");

    Liste[] listes = new Liste[3];
    listes[0] = new Liste("idtypeformation", new TypeFormation(), "val", "id");
    listes[1] = new Liste("idcategorieformation", new CategorieFormation(), "val", "id");
    TypeObjet semestre = new TypeObjet();
    semestre.setNomTable("SEMESTRE");
    listes[2] = new Liste("idsemestre", semestre, "val", "id");
    pr.getFormu().changerEnChamp(listes);

    pr.getFormu().getChamp("idplanformationlib").setLibelle("Plan de formation");
    pr.getFormu().getChamp("idtypeformation").setLibelle("Type de formation");
    pr.getFormu().getChamp("idcategorieformation").setLibelle("Cat&eacute;gorie de formation");
    pr.getFormu().getChamp("idsemestre").setLibelle("Semestre");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("formateur").setLibelle("Formateur");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("intitule").setLibelle("Intitul&eacute;");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme de budgettotalprevisionel"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=paie/formation/action/actionformation-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","R&eacute;f&eacute;rence","Intitul&eacute;","Type de formation","Formateur","Type de prestataire","Semestre"};
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

