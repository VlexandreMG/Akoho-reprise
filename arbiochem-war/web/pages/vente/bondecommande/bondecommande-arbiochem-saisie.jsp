<%--
    Document   : bondecommande-saisie
    Created on : 17 juil. 2024, 16:27:57
    Author     : micha
--%>


<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="vente.*"%>
<%@page import="bean.UnionIntraTable"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="java.util.Calendar"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageInsert"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@page import="annexe.Unite"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="client.Client" %>
<%@ page import="utils.ConstanteSocobis" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="produits.TarifIngredients" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="proforma.*" %>
<%@ page import="client.ClientArbiochem" %>
<%
    boolean carteExpiree = false;
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    BonDeCommande mere = new BonDeCommande();
    BonDeCommandeFIlleCplArbiochem fille = new BonDeCommandeFIlleCplArbiochem();
    fille.setNomTable("BONDECOMMANDE_CLIENT_FILLE_V");
    int nombreLigne = 10;
        String idProforma = request.getParameter("idProforma");
        ProformaArbichem proforma = null;
        ProformaDetailsLibArbiochem[] proformaDetails = null;
        BonDeCommande bcFromProforma = null;

        if (idProforma != null && !idProforma.trim().isEmpty()) {
            proforma = new ProformaArbichem();
            proforma.setId(idProforma);
            bcFromProforma = proforma.createBonDeCommande();
            proformaDetails = proforma.getFilleProformaLib2();
            if (proformaDetails != null && proformaDetails.length > nombreLigne) {
                nombreLigne = proformaDetails.length;
            }
        }

        String idCommande = request.getParameter("idCommande");
        Commande commande = null;
        CommandeFIlleCpl[] commandeDetails = null;
        BonDeCommande bcFromCommande = null;

        if (idCommande != null && !idCommande.trim().isEmpty()) {
            commande = new Commande();
            commande.setId(idCommande);
            bcFromCommande = commande.createBonDeCommande();
            commandeDetails = commande.getFilleCommandeLib();
            if (commandeDetails != null && commandeDetails.length > nombreLigne) {
                nombreLigne = commandeDetails.length;
            }
        }


    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("dateBesoin").setVisible(false);
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("idClient").setLibelle("Client");
    pi.getFormu().getChamp("idClient").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idDevise").setVisible(false);
    pi.getFormu().getChamp("numeroBc").setVisible(false);
    pi.getFormu().getChamp("idDevise").setDefaut("AR");
    pi.getFormu().getChamp("idProforma").setAutre("readonly");
    pi.getFormu().getChamp("fraislivraison").setLibelle("Frais de livraison(Par Kg)");
    pi.getFormu().getChamp("fraislivraison").setVisible(false);
    pi.getFormu().getChamp("fraislivraison").setDefaut("0");
    pi.getFormu().getChamp("fraislivraison").setAutre("onchange=\"recalculerTousLesMontants()\"");
    pi.getFormu().getChamp("idProforma").setLibelle("ID Proforma");
    pi.getFormu().getChamp("modelivraison").setLibelle("Mode de livraison");
    pi.getFormu().getChamp("lieuLivraison").setLibelle("Lieu de livraison");
    pi.getFormu().getChamp("dateLivraison").setLibelle("Date de livraison");

    Liste[] liste = new Liste[3];
    ModePaiement mp = new ModePaiement();
    liste[0] = new Liste("modepaiement",mp,"val","id");
    //liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
    //liste[1].setDefaut("AR");
    //liste[1].setLibelle("Devise");
    //liste[1].setLibelle("Devise");
        Magasin m = new Magasin();
        m.setNomTable("MagasinVente");
    liste[1] = new Liste("idMagasin",m,"val","id");
    liste[1].setLibelle("Magasin");

    Liste listemode = new Liste("modelivraison");

    String [] affVal = new String[2];
    String [] aff = new String[2];
    aff = new String[]{"LIVRAISON","RECUPERATION"};
    affVal = new String[]{"1","2"};

    listemode.ajouterValeur(affVal,aff);
    liste[2] = listemode;

    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("idMagasin").setDefaut(ConstanteSocobis.MAGASIN);
    String [] ordre = {"daty","designation","remarque","reference","idDevise","idMagasin","idClient","modepaiement"};
    pi.getFormu().setOrdre(ordre);
    pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
    pi.getFormu().getChamp("modelivraison").setLibelle("Mode de livraison");
    //pi.getFormu().getChamp("fournisseur").setPageAppel("choix/fournisseur/fournisseur-choix.jsp","fournisseur;fournisseurlibelle");
    pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","CLIENT_ACTIF");
    pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
    affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngredientVente","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;idunitelib;tva","pu;compte;designation;unite;uniteLib;tva"," AND 1>2");

        double tva = 0.0;
    String acte=request.getParameter("acte");
    String idC = request.getParameter("id");

    //Nommage et visibilite

    for (int i = 0; i < nombreLigne; i++) {
        pi.getFormufle().getChamp("quantite_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("remise_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("ristourne_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("tva_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("pu_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("remiseArbiochem_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("ristourneArbiochem_"+i).setAutre("onChange='calculerMontant("+i+")'");
        //pi.getFormufle().getChamp("tva_"+i).setDefaut("20");
        pi.getFormufle().getChamp("produit_" + i).setLibelle("Produit");
        pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
        pi.getFormufle().getChamp("unite_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("unitelib_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("tva_"+i).setDefaut(tva+"");
        pi.getFormufle().getChamp("punet_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("montantht_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("montantttc_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("calorie_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
    }

    //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("produit").getListeChamp(), "produits.IngredientsLib", "id", "as_ingredients_lib", "pv;tva;unite","pu;tva;unite");



    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
    pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
    pi.getFormufle().getChamp("tva_0").setLibelle("TVA (En %)");
    pi.getFormufle().getChamp("remise_0").setLibelle("Remise (En %)");
    pi.getFormufle().getChamp("ristourne_0").setLibelle("Ristourne (En %)");
    pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
    pi.getFormufle().getChamp("punet_0").setLibelle("PU Net");
    pi.getFormufle().getChamp("montantht_0").setLibelle("Montant HT");
    pi.getFormufle().getChamp("montantttc_0").setLibelle("Montant TTC");
    pi.getFormufle().getChamp("calorie_0").setLibelle("Poids en Kg");
        pi.getFormufle().getChamp("remiseArbiochem_0").setLibelle("Montant Remise");
        pi.getFormufle().getChamp("ristourneArbiochem_0").setLibelle("Montant Ristourne");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idDevise"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idbc"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("montant"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("unite"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("calorie"),false);
//        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("calorie"), "0");
    //affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tva"), "20");
//    pi.getFormufle().getChampMulitple("unite").setVisible(false);
    //pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
    pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");

    BonDeCommande ocr = (BonDeCommande) session.getAttribute("ocr");
    if(ocr!=null){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate localDate = ocr.getDaty().toLocalDate();
        String formattedDate = localDate.format(formatter);
        pi.getFormu().getChamp("designation").setDefaut(ocr.getDesignation());
        pi.getFormu().getChamp("daty").setDefaut(formattedDate);
        if(ocr.getIdClient()!=null){
            pi.getFormu().getChamp("idClient").setDefaut(ocr.getIdClient());
        }
        if(ocr.getIdMagasin()!=null){
            pi.getFormu().getChamp("idMagasin").setDefaut(ocr.getIdMagasin());
        }
        pi.setDefautFille(ocr.getFille());
    }
    session.removeAttribute("ocr");
        BonDeCommande prerempli = null;
        String message = "";
         idProforma = request.getParameter("idProforma");
        if (idProforma != null && !idProforma.trim().isEmpty()) {
            pi.getFormu().getChamp("idProforma").setDefaut(request.getParameter("idProforma"));
            //pi.getFormu().getChamp("idMagasin").setAutre("disabled");
             proforma = new ProformaArbichem();
            proforma.setId(idProforma);
            BonDeCommande bc = proforma.createBonDeCommande();
            ProformaDetailsLibArbiochem[] details = proforma.getFilleProformaLib2();
            ClientArbiochem clientArbiochem = new ClientArbiochem();
            clientArbiochem.setId(proforma.getIdClient());
            message = clientArbiochem.message();
            System.out.println("1        " + message);
            if (details != null && details.length > 0) {
                BonDeCommandeFIlleCplArbiochem[] lignes = new BonDeCommandeFIlleCplArbiochem[details.length];
                for (int i = 0; i < details.length; i++) {
                    ProformaDetailsLibArbiochem detail = details[i];
                    lignes[i] = detail.createBonDeCommandeFilleLib();
                }
                pi.setDefautFille(lignes);
            }
            pi.getFormu().setDefaut(bc);
            pi.getFormu().getChamp("idMagasin").setDefaut(bc.getIdMagasin());
        }

         idCommande = request.getParameter("idCommande");
        if (idCommande != null && !idCommande.trim().isEmpty()) {
            pi.getFormu().getChamp("idProforma").setDefaut(request.getParameter("idCommande"));
             commande = new Commande();
            commande.setId(idCommande);
            prerempli = commande.createBonDeCommande();
            CommandeFIlleCpl[] details =commande.getFilleCommandeLib();
            if (details != null && details.length > 0) {
                BonDeCommandeFIlleCpl[] lignes = new BonDeCommandeFIlleCpl[details.length];
                for (int i = 0; i < details.length; i++) {
                    CommandeFIlleCpl detail = details[i];
                    lignes[i] = detail.createBonDeCommandeFilleCpl();
                }
                pi.setDefautFille(lignes);
            }
            pi.getFormu().setDefaut(prerempli);
            pi.getFormu().getChamp("idMagasin").setDefaut(prerempli.getIdMagasin());
        }

        if ( (idProforma != null && !idProforma.trim().isEmpty()) || prerempli!=null || ((request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true"))||(acte!=null&&acte.compareToIgnoreCase("update")==0&&idC!=null&&idC.compareToIgnoreCase("")!=0))){
            String idmagasin = request.getParameter("idMagasin");
            if(request.getParameter("idMagasin") != null && !request.getParameter("idMagasin").isEmpty()){
                session.setAttribute("idMagasin", request.getParameter("idMagasin"));
            }
            if(idmagasin == null || idmagasin.isEmpty()){
                idmagasin = (String) session.getAttribute("idMagasin");
            }
            Client c = null;
            if(request.getParameter("idClientlibelle")!=null && request.getParameter("idClientlibelle").split(" - ").length>0){
                String idclient = request.getParameter("idClientlibelle").split(" - ")[0];
                c = (Client)new Client().getById(idclient,"client",null);
                Calendar cal = Calendar.getInstance();
                if(c.getDatecarte()!=null){
                    cal.setTime(c.getDatecarte());
                    cal.add(Calendar.YEAR, 1);
                    Date dateCartePlusUnAn = cal.getTime();
                    Date dateAujourdhui = new Date();
                    carteExpiree = dateAujourdhui.compareTo(dateCartePlusUnAn) >= 0;
                }
                ClientArbiochem clientArbiochem = new ClientArbiochem();
                clientArbiochem.setId(c.getId());
                message = clientArbiochem.message();
                System.out.println("2        " + message);

                tva = c.getTaxe();
                session.setAttribute("idclient", idclient);
            }else{
                c = (Client)new Client().getById((String) session.getAttribute("idclient"),"client",null);
                ClientArbiochem clientArbiochem = new ClientArbiochem();
                clientArbiochem.setId(c.getId());
                message = clientArbiochem.message();
                System.out.println("3        " + message);

                tva = c.getTaxe();
            }
            String awhere = " AND IDTYPECLIENT='"+c.getIdTypeClient()+"'";
            if(idmagasin != null){
                TarifIngredients rechercheTarif = new TarifIngredients();
                rechercheTarif.setNomTable("TARIF_INGREDIENTS_MAX");
                rechercheTarif.setIdMagasin(idmagasin);
                TarifIngredients[] tarifs = (TarifIngredients[]) CGenUtil.rechercher(rechercheTarif, null, null, null, "");
                if (tarifs.length > 0){
                    //awhere += " AND TARIFMAGASIN='"+idmagasin+"'";
                }
                else {
                    //awhere += " AND TARIFMAGASIN IS NULL";
                }
            }
            else {
                //awhere += " AND TARIFMAGASIN IS NULL";
            }
            affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngreventVenteTarif","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;idunitelib;tva;calorie","pu;compte;designation;unite;uniteLib;tva;calorie", awhere);
        }else{
            session.removeAttribute("idMagasin");
            session.removeAttribute("idclient");
        }

      String[] colOrdre = {"id","produit","designation","calorie","unitelib","quantite","pu","remise","remiseArbiochem", "ristourne","ristourneArbiochem","punet","tva","montantht","montantttc","idDevise","unite"};
      pi.getFormufle().setColOrdre(colOrdre);


    //Variables de navigation
    String classeMere = "vente.BonDeCommande";
    String classeFille = "vente.BonDeCommandeFilleArbiochem";
    String butApresPost = "vente/bondecommande/bondecommande-arbiochem-fiche.jsp";
    String colonneMere = "idbc";
    //Preparer les affichages
     pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <%
        if (request.getParameter("acte")!=null && request.getParameter("acte")!=""){
            out.println("<h1>Modification d&rsquo;un bon de commande client</h1>");
        }else{
            out.println("<h1>Saisie d&rsquo;un bon de commande client</h1>");
        }
    %>
    <!--  -->
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <div class="col-md-12 cardradius">
            <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> Ar</span></h3>
        </div>
        <div id="butfillejsp">
            <input name="message" type="hidden" id="message" value="<%= message != null ? message.replace("\"", "&quot;") : "" %>">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
        </div>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>

</div>


<script>
    $(document).ready(function () {
        var lignes = <%=pi.getNombreLigne()%>
        for (let i = 0; i < lignes; i++) {
            calculerMontant(i);
        }
    });
    function formatNumber(number) {
        return number.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    }
    function calculerMontant(indice) {
        // Valeurs
        var pu = parseFloat(document.getElementById('pu_' + indice).value.replace(/\s/g, '')) || 0;
        var qte = parseFloat(document.getElementById('quantite_' + indice).value.replace(/\s/g, '')) || 0;
        var remise = parseFloat(document.getElementById('remise_' + indice).value.replace(/\s/g, '')) || 0;
        var ristourne = parseFloat(document.getElementById('ristourne_' + indice).value.replace(/\s/g, '')) || 0;
        var ristourneArbiochem1 = parseFloat(document.getElementById('ristourneArbiochem_' + indice).value.replace(/\s/g, '')) || 0;
        var remiseArbiochem1 = parseFloat(document.getElementById('remiseArbiochem_' + indice).value.replace(/\s/g, '')) || 0;
        var tva = parseFloat(document.getElementById('tva_' + indice).value.replace(/\s/g, '')) || 0;
        var Poids = parseFloat(document.getElementById('calorie_' + indice).value.replace(/\s/g, '')) || 0;
        var fraislivraison = parseFloat(document.getElementById('fraislivraison').value.replace(/\s/g, '')) || 0;
        // Montant HT brut
        var montantHtBrut = pu * qte;
        var montantFraisLivraison = fraislivraison * Poids * qte;

        // Remise
        var remiseArbiochem = (remiseArbiochem1 * qte) + montantHtBrut * remise / 100;
        var montantApresRemise = montantHtBrut - remiseArbiochem;

        // Ristourne (SUR montant remisé)
        var ristourneArbiochem = (ristourneArbiochem1 * qte)  + montantApresRemise * ristourne / 100;
        var montantHtNet = montantApresRemise - ristourneArbiochem-montantFraisLivraison;

        // TVA
        var montantTva = montantHtNet * tva / 100;
        var montantTtc = montantHtNet + montantTva;

        // PU net informatif
        var puNet = montantHtNet / qte;

        // Mise à jour UI
        document.getElementById('punet_' + indice).value = formatNumber(puNet);
        document.getElementById('montantht_' + indice).value = formatNumber(montantHtNet);
        document.getElementById('montantttc_' + indice).value = formatNumber(montantTtc);

        // Total général
        var total = 0;
        $('input[id^="montantttc_"]').each(function () {
            var v = parseFloat($(this).val().replace(/\s/g, ''));
            if (!isNaN(v)) total += v;
        });

        $("#montanttotal").html(
            Intl.NumberFormat('fr-FR', { minimumFractionDigits: 2 }).format(total)
        );
    }

    function recalculerTousLesMontants() {
        var nombreLigne = parseInt(document.getElementById('nombreLigne').value, 10);
        for (var i = 0; i < nombreLigne; i++) {
            var idProduit = document.getElementById('produit_' + i);
            if (idProduit && idProduit.value !== '') {
                calculerMontant(i);
            }
        }
    }

</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        const champClient = document.getElementById("idClient");

        if (!champClient) {
            console.log("idClient introuvable");
            return;
        }

        console.log("ID CLIENT AU DEBUT =", champClient.value);

        const observer = new MutationObserver(function (mutationsList) {

            for (let mutation of mutationsList) {

                if (
                    mutation.type === "attributes"
                    && mutation.attributeName === "value"
                ) {

                    console.log(
                        "NOUVEAU CLIENT =",
                        champClient.value
                    );

                    // Déclenche le vrai onchange du champ
                    champClient.dispatchEvent(
                        new Event("change", { bubbles: true })
                    );
                }
            }
        });

        observer.observe(champClient, {
            attributes: true
        });

    });
</script>
<script>
    (function(){
        var form = document.getElementById("formId");
        if(form){
            form.addEventListener("submit", function(e){
                var champMessage =
                    document.getElementById("message");
                var message =
                    champMessage
                        ? champMessage.value
                        : "";
                console.log(
                    "MESSAGE AU SUBMIT = [" + message + "]"
                );
                if(message.trim() !== ""){
                    var ok = confirm(message);
                    if(!ok){
                        e.preventDefault();
                    }
                }
            });
        }

    })();
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
<script language="JavaScript">
document.querySelectorAll("input[id^='designation_']").forEach(function(input) {
    input.style.width = "350px";
    input.style.minWidth = "350px";
});
</script>

