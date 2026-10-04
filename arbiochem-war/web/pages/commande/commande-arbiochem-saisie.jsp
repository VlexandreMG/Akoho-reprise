<%--
    Document   : commande-saisie
    Created on : 2026 M05 5
    Author     : fitah
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
<%@ page import="magasin.Magasin" %>
<%@ page import="produits.TarifIngredients" %>
<%@ page import="java.util.Date" %>
<%
    boolean carteExpiree = false;
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Commande mere = new Commande();
    CommandeFIlleCpl fille = new CommandeFIlleCpl();
    fille.setNomTable("COMMANDEFILLEVIDE");
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("idClient").setLibelle("Client");
    pi.getFormu().getChamp("idClient").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pi.getFormu().getChamp("reference").setDefaut("-");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idDevise").setVisible(false);
    pi.getFormu().getChamp("idDevise").setDefaut("AR");
    pi.getFormu().getChamp("idProforma").setAutre("readonly");
    pi.getFormu().getChamp("fraisLivraison").setLibelle("Frais de livraison (Par Kg)");
    pi.getFormu().getChamp("fraisLivraison").setVisible(false);
    pi.getFormu().getChamp("fraisLivraison").setDefaut("0");
    pi.getFormu().getChamp("fraisLivraison").setAutre("onchange=\"recalculerTousLesMontants()\"");
    pi.getFormu().getChamp("idProforma").setLibelle("ID Proforma");

    Liste[] liste = new Liste[2];
//    ModePaiement mp = new ModePaiement();
//    liste[0] = new Liste("modepaiement",mp,"val","id");
        Magasin m = new Magasin();
        m.setNomTable("MagasinVente");
    liste[0] = new Liste("idMagasin",m,"val","id");
    liste[0].setLibelle("Magasin");
        Liste listemode = new Liste("modeLivraison");

        String [] affVal = new String[2];
        String [] aff = new String[2];
        aff = new String[]{"LIVRAISON","RECUPERATION"};
        affVal = new String[]{"1","2"};
        listemode.ajouterValeur(affVal,aff);
        liste[1] = listemode;
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("idMagasin").setDefaut(ConstanteSocobis.MAGASIN);
    String [] ordre = {"daty","designation","remarque","reference","idDevise","idMagasin","idClient"};
    pi.getFormu().setOrdre(ordre);
    pi.getFormu().getChamp("idMagasin").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
    pi.getFormu().getChamp("modeLivraison").setLibelle("Mode de livraison");
    pi.getFormu().getChamp("idClient").setPageAppelComplete("client.ClientLib","id","CLIENT_ACTIF");
    pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientLibelle","id;nom");
    pi.getFormu().getChamp("lieuLivraison").setLibelle("Lieu de livraison");
    pi.getFormu().getChamp("dateLivraison").setLibelle("Date de livraison");
    pi.getFormu().getChamp("idProforma").setVisible(false);
