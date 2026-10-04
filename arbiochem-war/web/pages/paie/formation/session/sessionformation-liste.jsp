<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.formation.session.SessionFormationLib" %>

<% try{ 
    SessionFormationLib o = new SessionFormationLib();
    o.setNomTable("SESSION_FORMATION_LIB");
    String[] listeCrt = {"id","idactionformationlib","remarque","datedebut","datefin"};
    String[] listeInt = {"datedebut","datefin"};
    String[] libEntete = {"id","idactionformation","idactionformationlib","datedebut","datefin","nbheureprevue","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des sessions de formations");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/formation/session/sessionformation-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idactionformationlib").setLibelle("Action de formation");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");
    pr.getFormu().getChamp("datedebut1").setLibelle("Date de d&eacute;but min");
    pr.getFormu().getChamp("datedebut2").setLibelle("Date de d&eacute;but max");
    pr.getFormu().getChamp("datefin1").setLibelle("Date de fin min");
    pr.getFormu().getChamp("datefin2").setLibelle("Date de fin max");
    
    String[] colSomme = {"nbheureprevue"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme des heure de formation pr&eacute;vues"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=paie/formation/session/sessionformation-fiche.jsp",pr.getLien() + "?but=paie/formation/action/actionformation-fiche-back.jsp"};
    String[] colonneLien = {"id","idactionformation"};
    String[] attributLien = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","REF Action de Formation","Titre","Date de d&eacute;but","Date de fin","Nb. heures pr&eacute;vues" ,"&Eacute;tat"};
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

