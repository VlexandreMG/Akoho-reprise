<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.production.triageOeufLib" %>

<% try{ 
    triageOeufLib o = new triageOeufLib();
    o.setNomTable("TRIAGEOEUF_LIB");
    String[] listeCrt = {"daty","idOperateurLib","idNumeroCollecteLib","idBatimentLib","idParquetLib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","daty","heuredepart","idOperateurLib","idBatimentLib","idParquetLib","idNumeroCollecteLib","oeuftotal","poidsmoyenoeufs"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des triage &oelig;uf");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/production/triageoeuf-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idOperateurLib").setLibelle("Op&eacute;rateur");
    pr.getFormu().getChamp("idNumeroCollecteLib").setLibelle("Num&eacute;ro de collecte");
    pr.getFormu().getChamp("idBatimentLib").setLibelle("B&acirc;timent");
    pr.getFormu().getChamp("idParquetLib").setLibelle("Parquet");
    
    String[] colSomme = {"oeuftotal"};
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().setLienFille("ferme/production/inc/triageoeuf-details.jsp&id=");

    String[] labelRecap = {"" ,"Nombre", "Somme des total d'&oelig;ufs" };
    pr.getTableauRecap().setLibeEntete(labelRecap);

    String[] lienTableau = {pr.getLien() + "?but=ferme/production/triageoeuf-fiche.jsp",pr.getLien() + "?but=ferme/configuration/batiment-fiche.jsp"};
    String[] colonneLien = {"id","idBatimentLib"};
    String[] attributLien = {"id","id"};
    String[] valeurLien = {"id","idBatiment"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setValeurLien(valeurLien);

    String[] libEnteteAffiche = {"Id","Date","Heure d&eacute;part","Op&eacute;rateur","B&acirc;timent","Parquet","Num&eacute;ro de collecte","Total &oelig;ufs","Poids moyen &oelig;ufs"};
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
