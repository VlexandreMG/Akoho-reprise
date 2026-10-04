<%@page import="magasin.Magasin"%>
<%@page import="annexe.Categorie"%>
<%@page import="annexe.Point"%>
<%@page import="stock.TypeMvtStock"%>
<%@page import="stock.TransfertStockDetails"%>
<%@page import="stock.TransfertStock"%>
<%@page import="stock.EtatStockParEntree"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="fabrication.Of" %>
<%@ page import="demande.DemandeTransfert" %>
<%@ page import="vente.Vente" %>
<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = u = (UserEJB) session.getValue("u");
        String classeMere = "stock.TransfertStock",
               classeFille = "stock.TransfertStockDetails",
               titre = "Saisie de transfert de stock",
			   redirection = "stock/transfertstock/transfertstock-fiche.jsp";
        String colonneMere = "idTransfertStock";

        if(request.getParameter("acte")!=null){
            titre = "Modification du transfert de stock";
        }

        int taille = 10;
        String idOf = request.getParameter("idOf");
        String idMagasin = request.getParameter("idMagasin");
        String[] ids = request.getParameterValues("ids");
        TransfertStock preRempli = null;
        if (idOf != null && !idOf.isEmpty()) {
            Of of = new Of();
            of.setId(idOf);
            if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
                String idMagasinDepart = request.getParameter("idMagasinDepart");
                String idMagasinArrive = request.getParameter("idMagasinArrive");
                preRempli = of.genererTransfertStock(idMagasinDepart, idMagasinArrive,null);
            }else{
                preRempli = of.genererTransfertStock(null);
            }

            if (preRempli != null && preRempli.getFille() != null && preRempli.getFille().length > 0) {
                taille = preRempli.getFille().length >=10 ? (preRempli.getFille().length + 3) : 10;
            }

        }

        String idfc_client = request.getParameter("idfc_client");
        if (idfc_client != null && !idfc_client.isEmpty()) {
            Vente vente = new Vente();
            vente.setId(idfc_client);

            preRempli = vente.genererTransfertStock(null);


            if (preRempli != null && preRempli.getFille() != null && preRempli.getFille().length > 0) {
                taille = preRempli.getFille().length >=10 ? (preRempli.getFille().length + 3) : 10;
            }

        }

        String idDemandeTransfert = request.getParameter("idDemande");
        if (idDemandeTransfert != null && !idDemandeTransfert.isEmpty()) {
            DemandeTransfert dm = new DemandeTransfert();
            dm.setId(idDemandeTransfert);
            if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
                String idMagasinDepart = request.getParameter("idMagasinDepart");
                String idMagasinArrive = request.getParameter("idMagasinArrive");
                preRempli = dm.genererTransfertStock(idMagasinDepart, idMagasinArrive,null);
            }else{
                preRempli = dm.genererTransfertStock(null);
            }

            if (preRempli != null && preRempli.getFille() != null && preRempli.getFille().length > 0) {
                taille = preRempli.getFille().length >=10 ? (preRempli.getFille().length + 3) : 10;
            }
        }

        TransfertStock mere = new TransfertStock();
        mere.setNomTable("TransfertStock");
        TransfertStockDetails fille = new TransfertStockDetails();
        fille.setNomTable("TransfertStockDetails");
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("etat").setVisible(false);
        if(idMagasin!=null&&!idMagasin.isEmpty()){
            pi.getFormu().getChamp("idMagasinDepart").setDefaut(idMagasin);
        }
        if(ids!=null&&ids.length>0){
            TransfertStockDetails[] trsf = EtatStockParEntree.toTransfertStock(null,ids);
            if(trsf!=null&&trsf.length>0)pi.setDefautFille(trsf);
        }
        Liste[] liste = new Liste[2];
        Magasin m1 = new Magasin();
        m1.setNomTable("magasinpoint");

        Magasin m2 = new Magasin();
        m2.setNomTable("magasinpoint");

        liste[0] = new Liste("idMagasinDepart", m1, "val", "id");
        liste[1] = new Liste("idMagasinArrive", m2, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        String[] order = {"daty"};
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("isvente").setVisible(false);
        pi.getFormu().getChamp("idMagasinDepart").setLibelle("Magasin de d&eacute;part");
        pi.getFormu().getChamp("idMagasinArrive").setLibelle("Magasin d'arriv&eacute;e");
        pi.getFormu().getChamp("idDemandeTransfert").setLibelle("Demande transfert");
        pi.getFormu().getChamp("idDemandeTransfert").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idDemandeTransfert").setPageAppelComplete("demande.DemandeTransfert","id","demandetransfert");
        pi.getFormu().setOrdre(order);
        if(idOf != null && !idOf.isEmpty()){
            pi.getFormu().getChamp("idMagasinArrive").setAutre("onchange=\"updateFille(event, 'formId')\"");
        }
        if(idDemandeTransfert != null && !idDemandeTransfert.isEmpty()){
            Champ.setDefaut(pi.getFormufle().getChampFille("idDemandeTransfert"),idDemandeTransfert);
        }
        pi.getFormu().getChamp("idMagasinDepart").setAutre("onchange=\"updateFille(event, 'formId')\"");
        pi.getFormu().getChamp("idOf").setLibelle("Ordre de Fabrication Relatif");
        pi.getFormu().getChamp("idOf").setPageAppelComplete("fabrication.Of", "id", "OFAB");
        if(request.getParameter("idOf")!=null && !request.getParameter("idOf").isEmpty()) {
            pi.getFormu().getChamp("idOf").setValeur(idOf);
        }
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTO","pu;compte_vente;libelle","pu;compte;remarque");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idsource"),"stock.MvtStockEntreeAvecReste","id","v_etatstock_entree_standard","pu","pu");
        if (preRempli != null ) {
            String idDEpart = preRempli.getIdMagasinDepart();
            String con = "";
            if(!Utilitaire.champNull(idDEpart).isEmpty()){
                con += " and idmagasin = '" + idDEpart + "'";
            }
            affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idsource"),"stock.EtatStockParEntreeStandard","id","v_etatstock_entree_standard","pu","pu",con);
        }
        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("quantite_0").setLibelle("quantit&eacute;");
        pi.getFormufle().getChamp("idSource_0").setLibelle("Mouvement source");
        pi.getFormufle().getChamp("remarque_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("idFournisseur_0").setLibelle("Fournisseur");
        pi.getFormufle().getChamp("daty_0").setLibelle("Date");
        Champ.setVisible(pi.getFormufle().getChampFille("idFournisseur"),false);
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idFournisseur"), "faturefournisseur.Fournisseur","id","fournisseur");

        if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
//            idDemandeTransfert = request.getParameter("idDemandeTransfertlibelle");
//            if(!Utilitaire.champNull(idDemandeTransfert).isEmpty()){
//                DemandeTransfert dm = new DemandeTransfert();
//                dm.setId(idDemandeTransfert);
//                String idMagasinDepart = request.getParameter("idMagasinDepart");
//                String idMagasinArrive = request.getParameter("idMagasinArrive");
//                preRempli = dm.genererTransfertStock(idMagasinDepart, idMagasinArrive,null);
//            }
            String idDEpart = request.getParameter("idMagasinDepart");
            String con = "";
            if(!Utilitaire.champNull(idDEpart).isEmpty()){
                con += " and idmagasin = '" + idDEpart + "'";
            }
            affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idsource"),"stock.EtatStockParEntreeStandard","id","v_etatstock_entree_standard","pu","pu",con);
        }

        Champ.setVisible(pi.getFormufle().getChampFille("idTransfertStock"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("daty"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        Champ.setVisible(pi.getFormufle().getChampFille("idFournisseur"),false);
//        Champ.setVisible(pi.getFormufle().getChampFille("daty"),false);
        Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idFournisseur"),"faturefournisseur.Fournisseur","id","fournisseur");

        pi.getFormufle().setColOrdre(new String[]{"idProduit","remarque","quantite","pu","idSource"});
        if(preRempli!=null){
            pi.setDefautFille(preRempli.getFille());
            pi.getFormu().setDefaut(preRempli);
        }


       // affichage.Champ.setAutoCompleteDependante(pi.getFormufle().getChampFille("idProduit"), pi.getFormufle().getChampFille("idsource"), "stock.MvtStockEntreeAvecReste", "V_ETATSTOCK_ENTREE", "idProduit", "pu", "pu");

        pi.preparerDataFormu();

//        pi.getFormufle().setNbLigne(5);

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<style>
        .col-md-12.cardradius {
        margin-bottom: 20px;
    }

</style>
<div class="content-wrapper" >
    <h1><%=titre%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div class="">
            <h3 class="h329pxBold">Détails du transfert de stock</h3>
        </div>
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= taille %>">
        </div>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="classefille" value="TransfertStockDetails">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert("<%=e.getMessage()%>");
        history.back();
    </script>
<% }%>
