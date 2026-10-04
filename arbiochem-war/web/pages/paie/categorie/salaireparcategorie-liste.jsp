<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.categorie.SalaireCategorieLib" %>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>

<% try{ 
    SalaireCategorieLib o = new SalaireCategorieLib();
    o.setNomTable("CATEGORIE_QUALIFICATION_VW");
    String[] listeCrt = {"id","categorieLib","qualificationLib","date_debut","date_fin"};
    String[] listeInt = {};
    String[] libEntete = {"id","categorieLib","qualificationLib","montant","date_debut","date_fin","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste salaire par categorie");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/categorie/salaireparcategorie-liste.jsp");

    affichage.Champ[] liste = new affichage.Champ[2];
    TypeObjet qualification = new TypeObjet();
    qualification.setNomTable("QUALIFICATION_PAIE");
    liste[0] = new Liste("qualificationLib", qualification, "val", "desce");
    TypeObjet categPaie = new TypeObjet();
    categPaie.setNomTable("CATEGORIE_PAIE");
    liste[1] = new Liste("categorieLib", categPaie, "val", "desce");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("categorieLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("qualificationLib").setLibelle("Qualification");
    pr.getFormu().getChamp("date_debut").setLibelle("Date de d&eacute;but");
    pr.getFormu().getChamp("date_fin").setLibelle("Date de fin");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=paie/categorie/salaireparcategorie-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Cat&eacute;gorie","Qualification","Montant","Date de d&eacute;but","Date de fin","&Eacute;tat"};
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

