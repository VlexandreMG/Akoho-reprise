<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.triageBatiment.TriageBatimentParquetLib" %>

<% try{ 
    TriageBatimentParquetLib o = new TriageBatimentParquetLib();
    o.setNomTable("TRIAGEBATIMENTPARQUET_LIB");
    String[] listeCrt = {"idLotLib","idSoucheLib","daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","idLotLib","idSoucheLib","daty","dispomale","dispofemelle","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des triage batiment par parquet");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/triagebatiment/triagebatimentparquet-liste.jsp");
    pr.getFormu().getChamp("idLotLib").setLibelle("Nom du lot");
    pr.getFormu().getChamp("idSoucheLib").setLibelle("Souche");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    
    String[] colSomme = {"dispomale","dispofemelle"};
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().setLienFille("ferme/triagebatiment/inc/triagebatimentparquet-det.jsp&id=");
    
    String[] enteteRecap = {"","Nombre","Somme des dispomales","Somme des dispofemelles"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=ferme/triagebatiment/triagebatimentparquet-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Nom du lot","Souche","Date","Dispo m&acirc;le","Dispo femelle","&Eacute;tat"};
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

