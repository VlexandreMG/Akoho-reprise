<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste"%>
<%@ page import="paie.edition.PaieFonction"%>
<%@ page import="onBoarding.OnboardingMere" %>
<%@ page import="onBoarding.OnboardingMereLib" %>

<% try{
    OnboardingMereLib o = new OnboardingMereLib();
    String[] listeCrt = {"id","nom","description","idFonction"};
    String[] listeInt = {};
    String[] libEntete = {"id","nom","description", "idFonctionLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des on boarding");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("onBoarding/onboardingspecific-liste.jsp");

    Liste[] listes = new Liste[1];
    listes[0] = new Liste("idFonction", new PaieFonction(), "val", "id");
    pr.getFormu().changerEnChamp(listes);

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("description").setLibelle("Description");
    pr.getFormu().getChamp("idFonction").setLibelle("Fonction");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=onBoarding/onBoarding-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Nom","Description", "Fonction"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=onBoarding/onboardingspecific-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir un onboarding\n" +
                    "                </a>"
    );
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

