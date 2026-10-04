<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.recrutement.OffreEmploiLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    OffreEmploiLib o = new OffreEmploiLib();
    o.setNomTable("offre_emploilib");
    String[] listeCrt = {"id","titre","datepublication","idtypecontrat"};
    String[] listeInt = {"datepublication","datefermeture"};
    String[] libEntete = {"id","titre","idfichepostelib","idtypecontratlib","datepublication","datefermeture","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des offres d'emplois");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/recrutement/offreemploi-liste.jsp");
    
    Liste[] liste = new Liste[1];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("TYPE_CONTRAT");
    liste[0] = new Liste("idtypecontrat",liste0,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("titre").setLibelle("Titre");
    pr.getFormu().getChamp("datepublication1").setLibelle("Date de publication min");
    pr.getFormu().getChamp("datepublication2").setLibelle("Date de publication max");
    pr.getFormu().getChamp("idtypecontrat").setLibelle("Type de contrat");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Titre","Titre de la fiche poste","Type de contrat","Date de publication","Date de fermeture","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

     String[] lienTableau = {pr.getLien() + "?but=paie/recrutement/offreemploi-fiche.jsp",pr.getLien() + "?but=poste/ficheposte-fiche.jsp"};
    String[] colonneLien = {"id","Idficheposte"};
    String[] attributLien = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=paie/recrutement/offreemploi-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir une offre d'emploi\n" +
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

