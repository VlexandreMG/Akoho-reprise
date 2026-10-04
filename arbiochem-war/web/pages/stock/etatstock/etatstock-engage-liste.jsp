<%--
    Document   : etatcaisse-liste
    Created on : 2 avr. 2024, 10:11:22
    Author     : 26134
--%>


<%@page import="produits.CategorieIngredient"%>
<%@page import="utils.ConstanteStation"%>
<%@page import="stock.PageRechercheEtatStock"%>
<%@page import="stock.EtatStock"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Unite"%>
<%@page import="affichage.Liste"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="stock.EtatStockEngage" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    EtatStockEngage t = new EtatStockEngage();
    t.setNomTable("V_ETATSTOCK_ING_VENTE");
    String listeCrt[] = {"id","idProduitLib","idMagasin"};
    String listeInt[] = {};
    String libEntete[] = {"id","idProduitLib","idMagasinLib","physique","engage","afacturer"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("&Eacute;tat de Stock");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-engage-liste.jsp");

    Liste[] liste = new Liste[1];
    Magasin m = new Magasin();
    m.setNomTable("MagasinVente");
    liste[0] = new Liste("idMagasin",m,"val","id");
    liste[0].setLibelle("Magasin");
    pr.getFormu().changerEnChamp(liste);

//    pr.getFormu().getChamp("dateDernierMouvement1").setDefaut("01/01/2001");
//    pr.getFormu().getChamp("dateDernierMouvement1").setVisible(false);
//    pr.getFormu().getChamp("dateDernierMouvement1").setLibelle("-");
//    pr.getFormu().getChamp("dateDernierMouvement2").setLibelle("Date");
//    pr.getFormu().getChamp("dateDernierMouvement2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");


    //pr.getFormu().getChamp("idUnite").setLibelle("Unite");
    //pr.getFormu().getChamp("puVente1").setLibelle("Prix de vente minimum");
    //pr.getFormu().getChamp("puVente2").setLibelle("Prix de vente maximum");
    String[] colSomme = {"physique","engage","afacturer"};
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"Id","Produit","Magasin","Stock physique", "Stock engag&eacute;", "Stock disponible"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String enteteRecap[] = {"","Nombre","Somme des Quantit&eacute;s physique","Somme des quantit&eacute;s engag&eacute;es", "Somme des Quantit&eacute;s disponible"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    pr.getFormu().setAnotherButton(
            "                <a id='export-btn' class='btn btn-secondary  btn-bg-white btn-small' href='#' onclick='exportPDF()'>\n" +
                    "                    <i class='material-symbols-rounded'>download</i> Imprimer en PDF \n" +
                    "                </a>\n"
    );
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
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
        <div class="row justify-content-center d-none">
            <div class="col-md-12 d-flex justify-content-right">
                <div class="box box-primary">
                    <div class="box-body text-center">
                        <a id="export-btn" class="btn btn-warning pull-right" href="#">
                            Exporter en pdf <i class="fa fa-download"></i>
                        </a>


                    </div>
                </div>
            </div>
        </div>
        <%
            // out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    function exportPDF() {
        // Récupération des champs
        var idvalue = document.getElementById("id").value;
        var idProduitLibValue = document.getElementById("idProduitLib").value;
        var idMagasin = document.getElementById("idMagasin").value;



        var exportUrl = "${pageContext.request.contextPath}/ExportPDF?action=imprimer_etatstock_engage"
            + "&id=" + encodeURIComponent(idvalue)
            + "&idProduitLib=" + encodeURIComponent(idProduitLibValue)
            + "&idMagasin=" + encodeURIComponent(idMagasin)


        var exportButton = document.getElementById("export-btn");
        exportButton.href = exportUrl;
    }

</script>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