//    pi.getFormu().getChamp("fraisLivraison").setVisible(false);
    pi.getFormu().getChamp("modepaiement").setVisible(false);
    pi.getFormu().getChamp("dateBesoin").setVisible(false);
    //affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngreventVenteTarif","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;tva","pu;compte;designation;unite;tva"," ");
    affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngreventVenteTarif","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;idunitelib;tva;calorie","pu;compte;designation;unite;uniteLib;tva;calorie", " and 1>2");
        String acte=request.getParameter("acte");
        String idC = request.getParameter("id");

        double tva = 0.0;
        if ((request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true"))||(acte!=null&&acte.compareToIgnoreCase("update")==0&&idC!=null&&idC.compareToIgnoreCase("")!=0)){
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
                tva = c.getTaxe();
                session.setAttribute("idclient", idclient);
            }else{
                c = (Client)new Client().getById((String) session.getAttribute("idclient"),"client",null);
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
            //affichage.Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("produit"),"produits.IngreventVenteTarif","id","AS_INGREDIENT_VENTE_LIB","prixunitaire;compte_vente;libelle;idunite;idunitelib;tva;calorie","pu;compte;designation;unite;uniteLib;tva;calorie", "");
        }else{
            session.removeAttribute("idMagasin");
            session.removeAttribute("idclient");
        }

    //Nommage et visibilite

    for (int i = 0; i < nombreLigne; i++) {
        pi.getFormufle().getChamp("quantite_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("remise_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("ristourne_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("tva_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("pu_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("produit_" + i).setLibelle("Produit");
        pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
        pi.getFormufle().getChamp("uniteLib_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("calorie_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("tva_"+i).setDefaut(tva+"");
        pi.getFormufle().getChamp("montant_"+i).setAutre("readonly");
    }

    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
    pi.getFormufle().getChamp("montant_0").setLibelle("Montant TTC");
    pi.getFormufle().getChamp("tva_0").setLibelle("TVA (En %)");
    pi.getFormufle().getChamp("remise_0").setLibelle("Remise (En %)");
    pi.getFormufle().getChamp("ristourne_0").setLibelle("Ristourne (En %)");
    pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
    pi.getFormufle().getChamp("calorie_0").setLibelle("Poids en Kg");
    pi.getFormufle().getChamp("uniteLib_0").setLibelle("Unit&eacute;");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idDevise"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idc"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("unite"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("calorie"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("pu"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("remise"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("ristourne"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("tva"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("montant"),false);
    pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");

    Commande ocr = (Commande) session.getAttribute("ocr");
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

    String[] colOrdre = {"id","produit","designation","calorie","quantite","pu","remise", "ristourne","tva","montant","idDevise","unitelib"};
    pi.getFormufle().setColOrdre(colOrdre);

    //Variables de navigation
    String classeMere = "vente.Commande";
    String classeFille = "vente.CommandeFille";
    String butApresPost = "commande/commande-arbiochem-fiche.jsp";
    String colonneMere = "idc";
    //Preparer les affichages
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <%
        if (request.getParameter("acte")!=null && request.getParameter("acte")!=""){
            out.println("<h1>Modification d&rsquo;une commande</h1>");
        }else{
            out.println("<h1>Saisie d&rsquo;une commande</h1>");
        }
    %>
    <!--  -->
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <!--div class="col-md-12 cardradius">
            <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> Ar</span></h3>
        </div-->
<%--        <div class="col-md-12 cardradius">--%>
<%--            <h3 class="fontinter" style="background: white;padding: 16px;margin-top: 10px;border-radius: 16px;" >Total  : <span id="montanttotal">0</span><span id="deviseLibelle"> Ar</span></h3>--%>
<%--        </div>--%>
        <div id="butfillejsp">
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
    document.addEventListener('DOMContentLoaded', function() {
        var val = 0;
        $('input[id^="montant_"]').each(function() {
            var montant = parseFloat(String($(this).val() || '').replace(/\s/g, ''));
            if(!isNaN(montant)){
                val += montant;
            }
        });
        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(val));
        const deviseSelect = document.getElementById('idDevise');
        if (deviseSelect) {
            deviseSelect.addEventListener('change', function() {
                const deviseSelectionne = this.value;
                for (let i = 0; i <= 10; i++) {
                    const champDevise = document.getElementById('idDevise_' + i);
                    if (champDevise) {
                        champDevise.value = deviseSelectionne;
                        if (champDevise.tagName === 'SELECT') {
                            for (let j = 0; j < champDevise.options.length; j++) {
                                if (champDevise.options[j].value === deviseSelectionne) {
                                    champDevise.selectedIndex = j;
                                    break;
                                }
                            }
                        }
                        const event = new Event('change');
                        champDevise.dispatchEvent(event);
                    }
                }
            });
        }
    });
</script>
<script>
    $(document).ready(function () {
        var lignesElement = document.getElementById('nombreLigne');
        var lignes = lignesElement ? parseInt(lignesElement.value, 10) || 0 : 0;
        for (let i = 0; i < lignes; i++) {
            calculerMontant(i);
        }
    });
    function parseMontantValue(elementId) {
        var element = document.getElementById(elementId);
        if (!element || element.value === null || element.value === undefined) {
            return 0;
        }
        var value = String(element.value).replace(/\s/g, '');
        return parseFloat(value) || 0;
    }
    function formatNumber(number) {
        return number.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    }
    function calculerMontant(indice) {
        // Valeurs
        var pu = parseMontantValue('pu_' + indice);
        var qte = parseMontantValue('quantite_' + indice);
        var remise = parseMontantValue('remise_' + indice);
        var ristourne = parseMontantValue('ristourne_' + indice);
        var tva = parseMontantValue('tva_' + indice);
        var poids = parseMontantValue('calorie_' + indice);
        var fraisLivraison = parseMontantValue('fraisLivraison');

        // Montant HT brut
        var montantHtBrut = pu * qte;
        var montantFraisLivraison = fraisLivraison * poids * qte;

        // Remise
        var montantRemise = montantHtBrut * remise / 100;
        var montantApresRemise = montantHtBrut - montantRemise;

        // Ristourne (SUR montant remisé)
        var montantRistourne = montantApresRemise * ristourne / 100;
        var montantHtNet = montantApresRemise - montantRistourne - montantFraisLivraison;

        // TVA
        var montantTva = montantHtNet * tva / 100;
        var montantTtc = montantHtNet + montantTva;

        // Mise à jour UI
        var montantField = document.getElementById('montant_' + indice);
        if (montantField) {
            montantField.value = formatNumber(montantTtc);
        }

        // Total général
        var total = 0;
        $('input[id^="montant_"]').each(function () {
            var v = parseFloat(String($(this).val() || '').replace(/\s/g, ''));
            if (!isNaN(v)) total += v;
        });

        $("#montanttotal").html(
            Intl.NumberFormat('fr-FR', { minimumFractionDigits: 2 }).format(total)
        );
    }

    function recalculerTousLesMontants() {
        var lignesElement = document.getElementById('nombreLigne');
        var lignes = lignesElement ? parseInt(lignesElement.value, 10) || 0 : 0;
        for (var i = 0; i < lignes; i++) {
            var produit = document.getElementById('produit_' + i);
            if (produit && produit.value !== '') {
                calculerMontant(i);
            }
        }
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
