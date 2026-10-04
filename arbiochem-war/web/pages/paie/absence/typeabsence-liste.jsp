<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 27/03/2026
  Time: 12:45
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.absence.TypeAbsenceLib" %>

<% try{
  TypeAbsenceLib o = new TypeAbsenceLib();
  String[] listeCrt = {"id","val","nbjour","frequencelib"};
  String[] listeInt = {};
  String[] libEntete = {"id","val","desce","nbjour","frequencelib","etatlib"};
  PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
  pr.setTitre("Liste des types d'absences");
  pr.setUtilisateur((user.UserEJB) session.getValue("u"));
  pr.setLien((String) session.getValue("lien"));
  pr.setApres("paie/absence/typeabsence-liste.jsp");

  pr.getFormu().getChamp("val").setLibelle("Libelle");
  pr.getFormu().getChamp("nbjour").setLibelle("Nombre de jour");
  pr.getFormu().getChamp("frequencelib").setLibelle("Fr&eacute;quence");

  String[] colSomme = null;
  pr.creerObjetPage(libEntete, colSomme);

  String[] libEnteteAffiche = {"Id","Libelle","Description","Nombre de jour","Fr&eacute;quence","&Eacute;tat"};

  String lienTableau[] = {pr.getLien() + "?but=paie/absence/typeabsence-fiche.jsp"};
  String colonneLien[] = {"id"};
  pr.getTableau().setLien(lienTableau);
  pr.getTableau().setColonneLien(colonneLien);
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

