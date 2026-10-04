<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.cv.CVLib" %>

<% try{ 
    CVLib o = new CVLib();
    o.setNomTable("CV_Lib");
    String[] listeCrt = {"nomcandidat","prenomcandidat","titrecv","idFichePosteLib","resumeprofil","daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","nomcandidat","prenomcandidat","titrecv","idFichePosteLib","resumeprofil","daty"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des CV");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/cv/cv-liste.jsp");
    pr.getFormu().getChamp("nomcandidat").setLibelle("Nom du candidat");
    pr.getFormu().getChamp("prenomcandidat").setLibelle("Pr&eacute;nom du candidat");
    pr.getFormu().getChamp("titrecv").setLibelle("Titre du CV");
    pr.getFormu().getChamp("idFichePosteLib").setLibelle("Fiche de poste");
    pr.getFormu().getChamp("resumeprofil").setLibelle("R&eacute;sum&eacute; du profil");
    pr.getFormu().getChamp("daty1").setLibelle("Date de dėp&ocirc;t min");
    pr.getFormu().getChamp("daty2").setLibelle("Date de dėp&ocirc;t max");

    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=paie/cv/cv-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Nom du candidat","Pr&eacute;nom du candidat","Titre du CV", "Fiche de poste","R&eacute;sum&eacute; du profil","Date de d&eacute;p&ocirc;t"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=paie/cv/cv-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir un CV\n" +
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

