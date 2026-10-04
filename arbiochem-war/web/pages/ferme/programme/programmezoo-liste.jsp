<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.programme.ProgrammeZootechniqueLib" %>

<% try{ 
    ProgrammeZootechniqueLib o = new ProgrammeZootechniqueLib();
    o.setNomTable("PROGRAMMEZOOTECHNIQUE_LIB");
    String[] listeCrt = {"id","idSoucheLib","code","version","daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","idSoucheLib","code","version","daty","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des programme zoo");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/programme/programmezoo-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idSoucheLib").setLibelle("Souche");
    pr.getFormu().getChamp("code").setLibelle("Code");
    pr.getFormu().getChamp("version").setLibelle("Version");
    pr.getFormu().getChamp("daty1").setLibelle("Date de validit&eacute; min");
    pr.getFormu().getChamp("daty2").setLibelle("Date de validit&eacute; max");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=ferme/programme/programmezoo-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Souche","Code","Version","Date de validit&eacute;","&Eacute;tat"};
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

