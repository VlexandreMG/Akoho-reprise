<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.couvoir.EclosionLib" %>

<% try{ 
    EclosionLib o = new EclosionLib();
    o.setNomTable("ECLOSION_LIB");
    String[] listeCrt = {"id","idIncubateurLib","idBatimentLib","idParquetLib","etatLib"};
    String[] listeInt = {};
    String[] libEntete = {"id","idIncubateurLib","idBatimentLib","idParquetLib","idEclosoirLib","dateeclosion","nombreoeufinitial","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Eclosion liste");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/couvoir/eclosion-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idIncubateurLib").setLibelle("Incubateur");
    pr.getFormu().getChamp("idBatimentLib").setLibelle("B&acirc;timent");
    pr.getFormu().getChamp("idParquetLib").setLibelle("Parquet");
    pr.getFormu().getChamp("etatLib").setLibelle("&Eacute;tat");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().setLienFille("ferme/couvoir/inc/eclosion-details.jsp&id=");

    String[] lienTableau = {pr.getLien() + "?but=ferme/couvoir/eclosion-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Incubateur","B&acirc;timent","Parquet","&Eacute;closoir","Date d'&eacute;closion","Nombre d'oeufs initial","&Eacute;tat"};
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

