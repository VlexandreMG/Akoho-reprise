<%--
    Document   : etatcaisse-liste
    Created on : 2 avr. 2024, 10:11:22
    Author     : 26134
--%>


<%@page import="produits.CategorieIngredient"%>
<%@page import="utils.ConstanteStation"%>
<%@page import="stock.PageRechercheEtatStock"%>
<%@page import="stock.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Unite"%>
<%@page import="affichage.Liste"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    Magasin mag = u.getMagasin();
    EtatStockParEntree t = new EtatStockParEntree();
    String listeCrt[] = {"id","idProduit","idProduitLib","idMagasin","idTypeProduitLib","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","idProduit","idProduitLib","idUniteLib","idFournisseurLib","idTypeProduitLib","idMagasinLib","invquantite","invdaty","daty","entree","sortie","reste","pu","montantReste"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(mag != null){
        pr.setAWhere("AND IDMAGASIN='"+mag.getId()+"'");
    }
    pr.setTitre("Etat de stock par entr&eacute;e");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/etatstock/etatstock-liste-pu.jsp");

    Liste[] dropDowns = new Liste[1];
    Magasin m = new Magasin();
    m.setNomTable("magasinpoint");
    dropDowns[0] = new Liste("idMagasin", m, "val", "id");

    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("daty1").setDefaut("01/01/2001");
    pr.getFormu().getChamp("daty1").setVisible(false);
    pr.getFormu().getChamp("daty1").setLibelle("-");
    pr.getFormu().getChamp("daty2").setLibelle("Date");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idProduitLib").setLibelle("Produit");
    pr.getFormu().getChamp("idProduit").setLibelle("Id produit");
    pr.getFormu().getChamp("idTypeProduitLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("id").setLibelle("ID Mouvement de stock");
    if(mag != null){
        pr.getFormu().getChamp("idMagasin").setAutre("disabled");
        pr.getFormu().getChamp("idMagasin").setDefaut(mag.getId());
    }
    String[] colSomme = {"invquantite","entree","sortie","reste","montantReste"};
    pr.creerObjetPage(libEntete, colSomme);

//    pr.getFormu().setAnotherButton(
//        "                <a id='export-btn-excel' class='btn btn-secondary btn-small btn-bg-white' href='#' onclick='exportExcel()'>\n" +
//        "                    <i class='material-symbols-rounded'>download</i> Exporter en excel\n" +
//        "                </a>"
//    );

    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idProduit"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    String[] enteteRecap = {"","Nombre","Somme inventaire","Somme des entr&eacute;es","Somme des sorties","Somme des restes", "Somme des Montants Restant"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    //Definition des libelles à afficher

    String libEnteteAffiche[] = {"ID Mouvement de stock ","ID Produit","Produit","Unit&eacute;","Fournisseur","Cat&eacute;gorie","Magasin","Quantit&eacute; d&rsquo;inventaire","Date d&rsquo;inventaire","date entree","entr&eacute;e","sortie","reste","Prix unitaire","Montant restant"};
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
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<script>
    function exportExcel() {
        var idValue = document.getElementById("id").value;
        var idProduitValue = document.getElementById("idProduit").value;
        var idProduitLibValue = document.getElementById("idProduitLib").value;
        var idMagasinValue = document.getElementById("idMagasin").value;
        var idTypeProduitLibValue = document.getElementById("idTypeProduitLib").value;
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var awhere = "<%= pr.getAWhere() %>";
        var selectMagasin = document.getElementById("idMagasin");
        var libelleMagasin = selectMagasin.options[selectMagasin.selectedIndex].text;



        var exportUrl = "${pageContext.request.contextPath}/ExportExcel?action=etat_stock"
            + "&id=" + encodeURIComponent(idValue)
            + "&idProduit=" + encodeURIComponent(idProduitValue)
            + "&idProduitLib=" + encodeURIComponent(idProduitLibValue)
            + "&idMagasin=" + encodeURIComponent(idMagasinValue)
            + "&idTypeProduitLib=" + encodeURIComponent(idTypeProduitLibValue)
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&awhere=" + encodeURIComponent(awhere)
            + "&idMagasinLib=" + encodeURIComponent(libelleMagasin)

        var exportButton = document.getElementById("export-btn-excel");
        exportButton.href = exportUrl;
    }
    document.getElementById("export-btn-excel").addEventListener("click", exportExcel);
</script>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



