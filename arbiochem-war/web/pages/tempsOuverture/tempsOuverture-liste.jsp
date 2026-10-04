<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.tempOuverture.TempsOuvertureLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="annexe.Unite" %>

<% try{ 
    TempsOuvertureLib o = new TempsOuvertureLib();
    o.setNomTable("TEMPSOUVERTURELIB");
    String[] listeCrt = {"id","idMachinelib","temps","capacite","idUnite"};
    String[] listeInt = {"temps","capacite"};
    String[] libEntete = {"id","idMachinelib","temps","capacite","idUnitelib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des temps d'ouvertures");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("tempsOuverture/tempsOuverture-liste.jsp");
    
    Liste[] liste = new Liste[1];
    Unite unite = new Unite();
    unite.setNomTable("AS_UNITE");
    liste[0] = new Liste("idUnite",unite,"val","id");

    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idMachinelib").setLibelle("Machine");
    pr.getFormu().getChamp("temps1").setLibelle("Temps min");
    pr.getFormu().getChamp("temps2").setLibelle("Temps max");
    pr.getFormu().getChamp("capacite1").setLibelle("Capacite min");
    pr.getFormu().getChamp("capacite2").setLibelle("Capacite max");
    pr.getFormu().getChamp("idUnite").setLibelle("Unit&eacute;");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=tempsOuverture/tempsOuverture-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Machine","Temps","Capacit&eacute;","Unit&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=tempsOuverture/tempsOuverture-saisie.jsp&currentMenu=MENDYN1771224965983163\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un temps d'ouverture</a>"
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

