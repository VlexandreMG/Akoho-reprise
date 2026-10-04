<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="onBoarding.EmployeOnBoardingSessionLib" %>
<%@ page import="affichage.Liste"%>

<% try{ 
    EmployeOnBoardingSessionLib o = new EmployeOnBoardingSessionLib();
    o.setNomTable("EMP_ONBOARDING_COM");
    String[] listeCrt = {"id","onboardinglib","personnelLib","dateDebut","dateFin"};
    String[] listeInt = {};
    String[] libEntete = {"id","onboardinglib","personnelLib","dateDebut","dateFin"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("onBoarding/employeeonboarding-liste.jsp");
    
    Liste[] liste = new Liste[0];
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("onboardinglib").setLibelle("Onboarding");
    pr.getFormu().getChamp("personnelLib").setLibelle("Personnel");
    pr.getFormu().getChamp("dateDebut").setLibelle("Date de d&eacute;but");
    pr.getFormu().getChamp("dateFin").setLibelle("Date de fin");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=onBoarding/employeeonboarding-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Onboarding","Personnel","Date de d&eacute;but","Date de fin"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=onBoarding/employeeonboarding-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir un onboarding d'un employé\n" +
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

