<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.capacitejournalier.CapaciteJournalierLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="machine.Ligne" %>

<% try{ 
    CapaciteJournalierLib o = new CapaciteJournalierLib();
    o.setNomTable("");
    String[] listeCrt = {"id","idLigne"};
    String[] listeInt = {};
    String[] libEntete = {"id","idLigneLib","capacite"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/configuration/capacite-journalier-liste.jsp");
    
    Liste[] liste = new Liste[1];
    Ligne liste0 = new Ligne();
    liste0.setNomTable("LIGNE");
    liste[0] = new Liste("idLigne",liste0,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idLigne").setLibelle("Ligne");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=maintenance/configuration/capacite-journalier-fiche.jsp",pr.getLien() + "?but=ligne/ligne-fiche.jsp"};
    String[] colonneLien = {"id","idLigneLib"};
    String[] attributLien = {"id","id"};
    String[] valeurLien = {"id","idLigne"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setValeurLien(valeurLien);

    String[] libEnteteAffiche = {"ID","Ligne","Capacit&eacute;"};
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

