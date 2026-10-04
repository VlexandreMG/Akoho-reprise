<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.competence.EmploiLib" %>

<% try{
    EmploiLib o = new EmploiLib();
    o.setNomTable("emploi_lib");
    String[] listeCrt = {"id","val","idcoderomelib","idfamilleprolib","idsousfamilleprolib"};
    String[] listeInt = {};
    String[] libEntete = {"id","val","idmetierlib","idcoderomelib","idfamilleprolib","idsousfamilleprolib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des emplois");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/competence/emploi-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("val").setLibelle("M&eacute;tier");
    pr.getFormu().getChamp("idcoderomelib").setLibelle("Code ROME");
    pr.getFormu().getChamp("idfamilleprolib").setLibelle("Famille professionnelle");
    pr.getFormu().getChamp("idsousfamilleprolib").setLibelle("Sous-famille professionnelle");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=paie/competence/emploi-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Libell&eacute;","M&eacute;tier","Code ROME","Famille professionnelle","Sous-famille professionnelle"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=paie/competence/emploi-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir un emploi\n" +
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
