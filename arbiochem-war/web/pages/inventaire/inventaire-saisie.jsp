<%@page import="inventaire.InventaireFille"%>
<%@page import="inventaire.Inventaire"%>
<%@page import="stock.TypeMvtStock"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@page import="magasin.Magasin"%>
<%@page import="annexe.Point"%>
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="stock.MvtStockFilleLib" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = u = (UserEJB) session.getValue("u");
        String classeMere = "inventaire.Inventaire",
                classeFille = "inventaire.InventaireFille",
                titre = "Saisie inventaire",
                redirection = "inventaire/inventaire-fiche.jsp";
        String colonneMere = "idInventaire";
        int taille = 10;
        String idMvtStockFille = request.getParameter("idmvtstockfille");
        String acte = request.getParameter("acte");
        String id =request.getParameter("id");

        ClassMAPTable[] var = (ClassMAPTable[]) session.getAttribute("resultat");
        if (var != null && var.length > 0) {
            taille = var.length;
        }

        Inventaire mere = new Inventaire();
        mere.setNomTable("Inventaire");
        InventaireFille fille = new InventaireFille();
        fille.setNomTable("InventaireFille");
        if(request.getParameter("acte") != null && !request.getParameter("acte").equals("")){
            fille.setNomTable("INVENTAIREFILLEAUTOCOMPLETE");
        }
        if(acte!=null&&acte.equalsIgnoreCase("update")){
            fille.setNomTable("inventairefilleupdate");
        }

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setLien((String) session.getValue("lien"));

        if((idMvtStockFille!=null&&idMvtStockFille.compareToIgnoreCase("")!=0)||(acte==null&&id!=null&&id.startsWith("MVTSFI"))){
            if(id!=null)idMvtStockFille=id;
            MvtStockFilleLib mvtStockFille = (MvtStockFilleLib) new MvtStockFilleLib().getById(idMvtStockFille, "mvtstockfillelib", null);
            if(mvtStockFille!=null){
                Inventaire inv = mvtStockFille.genererInventaire();
                pi.getFormu().setDefaut(inv);
                pi.setDefautFille(inv.getFille());
            }
        }


        Liste[] liste = new Liste[1];

        Magasin cat= new Magasin();
        cat.setNomTable("magasinpoint");
        liste[0] = new Liste("idMagasin", cat, "val", "id");
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("heure").setLibelle("Heure");
        pi.getFormu().getChamp("heure").setDefaut(Utilitaire.heureCouranteHMS());
        pi.getFormu().getChamp("daty").setEstMoitier(true);
        pi.getFormu().getChamp("heure").setEstMoitier(true);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idCategorie").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");


        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("explication_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("idFournisseur_0").setLibelle("Fournisseur");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("mvtsrc_0").setLibelle("Mouvement Source");
        pi.getFormufle().getChamp("daty_0").setLibelle("Date d'entr&eacute;e");

        Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idInventaire"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idFournisseur"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("daty"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("quantiteTheorique"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idJauge"),false);
        Champ.setAutre(pi.getFormufle().getChampFille("quantiteTheorique"),"readonly");

        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idInventaire"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("daty"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idFournisseur"),false);
        if(request.getParameter("acte") == null ) {
            affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"), false);
        }

        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTO","pu","pu");

        affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("mvtsrc"),"stock.MvtStockEntreeAvecReste","id","v_etatstock_entree_standard","pu","pu"," ");
        String idMag = "";
        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
            String apr = "";
            idMag = request.getParameter("idMagasin");
            if(!Utilitaire.champNull(idMag).isEmpty()){
                apr = " AND idmagasin='"+idMag+"'";
            }
            affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("mvtSrc"),"stock.MvtStockEntreeAvecReste","id","v_etatstock_entree_standard","reference","reference",apr);
        }
        pi.getFormufle().setPageActuelle("pages/module.jsp?but=inventaire/inventaire-saisie.jsp");
        pi.getFormufle().setClasseFille("inventaire.InventaireFille");

        if (var != null && var.length > 0) {
            pi.setDefautFille(var);
        }
        session.removeAttribute("resultat");


        String[] ordre = {"id", "daty", "heure", "designation", "idMagasin", "remarque", "etat", "idCategorie"};
        String[] colOrdreFille = {"idProduit", "explication", "quantite", "pu", "mvtsrc"};
        pi.getFormufle().setColOrdre(colOrdreFille);
        pi.getFormu().setOrdre(ordre);
        pi.preparerDataFormu();

//        pi.getFormufle().setNbLigne(5);
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());

            %>
        </div>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value="inventairefille">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>



<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
