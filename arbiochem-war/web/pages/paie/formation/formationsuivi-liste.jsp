<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.formation.FormationSuiviLib" %>

<% try{ 
    FormationSuiviLib o = new FormationSuiviLib();
    o.setNomTable("FORMATION_SUIVILIB");
    String[] listeCrt = {"id","idpersonnellib","idformationlib","datedebut","datefin"};
    String[] listeInt = {"datedebut","datefin"};
    String[] libEntete = {"id","idformation","idformationlib","idpersonnel","idpersonnellib","datedebut","datefin","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des formations suivi");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/formation/formationsuivi-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idpersonnellib").setLibelle("Nom & pr&eacute;nom");
    pr.getFormu().getChamp("idformationlib").setLibelle("Formation");
    pr.getFormu().getChamp("datedebut1").setLibelle("Date de d&eacute;but min");
    pr.getFormu().getChamp("datedebut2").setLibelle("Date de d&eacute;but max");
    pr.getFormu().getChamp("datefin1").setLibelle("Date de fin min");
    pr.getFormu().getChamp("datefin2").setLibelle("Date de fin max");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=paie/formation/formationsuivi-fiche.jsp",pr.getLien() + "?but=paie/formation/formation-fiche.jsp",pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp"};
    String[] colonneLien = {"id","idformation","idpersonnel"};
    String[] attributLien = {"id","id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","ID Formation","Formation","Personnel","Nom & pr&eacute;nom","Date de d&eacute;but","Date de fin","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=paie/formation/formationsuivi-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir un suivi de formation\n" +
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

