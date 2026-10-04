<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.formation.BilanFormationParStatut" %>

<% try{ 
    BilanFormationParStatut o = new BilanFormationParStatut();
    o.setNomTable("V_FORMATION_BILAN_PAR_STATUT");
    String[] listeCrt = {"annee"};
    String[] listeInt = {};
    String[] libEntete = {"annee","nbrealise","nbnonrealisee"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Bilan de formation par Statut");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/formation/bilan/bilanformation-statut.jsp");
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    
    String[] colSomme =  {"nbrealise","nbnonrealisee"};
    pr.creerObjetPage(libEntete, colSomme);
     String[] enteteRecap = {"","Nombre","Somme des r&eacute;alisations ","Somme des non r&eacute;alisations"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] libEnteteAffiche = {"Ann&eacute;e","Nombre r&eacute;alis&eacute;","Nombre non r&eacute;alis&eacute;"};
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

