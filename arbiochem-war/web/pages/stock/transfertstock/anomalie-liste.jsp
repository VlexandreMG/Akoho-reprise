<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="stock.AnomalieTransfert" %>
<%@ page import="affichage.Liste"%>
<%@ page import="magasin.MagasinLib" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    AnomalieTransfert o = new AnomalieTransfert();
    o.setNomTable("ANOMALIETRANSFERT");
    String[] listeCrt = {"idTransfert","designation","daty","magasinDepart","magasinArrive","idProduitLib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"idTransfert","daty","magasinDepartLib","magasinArriveLib","designation","idProduitLib","quantite","montant","envoye","recu","ecart","montantEcart","reste"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des anomalies des transferts de stock");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/transfertstock/anomalie-liste.jsp");

    Liste[] liste = new Liste[2];
    Magasin liste0 = new Magasin();
    liste0.setNomTable("MAGASINPOINT");
    liste[0] = new Liste("magasinDepart",liste0,"val","id");
    Magasin liste1 = new Magasin();
    liste1.setNomTable("MAGASINPOINT");
    liste[1] = new Liste("magasinArrive",liste1,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("idTransfert").setLibelle("ID transfert");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.getDebutSemaineString());
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.getFinSemaineString());
    pr.getFormu().getChamp("magasinDepart").setLibelle("Magasin de depart");
    pr.getFormu().getChamp("magasinArrive").setLibelle("Magasin d'arrive");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("designation").setLibelle("d&eacute;signation");

    String[] colSomme = {"envoye","recu","ecart","montantEcart","reste"};
    pr.creerObjetPage(libEntete, colSomme);

    String[] enteteRecap = {"","Nombre","Somme des quantit&eacute; envoy&eacute;","Somme des quantit&eacute; re&ccedil;u","Somme des &eacute;carts en quantit&eacute;","Somme des &eacute;carts en montant","Somme des quantit&eacute; reste &agrave; envoyer"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=stock/transfertstock/transfertstock-fiche.jsp"};
    String[] colonneLien = {"idTransfert"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"ID Transfert","Date","Magasin de d&eacute;part","Magasin d'arriv&eacute;e","D&eacute;signation","Produit","Quantit&eacute; ","Montant","Envoy&eacute;","Re&ccedil;u","&Eacute;cart","Montant de l'&eacute;cart","Reste &agrave; envoyer  "};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("stock/transfertstock/inc/transfertstockdetails-liste.jsp&id=");
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

