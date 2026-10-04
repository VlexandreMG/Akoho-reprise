<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="entretien.Entretient" %>

<% try{ 
    Entretient o = new Entretient();
    o.setNomTable("V_ENTRETIENT");

    // 🔍 Critères de recherche (intervalle)
    String[] listeCrt = {"score"};
    String[] listeInt = {"score"};

    // 📊 Colonnes
    String[] libEntete = {
        "id",
        "idCandidature",
        "idInterviewerLib",
        "dateEntretient",
        "score",
        "remarque",
            "etatlib"
    };

    PageRecherche pr = new PageRecherche(
        o,
        request,
        listeCrt,
        listeInt,
        4,
        libEntete,
        libEntete.length
    );

    pr.setTitre("Liste des entretiens");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("entretient/entretient-liste.jsp");

    // 🔥 Libellés des filtres
    pr.getFormu().getChamp("score1").setLibelle("Score min");
    pr.getFormu().getChamp("score2").setLibelle("Score max");

    // 📈 Colonnes à sommer
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    // 📊 Entête récap
//    String[] enteteRecap = {"","Nombre"};
//    pr.getTableauRecap().setLibeEntete(enteteRecap);

    // 🔗 Lien vers fiche
    String[] lienTableau = {
        pr.getLien() + "?but=entretient/entretient-fiche.jsp"
    };
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};

    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    // 🧾 Libellés affichés
    String[] libEnteteAffiche = {
        "ID",
        "Candidature",
        "Intervieweur",
        "Date de l'entretien",
        "Score sur 20",
        "Remarque",
        "&Eacute;tat",
    };

    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=entretient/entretient-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un entretient</a>"
    );

%>

<div class="content-wrapper">

    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>

    <section class="content">

        <!-- 🔍 Formulaire recherche -->
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <!-- 📊 Récap -->
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>

        <br>

        <!-- 📋 Tableau -->
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>

    </section>

</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script>
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>