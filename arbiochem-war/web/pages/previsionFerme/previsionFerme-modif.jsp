<%@page import="prevision.*"%>
<%@page import="affichage.*"%>
<%@page import="user.*"%>
<%@ page import="previsionFerme.PrevisionFerme" %>
<%@ page import="magasin.Magasin" %>
<% try {
    UserEJB user = (UserEJB) session.getAttribute("u");
    PrevisionFerme prevision = new PrevisionFerme();
    String id = request.getParameter("id");
    PageUpdate pageUpdate = new PageUpdate( prevision, request, user );
    pageUpdate.setTitre("Modification de la pr&eacute;vision");
    String lien = (String) session.getAttribute("lien");
    pageUpdate.setLien(lien);
    prevision = (PrevisionFerme) pageUpdate.getBase();
    Liste[] liste = new Liste[1];
    Magasin magasin = new Magasin();
    magasin.setNomTable("magasin2");
    liste[0] = new Liste("idMagasin", magasin, "val", "id" ," and actif = 1");
    pageUpdate.getFormu().changerEnChamp(liste);
    pageUpdate.getFormu().getChamp("sortie").setLibelle("Sortie");
    pageUpdate.getFormu().getChamp("daty").setLibelle("date");
    pageUpdate.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
    pageUpdate.getFormu().getChamp("entree").setLibelle("Entr&eacute;e");
    pageUpdate.getFormu().getChamp("etat").setVisible(false);
    pageUpdate.getFormu().getChamp("idMvtStockFille").setVisible(false);
    pageUpdate.getFormu().getChamp("idTiers").setLibelle("Tiers");
    pageUpdate.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pageUpdate.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pageUpdate.getFormu().getChamp("idProduit").setLibelle("Produit");
    pageUpdate.getFormu().getChamp("idTiers").setPageAppelComplete("pertegain.Tiers","id","tiers");
    pageUpdate.getFormu().getChamp("idProduit").setPageAppelComplete("produits.IngredientsLib","id","ST_INGREDIENTSAUTO");
    pageUpdate.getFormu().getChamp("idOrigine").setVisible(false);

    if (prevision.isSortie()) {
        pageUpdate.getFormu().getChamp("entree").setVisible(false);
    } else {
        pageUpdate.getFormu().getChamp("sortie").setVisible(false);
    }
    pageUpdate.preparerDataFormu();
    String classe = "previsionFerme.PrevisionFerme";
    String bute = "previsionFerme/previsionFerme-fiche.jsp";
    String nomTable = "PREVISIONFERME";

%>
<style>
    .col-md-12.cardradius.input-container {
        border: none;
        border-top: none !important;
        padding: 0;
        margin-bottom: 20px;
    }
    .col-md-12.mb-5.import-input {
        display: none;
    }
    .box-footer {
        border-top: none;
    }
</style>
<div class="content-wrapper">
    <h1 class="box-title">
        <a href="<%= lien + "?but=previsionFerme/previsionFerme-fiche.jsp&id=" + id %>">
            <i class="fa fa-arrow-circle-left"></i>
        </a>
        <%= pageUpdate.getTitre() %>
    </h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%= id %>" method="post">
                        <%
                            out.println(pageUpdate.getFormu().getHtmlInsert());
                        %>
                        <div class="row">
                            <div class="col-md-12">
                                <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                            </div>
                            <br><br>
                        </div>
                        <input name="acte" type="hidden" id="acte" value="update">
                        <input name="bute" type="hidden" id="bute" value="<%= bute %>">
                        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
                        <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%= id %>" >
                        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>