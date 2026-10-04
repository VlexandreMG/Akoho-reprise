<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="entretien.EntretienRHLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.edition.PaieFonction" %>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    EntretienRHLib o = new EntretienRHLib();
    o.setNomTable("ENTRETIENRH_LIB");
    String[] listeCrt = {"id","typeEntretientLib","idFonctionLib","idDirectionLib","idEvaluateurLib","nomPrenomCandidat"};
    String[] listeInt = {};
    String[] libEntete = {"id","typeEntretientLib","idFonctionLib","idDirectionLib","idEvaluateurLib","nomPrenomCandidat"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des entretients");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("entretient/entretientrh-liste.jsp");
    Liste[] listes = new Liste[2];
    PaieFonction paieFonction = new PaieFonction();
    listes[0] = new Liste("idFonctionLib", paieFonction, "val", "val");
    TypeObjet to = new TypeObjet();
    to.setNomTable("LOG_DIRECTION");
    listes[1] = new Liste("idDirectionLib", to, "val", "val");
    pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("typeEntretientLib").setLibelle("Type d'entretien");
    pr.getFormu().getChamp("idFonctionLib").setLibelle("Fonction");
    pr.getFormu().getChamp("idDirectionLib").setLibelle("Direction");
    pr.getFormu().getChamp("idEvaluateurLib").setLibelle("&Eacute;valuateur");
    pr.getFormu().getChamp("nomPrenomCandidat").setLibelle("Nom et pr&eacute;nom du candidat");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=entretient/entretientrh-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=entretient/entretientrh-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir une entretien\n" +
                    "                </a>"
    );

    String[] libEnteteAffiche = {"Id","Type d'entretien","Fonction","Direction","Evaluateur","Nom et pr&eacute;nom du candidat"};
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

