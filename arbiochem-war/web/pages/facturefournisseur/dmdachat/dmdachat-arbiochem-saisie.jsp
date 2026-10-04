<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 10/08/2026
  Time: 22:41
  To change this template use File | Settings | File Templates.
--%>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="faturefournisseur.*"%>
<%@ page import="magasin.Magasin" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="maintenance.travaux.TravauxCpl" %>
<%@ page import="affichage.Champ" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>
<%@ page import="prevision.Service" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        DmdAchat mere = new DmdAchat();
        DmdAchatFille fille = new DmdAchatFille();
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] listes = new Liste[4];
        Magasin magasin = new Magasin();
        magasin.setNomTable("MAGASIN2");
        listes[0] = new Liste("idMagasin", magasin, "val", "id");
        listes[0].setApresW(" and actif = 1");
        CategorieIngredient categorieIngredient = new CategorieIngredient();
        categorieIngredient.setNomTable("CATEGORIEINGREDIENTLIB_ACHT");
        listes[1] = new Liste("idCategorie", categorieIngredient, "val", "id");
        listes[2] = new Liste("service",new TypeObjet("DEPARTEMENT"),"val","id");
        listes[2].setApresW(" and Actif = 1");
        TypeObjet prov = new TypeObjet();
        prov.setNomTable("PROVENANCE");
        listes[3] = new Liste("idProvenance", prov, "val", "id");

        pi.getFormu().changerEnChamp(listes);

        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("service").setLibelle("D&eacute;partement");
        pi.getFormu().getChamp("fournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("fournisseur").setPageAppelCompleteAWhere("faturefournisseur.Fournisseur","id","Fournisseur", "", "", " and estActif = 1");
        pi.getFormu().getChamp("fournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","fournisseur;fournisseurlibelle","id;nom");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("dateLimite").setLibelle("Date limite de livraison");
        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("idProvenance").setLibelle("Provenance");
        pi.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");
        pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idproduit"),"annexe/produit/produit-saisie.jsp","id;val");
        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
            String idMagasin = request.getParameter("idMagasin");
            String con = "";
            if(!Utilitaire.champNull(idMagasin).isEmpty()){
                con += " and idmagasin = '" + idMagasin + "'";
            }
            //affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idProduit"),"stock.MvtStockEntreeAvecReste","idProduit","V_ETATSTOCK_ENTREE_DMDACHAT","idProduitLib;pu;quantite","designation;pu;qtestock",con);
        }
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","idproduit","AS_INGREDIENTS_LIB_ACHAT","id;libelle;pu","idproduit;designation;pu");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("idproduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("qtestock_0").setLibelle("Quantit&eacute; en stock");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
        // pi.getFormufle().getChamp("qtestock").setAutre("readonly");

//        for(int i=0; i<pi.getNombreLigne(); i++){
//            pi.getFormufle().getChamp("qtestock_" + i).setAutre("readonly");
//        }

        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idmere").setVisible(false);
        pi.getFormufle().getChampMulitple("pu").setVisible(false);
        pi.getFormufle().getChampMulitple("qtestock").setVisible(false);
        pi.getFormufle().getChampMulitple("tva").setVisible(false);
        pi.getFormufle().getChampMulitple("quantite").setAutre("onChange='calculerMontant()'");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("quantite"),"0");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tva"),"0");

        String titre = "Saisie demande d'achat";

        String idTravaux = request.getParameter("idTravaux");
        if(idTravaux!=null && !idTravaux.equals("")){
            titre = "Demande de service externe";
            TravauxCpl[] travauxCpls = (TravauxCpl[]) CGenUtil.rechercher(new TravauxCpl(), null, null, " and id = '"+idTravaux+"'");
            if(travauxCpls.length!=0){
                Champ.setVisible(pi.getFormufle().getChampFille("qtestock"), false);
                affichage.Champ.setAutre(pi.getFormufle().getChampFille("idproduit"),"readonly");
                pi.getFormufle().getChamp("quantite_0").setDefaut("1");
                pi.getFormu().getChamp("idObjet").setDefaut(idTravaux);
                pi.getFormu().getChamp("dateLimite").setDefaut(Utilitaire.datetostring(travauxCpls[0].getBesoin()));
                affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","idproduit","AS_INGREDIENTS_LIB_ACHAT","id;libelle;pu","idproduit;designation;pu");
                pi.getFormufle().getChamp("idproduit_0").setDefaut(ConstanteMaintenance.produitServiceExterne);
                titre = "Demande de service externe";
                pi.setNombreLigne(1);
            }
        }else {
            //affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idproduit"),"annexe/produit/produit-saisie.jsp","id;val");
            //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"stock.MvtStockEntreeAvecReste","idproduit","V_ETATSTOCK_ENTREE_DMDACHAT","idProduitLib;pu;quantite","designation;pu;qtestock");
            affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","idproduit","AS_INGREDIENTS_LIB_ACHAT","id;libelle;pu","idproduit;designation;pu");
        }

        pi.getFormu().getChamp("idObjet").setVisible(false);

        pi.preparerDataFormu();

        String classeMere = "faturefournisseur.DmdAchat";
        String classeFille = "faturefournisseur.DmdAchatFille";
        String butApresPost = "facturefournisseur/dmdachat/dmdachat-arbiochem-fiche.jsp";
        String colonneMere = "idmere";

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
        System.out.println("Titre = "+titre);
%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    <div class="box-body">
        <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
            %>

            <div id="butfillejsp">
                <%
                    out.println(pi.getFormufle().getHtmlTableauInsert());
                %>

                <input name="acte" type="hidden" id="nature" value="insert">
                <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
                <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
                <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
                <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
                <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
                <input name="nomtable" type="hidden" id="nomtable" value="DMDACHATFILLE">
            </div>
        </form>
    </div>
</div>
</div>
<script>
    $(document).ready(function () {
        var lignes = <%=pi.getNombreLigne()%>
        for (let i = 0; i < lignes; i++) {
            calculerMontant(i);
        }
    });
    function calculerMontant() {
        var val = 0;
        $('input[id^="quantite_"]').each(function() {
            var quantite =  parseFloat($("#"+$(this).attr('id').replace("quantite","pu")).val());
            var montant = parseFloat($(this).val());
            if(!isNaN(quantite) && !isNaN(montant)){
                var value =quantite * montant;
                val += value;
            }
        });
        $("#montanttotal").html(val.toFixed(2));
    }
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
