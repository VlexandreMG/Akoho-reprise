<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>
<%@ page import="client.Client" %>
<%@ page import="vente.Vente" %>
<%@ page import="vente.InsertionVente" %>
<%@ page import="user.UserEJB" %>
<%@ page import="vente.VenteDetails" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.util.List" %>
<%@ page import="affichage.Liste" %>
<%@ page import="annexe.Unite" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="personnel.Personnel" %>
<%@ page import="paie.employe.EmployeComplet" %>

<script>
    (function() {

        // ================================================================
        // CONFIG
        // ================================================================
        const MODES = {
            'especes': 'valeurEspece',
            'mvola':   'montantMvola',
            'orange':  'montantOrange',
            'airtel':  'montantAirtel',
            'cheque':  'montantCheque',
            'visa':    'montantVisa'
        };

        // ================================================================
        // HELPERS
        // ================================================================

        function getTotal() {
            const el = document.getElementById('totalGeneral');
            return el ? parseAmount(el.textContent) : 0;
        }

        function isMultiple() {
            const cb = document.getElementById('multiple-payment');
            return !!(cb && cb.checked);
        }

        function getModesActifs() {
            return Array.from(
                document.querySelectorAll('.toggle-container .toggle-button.active input[name="payment-method"]')
            ).map(i => i.value);
        }

        function getRawMontant(inputId) {
            const el = document.getElementById(inputId);
            if (!el || !el.value) return 0;
            const raw = el.value.replace(/\D/g, '');
            return raw ? parseInt(raw, 10) : 0;
        }

        function setMontant(inputId, valeur) {
            const el = document.getElementById(inputId);
            if (!el) return;
            el.value = valeur > 0 ? valeur.toLocaleString('fr-FR') + ' Ar' : '';
        }

        function getSomme(excludeId) {
            let somme = 0;
            getModesActifs().forEach(mode => {
                const id = MODES[mode];
                if (id && id !== excludeId) {
                    somme += getRawMontant(id);
                }
            });
            return somme;
        }

        // ================================================================
        // ERREURS UI
        // ================================================================

        function showError(inputId, msg) {
            const eid = 'mpay-err-' + inputId;
            let el = document.getElementById(eid);
            if (!el) {
                el = document.createElement('div');
                el.id = eid;
                el.style.cssText = 'color:#c00;font-size:12px;font-weight:600;margin-top:4px;' +
                    'background:#fff0f0;border:1px solid #f99;border-radius:4px;padding:4px 8px;';
                const input = document.getElementById(inputId);
                if (input) {
                    const parent = input.closest('.form-input') || input.parentNode;
                    parent.appendChild(el);
                }
            }
            el.textContent = msg;
            el.style.display = 'block';
        }

        function hideError(inputId) {
            const el = document.getElementById('mpay-err-' + inputId);
            if (el) el.style.display = 'none';
        }

        function hideAllErrors() {
            Object.values(MODES).forEach(hideError);
        }

        // ================================================================
        // MISE A JOUR MONTANT PAYE AFFICHÉ
        // ================================================================

        function updateMontantPayeAffiche() {
            let somme = 0;
            const modes = isMultiple() ? getModesActifs() : (() => {
                const r = document.querySelector('input[name="payment-method"]:checked');
                return r ? [r.value] : [];
            })();
            modes.forEach(mode => {
                const id = MODES[mode];
                if (id) somme += getRawMontant(id);
            });
            const el = document.getElementById('montantPayerTexte');
            if (el) el.textContent = formatAmount(somme, true);
        }

        // ================================================================
        // CONTROLE PRINCIPAL
        // ================================================================

        function controler(inputId) {
            if (!isMultiple()) {
                hideError(inputId);
                return true;
            }

            const total       = getTotal();
            const sommeAutres = getSomme(inputId);
            const valeur      = getRawMontant(inputId);
            const restant     = total - sommeAutres;

            // Cas 1 : les autres modes couvrent déjà tout
            if (restant <= 0 && valeur > 0) {
                showError(inputId,
                    'Les autres modes couvrent déjà le total (' +
                    formatAmount(total, true) + '). Remettez ce champ à 0.'
                );
                setMontant(inputId, 0);
                return false;
            }

            // Cas 2 : valeur saisie dépasse le restant
            if (valeur > restant) {
                showError(inputId,
                    'Maximum autorisé : ' + formatAmount(restant, true) +
                    ' (Total : ' + formatAmount(total, true) + ')'
                );
                setMontant(inputId, restant);
                return false;
            }

            // Cas OK
            hideError(inputId);
            return true;
        }

        // ================================================================
        // LISTENER SUR UN INPUT MONTANT
        // ================================================================

        function onMontantInput(e, inputId) {
            if (!isMultiple()) return;

            const input = e.target;

            // 1. Formater la valeur
            const raw = input.value.replace(/\D/g, '');
            if (!raw) {
                input.value = '';
                hideError(inputId);
                updateMontantPayeAffiche();
                if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
                return;
            }
            const num = parseInt(raw, 10);
            input.value = num.toLocaleString('fr-FR') + ' Ar';

            // 2. Repositionner curseur avant " Ar"
            try {
                const pos = input.value.length - 3;
                input.setSelectionRange(pos, pos);
            } catch(err) {}

            // 3. Contrôler le dépassement (corrige si besoin)
            controler(inputId);

            // 4. Mettre à jour l'affichage
            updateMontantPayeAffiche();

            // 5. Réactiver/désactiver le bouton Payer
            if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
        }

        // ================================================================
        // ATTACHER LES LISTENERS (sans écraser les existants)
        // ================================================================

        function attachListeners() {
            Object.entries(MODES).forEach(([mode, inputId]) => {
                const input = document.getElementById(inputId);
                if (!input || input.dataset.mpayCtrl) return;
                input.dataset.mpayCtrl = '1';

                input.addEventListener('input', function(e) {
                    onMontantInput(e, inputId);
                });

                // Sécurité : contrôle aussi au blur
                input.addEventListener('blur', function() {
                    if (!isMultiple()) return;
                    controler(inputId);
                    updateMontantPayeAffiche();
                    if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
                });
            });
        }

        // ================================================================
        // BLOQUER LA SOUMISSION SI DÉPASSEMENT
        // ================================================================

        function attachSubmitGuard() {
            const form = document.getElementById('venteForm');
            if (!form || form.dataset.mpaySubmit) return;
            form.dataset.mpaySubmit = '1';

            // On utilise capture:true pour passer en premier
            form.addEventListener('submit', function(e) {
                if (!isMultiple()) return;

                const total = getTotal();
                let somme = 0;
                getModesActifs().forEach(mode => {
                    const id = MODES[mode];
                    if (id) somme += getRawMontant(id);
                });

                if (somme > total) {
                    e.preventDefault();
                    e.stopImmediatePropagation();

                    const loader = document.getElementById('globalLoader');
                    if (loader) loader.style.display = 'none';

                    // Réactiver le bouton Payer
                    const btn = document.querySelector('.btn-primary.btn-large');
                    if (btn) {
                        btn.disabled = false;
                        btn.style.opacity = '1';
                        btn.style.cursor = 'pointer';
                        btn.innerHTML = 'Payer';
                        btn.style.pointerEvents = 'auto';
                        btn.style.backgroundColor = '';
                    }

                    alert(
                        'La somme des paiements (' + formatAmount(somme, true) + ') ' +
                        'dépasse le total à payer (' + formatAmount(total, true) + ').\n\n' +
                        'Veuillez corriger les montants.'
                    );
                    return false;
                }

                // Vérifier aussi que la somme couvre bien le total
                if (somme < total) {
                    e.preventDefault();
                    e.stopImmediatePropagation();

                    const loader = document.getElementById('globalLoader');
                    if (loader) loader.style.display = 'none';

                    const btn = document.querySelector('.btn-primary.btn-large');
                    if (btn) {
                        btn.disabled = false;
                        btn.style.opacity = '1';
                        btn.style.cursor = 'pointer';
                        btn.innerHTML = 'Payer';
                        btn.style.pointerEvents = 'auto';
                        btn.style.backgroundColor = '';
                    }

                    alert(
                        'Le total des paiements (' + formatAmount(somme, true) + ') ' +
                        'ne couvre pas le total à payer (' + formatAmount(total, true) + ').\n\n' +
                        'Il reste ' + formatAmount(total - somme, true) + ' à régler.'
                    );
                    return false;
                }

            }, true);
        }

        // ================================================================
        // OBSERVER LES CHANGEMENTS DE MODE
        // ================================================================

        function observerModes() {
            // Changement checkbox "Paiement multiple"
            const cb = document.getElementById('multiple-payment');
            if (cb) {
                cb.addEventListener('change', function() {
                    hideAllErrors();
                    updateMontantPayeAffiche();
                    if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
                });
            }

            // Changement de mode de paiement actif
            document.querySelectorAll('.toggle-container .toggle-button').forEach(btn => {
                btn.addEventListener('click', function() {
                    // Léger délai pour laisser le DOM se mettre à jour
                    setTimeout(() => {
                        hideAllErrors();
                        // Re-contrôler tous les champs actifs
                        if (isMultiple()) {
                            getModesActifs().forEach(mode => {
                                const id = MODES[mode];
                                if (id && getRawMontant(id) > 0) {
                                    controler(id);
                                }
                            });
                        }
                        updateMontantPayeAffiche();
                        if (typeof checkPaymentValidation === 'function') checkPaymentValidation();
                    }, 60);
                });
            });
        }

        // ================================================================
        // INIT
        // ================================================================

        function init() {
            attachListeners();
            attachSubmitGuard();
            observerModes();
            console.log('[MultiPaiement] ✅ Contrôle montant actif');
        }

        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', init);
        } else {
            init();
        }

    })();
</script>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    try {
        String classeMere = "vente.Vente";
        String classeFille = "vente.VenteDetails";
        String butApresPost = "vente/vente-saisie-directe-apj.jsp";
        String colonneMere = "idVente";
        String nombreLigne = "1";
        int nbl = 1;
        String lien =(String) session.getValue("lien");

        String idPoint = (String)session.getAttribute("idPoint");
        Client client = new Client();
        client.setIdPoint(idPoint);
        client.clientPoint();

        String idClient = "CLI000576";
        String nomClient = "Client Divers";

        if(client.getId()!=null){
            idClient = client.getId();
            nomClient = client.getNom();
        }

        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Vente mere = new InsertionVente();
        mere.setNomTable("INSERTION_VENTE_PERSONNEL_VIDE");
        VenteDetails fille = new VenteDetails();
        fille.setNomTable("VENTE_DETAILS_SAISIE_DIRECTE");
        Vente res = new Vente();
        VenteDetails[] vente_details = null;
        String titre = "Enregistrement d'une vente compl&egrave;te";

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nbl, u);
        pi.setLien((String) session.getValue("lien"));
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","ST_INGREDIENTSAUTOVENTE_MGA2","pv;compte_vente;libelleComposant;codebarre;taux;photo;reference;unite","pu;compte;designation;codebarre;tauxDeChange;photo;reference;unite");
//        Liste[] listes = new Liste[1];
//        Personnel personnel = new Personnel();
////        TypeObjet tp = new TypeObjet();
////        tp.setNomTable("AS_UNITE");
//        listes[0] = new Liste("idResponsable", personnel,"nom","id");
//        pi.getFormu().changerEnChamp(listes);

        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("designation").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setVisible(false);
        pi.getFormu().getChamp("daty").setVisible(false);
        // ID CLIENT
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idResponsable").setLibelle("Responsable");
        pi.getFormu().getChamp("idResponsable").setDefaut(u.getUser().getTuppleID());
        pi.getFormu().getChamp("idResponsable").setVisible(false);
//        pi.getFormu().getChamp("idResponsable").setAutocompleteDynamique("personnel.Personnel","nom","id","Personnel");
        pi.getFormu().getChamp("idClient").setAutocompleteDynamique("client.Client","nom","id","Client");
//        pi.getFormu().getChamp("idClient").setDefaut(idClient);
        // INVISIBLE: Remarque , Etat, Origine, IdDevise
        pi.getFormu().getChamp("remarque").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idOrigine").setVisible(false);
        pi.getFormu().getChamp("idDevise").setVisible(false);
        pi.getFormu().getChamp("estPrevu").setVisible(false);
        pi.getFormu().getChamp("datyPrevu").setVisible(false);
        pi.getFormu().getChamp("idCommercial").setVisible(false);
        pi.getFormu().getChamp("idmodepaiement").setVisible(false);
        pi.getFormu().getChamp("remise").setVisible(false);
        pi.getFormu().getChamp("remiseMontant").setVisible(false);
        pi.getFormu().getChamp("heureSaisie").setVisible(false);

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
//        pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("designation_0").setLibelle("Article");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise en %");
        pi.getFormufle().getChamp("ristourne_0").setLibelle("Ristourne en %");
        pi.getFormufle().getChamp("remiseMontant_0").setLibelle("Remise en Montant");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Origine");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("photo_0").setLibelle("Image");
//        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("pu_0").setLibelle("Montant");
        pi.getFormufle().getChamp("reference_0").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onChange='updateTotals()' readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("qte"),"onChange='updateTotals()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("remiseMontant"),"onChange='updateTotals()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("compte"),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tauxDeChange"),"readonly");
//        affichage.Champ.setAutre(pi.getFormufle().getChampFille("montant"),"readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("designation"),"readonly");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("tauxDeChange"),"1");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("idDevise"),"Ar");

        pi.getFormufle().getChampMulitple("compte").setVisible(false);
        pi.getFormufle().getChampMulitple("idDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);
        pi.getFormufle().getChampMulitple("remise").setVisible(false);
        pi.getFormufle().getChampMulitple("remiseMontant").setVisible(false);
        pi.getFormufle().getChampMulitple("reference").setVisible(false);
        pi.getFormufle().getChampMulitple("tva").setVisible(false);

        pi.getFormufle().getChampMulitple("idVente").setVisible(false);
        pi.getFormufle().getChampMulitple("montant").setVisible(false);
        pi.getFormufle().getChampMulitple("idProduit").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("ristourne").setVisible(false);
        pi.getFormufle().getChampMulitple("IdOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);
        pi.getFormufle().getChampMulitple("unite").setVisible(false);
//        pi.getFormufle().getChampMulitple("photo").setVisible(false);
        pi.preparerDataFormu();

        String[] ordreFille = new String[]{"photo", "idProduit", "designation","pu", "qte"};
        pi.getFormufle().setColOrdre(ordreFille);
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<link href="${pageContext.request.contextPath}/assets/css/vente-directe.css" rel="stylesheet" type="text/css" />
<div class="vd-header">
    <img src="${pageContext.request.contextPath}/assets/img/logo_A.png" alt="logo" id="site-logo">
    <div class="form-input w-100">
<%--        CHANGE STE--%>
        <input value="" class="form-control ui-autocomplete-input ui-autocomplete-loading" id="idProduit_libelle"  type="text" oninput="autoCompleteVenteDirect('idProduit_libelle','ST_INGREDIENTSVENTEPOS','produits.Ingredients','photo;libelle;reference;quantite=1;pv;codegros;pvgros;remise=0;prix=0;unite;compte_vente','photo;designation;reference;qte;pu;codegros;pu_pvgros;remiseMontant;prix;unite;compte','id')")
        />
        <input value='' class='form-control' id='idProduit' name='idProduit' type='hidden'/>
    </div>
    <div class="d-flex gap-2">
        <a class="btn btn-tertiary" href="${pageContext.request.contextPath}/pages/module.jsp?but=vente/vente-saisie-directe-apj.jsp" target="_blank">
            POS
        </a>
        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                Mouvement
                <span class="material-symbols-rounded">keyboard_arrow_down</span>
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-entree-pos.jsp">Entrée de caisse</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/mvt/mvtcaisse-sortie-pos.jsp">Sortie de caisse</a></li>
                <li><a href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/tranb/tranb-saisie.jsp">Transfert de caisse</a></li>
            </ul>
        </div>
        <a class="btn btn-tertiary" href="${pageContext.request.contextPath}/pages/module.jsp?but=caisse/cloturecaisse/cloturecaisse-saisie.jsp" >
            Clôture de caisse
        </a>
    </div>
    <div class="btn btn-tertiary">
        <i class="material-symbols-rounded">account_circle</i>
        <%=u.getCnapsUser().getUsername()%>
    </div>
</div>
<div class="content-wrapper">
    <div class="box-body">
        <form class='container' id="venteForm" action="apresVenteDirecte.jsp" method="post" >
            <div class="row">
                <div class="col-md-8 d-flex vente-directe-left-container">

                    <!-- Conteneur Formulaire + Tableau -->
                    <div class="w-100" id="formTableContainer">
                        <%
                            out.println(pi.getFormu().getHtmlInsert());
                        %>
                        <br>
                        <div id="butfillejsp">
                            <%
                                out.println(pi.getFormufle().getHtmlTableauInsert());
                            %>
                            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
                        </div>
                    </div>
                    <!-- Conteneur du Clavier -->
                    <div class="d-none fade w-100" id="clavierContainer">
                        <button type="button" class="btn btn-secondary " id="btnCloseClavier">
                            <i class="material-symbols-rounded">close</i>
                        </button>
                        <%=pi.getHtmlClavierVisuel()%>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="d-flex vente-directe-right-container">
                        <h2 class="h520pxSemibold m-0" >R&eacute;sum&eacute; des commandes</h2>
                        <div class="box">
                            <div class="box-body recap-achat upside">
                                <div class="d-flex"><p class="Body14pxRegular" >Sous-total</p> <p id="recapSousTotal" class="Body14pxRegular" >0 Ar</p> </div>
                                <div class="d-flex"><p  class="Body14pxRegular" >Remises totales</p> <p id="recapRemises" class="Body14pxRegular">0 Ar</p> </div>
                            </div>
                            <div class="box-footer total-container">
                                <p class="Body12pxBold" >Total à payer</p>
                                <p id="totalGeneral" class="h142pxBold" style="color: var(--VD-main-color);">0 Ar</p>
                                <input type="hidden" name="totalGeneralInput" id="totalGeneralInput">
                            </div>
                            <div class="box-body recap-achat downside" style="border-top: 1px solid #eee; padding-top: 10px;">
                                <div class="d-flex"><p class="h520pxRegular" >Montant payé</p> <p id="montantPayerTexte" class="h235pxBold" style="color: var(--VD-main-color);">0 Ar</p> </div>
                                <div class="d-flex"><p class="h520pxRegular" >&Agrave; retourner</p> <p id="montantRetourner" class="h235pxBold" style="color: var(--VD-main-color);">0 Ar</p> </div>
                                <input type="hidden" name="aretourner" id="aretourner">
                            </div>
                        </div>
                        <div class="box d-none">
                            <button type="submit" style="margin-right: 8px" class="btn btn-small btn-primary pull-right " onclick="setPaymentMode('espece')">Payer en esp&egrave;ce</button>
                            <button style="margin-right: 8px" class="btn btn-small btn-tertiary pull-right nopadding" data-toggle="modal" data-target="#mvola" type="button" ><img src="${pageContext.request.contextPath}/assets/img/mvola.jpeg" alt="mvola" ></button>
                            <button style="margin-right: 8px" class="btn btn-tertiary btn-small pull-right nopadding" data-toggle="modal" data-target="#airtelmoney" type="button"><img src="${pageContext.request.contextPath}/assets/img/airtel.png" alt="airtel" ></button>
                            <button  style="margin-right: 8px" class="btn btn-tertiary btn-small pull-right nopadding" data-toggle="modal" data-target="#orangemoney" type="button"><img src="${pageContext.request.contextPath}/assets/img/orangemoney.png" alt="orangemoney" ></button>
                            <%--                        <button type="button" style="margin-right: 8px" class="btn btn-small btn-primary pull-left " data-toggle="modal" data-target="#paiement-multiple">Modes de paiement multiples</button>--%>
                            <button  style="margin-right: 8px" class="btn btn-secondary btn-small pull-left " data-toggle="modal" data-target="#cheque" type="button">Payer par ch&egrave;que</button>
                            <button  style="margin-right: 8px" class="btn btn-small btn-secondary pull-left " onclick="setPaymentMode('cartebancaire')" data-toggle="modal" data-target="#virement" type="button">Payer par carte bancaire</button>
                        </div>
                        <label class="toggle-button link">
                            <input type="checkbox" id="multiple-payment">
                            <div class="d-flex">
                                <span class="label" style="white-space: nowrap">Paiement multiple</span>
                            </div>
                            <input type="hidden" name="multiplePayment" id="multiplePaymentInput" value="false" />
                        </label>
                        <div class="paiement-container">
                            <div class="toggle-container">
                                <label class="toggle-button active">
                                    <input type="radio" name="payment-method" value="especes" checked>
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/payments.png">
                                        <span class="label">Espèces</span>
                                    </div>
                                </label>

                                <label class="toggle-button ">
                                    <input type="radio" name="payment-method" value="cheque">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/checkbook.png">
                                        <span class="label">Chèque</span>
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="mvola">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/mvola.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="airtel">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/airtel.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="orange">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/orangemoney.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="visa">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <img src="${pageContext.request.contextPath}/assets/img/visa.png">
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="bonAchat">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <i class="material-symbols-rounded">hand_package</i>
                                        <label class="label">BON D'ACHAT</label>
                                    </div>
                                </label>
                                <label class="toggle-button">
                                    <input type="radio" name="payment-method" value="cadeaux">
                                    <div class="checkbox">
                                        <span class="checkmark"><i class="material-symbols-rounded">check</i></span>
                                    </div>
                                    <div class="d-flex">
                                        <i class="material-symbols-rounded">redeem</i>
                                        <span class="label" >CARTE CADEAUX</span>
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div class="input-container">
                            <%--                            espece--%>
                            <div class="form-input w-100 paiement-section" data-mode="especes">
                                <div class="d-flex" style="justify-content: space-between;align-items: baseline">
                                    <label class="input-label" >Montant payé</label>
                                </div>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Espèces</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" name="valeurEspece" id="valeurEspece" value="" autocomplete="off" />
                                </div>
                            </div>
                            <%--                            mvola--%>
                            <div class="form-input paiement-section d-none" data-mode="mvola">
                                <label class="input-label" >Référence</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/mvola.png"> </span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refMvola" name="refMvola"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="mvola">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantMvola" name="montantMvola"/>
                            </div>
                            <%--                            orange money--%>
                            <div class="form-input paiement-section d-none" data-mode="orange">
                                <label class="input-label" >Référence</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/orangemoney.png"> </span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refOrange" name="refOrange"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="orange">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantOrange" name="montantOrange"/>
                            </div>
                            <%--                            airtel money--%>
                            <div class="form-input paiement-section d-none" data-mode="airtel">
                                <label class="input-label" >Référence</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span><img src="${pageContext.request.contextPath}/assets/img/airtel.png"> </span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refAirtel" name="refAirtel"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="airtel">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantAirtel" name="montantAirtel"/>
                            </div>


                            <%--                            cheque--%>
                            <div class="form-input paiement-section d-none" data-mode="cheque">
                                <label class="input-label" >Numéro chèque</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Cheque</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refCheque" name="refCheque"/>
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="cheque">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantCheque" name="montantCheque"/>
                            </div>

                            <%--                            visa--%>
                            <div class="form-input paiement-section d-none" data-mode="visa">
                                <label class="input-label" >Référence Visa</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Visa</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refVisa" name="refVisa" />
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="visa">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantVisa" name="montantVisa"/>
                            </div>
                            <%--                            carte bon d'achat--%>
                            <div class="form-input paiement-section d-none" data-mode="bonAchat">
                                <label class="input-label" >Référence du bon d'achat</label>
                                <div class="d-flex input-with-addons with-btn-left">
                                    <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Bon d'achat</span></button>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refVisa" name="refVisa" />
                                </div>
                            </div>
                            <div class="form-input paiement-section d-none" data-mode="bonAchat">
                                <label class="input-label" >Montant</label>
                                <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantVisa" name="montantVisa"/>
                            </div>
                                <%--                            carte cadeaux--%>
                                <div class="form-input paiement-section d-none" data-mode="cadeaux">
                                    <label class="input-label" >Référence de la carte cadeaux</label>
                                    <div class="d-flex input-with-addons with-btn-left">
                                        <button class="btn btn-secondary btn-small btn-left"  type="button"><span>Carte cadeaux</span></button>
                                        <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="refVisa" name="refVisa" />
                                    </div>
                                </div>
                                <div class="form-input paiement-section d-none" data-mode="cadeaux">
                                    <label class="input-label" >Montant</label>
                                    <input class="form-control ui-autocomplete-input ui-autocomplete-loading" value="" id="montantVisa" name="montantVisa"/>
                                </div>
                        </div>
                        <button type="submit" class="btn btn-primary btn-large w-100" style="justify-content: center;align-items: center">Payer</button>
                    </div>
                </div>
            </div>

            <input name="acte" type="hidden" id="nature" value="viserLivrerEncaisser">
            <input name="action" type="hidden" id="action" value="viserLivrerEncaisser">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="Vente_Details">
            <%-- CHANGE STE 2--%>
            <input type="hidden" id="idPoint" value="<%=session.getAttribute("idPoint")%>">
        </form>
    </div>
</div>
<div id="globalLoader" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:99999;background:rgba(255,255,255,0.7);justify-content:center;align-items:center;">
    <div style="text-align:center;">
        <div class="spinner-border"  role="status"></div>
        <div style="margin-top:1rem;font-size:1.2rem;color:(--VD-main-color)">Chargement...</div>
    </div>
</div>
<script>
    const multipleInput = document.getElementById('multiple-payment');
    const hiddenInput = document.getElementById('multiplePaymentInput');

    multipleInput.addEventListener('change', function() {
        hiddenInput.value = this.checked ? 'true' : 'false';
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById("idClientlibelle").value = "<%=nomClient%>";
        document.getElementById("idClient").value = "<%=idClient%>";
        const form = document.getElementById('venteForm');

        form.addEventListener('submit', function(e) {
            const monetaryInputs = [
                'valeurEspece',
                'montantMvola',
                'montantOrange',
                'montantAirtel',
                'montantCheque',
                'montantVisa'
            ];

            monetaryInputs.forEach(inputId => {
                const input = document.getElementById(inputId);
                if (input && input.value) {
                    const rawValue = input.value.replace(/[^\d.]/g, '');
                    input.value = rawValue;
                }
            });

            document.querySelectorAll("input[name^='pu_'], input[name^='prix_'], input[name^='qte_'], input[name^='remiseMontant_']").forEach(input => {
                if (input.value) {
                    const rawValue = input.value.replace(/[^\d.]/g, '');
                    input.value = rawValue;
                }
            });

            const formData = new FormData(form)
            console.log("Form Data before submission1 :", formData);
        });
    });
</script>
<%--paiement multiple--%>
<script>
    // Loader
    var loader = document.getElementById('globalLoader');
    (function() {
        var originalAlert = window.alert;
        window.alert = function(msg) {
            var loader = document.getElementById('globalLoader');
            if (loader) {
                loader.style.display = 'none';
                // Pour forcer la disparition même si flex ou autre style
                loader.classList.add('d-none');
                loader.style.setProperty('display', 'none', 'important');
            }
            originalAlert.call(window, msg);
            setTimeout(function() {
                if (loader) {
                    loader.style.display = 'none';
                    loader.classList.add('d-none');
                }
            }, 100);
        };
    })();
    // Affiche le loader dès le début
    loader.style.display = 'flex';

    // Masque le loader quand la page est complètement chargée
    window.addEventListener('load', function() {
        loader.style.display = 'none';
    });

    // Gestionnaire global d'erreur
    window.addEventListener('error', function() {
        var loader = document.getElementById('globalLoader');
        if (loader) {
            loader.style.display = 'none';
            loader.classList.add('d-none');
        }
    });

    window.addEventListener('unhandledrejection', function() {
        var loader = document.getElementById('globalLoader');
        if (loader) {
            loader.style.display = 'none';
            loader.classList.add('d-none');
        }
    });

    // Affiche le loader lors de la soumission du formulaire
    document.addEventListener('DOMContentLoaded', function() {
        var form = document.getElementById('venteForm');
        if (form && loader) {
            form.addEventListener('submit', function(e) {
                // e.preventDefault()
                // const row1 = document.getElementById('ligne-multiple-0');
                // row1.remove()
                const formData = new FormData(form)
                console.log("Form Data before submission2 :", formData);
                // Save cart state BEFORE submission
                saveCartState();

                const submitBtn = form.querySelector('button[type="submit"].btn-primary.btn-large');
                if (submitBtn) {
                    submitBtn.style.backgroundColor = '#6c757d';
                    submitBtn.style.cursor = 'not-allowed';
                    submitBtn.style.opacity = '0.7';
                    submitBtn.style.pointerEvents = 'none';
                    submitBtn.innerHTML = 'Paiement en cours...';
                    submitBtn.disabled = true;
                }

                const multiplePayment = document.getElementById('multiple-payment');
                const isMultiplePayment = multiplePayment && multiplePayment.checked;

                if (isMultiplePayment) {
                    loader.style.display = 'flex';
                    loader.classList.remove('d-none');
                    return;
                }

                const totalElement = document.getElementById("totalGeneral");
                const total = parseAmount(totalElement.textContent);
                const selectedRadio = document.querySelector('input[name="payment-method"]:checked');

                if (selectedRadio && selectedRadio.value === 'especes') {
                    const rawValue = document.getElementById('valeurEspece').value.replace(/\D/g, '');
                    const numericValue = rawValue ? parseInt(rawValue, 10) : 0;
                    if (numericValue < total) {
                        if (submitBtn) {
                            submitBtn.classList.remove('btn-payment-processing');
                            submitBtn.textContent = 'Payer';
                            submitBtn.disabled = false;
                        }
                        loader.style.display = 'none';
                        loader.classList.add('d-none');
                        return;
                    }
                }


                loader.style.display = 'flex';
                loader.classList.remove('d-none');
            });
        }
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const multipleInput = document.getElementById('multiple-payment'); // checkbox maintenant
        // on ne prend QUE les toggle buttons des moyens (dans .toggle-container) => exclut "Paiement multiple"
        const paymentButtons = Array.from(document.querySelectorAll('.toggle-container .toggle-button'));
        const sections = Array.from(document.querySelectorAll('.paiement-section'));
        let lastClicked = null;

        // Par défaut : activer "especes"
        paymentButtons.forEach(btn => {
            const inp = btn.querySelector('input[name="payment-method"]');
            if (inp && inp.value === 'especes') {
                btn.classList.add('active');
                lastClicked = btn;
            }
        });

        function updateSections() {
            const activeModes = paymentButtons
                .filter(b => b.classList.contains('active'))
                .map(b => b.querySelector('input[name="payment-method"]').value);

            sections.forEach(sec => {
                const show = activeModes.includes(sec.dataset.mode);
                sec.classList.toggle('d-none', !show);
            });
        }

        // Clique sur un moyen de paiement
        paymentButtons.forEach(btn => {
            btn.addEventListener('click', function(e) {
                // si on est en mode multiple : empêcher le comportement radio standard
                if (multipleInput && multipleInput.checked) {
                    e.preventDefault(); // empêche la radio native (qui forcerait une seule sélection)
                    this.classList.toggle('active');
                } else {
                    // mode single : un seul actif
                    paymentButtons.forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                }
                lastClicked = this;
                updateSections();
                checkPaymentValidation();
            });
        });

        // Quand on active/désactive "paiement multiple"
        if (multipleInput) {
            multipleInput.addEventListener('change', function() {
                if (!this.checked) {
                    // sortie du mode multiple : ne garder que le dernier cliqué (ou 'especes' par défaut)
                    if (lastClicked) {
                        paymentButtons.forEach(b => {
                            if (b !== lastClicked) b.classList.remove('active');
                        });
                    } else {
                        // fallback : activer "especes"
                        paymentButtons.forEach(b => {
                            const inp = b.querySelector('input[name="payment-method"]');
                            if (inp && inp.value === 'especes') b.classList.add('active');
                            else b.classList.remove('active');
                        });
                    }
                }
                updateSections();
                checkPaymentValidation();
            });
        }

        // initial
        updateSections();
    });

    let paymentValidationState = {
        especes: { valid: false, required: false },
        mvola: { valid: false, required: false },
        orange: { valid: false, required: false },
        airtel: { valid: false, required: false },
        cheque: { valid: false, required: false },
        visa: { valid: false, required: false }
    };

    // Consult Stefan: Reference Listener
    ['refMvola', 'refOrange', 'refAirtel', 'refCheque', 'refVisa'].forEach(inputId => {
        const input = document.getElementById(inputId);
        if (input) {
            input.addEventListener('input', function() {
                checkPaymentValidation();
            });
            input.addEventListener('change', function() {
                checkPaymentValidation();
            });
        }
    });

    function checkPaymentValidation() {
        const multiplePayment = document.getElementById('multiple-payment');
        const isMultiplePayment = multiplePayment && multiplePayment.checked;
        const validateButton = document.querySelector('.btn-primary.btn-large');

        if (!isMultiplePayment) {
            const valid = checkSingleModeAmount();
            if (valid) {
                validateButton.disabled = false;
                validateButton.style.opacity = '1';
                validateButton.style.cursor = 'pointer';
            }
            return;
        }

        // Check which payment methods are active
        const activeButtons = document.querySelectorAll('.toggle-container .toggle-button.active');

        let allValid = true;
        let sommePaiements = 0;

        activeButtons.forEach(btn => {
            const paymentType = btn.querySelector('input[name="payment-method"]').value;

            if (paymentType === 'especes') {
                // Especes only needs amount, not reference
                const amountInput = document.getElementById('valeurEspece');
                const rawValue = amountInput?.value.replace(/\D/g, '');
                const numericValue = rawValue ? parseInt(rawValue, 10) : 0;

                if (numericValue <= 0) {
                    allValid = false;
                }
                sommePaiements += numericValue;
            } else {
                // Other payment methods need both reference and amount
                const refInputId = getRefInputId(paymentType);
                const montantInputId = getMontantInputId(paymentType);

                const refInput = document.getElementById(refInputId);
                const montantInput = document.getElementById(montantInputId);

                const refValue = refInput?.value.trim() || '';
                const montantRaw = montantInput?.value.replace(/\D/g, '') || '';
                const montantValue = montantRaw ? parseInt(montantRaw, 10) : 0;

                if (refValue === '' || montantValue <= 0) {
                    allValid = false;
                }
                sommePaiements += montantValue;
            }
        });

        // Vérifier que la somme des paiements couvre bien le total à payer
        const totalElement = document.getElementById("totalGeneral");
        const total = totalElement ? parseAmount(totalElement.textContent) : 0;

        if (sommePaiements < total) {
            allValid = false;
        }

        validateButton.disabled = !allValid;
        validateButton.style.opacity = allValid ? '1' : '0.6';
        validateButton.style.cursor = allValid ? 'pointer' : 'not-allowed';
    }

    function getRefInputId(paymentType) {
        const mapping = {
            'mvola': 'refMvola',
            'orange': 'refOrange',
            'airtel': 'refAirtel',
            'cheque': 'refCheque',
            'visa': 'refVisa'
        };
        return mapping[paymentType] || '';
    }

    function getMontantInputId(paymentType) {
        const mapping = {
            'mvola': 'montantMvola',
            'orange': 'montantOrange',
            'airtel': 'montantAirtel',
            'cheque': 'montantCheque',
            'visa': 'montantVisa'
        };
        return mapping[paymentType] || '';
    }
</script>


<%--Remove double th--%>
<script>
    // 1. Fonction pour supprimer la ligne et recalculer les totaux
    function removeLine(button) {
        const row = button.closest('tr');
        if (!row) return;

        // Supprimer la ligne du tableau
        row.remove();

        // Mettre à jour les totaux et synchroniser
        if (typeof updateTotals === 'function') updateTotals();
        if (typeof sync === 'function') sync();
    }

    // 2. Fonction pour nettoyer les anciens boutons et ajouter le nouveau bouton personnalisé
    function formaterActionLigne(tr) {
        if (!tr) return;

        // A. Effacer la colonne du bouton "Dupliquer" (glyphicon-duplicate)
        const duplicateLink = tr.querySelector('a[onclick*="duplicateSingleRow"]');
        if (duplicateLink) {
            const tdDuplicate = duplicateLink.closest('td');
            if (tdDuplicate) tdDuplicate.remove();
        }

        // B. Remplacer l'ancien bouton "Supprimer" par le nouveau bouton stylisé
        const deleteLink = tr.querySelector('a[onclick*="delete_line"]');
        if (deleteLink) {
            const tdDelete = deleteLink.closest('td');
            if (tdDelete) {
                tdDelete.style.textAlign = 'center';
                tdDelete.style.verticalAlign = 'middle';
                tdDelete.innerHTML = `
                <button type="button" class="btn btn-tertiary btn-danger " onclick="removeLine(this)">
                    <i class="material-symbols-rounded">delete</i>
                </button>
            `;
            }
        }
    }

    // 3. Appliquer le nettoyage sur toutes les lignes du tableau
    function nettoyerBoutonsTableau() {
        document.querySelectorAll('#ajout_multiple_ligne tr').forEach(tr => {
            formaterActionLigne(tr);
        });
    }
    function masquerEnTeteImageEnDouble() {
        const table = document.querySelector('#butfillejsp table');
        if (!table) return;

        // 1. Trouver les <th> avec le texte "Image" ou "Photo"
        const imageHeaders = [];
        table.querySelectorAll('thead th').forEach(th => {
            const text = th.textContent.trim().toLowerCase();
            if (text === 'image' || text === 'photo') {
                imageHeaders.push(th);
            }
        });

        // 2. Si un doublon est trouvé, MASQUER visuellement (sans supprimer du DOM)
        if (imageHeaders.length > 1) {
            for (let i = 1; i < imageHeaders.length; i++) {
                const thDoublon = imageHeaders[i];
                const colIndex = Array.from(thDoublon.parentNode.children).indexOf(thDoublon);

                // Cacher uniquement l'en-tête
                thDoublon.style.display = 'none';

                // Cacher la cellule de chaque ligne tout en conservant ses <input> pour les autres scripts
                table.querySelectorAll('tbody tr').forEach(tr => {
                    if (tr.children[colIndex]) {
                        tr.children[colIndex].style.display = 'none';
                    }
                });
            }
        }
    }
</script>

<%--TOGGLE CLAVIER--%>

<script>
    let bloquerOuvertureClavier = false;

    // Détection automatique du conteneur Tableau/Formulaire (même si l'ID manque)
    function getFormTableContainer() {
        let el = document.querySelector('#formTableContainer #butfillejsp');
        if (!el) {
            const parent = document.querySelector('.vente-directe-left-container');
            if (parent && parent.children.length > 1) {
                el = parent.children[1];
            }
        }
        return el;
    }

    // Détection automatique du conteneur Clavier (même si l'ID manque)
    function getClavierContainer() {
        let el = document.getElementById('clavierContainer');
        if (!el) {
            const parent = document.querySelector('.vente-directe-left-container');
            if (parent && parent.children.length > 0) {
                el = parent.children[0];
            }
        }
        return el;
    }

    function ouvrirClavierVisuel(inputTarget) {
        if (bloquerOuvertureClavier) return;

        const clavier = getClavierContainer();
        const formTable = getFormTableContainer();

        if (!clavier || !formTable) {
            console.error("[Clavier] Impossible de trouver les blocs HTML.");
            return;
        }

        // Masquer le tableau et afficher le clavier (Forcé en CSS direct)
        formTable.style.setProperty('display', 'none', 'important');
        clavier.style.setProperty('display', 'block', 'important');
        clavier.classList.remove('d-none', 'hidden', 'hide');
        clavier.classList.add('in', 'show');

        if (typeof setActiveInput === 'function' && inputTarget) {
            setActiveInput(inputTarget);
        }
    }

    let clavierBlockTimer = null;
    function fermerClavierVisuel() {
        bloquerOuvertureClavier = true;

        if (clavierBlockTimer) {
            clearTimeout(clavierBlockTimer);
            clavierBlockTimer = null;
        }

        // Réinitialiser l'input actif
        if (typeof activeInput !== 'undefined') {
            activeInput = null;
        }

        // 1. Retirer le focus de tous les champs
        document.querySelectorAll('.form-control, input').forEach(input => {
            if (typeof input.blur === 'function') {
                input.blur();
            }
        });

        if (document.activeElement && typeof document.activeElement.blur === 'function') {
            document.activeElement.blur();
        }

        // 2. Fermer la modale ABC si elle était ouverte
        if (typeof $ !== 'undefined' && $('#clavier-abc').length) {
            $('#clavier-abc').modal('hide');
            $('.modal-backdrop').remove();
            $('body').removeClass('modal-open');
        }

        // 3. Masquer le clavier et réafficher le tableau
        const clavier = getClavierContainer();
        const formTable = getFormTableContainer();

        if (clavier) {
            clavier.style.setProperty('display', 'none', 'important');
            clavier.classList.add('d-none', 'hidden', 'hide');
            clavier.classList.remove('in', 'show');
        }

        if (formTable) {
            formTable.style.setProperty('display', 'block', 'important');
            formTable.classList.remove('d-none', 'hidden', 'hide');
        }

        // Porter le blocage à 800ms pour ignorer le "ghost click" tactile et le refocus jQuery UI
        clavierBlockTimer = setTimeout(function() {
            bloquerOuvertureClavier = false;
            clavierBlockTimer = null;
        }, 800);
    }

    // Exposer globalement les fonctions
    window.ouvrirClavierVisuel = ouvrirClavierVisuel;
    window.fermerClavierVisuel = fermerClavierVisuel;

    document.addEventListener('DOMContentLoaded', function() {
        const btnClose = document.getElementById('btnCloseClavier');

        function verifierEtOuvrirClavier(e) {
            if (bloquerOuvertureClavier) return;

            const input = e.target;
            if (!input) return;

            // Si l'élément a été retiré du DOM ou provient du menu autocomplete, ne rien faire
            if (!document.body.contains(input) || input.closest('.ui-autocomplete') || input.closest('.ui-menu-item')) {
                return;
            }

            // Déclencher si c'est un input .form-control (hors select/hidden)
            if (input && input.matches && input.matches('.form-control:not(select)')) {
                const estDansTableau = input.closest('table') !== null || input.closest('#butfillejsp') !== null;

                if (!estDansTableau) {
                    ouvrirClavierVisuel(input);
                }
            }
        }

        // Écouteurs sur le focus et le clic
        document.addEventListener('focusin', verifierEtOuvrirClavier);
        document.addEventListener('click', verifierEtOuvrirClavier);

        // Bouton de fermeture
        if (btnClose) {
            btnClose.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                fermerClavierVisuel();
            });
        }
    });
</script>
<script>
    // Variables globales
    let activeInput = null;
    let isShiftActive = false;

    // Fonction pour gérer l'activation des inputs
    function setActiveInput(input) {
        // Retirer la classe active de tous les inputs
        document.querySelectorAll('.form-control').forEach(el => {
            el.classList.remove('active');
        });

        // Ajouter la classe active à l'input cliqué
        if (input) {
            input.classList.add('active');
            activeInput = input;
        }
    }

    // Initialiser les écouteurs sur tous les inputs avec la classe form-control
    function initVirtualKeyboard() {
        document.querySelectorAll('.form-control:not(select)').forEach(input => {
            input.addEventListener('focus', () => {
                setActiveInput(input);
            });

            input.addEventListener('click', () => {
                setActiveInput(input);
            });
        });
    }

    // Fonction pour ajouter du texte à l'input actif
    function addText(char) {
        if (!activeInput) return;

        const cursorPos = activeInput.selectionStart || activeInput.value.length;
        const textBefore = activeInput.value.substring(0, cursorPos);
        const textAfter = activeInput.value.substring(cursorPos);

        if (isShiftActive) {
            activeInput.value = textBefore + char.toUpperCase() + textAfter;
            isShiftActive = false;
            // Désactiver visuellement tous les boutons maj
            document.querySelectorAll('.btn-clavier.maj').forEach(btn => {
                btn.classList.remove('active');
            });
        } else {
            activeInput.value = textBefore + char.toLowerCase() + textAfter;
        }

        // Repositionner le curseur
        const newPos = cursorPos + 1;
        activeInput.setSelectionRange(newPos, newPos);
        activeInput.focus();

        const inputEvent = new Event('input', { bubbles: true, cancelable: true });
        activeInput.dispatchEvent(inputEvent);
    }

    // Fonction pour supprimer un caractère
    function deleteChar() {
        if (!activeInput) return;

        const cursorPos = activeInput.selectionStart || activeInput.value.length;
        if (cursorPos > 0) {
            const textBefore = activeInput.value.substring(0, cursorPos - 1);
            const textAfter = activeInput.value.substring(cursorPos);
            activeInput.value = textBefore + textAfter;

            // Repositionner le curseur
            const newPos = cursorPos - 1;
            activeInput.setSelectionRange(newPos, newPos);
            activeInput.focus();
        }
    }

    // Variables pour la répétition
    let repeatInterval = null;
    let repeatTimeout = null;

    // Fonction pour exécuter l'action d'un bouton
    function executeButtonAction(btn) {
        // 1. Bouton MAJ (Shift) - pas de répétition
        if (btn.classList.contains('maj')) {
            isShiftActive = !isShiftActive;
            btn.classList.toggle('active');
            return false; // Pas de répétition
        }

        // 2. Bouton DELETE (Supprimer)
        if (btn.classList.contains('delete')) {
            deleteChar();
            return true; // Répétition activée
        }

        // 3. Bouton ESPACE
        if (btn.classList.contains('space-touch')) {
            addText(' ');
            return true; // Répétition activée
        }

        // 5. Boutons normaux avec data-key (lettres et chiffres)
        const key = btn.getAttribute('data-key');
        if (key) {
            addText(key);
            return true; // Répétition activée
        }

        // 6. Fallback : utiliser le texte du bouton si pas de data-key
        const btnText = btn.textContent.trim();
        if (btnText && btnText !== 'ABC' && btnText !== '123' && btnText !== 'Espace') {
            addText(btnText);
            return true; // Répétition activée
        }

        return false;
    }

    // Fonction pour arrêter la répétition
    function stopRepeat() {
        if (repeatTimeout) {
            clearTimeout(repeatTimeout);
            repeatTimeout = null;
        }
        if (repeatInterval) {
            clearInterval(repeatInterval);
            repeatInterval = null;
        }
    }

    // Initialisation au chargement du DOM
    document.addEventListener('DOMContentLoaded', function() {
        // Initialiser le clavier virtuel
        initVirtualKeyboard();

        // Gérer TOUS les boutons du clavier de manière généralisée
        document.querySelectorAll('.btn-clavier').forEach(btn => {
            // Gestion du mousedown pour démarrer la répétition
            btn.addEventListener('mousedown', (e) => {
                e.preventDefault();

                // Exécuter l'action immédiatement
                const shouldRepeat = executeButtonAction(btn);

                // Si le bouton doit se répéter
                if (shouldRepeat) {
                    // Attendre 500ms avant de commencer la répétition
                    repeatTimeout = setTimeout(() => {
                        // Répéter toutes les 100ms
                        repeatInterval = setInterval(() => {
                            executeButtonAction(btn);
                        }, 100);
                    }, 500);
                }
            });

            // Arrêter la répétition quand on relâche le bouton
            btn.addEventListener('mouseup', stopRepeat);
            btn.addEventListener('mouseleave', stopRepeat);

            // Support tactile pour mobile
            btn.addEventListener('touchstart', (e) => {
                e.preventDefault();
                const shouldRepeat = executeButtonAction(btn);

                if (shouldRepeat) {
                    repeatTimeout = setTimeout(() => {
                        repeatInterval = setInterval(() => {
                            executeButtonAction(btn);
                        }, 100);
                    }, 500);
                }
            });

            btn.addEventListener('touchend', stopRepeat);
            btn.addEventListener('touchcancel', stopRepeat);

            btn.addEventListener('mousedown', function() {
                btn.classList.add('is-active');
            });
            btn.addEventListener('mouseup', function() {
                btn.classList.remove('is-active');
            });
            btn.addEventListener('mouseleave', function() {
                btn.classList.remove('is-active');
            });
            // For touch devices
            btn.addEventListener('touchstart', function() {
                btn.classList.add('is-active');
            });
            btn.addEventListener('touchend', function() {
                btn.classList.remove('is-active');
            });
            btn.addEventListener('touchcancel', function() {
                btn.classList.remove('is-active');
            });
        });

        // Arrêter la répétition si on relâche en dehors du document
        document.addEventListener('mouseup', stopRepeat);
        document.addEventListener('touchend', stopRepeat);
    });

    // Save cart state before form submission
    function saveCartState() {
        const cartState = {
            products: gatherProductData(),
            client: {
                id: document.getElementById('idClient')?.value || '',
                nom: document.getElementById('idClient_libelle')?.value || ''
            },
            productPreview: {
                photo: document.getElementById('selectedProductImage')?.src || '',
                name: document.getElementById('selectedProductName')?.textContent || '',
                code: document.getElementById('selectedProductCode')?.textContent || '',
                price: document.getElementById('selectedProductPrice')?.textContent || ''
            },
            timestamp: Date.now()
        };

        sessionStorage.setItem('cartStateBeforeSubmit', JSON.stringify(cartState));
        console.log('Cart state saved:', cartState);
    }

    // Restore cart state after page reload
    function restoreCartState() {
        const savedState = sessionStorage.getItem('cartStateBeforeSubmit');

        if (!savedState) {
            console.log('No saved cart state found');
            return;
        }

        try {
            const cartState = JSON.parse(savedState);

            // Check if state is less than 5 minutes old
            if (Date.now() - cartState.timestamp > 300000) {
                sessionStorage.removeItem('cartStateBeforeSubmit');
                return;
            }

            // Restore client
            if (cartState.client.id) {
                const idClientInput = document.getElementById('idClient');
                const idClientLibelleInput = document.getElementById('idClient_libelle');
                if (idClientInput) idClientInput.value = cartState.client.id;
                if (idClientLibelleInput) idClientLibelleInput.value = cartState.client.nom;
            }

            // Restore products
            if (cartState.products && cartState.products.length > 0) {
                const tbody = document.getElementById("panierBody");
                if (!tbody) return;

                // Clear existing rows
                tbody.innerHTML = '';

                cartState.products.forEach((product, index) => {
                    restoreProductRow(product, index);
                });

                updateTotals();
                sync();
            }

            // Restore product preview
            if (cartState.productPreview && cartState.productPreview.name) {
                updateProductPreview(cartState.productPreview);
            }

            console.log('Cart state restored successfully');

            // Clear the saved state after successful restore
            sessionStorage.removeItem('cartStateBeforeSubmit');

        } catch (error) {
            console.error('Error restoring cart state:', error);
            sessionStorage.removeItem('cartStateBeforeSubmit');
        }
    }

    // Helper function to restore a single product row
    function restoreProductRow(product, rowCount) {
        console.log('product => ', product);
        const tbody = document.getElementById("panierBody");
        if (!tbody) return;

        const row = document.createElement("tr");

        // Hidden inputs
        const hiddenID = document.createElement("input");
        hiddenID.type = "hidden";
        hiddenID.value = product.id;
        hiddenID.name = "idProduit_" + rowCount;
        hiddenID.id = "idProduit_" + rowCount;
        row.appendChild(hiddenID);

        const hiddenEstEnGros = document.createElement("input");
        hiddenEstEnGros.type = "hidden";
        hiddenEstEnGros.name = "estEnGros_" + rowCount;
        hiddenEstEnGros.value = "0";
        row.appendChild(hiddenEstEnGros);

        const ids = document.createElement("input");
        ids.type = "hidden";
        ids.value = rowCount;
        ids.name = "ids";
        row.appendChild(ids);

        // Photo hidden input
        const photoInput = document.createElement("input");
        photoInput.type = "hidden";
        photoInput.name = "photo_" + rowCount;
        photoInput.value = product.urlPhoto || '';
        row.appendChild(photoInput);

        // Designation hidden input
        const designationInput = document.createElement("input");
        designationInput.type = "hidden";
        designationInput.name = "designation_" + rowCount;
        designationInput.value = product.designation;
        row.appendChild(designationInput);

        const referenceInput = document.createElement("input");
        referenceInput.type = "hidden";
        referenceInput.name = "reference_" + rowCount;
        referenceInput.value = product.reference || '';
        row.appendChild(referenceInput);

        // Quantity hidden input
        const qteInput = document.createElement("input");
        qteInput.type = "hidden";
        qteInput.name = "qte_" + rowCount;
        qteInput.value = product.quantite;
        row.appendChild(qteInput);

        // Price hidden input
        const puInput = document.createElement("input");
        puInput.type = "hidden";
        puInput.name = "pu_" + rowCount;
        puInput.value = product.prixunitaire;
        row.appendChild(puInput);

        // Remise hidden input
        const remiseInput = document.createElement("input");
        remiseInput.type = "hidden";
        remiseInput.name = "remiseMontant_" + rowCount;
        remiseInput.value = product.remiseMontant || 0;
        row.appendChild(remiseInput);

        //Change Ste 3
        row.dataset.remiseUnitaire = (parseFloat(product.remiseMontant) || 0) / (parseFloat(product.quantite) || 1);
        //Change Ste 3

        // Prix total hidden input
        const prixInput = document.createElement("input");
        prixInput.type = "hidden";
        prixInput.name = "prix_" + rowCount;
        prixInput.value = (product.quantite * product.prixunitaire) - (product.remiseMontant || 0);
        row.appendChild(prixInput);

        // Unit hidden input
        const uniteInput = document.createElement("input");
        uniteInput.type = "hidden";
        uniteInput.name = "unite_" + rowCount;
        uniteInput.value = product.isWeightBased ? "UNT00004" : "UNT00001";
        row.appendChild(uniteInput);

        // Base price hidden input
        const basePriceInput = document.createElement("input");
        basePriceInput.type = "hidden";
        basePriceInput.name = "basePriceKg_" + rowCount;
        basePriceInput.value = product.originalPrice || product.prixunitaire;
        row.appendChild(basePriceInput);

        // Column 1: Image
        const imgCell = document.createElement("td");
        imgCell.className = "contenuetable";
        const img = document.createElement("img");
        img.className = "product-img";
        img.src = resolveProductImage(product.urlPhoto);
        img.onerror = function() { this.src = productImageFallback; };
        imgCell.appendChild(img);
        row.appendChild(imgCell);

        // Column 2: Article name and price
        const articleCell = document.createElement("td");
        articleCell.className = "contenuetable";
        const productDetail = document.createElement("div");
        productDetail.className = "d-flex product-detail";
        const productName = document.createElement("span");
        productName.className = "Body14pxSemiBold";
        productName.textContent = product.designation;
        const productPrice = document.createElement("span");
        productPrice.className = "Body14pxRegular";

        let displayPrice = product.prixunitaire;
        if (product.isWeightBased) {
            displayPrice = roundToNearest100(product.prixunitaire);
        }
        productPrice.textContent = formatAmount(displayPrice, true);

        productDetail.appendChild(productName);
        productDetail.appendChild(productPrice);
        articleCell.appendChild(productDetail);
        row.appendChild(articleCell);

        // Column 3: Quantity
        const qteCell = document.createElement("td");
        qteCell.className = "contenuetable col-qte";
        const qteAction = document.createElement("div");
        qteAction.className = "d-flex gap-1 qte-action";

        const minusBtn = document.createElement("button");
        minusBtn.className = "btn btn-secondary btn-small minus-btn-qte";
        minusBtn.type = "button";
        minusBtn.innerHTML = '<i class="material-symbols-rounded">remove</i>';
        minusBtn.onclick = function() {
            const qteVisibleInput = row.querySelector(".qte-editable-input");
            const qteHiddenInput = row.querySelector("input[name^='qte_']");
            const currentQte = parseAmount(qteVisibleInput?.value || 0);
            const newQte = Math.max(currentQte - 1, 0);
            qteHiddenInput.value = newQte;
            qteVisibleInput.value = newQte;
            updateTotals();
            sync();
        };

        const qteVisibleInput = document.createElement("input");
        qteVisibleInput.type = "text";
        qteVisibleInput.className = "qte-editable-input Body14pxSemiBold";
        qteVisibleInput.value = product.quantite;

        qteVisibleInput.addEventListener('focus', function() { setActiveInput(this); });
        qteVisibleInput.addEventListener('click', function() { setActiveInput(this); });

        qteVisibleInput.addEventListener('keydown', function(e) {
            if ([46, 8, 9, 27, 13].includes(e.keyCode) ||
                (e.keyCode === 65 && e.ctrlKey === true) ||
                (e.keyCode >= 35 && e.keyCode <= 39)) {
                return;
            }
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) &&
                (e.keyCode < 96 || e.keyCode > 105) &&
                e.keyCode !== 188 && e.keyCode !== 190 && e.keyCode !== 110) {
                e.preventDefault();
            }
        });

        const plusBtn = document.createElement("button");
        plusBtn.className = "btn btn-primary btn-small plus-btn-qte";
        plusBtn.type = "button";
        plusBtn.innerHTML = '<i class="material-symbols-rounded">add</i>';
        plusBtn.onclick = function() {
            const qteVisibleInput = row.querySelector(".qte-editable-input");
            const qteHiddenInput = row.querySelector("input[name^='qte_']");
            const currentQte = parseAmount(qteVisibleInput?.value || 0);
            const newQte = currentQte + 1;
            qteHiddenInput.value = newQte;
            qteVisibleInput.value = newQte;
            updateTotals();
            sync();
        };

        qteAction.appendChild(minusBtn);
        qteAction.appendChild(qteVisibleInput);
        qteAction.appendChild(plusBtn);
        qteCell.appendChild(qteAction);
        row.appendChild(qteCell);

        // Column 4: Unit
        const unitCell = document.createElement("td");
        unitCell.className = "contenuetable";
        const unitSpan = document.createElement("span");
        unitSpan.className = "Body14pxRegular";
        unitSpan.textContent = product.isWeightBased ? "Gramme" : "Unité";
        unitCell.appendChild(unitSpan);
        row.appendChild(unitCell);

        const montantCell = document.createElement("td");
        montantCell.className = "contenuetable montant-row";
        let initialAmount = 0;
        if (product.isWeightBased) {
            // If weight based: (Qty * BasePrice) / 1000
            initialAmount = (product.quantite * (product.originalPrice || product.prixunitaire)) / 1000;
        } else {
            // If unit based: Qty * Price
            initialAmount = product.quantite * product.prixunitaire;
        }
        if(product.remiseMontant) {
            initialAmount -= product.remiseMontant;
        }
        montantCell.textContent = formatAmount(Math.max(initialAmount, 0), true);
        row.appendChild(montantCell);

        // Column 5: Actions
        const actionCell = document.createElement("td");
        actionCell.className = "contenuetable";
        const removeBtn = document.createElement("button");
        removeBtn.className = "btn btn-danger btn-small";
        removeBtn.type = "button";
        removeBtn.innerHTML = '<i class="fa fa-trash"></i>';
        removeBtn.onclick = function() { removeProductRow(this); };
        actionCell.appendChild(removeBtn);
        row.appendChild(actionCell);

        // Store data in row dataset
        row.dataset.productPhoto = product.urlPhoto || '';
        row.dataset.productName = product.designation;
        row.dataset.productReference = product.reference || '';
        row.dataset.productPrice = product.prixunitaire;
        row.dataset.productOriginalPrice = product.originalPrice || product.prixunitaire;

        tbody.appendChild(row);
    }

    // Rendre les fonctions disponibles globalement
    window.setActiveInput = setActiveInput;
    window.initVirtualKeyboard = initVirtualKeyboard;
</script>
<script>
    function swapclavier(){
        e.preventDefault();
        $('.modal-body .clavier-container').toggleClass('d-none');
        $('.clavier-abc-container').toggleClass('d-none');
    }
</script>
<%--par defaut eo @ produit ny cursor--%>
<script>
    function focusOnProduit() {
        const input = document.getElementById("idProduit_libelle");
        if (input) {
            // input.focus();
        }
    }
    //gestion de focus sur recherche produit
    window.onload = function() {
        focusOnProduit();
        restoreCartState();

        const observer = new MutationObserver(() => {
            // Ne pas remettre le focus si la fermeture du clavier est en cours
            if (bloquerOuvertureClavier) return;

            const activeElement = document.activeElement;
            const isUserTyping = activeElement && (
                activeElement.id === 'idClient_libelle' ||
                activeElement.classList.contains('ui-autocomplete-input') ||
                (activeElement.tagName === 'INPUT' && activeElement.type !== 'hidden')
            );

            // Si l'utilisateur n'est pas en train de taper ET que le clavier est fermé,
            // on ne ré-applique PAS brusquement le focus si un élément vient d'être ajouté.
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true,
            attributes: true
        });

        sendMessage("BIENVENUE !!!");
    };
</script>

<script src="/socobis/dist/js/socket.io.min.js"></script>
<script>

    const amountFormatter = new Intl.NumberFormat('fr-FR', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 2
    });
    const productImageFallback = '${pageContext.request.contextPath}/assets/img/products/no_image.png';

    function getIdNumber() {
        const ids = [];
        // Sélectionner tous les inputs dont le name commence par "designation_"
        const designations = document.querySelectorAll("input[name^='designation_']");
        if (!designations || designations.length == 0) {
            ids.push(0);
        }
        else
        {
            designations.forEach(input => {
                const match = input.name.match(/^designation_(\d+)$/);
                if (match) {
                    ids.push(parseInt(match[1], 10));
                }
            });
        }
        return ids;
    }

    function sync() {
        setupListeners();
        // Optionnel : appeler gatherProductData() pour initialiser l'état
        const products = gatherProductData();
        save(products);
        console.log("product sync", products);
    }

    function parseAmount(value) {
        if (value === null || value === undefined) {
            return 0;
        }
        const normalized = value.toString()
            .replace(/Ar/gi, '')
            .replace(/[\s\u00A0]/g, '')
            .replace(/,/g, '.');
        const parsed = Number(normalized);
        return Number.isFinite(parsed) ? parsed : 0;
    }

    function formatAmount(value, withCurrency) {
        const formatted = amountFormatter.format(Number(value) || 0);
        return withCurrency ? formatted + ' Ar' : formatted;
    }

    function setCellDisplay(cell, text) {
        if (!cell) {
            return;
        }
        Array.from(cell.childNodes).forEach(node => {
            if (node.nodeType === 3 && node.textContent.trim() !== '') {
                cell.removeChild(node);
            }
        });
        const hiddenInputs = cell.querySelectorAll("input[type='hidden']");
        let span = cell.querySelector('.cell-value');
        if (!span) {
            span = document.createElement('span');
            span.className = 'cell-value';
            if (hiddenInputs.length > 0) {
                cell.insertBefore(span, hiddenInputs[0]);
            } else {
                cell.appendChild(span);
            }
        }
        // span.textContent = text;
    }

    function getCellDisplay(cell) {
        if (!cell) {
            return '';
        }
        const span = cell.querySelector('.cell-value');
        if (span) {
            return span.textContent.trim();
        }
        return cell.textContent.trim();
    }


    function parseWeightBarcode(barcode) {
        const cleaned = barcode.trim();
        const codeLen = 13;
        console.log("Full barcode scanned:", cleaned);
        console.log("Barcode length:", cleaned.length);

        if (cleaned.length < codeLen) {
            return { isWeightBased: false, productCode: null, weight: null };
        }

        const prefix = cleaned.substring(0, 2);
        const productCode = cleaned.substring(4, 7);
        const weightStr = cleaned.substring(7, 12);
        const weight = parseInt(weightStr, 10);

        return {
            isWeightBased: true,
            productCode: productCode,
            weight: isNaN(weight) ? 0 : weight
        };
    }

    async function getProductByBarcode(barcode) {
        const barcodeInfo = parseWeightBarcode(barcode);

        try {
            const response = await fetch(`${pageContext.request.contextPath}/ApresTarif?acte=pos&reference=${barcodeInfo.productCode}`);
            const data = await response.json();

            if (data.productPos) {
                console.log('Product retrieved from barcode:', data.productPos);
                return {
                    product: data.productPos,
                    barcodeInfo: barcodeInfo,
                    isWeightUnit: data.productPos.unite === "UNT00004"
                };
            } else {
                console.log('No product found for reference:', barcodeInfo.productCode);
                return { product: null, error: "Product not found" };
            }
        } catch (error) {
            console.error('Error fetching product by barcode:', error);
            return { product: null, error: error.message };
        }
    }

    window.parseWeightBarcode = parseWeightBarcode;
    window.formatAmount = formatAmount;
    window.parseAmount = parseAmount;
    window.setCellDisplay = setCellDisplay;
    window.getCellDisplay = getCellDisplay;
    window.refreshProductPreview = refreshProductPreview;
    window.removeProductRow = removeProductRow;

    function resolveProductImage(photo) {
        console.log({photo})
        if (!photo) {
            return `${pageContext.request.contextPath}/assets/img/products/no_image.png`;
        }
        if (/^https?:\/\//i.test(photo)) {
            return photo;
        }
        return `${pageContext.request.contextPath}/assets/img/produit/`+photo;
    }

    // Exemple d'utilisation
    const img = document.createElement("img");
    img.className = "logo";
    img.alt = "photo du produit";

    img.src = resolveProductImage(val);

    // imageFallback
    img.onerror = function() {
        this.onerror = null; // empêche boucle infinie
        this.src = `${pageContext.request.contextPath}/assets/img/products/no_image.png`;
    };

    cell.appendChild(img);


    function updateProductPreview({ photo, name, code, price }) {
        console.log({photo})

        const box = document.getElementById('selectedProductBox');
        if (!box) {
            return;
        }

        box.classList.remove('d-none');

        const imageElement = document.getElementById('selectedProductImage');
        if (imageElement) {
            imageElement.src = resolveProductImage(photo);
            imageElement.onerror = function () {
                this.onerror = null;
                this.src = productImageFallback;
            };
        }

        const nameElement = document.getElementById('selectedProductName');
        if (nameElement) {
            nameElement.textContent = name && name.trim() !== '' ? name : 'Aucun produit';
        }

        const codeElement = document.getElementById('selectedProductCode');
        if (codeElement) {
            // Use reference instead of ID
            codeElement.textContent = code && code.trim() !== '' ? code : '--';
        }

        const priceElement = document.getElementById('selectedProductPrice');
        if (priceElement) {
            const numericPrice = parseAmount(price);
            priceElement.textContent = formatAmount(numericPrice, true);
        }
    }

    function hideProductPreview() {
        const box = document.getElementById('selectedProductBox');
        if (!box) {
            return;
        }
        box.classList.add('d-none');
    }

    function refreshProductPreview(previewData) {
        if (previewData && (previewData.name || previewData.photo || previewData.code)) {
            // updateProductPreview(previewData);
            return;
        }

        const rows = document.querySelectorAll('#panierBody tr');
        if (!rows.length) {
            hideProductPreview();
            return;
        }

        const lastRow = rows[rows.length - 1];
        const data = {
            photo: lastRow?.dataset?.productPhoto || '',
            name: lastRow?.dataset?.productName || '',
            code: lastRow?.dataset?.productReference || lastRow?.dataset?.productCode || '',
            price: lastRow?.dataset?.productOriginalPrice || lastRow?.dataset?.productPrice || ''
        };
        // updateProductPreview(data);
    }

    function removeProductRow(button) {
        const row = button.closest('tr');
        if (!row) {
            return;
        }
        row.remove();
        updateTotals();
        refreshProductPreview();
        sync();
    }

    function adjustModalQuantity(delta) {
        const modalQuantite = document.getElementById("modalQuantite");
        if (!modalQuantite) {
            return;
        }

        const currentValue = parseAmount(modalQuantite.value || 0);
        const updated = Math.max(currentValue + delta, 0);
        modalQuantite.value = Number.isInteger(updated) ? updated : updated.toFixed(2);
    }

    document.addEventListener("click", function (e) {
        const modifierBtn = e.target.closest(".btn-modifier");
        if (!modifierBtn) {
            return;
        }

        const tr = modifierBtn.closest("tr");
        if (!tr) {
            return;
        }

        const cells = Array.from(tr.querySelectorAll("td"));
        if (cells.length < 7) {
            return;
        }

        const modalPhoto = document.getElementById("modalPhoto");
        const modalArticle = document.getElementById("modalArticle");
        const modalCode = document.getElementById("modalCode");
        const modalPrix = document.getElementById("modalPrix");
        const modalRemise = document.getElementById("modalRemise");
        const modalQuantite = document.getElementById("modalQuantite");

        const articleCell = cells[1];
        const codeCell = cells[2];
        const quantiteCell = cells[3];
        const prixUnitaireCell = cells[4];
        const remiseCell = cells[5];

        if (modalPhoto) {
            const photo = tr.querySelector("img")?.src || "";
            modalPhoto.src = photo;
        }
        if (modalArticle) {
            modalArticle.textContent = getCellDisplay(articleCell);
        }
        if (modalCode) {
            modalCode.textContent = getCellDisplay(codeCell);
        }
        if (modalPrix) {
            modalPrix.textContent = getCellDisplay(prixUnitaireCell);
        }

        const quantiteValue = parseAmount(tr.querySelector("input[name^='qte_']")?.value || getCellDisplay(quantiteCell));
        const remiseValue = parseAmount(tr.querySelector("input[name^='remiseMontant_']")?.value || getCellDisplay(remiseCell));

        if (modalQuantite) {
            modalQuantite.value = Number.isInteger(quantiteValue) ? quantiteValue : quantiteValue.toFixed(2);
        }
        if (modalRemise) {
            modalRemise.value = remiseValue.toString();
        }
    });

    function autoCompleteDyn(inputID, table, classe, champRetour,valeur) {
        let input = document.getElementById(inputID);
        if (!input) {
            return;
        }
        input.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' || event.key === 'Tab') {
                event.preventDefault();
                let prest = input.value;
                if (prest != null && prest.trim() !== "") {
                    let temp = prest.split("::");
                    input.value = temp[0].trim();
                }
            } else {

                $('#' + inputID).autocomplete({
                    source: function (request, response) {
                        let rep =  fetchAutocomplete(request, response, "null", valeur, "null", table, classe, "true",champRetour,"null");
                        console.log("REP", rep)
                    },
                    minLength: 0,
                    select: function (event, ui) {
                        let selectedObj = ui.item;
                        let prest = selectedObj.value;
                        let temp = prest.split("::");
                        let compte = temp[0].trim();

                        let prest2 = selectedObj.label;
                        let temp2 = prest2.split("::");
                        let compte2 = temp2[0].trim();

                        document.getElementById(inputID).value = compte2;
                        let tempinput = inputID.split("_");
                        console.log(selectedObj);
                        console.log(compte2);
                        console.log('#',inputID);
                        console.log('#',tempinput[0])
                        $('#'+tempinput[0]).val(compte)
                        document.getElementById(tempinput[0]).dispatchEvent(new Event("change"));

                        setTimeout(() => {
                            const input = document.getElementById(inputID);
                            input.value = compte2;
                            console.log('Set value:', input.value);

                            // Après sélection du client, refocuser sur le champ produit
                            if (inputID === 'idClient_libelle') {
                                setTimeout(() => {
                                    focusOnProduit();
                                }, 100);
                            }
                        }, 10);

                        return false;
                    }
                });
            }
        });
    }

    // autocomplete efa tonga de miselectionner produit hoazy raha iray ilay resultat hitany
    function autoCompleteVenteDirect(inputID, table, classe, champRetour, inputNom, valeur) {
        const champsBase = champRetour.split(";").filter(c => !c.includes("="));
        const inputNames = inputNom.split(";");

        const defaults = {};
        champRetour.split(";").forEach(c => {
            if (c.includes("=")) {
                const [key, val] = c.split("=");
                defaults[key] = val;
            }
        });

        let input = document.getElementById(inputID);
        if (!input) return;

        $('#' + inputID).autocomplete({
            source: function(request, response) {
                const searchTerm = request.term;
                const barcodeInfo = parseWeightBarcode(searchTerm);
                console.log("BARCODE  INFO",barcodeInfo)

                if (barcodeInfo.isWeightBased) {
                    const productCode = barcodeInfo.productCode;
                    const codegrosSearchRequest = { term: productCode };
                    fetchAutocomplete(codegrosSearchRequest, function(codegrosResults) {
                        console.log("Codegros search results:", codegrosResults);

                        const codegrosMatch = codegrosResults.find(result => {
                            let codegros = '';
                            const values = (result.retour || "").split(";");
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) {
                                    codegros = values[idx].toString();
                                }
                            });

                            if (!codegros) {
                                const valueParts = result.value.split(' - ');
                                console.log('===> valueParts', valueParts);
                                for (let i = 0; i < valueParts.length; i++) {
                                    let valiny = '[' + i + ']' + ' ===> '  + valueParts[i];
                                    console.log('valiny ======> ', valiny);
                                }
                                if (valueParts.length >= 5) {
                                    codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                                }
                            }
                            return codegros === productCode;
                        });

                        if (codegrosMatch) {
                            const values = (codegrosMatch.retour || "").split(";");
                            let codegros = '', reference = '', pvgros = '', pv = '';
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) codegros = values[idx].toString();
                                if (col === 'reference' && values[idx]) reference = values[idx].toString();
                                if (col === 'pvgros' && values[idx]) pvgros = values[idx].toString();
                                if (col === 'pv' && values[idx]) pv = values[idx].toString();
                            });

                            handleProductSelection(codegrosMatch, inputID, champRetour, inputNom, valeur, defaults, barcodeInfo.weight);
                            $('#' + inputID).autocomplete("close");
                        } else {
                            fetchAutocompletePrecis(codegrosSearchRequest, function(refResults) {
                                if (refResults && refResults.length > 0) {
                                    const single = refResults[0];
                                    handleProductSelection(single, inputID, champRetour, inputNom, valeur, defaults, barcodeInfo.weight);
                                    $('#' + inputID).autocomplete("close");
                                } else {
                                    response(refResults);
                                }
                            }, "null", valeur, "null", table, classe, "true", champsBase.join(";"), "null", "true");
                        }
                    }, "null", valeur, "null", table, classe, "true", champsBase.join(";"), "null");
                } else {
                    console.log("Regular search term, not weight-based");
                    const searchRequest = { term: searchTerm };
                    fetchAutocomplete(searchRequest, function(results) {
                        console.log("Search results for non-weight code:", results);
                        if (searchTerm.length < 3) {
                            response(results);
                            return;
                        }

                        const wholesaleMatch = results.find(result => {
                            let codegros = '';
                            const values = (result.retour || "").split(";");
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) {
                                    codegros = values[idx].toString();
                                }
                            });

                            if (!codegros) {
                                const valueParts = result.value.split(' - ');
                                if (valueParts.length >= 5) {
                                    codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                                }
                            }

                            return codegros === searchTerm;
                        });

                        if (wholesaleMatch) {
                            const values = (wholesaleMatch.retour || "").split(";");
                            let codegros = '', reference = '', pvgros = '', pv = '';
                            champsBase.forEach((col, idx) => {
                                if (col === 'codegros' && values[idx]) codegros = values[idx].toString();
                                if (col === 'reference' && values[idx]) reference = values[idx].toString();
                                if (col === 'pvgros' && values[idx]) pvgros = values[idx].toString();
                                if (col === 'pv' && values[idx]) pv = values[idx].toString();
                            });

                            handleProductSelection(wholesaleMatch, inputID, champRetour, inputNom, valeur, defaults);
                            $('#' + inputID).autocomplete("close");
                        } else {
                            response(results);
                            if (results && results.length === 1) {
                                const single = results[0];
                                const term = searchTerm.trim().toLowerCase();
                                const values = (single.retour || "").split(";");
                                let isExactMatch = false;

                                champsBase.forEach((col, idx) => {
                                    if (values[idx]) {
                                        const val = values[idx].toString().toLowerCase().trim();
                                        if (val === term) {
                                            isExactMatch = true;
                                        }
                                    }
                                });

                                if (!isExactMatch) {
                                    if ((single.label && single.label.toLowerCase() === term) ||
                                        (single.value && single.value.toLowerCase() === term)) {
                                        isExactMatch = true;
                                    }
                                }

                                if (isExactMatch) {
                                    handleProductSelection(single, inputID, champRetour, inputNom, valeur, defaults);
                                    $('#' + inputID).autocomplete("close");
                                }
                            }
                        }
                    }, "null", valeur, "null", table, classe, "true", champsBase.join(";"), "null");
                }
            },
            minLength: 0,
            select: function(event, ui) {
                if (event) event.preventDefault(); // EMPÊCHE jQuery UI de remettre le texte dans l'input !
                const currentInput = $('#' + inputID).val();
                const barcodeInfo = parseWeightBarcode(currentInput);

                if (barcodeInfo.isWeightBased) {
                    let codegros = '';
                    let unite='';
                    const values = (ui.item.retour || "").split(";");
                    champsBase.forEach((col, idx) => {
                        if (col === 'codegros' && values[idx]) {
                            codegros = values[idx].toString();
                        }
                        if (col === 'unite' && values[idx]) {
                            unite = values[idx].toString();
                        }
                    });

                    ui.item.unite = unite;

                    if (!codegros) {
                        const valueParts = ui.item.value.split(' - ');
                        if (valueParts.length >= 5) {
                            codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                        }
                    }


                    const isWholesale = codegros === barcodeInfo.productCode;
                    handleProductSelection(ui.item, inputID, champRetour, inputNom, valeur, defaults, barcodeInfo.weight);
                } else {
                    let codegros = '';
                    const values = (ui.item.retour || "").split(";");
                    champsBase.forEach((col, idx) => {
                        if (col === 'codegros' && values[idx]) {
                            codegros = values[idx].toString();
                        }
                    });

                    if (!codegros) {
                        const valueParts = ui.item.value.split(' - ');
                        if (valueParts.length >= 5) {
                            codegros = valueParts[4]; // codegros is the 5th element (0-indexed: 4)
                        }
                    }
                    if (codegros === currentInput) {
                        handleProductSelection(ui.item, inputID, champRetour, inputNom, valeur, defaults);
                    } else {
                        handleProductSelection(ui.item, inputID, champRetour, inputNom, valeur, defaults);
                    }
                }
                return false;
            }
        });
    }


    // Check for existing products, if so add. Helper method 1 here. Consult Stefan for any queries

    function getExistingProductRow(productId) {
        if (!productId) return null;
        const normalized = productId.toString().trim();
        let found = null;

        document.querySelectorAll("input[name^='idProduit_']").forEach(input => {
            if (found) return;
            const val = (input.value || "").toString().trim();
            if (val && val === normalized) {
                const row = input.closest('tr');
                // ignorer la ligne modèle non-remplie (designation vide)
                const designation = row?.querySelector("input[name^='designation_']")?.value?.trim();
                if (row && designation) {
                    found = row;
                }
            }
        });

        return found;
    }

    // Check for existing products, if so add. Helper method 2 here. Consult Stefan for any queries
    function incrementProductRow(row, overrideQuantity) {
        const qteInput = row.querySelector("input[name^='qte_']");
        const puInput = row.querySelector("input[name^='pu_']");
        const basePriceKgInput = row.querySelector("input[name^='basePriceKg_']");
        const uniteInput = row.querySelector("input[name^='unite_']");

        if (!qteInput) return;

        const uniteCode = uniteInput?.value || '';
        const isWeightBased = uniteCode === "UNT00004";

        // Produit au poids : on ajoute le poids scanné (ou 10g par défaut)
        // Produit à l'unité : on ajoute 1
        const increment = isWeightBased
            ? (overrideQuantity !== null && overrideQuantity !== undefined ? overrideQuantity : 10)
            : 1;

        const currentQte = parseAmount(qteInput.value || 0);
        const newQte = currentQte + increment;
        qteInput.value = newQte;

        if (isWeightBased && basePriceKgInput && puInput) {
            const basePricePerKg = parseAmount(basePriceKgInput.value);
            puInput.value = (newQte * basePricePerKg) / 1000;
        }

        updateTotals();
        sync();

        // petit retour visuel pour confirmer au caissier
        row.classList.add('row-qty-updated');
        setTimeout(() => row.classList.remove('row-qty-updated'), 500);
    }

    function handleProductSelection(selectedObj, inputID, champRetour, inputNom, valeur, defaults, overrideQuantity = null) {
        if (!selectedObj || !selectedObj.value) return;

        const champsBase = champRetour.split(";").filter(c => !c.includes("="));
        const inputNames = inputNom.split(";");

        // 1. Vérifier si le produit existe déjà dans le panier (Incrémenter si oui)
        const productIdCandidate = selectedObj.value.split("::")[0].trim();
        const existingRow = getExistingProductRow(productIdCandidate);
        if (existingRow) {
            incrementProductRow(existingRow, overrideQuantity);
            fermerClavierVisuel();
            const input = document.getElementById(inputID);
            if (input) { input.value = ""; input.blur(); }
            return;
        }

        let tbody = document.getElementById("ajout_multiple_ligne");
        if (!tbody) return;

        // 2. Déterminer si la ligne 0 (modèle) est libre ou s'il faut ajouter une nouvelle ligne
        let row = null;
        let rowCount = 0;
        const line0 = document.getElementById("ligne-multiple-0");
        const desig0 = document.getElementById("designation_0");

        if (line0 && desig0 && (!desig0.value || desig0.value.trim() === "")) {
            // Réutiliser la ligne 0 initiale si elle est encore vide
            row = line0;
            rowCount = 0;
        } else {
            // Sinon créer une nouvelle ligne
            let idsInput = getIdNumber();
            rowCount = idsInput.length > 0 ? idsInput[idsInput.length - 1] + 1 : 1;

            let addLineButton = document.getElementById("addLines");
            if (addLineButton) {
                addLineButton.dispatchEvent(new Event("click"));
                if (typeof attachEvents === 'function') attachEvents();
            }

            row = document.getElementById("ligne-multiple-" + rowCount);
        }

        if (!row) {
            console.error("[POS] Ligne HTML introuvable pour rowCount:", rowCount);
            return;
        }

        // Rendre la ligne bien visible (enlever le d-none hérité de la ligne 0)
        row.classList.remove("d-none");

        // Cocher la checkbox uniquement si elle existe (évite le crash JS)
        const check = document.getElementById("checkbox" + rowCount);
        if (check) {
            check.checked = true;
        }

        // ID du produit
        let hiddenID = document.getElementById("idProduit_" + rowCount);
        if (!hiddenID) {
            hiddenID = document.createElement("input");
            hiddenID.type = "hidden";
            hiddenID.name = "idProduit_" + rowCount;
            hiddenID.id = "idProduit_" + rowCount;
            row.appendChild(hiddenID);
        }
        hiddenID.value = productIdCandidate;

        let hiddenEstEnGros = document.getElementById("estEnGros_" + rowCount);
        if (!hiddenEstEnGros) {
            hiddenEstEnGros = document.createElement("input");
            hiddenEstEnGros.type = "hidden";
            hiddenEstEnGros.name = "estEnGros_" + rowCount;
            hiddenEstEnGros.id = "estEnGros_" + rowCount;
            row.appendChild(hiddenEstEnGros);
        }
        hiddenEstEnGros.value = "0";

        const valeurs = (selectedObj.retour || "").split(";");
        const finalColumns = champRetour.split(";").map(c => c.split("=")[0]);
        const productId = productIdCandidate;
        const productPreviewData = { photo: '', name: '', code: productId, price: '' };

        let photoVal = '', designationVal = '', qteVal = '1', puVal = '0', pvgrosVal = '', remiseVal = '0', prixVal = '0', compteVenteVal = '';
        let referenceVal = '', codegrosVal = '';

        champsBase.forEach((col, idx) => {
            if (valeurs[idx] !== undefined) {
                if (col === 'reference') referenceVal = valeurs[idx].toString();
                if (col === 'codegros') codegrosVal = valeurs[idx].toString();
                if (col === 'pvgros') pvgrosVal = valeurs[idx].toString();
                if (col === 'compte') compteVenteVal = valeurs[idx].toString();
                if (col === 'remise') remiseVal = valeurs[idx].toString();
            }
        });

        const labelParts = (selectedObj.label || "").split(' - ');
        if (labelParts.length >= 4) referenceVal = labelParts[3].trim();
        if (labelParts.length >= 5) codegrosVal = labelParts[4].trim();

        const originalInput = document.getElementById(inputID) ? document.getElementById(inputID).value : "";
        const barcodeInfo = parseWeightBarcode(originalInput);

        let isWholesaleCode = false;
        if (barcodeInfo.isWeightBased) {
            isWholesaleCode = codegrosVal && barcodeInfo.productCode.toString() === codegrosVal;
        } else {
            isWholesaleCode = codegrosVal && originalInput.toString() === codegrosVal;
        }

        if (isWholesaleCode) {
            hiddenEstEnGros.value = "1";
        }

        // Remplir les inputs
        finalColumns.forEach((col, idx) => {
            const val = defaults[col] !== undefined ? defaults[col] : (champsBase.indexOf(col) >= 0 ? valeurs[champsBase.indexOf(col)] : "");
            if (inputNames[idx] === 'qte' && overrideQuantity !== null) {
                qteVal = overrideQuantity.toString();
            } else {
                if (inputNames[idx] === 'photo') photoVal = val;
                if (inputNames[idx] === 'designation') designationVal = val;
                if (inputNames[idx] === 'qte') qteVal = val || '1';
                if (inputNames[idx] === 'reference') referenceVal = val;
                if (inputNames[idx] === 'pu') {
                    const priceToUse = isWholesaleCode && pvgrosVal ? pvgrosVal : val;
                    if (overrideQuantity !== null) {
                        const uniteParts = selectedObj.retour ? selectedObj.retour.split(';') : [];
                        const uniteCode = uniteParts.length >= 7 ? uniteParts[6] : null;
                        const basePrice = parseAmount(priceToUse);
                        puVal = uniteCode === "UNT00004"
                            ? ((overrideQuantity * basePrice) / 1000).toString()
                            : basePrice.toString();
                    } else {
                        puVal = priceToUse;
                    }
                }
                if (inputNames[idx] === 'pu_pvgros') pvgrosVal = val;
                if (inputNames[idx] === 'remiseMontant') remiseVal = val || '0';
                if (inputNames[idx] === 'prix') prixVal = val || '0';
                if (inputNames[idx] === 'compte') compteVenteVal = val;
            }

            if (inputNames[idx]) {
                let hiddenInput = document.getElementById(inputNames[idx] + "_" + rowCount);
                if (!hiddenInput) {
                    hiddenInput = document.createElement("input");
                    hiddenInput.type = "hidden";
                    hiddenInput.name = inputNames[idx] + "_" + rowCount;
                    hiddenInput.id = inputNames[idx] + "_" + rowCount;
                    row.appendChild(hiddenInput);
                }

                let inputValue = val;
                if (inputNames[idx] === 'qte' && overrideQuantity !== null) {
                    inputValue = overrideQuantity.toString();
                } else if (inputNames[idx] === 'pu') {
                    inputValue = puVal;
                } else if (inputNames[idx] === 'reference') {
                    inputValue = referenceVal;
                } else if (inputNames[idx] === 'compte') {
                    inputValue = compteVenteVal;
                }

                hiddenInput.value = inputValue;
            }
        });

        //CHANGE STE
        // Base de remise par unité (utilisée par updateTotals() pour multiplier
        // par la quantité). remiseVal/qteVal reflètent les valeurs par défaut à
        // ce stade (la remise réelle sera ensuite renvoyée par IngredientsRemiseServlet).
        row.dataset.remiseUnitaire = (parseAmount(remiseVal) || 0) / (parseAmount(qteVal) || 1);
        //CHANGE STE

        // Affichage Image
        const photoInput = document.getElementById("photo_" + rowCount);
        if (photoInput) {
            photoInput.type = "hidden";
            const tdimg = photoInput.closest('td');
            if (tdimg) {
                tdimg.querySelectorAll("img").forEach(i => i.remove());
                const img = document.createElement("img");
                img.className = "product-img";
                img.alt = "Produit sélectionné";
                img.src = resolveProductImage(photoVal);
                img.onerror = function() { this.src = productImageFallback; };
                tdimg.insertBefore(img, photoInput);
            }
        }

        // Quantité & Boutons +/-
        const qteVisibleInput = document.getElementById("qte_" + rowCount) || row.querySelector("input[name^='qte_']");
        if (qteVisibleInput) {
            const tdqte = qteVisibleInput.closest("td");
            if (tdqte) {
                const minusBtn = document.createElement("button");
                minusBtn.className = "btn btn-secondary btn-small minus-btn-qte";
                minusBtn.type = "button";
                minusBtn.innerHTML = '<i class="material-symbols-rounded">remove</i>';
                minusBtn.onclick = function() {
                    const qteHiddenInput = row.querySelector("input[name^='qte_']");
                    const puInput = row.querySelector("input[name^='pu_']");
                    const basePriceKgInput = row.querySelector("input[name^='basePriceKg_']");
                    const uniteInput = row.querySelector("input[name^='unite_']");
                    const currentQte = parseAmount(qteHiddenInput?.value || 0);
                    const uniteCode = uniteInput?.value || '';
                    const isWeightBased = uniteCode === "UNT00004";
                    const decrement = isWeightBased ? 10 : 1;
                    const newQte = Math.max(currentQte - decrement, 0);
                    if (qteHiddenInput) qteHiddenInput.value = newQte;
                    if (qteVisibleInput) qteVisibleInput.value = newQte;

                    if (isWeightBased && basePriceKgInput && puInput) {
                        const basePricePerKg = parseAmount(basePriceKgInput.value);
                        puInput.value = (newQte * basePricePerKg) / 1000;
                    }
                    updateTotals();
                    sync();
                };

                const plusBtn = document.createElement("button");
                plusBtn.className = "btn btn-secondary btn-small plus-btn-qte";
                plusBtn.type = "button";
                plusBtn.innerHTML = '<i class="material-symbols-rounded">add</i>';
                plusBtn.onclick = function() {
                    const qteHiddenInput = row.querySelector("input[name^='qte_']");
                    const puInput = row.querySelector("input[name^='pu_']");
                    const basePriceKgInput = row.querySelector("input[name^='basePriceKg_']");
                    const uniteInput = row.querySelector("input[name^='unite_']");
                    const currentQte = parseAmount(qteHiddenInput?.value || 0);
                    const uniteCode = uniteInput?.value || '';
                    const isWeightBased = uniteCode === "UNT00004";
                    const increment = isWeightBased ? 10 : 1;
                    const newQte = currentQte + increment;
                    if (qteHiddenInput) qteHiddenInput.value = newQte;
                    if (qteVisibleInput) qteVisibleInput.value = newQte;

                    if (isWeightBased && basePriceKgInput && puInput) {
                        const basePricePerKg = parseAmount(basePriceKgInput.value);
                        puInput.value = (newQte * basePricePerKg) / 1000;
                    }
                    updateTotals();
                    sync();
                };

                qteVisibleInput.addEventListener('input', function() {
                    updateTotals();
                    sync();
                });

                const qteWrapper = document.createElement("div");
                qteWrapper.className = "d-flex gap-1 qte-action-container";
                qteWrapper.appendChild(minusBtn);
                qteWrapper.appendChild(qteVisibleInput);
                qteWrapper.appendChild(plusBtn);

                tdqte.innerHTML = "";
                tdqte.appendChild(qteWrapper);
            }
        }

        // Unité
        let uniteCode = '';
        let uniteLibelle = '';
        champsBase.forEach((col, idx) => {
            if (col === 'unite' && valeurs[idx]) uniteCode = valeurs[idx].toString();
            if (col === 'uniteLibelle' && valeurs[idx]) uniteLibelle = valeurs[idx].toString();
        });
        if (!uniteLibelle && uniteCode === "UNT00004") uniteLibelle = "Gramme";
        else if (!uniteLibelle) uniteLibelle = "Unité";

        const hiddenUnite = document.getElementById("unite_" + rowCount);
        if (hiddenUnite) {
            const tdunite = hiddenUnite.closest("td");
            if (tdunite) {
                const unitSpan = document.createElement("span");
                unitSpan.className = "Body14pxRegular";
                unitSpan.textContent = uniteLibelle;
                tdunite.innerHTML = "";
                tdunite.appendChild(unitSpan);
                tdunite.appendChild(hiddenUnite);
            }
        }

        row.dataset.productPhoto = photoVal;
        row.dataset.productName = designationVal;
        row.dataset.productCode = productId;
        row.dataset.productReference = referenceVal;
        row.dataset.productPrice = puVal;

        try {
            if (typeof formaterActionLigne === 'function') {
                formaterActionLigne(row);
            }
        } catch(err) {}

        // CHANGE STE
        (function() {
            const idClient = document.querySelector("[name='idClient']")?.value
                || document.getElementById("idClient")?.value
                || "";
            const idPoint = '<%=session.getAttribute("idPoint")%>';

            fetch(`${pageContext.request.contextPath}/IngredientsRemiseServlet`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: new URLSearchParams({
                    idProduit: productId,
                    idClient: idClient,
                    idPoint: idPoint
                })
            })
                .then(response => response.json())
                .then(data => {
                    console.log("idProduit:", productId);
                    console.log("idClient:", idClient);
                    console.log("idPoint:", idPoint);

                    if (data.hasRemise) {
                        console.log("=== REMISE FOUND ===");
                        console.log("Remise value:", data.remise);
                        console.log("PV Remise value:", data.pvRemise);

                        const qteActuelle = parseAmount(row.querySelector("input[name^='qte_']")?.value || 1) || 1;
                        row.dataset.remiseUnitaire = parseAmount(data.remise);
                        $("#remiseMontant_" + rowCount).val(data.remise);
                        $("#pu_" + rowCount).val(formatAmount(data.pvRemise, true));

                        updateTotals();
                        sync();
                    }
                })
                .catch(error => {
                    console.error("Error checking remise:", error);
                });
        })();

        // CHANGE STE

        // MAJ TOTAUX & SYNC (S'exécute enfin au premier clic !)
        sync();
        updateTotals();
        refreshProductPreview(productPreviewData);

        // FERMETURE DU CLAVIER & VIDAGE DU CHAMP
        fermerClavierVisuel();

        const searchInput = document.getElementById(inputID);
        if (searchInput) {
            searchInput.value = "";
            searchInput.blur();
            if (typeof $ !== 'undefined' && $(searchInput).data('ui-autocomplete')) {
                try { $(searchInput).autocomplete("close"); } catch(e){}
            }
        }

        setTimeout(function() {
            if (searchInput) { searchInput.value = ""; searchInput.blur(); }
            fermerClavierVisuel();
        }, 100);
    }


</script>
<%--calcul prix et calcul montant total a payer avec remise --%>
<script>
    function updateTotals() {
        let sousTotal = 0;
        let remiseTotale = 0;
        document.querySelectorAll("#ajout_multiple_ligne tr").forEach(tr => {
            const qteInput = tr.querySelector("input[name^='qte_']");
            const puInput = tr.querySelector("input[name^='pu_']");
            const remiseInput = tr.querySelector("input[name^='remiseMontant_']");
            const prixInput = tr.querySelector("input[name^='montant_']");
            const uniteInput = tr.querySelector("input[name^='unite_']");

            const montantCell = tr.querySelector(".montant-row");
            const qteMinusBtn = tr.querySelector(".minus-btn-qte");
            const qtePlusBtn = tr.querySelector(".plus-btn-qte");

            // Change Ste

            const quantite = parseAmount(qteInput?.value || 0);
            const prixUnitaire = parseAmount(puInput?.value || 0);
            const uniteCode = uniteInput?.value || '';
            const isWeightBased = uniteCode === "UNT00004";

            const remiseUnitaire = tr.dataset.remiseUnitaire !== undefined
                ? parseAmount(tr.dataset.remiseUnitaire)
                : parseAmount(remiseInput?.value || 0);
            const remise = isWeightBased
                ? parseAmount(remiseInput?.value || 0) // produits au poids: remise non multipliée par la quantité
                : remiseUnitaire * quantite;
            if (remiseInput) {
                remiseInput.value = remise;
            }

            //Change Ste

            if (isWeightBased) {
                qteMinusBtn?.setAttribute("disabled", true);
                qtePlusBtn?.setAttribute("disabled", true);
            } else {
                qteMinusBtn?.removeAttribute("disabled");
                qtePlusBtn?.removeAttribute("disabled");
            }


            const montantBrut = isWeightBased
                ? prixUnitaire
                : quantite * prixUnitaire;

            sousTotal += montantBrut;
            remiseTotale += remise;

            const montantNet = Math.max(montantBrut - remise, 0);

            if (prixInput) {
                prixInput.value = montantNet.toFixed(2);
            }
            if (montantCell) {
                montantCell.textContent = formatAmount(montantNet, true);
            }
            const prixCell = prixInput ? prixInput.closest('td') : tr.querySelector("td:nth-last-child(2)");
            if (prixCell) {
                setCellDisplay(prixCell, formatAmount(montantNet));
            }
        });

        const total = Math.max(sousTotal - remiseTotale, 0);

        const sousTotalElement = document.getElementById("recapSousTotal");
        if (sousTotalElement) {
            sousTotalElement.textContent = formatAmount(sousTotal, true);
        }
        const remiseElement = document.getElementById("recapRemises");
        if (remiseElement) {
            remiseElement.textContent = formatAmount(remiseTotale, true);
        }

        const totalElement = document.getElementById("totalGeneral");
        if (totalElement) {
            const roundedTotal = roundToNearest100(total);
            sendMessage("A PAYER: " + formatNumberWithSpaces(roundedTotal) + " Ar");
            totalElement.textContent = formatAmount(roundedTotal, true);

            const totalElementInput = document.getElementById("totalGeneralInput");
            totalElementInput.value = parseAmount(totalElement.textContent);
        }

        if (typeof calculerRetour === 'function') {
            calculerRetour();
        }
    }

    function roundToNearest100(number) {
        return Math.round(number / 100) * 100;
    }

    function formatNumberWithSpaces(number) {
        return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
    }

    function sendMessage(texte) {
        const endpoint = "http://192.168.88.90:3100/lcd";
        const data = {
            message: texte
        };
        fetch(endpoint, {
            method: "POST",
            headers: {
                "content-type": "application/json"
            },
            body: JSON.stringify(data)
        })
            .then(
                (response) => {
                    if (!response.ok) {
                        throw new Error("Erreur réseau lors de l'envoi du message au LCD");
                    }
                    return response.json();
                }
            )
            .then(
                (result) => {
                    console.log("Message envoyé au LCD avec succès :", result);
                }
            ).catch(
            (error) => {
                console.error("Erreur lors de l'envoi du message au LCD :", error);
            }
        );
    }

    function attachEvents() {
        // document.querySelectorAll("input[name^='qte_'], input[name^='pu_'], input[name^='remiseMontant_']").forEach(input => {
        //     input.removeEventListener("input", updateTotals);
        //     input.addEventListener("input", updateTotals);
        //     input.removeEventListener("change", updateTotals);
        //     input.addEventListener("change", updateTotals);
        //     input.removeEventListener("blur", updateTotals);
        //     input.addEventListener("blur", updateTotals);
        // });
        document.querySelectorAll("a[onclick^='delete_line']").forEach(button => {
            button.removeEventListener("click", updateTotals);
            button.addEventListener("click", updateTotals);
        });
    }

    window.updateTotals = updateTotals;

    document.addEventListener("DOMContentLoaded", function() {
        attachEvents();
        checkPaymentValidation();
        updateTotals();
        refreshProductPreview();

        masquerEnTeteImageEnDouble();
        nettoyerBoutonsTableau();
        document.getElementById("ligne-multiple-0").classList.add("d-none");
        document.querySelectorAll('.box-footer.borderless.nopadding').forEach(footer => {
            footer.classList.add("d-none");
        })
    });

</script>
<script>

    // Change Ste
    function checkRemiseForRow(rowCount, productId, idClient, rowEl) {

        const idPoint = '<%=session.getAttribute("idPoint")%>';

        return fetch(`${pageContext.request.contextPath}/IngredientsRemiseServlet`, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams({
                idProduit: productId,
                idClient: idClient,
                idPoint: idPoint
            })
        })
            .then(response => response.json())
            .then(data => {

                console.log("Checking remise:");
                console.log("Product:", productId);
                console.log("Client:", idClient);
                console.log("Point:", idPoint);
                console.log("Response:", data);

                // On utilise l'élément <tr> passé par recheckRemiseAllRows quand il est
                // disponible ; sinon on retombe sur la recherche par ID (autres appelants).
                const row = rowEl || document.getElementById("remiseMontant_" + rowCount)?.closest('tr');


                if (data.hasRemise) {

                    console.log("=== REMISE FOUND 2 ===");
                    console.log("Remise:", data.remise);
                    console.log("PV Remise:", data.pvRemise);

                    // data.remise est une remise PAR UNITE : mémorisée comme base,
                    // updateTotals() la multipliera par la quantité de la ligne.
                    if (row) {
                        row.dataset.remiseUnitaire = parseAmount(data.remise);
                    }
                    $("#remiseMontant_" + rowCount).val(data.remise);
                    $("#pu_" + rowCount).val(formatAmount(data.pvRemise, true));

                    console.log("Product:", productId);
                    console.log("NEW PU INPUT:", $("#pu_" + rowCount).val());
                    console.log("NEW REMISE INPUT:", $("#remiseMontant_" + rowCount).val());


                    updateTotals();

                } else {

                    console.log("No remise found for product:", productId);

                    // Reset remise if the new client does not have one
                    if (row) {
                        row.dataset.remiseUnitaire = 0;
                    }
                    $("#remiseMontant_" + rowCount).val(0);

                    updateTotals();

                    // Here you need to decide:
                    // either restore original price
                    // or leave current price
                }

            })
            .catch(error => {
                console.error("Error checking remise:", error);
            });
    }

    // Change Ste

    // Change Ste
    $(document).ready(function () {
        $("#idClient").on("change", function () {

            let idClient = $(this).val();

            console.log("Client changed:", idClient);

            recheckRemiseAllRows(idClient);

        });
    });

    // CHECK REMISE HERE - rerun remise check for every already-selected product when the client changes
    function recheckRemiseAllRows(idClient) {

        console.log("Rechecking remise for client:", idClient);

        const promises = [];

        document.querySelectorAll("#ajout_multiple_ligne tr").forEach(tr => {
            const idProduitInput = tr.querySelector("input[name^='idProduit_']");
            if (!idProduitInput || !idProduitInput.value) return;

            const rowCount = idProduitInput.name.split("_")[1];
            promises.push(checkRemiseForRow(rowCount, idProduitInput.value, idClient, tr));
        });

        Promise.all(promises).then(() => {
            updateTotals();
            sync();
        });
    }

    // Change Ste

    function calculerMontant(indice,source) {
        var val = 0;
        $('input[id^="qte_"]').each(function() {
            var quantite =  parseFloat($("#"+$(this).attr('id').replace("qte","pu")).val());
            var montant = parseFloat($(this).val());
            if(!isNaN(quantite) && !isNaN(montant)){
                var value =quantite * montant;
                val += value;
            }
        });

        $('input[id^="remiseMontant_"]').each(function() {
            var remise = parseFloat($(this).val());  // <-- récupérer la valeur
            if (!isNaN(remise) && remise > 0) {
                val = val - remise;  // appliquer la remise en %
            }
        });

        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(val));
    }
    function deviseModification() {
        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){
                var mapping = {
                    "AR": {
                        "table": "ST_INGREDIENTSAUTOVENTE_MGA",
                    },
                    "USD": {
                        "table": "ST_INGREDIENTSAUTOVENTE_EURO"
                    },
                    "EUR": {
                        "table": "ST_INGREDIENTSAUTOVENTE_USD"
                    }
                };
                $("#deviseLibelle").html($('#idDevise').val());
                var idDevise = $('#idDevise').val();
                $("#idDevise_"+iL).val(idDevise);
                let autocompleteTriggered = false;
                $("#idProduit_"+iL+"libelle").autocomplete('destroy');
                $("#tauxDeChange_"+iL).val('');
                $("#pu_"+iL).val('');
                $("#idProduit_"+iL+"libelle").autocomplete({
                    source: function(request, response) {
                        $("#idProduit_"+iL).val('');
                        if (autocompleteTriggered) {
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "produits.IngredientsLib", "true","pv;libelleComposant;codebarre;taux");
                        }
                    },
                    select: function(event, ui) {
                        $("#idProduit_"+iL+"libelle").val(ui.item.label);
                        $("#idProduit_"+iL).val(ui.item.value);
                        $("#idProduit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'compte_'+iL,'designation_'+iL,'codebarre_'+iL,'tauxDeChange_'+iL];
                        for(let i=0;i<champsDependant.length;i++){
                            $('#'+champsDependant[i]).val(ui.item.retour.split(';')[i]);
                        }
                        autocompleteTriggered = false;
                        return false;
                    }
                }).autocomplete('disable');
                $("#idProduit_"+iL+"libelle").off('keydown');
                $("#idProduit_"+iL+"libelle").keydown(function(event) {
                    if (event.key === 'Tab') {
                        event.preventDefault();
                        autocompleteTriggered = true;
                        $(this).autocomplete('enable').autocomplete('search', $(this).val());
                    }
                });
                $("#idProduit_"+iL+"libelle").off('input');
                $("#idProduit_"+iL+"libelle").on('input', function() {
                    $("#idProduit_"+iL).val('');
                    autocompleteTriggered = false;
                    $(this).autocomplete('disable');
                });
                $("#idProduit_"+iL+"searchBtn").off('click');
                $("#idProduit_"+iL+"searchBtn").click(function() {
                    autocompleteTriggered = true;
                    $("#idProduit_"+iL+"libelle").autocomplete('enable').autocomplete('search', $("#idProduit_"+iL+"libelle").val());
                });
            });
        }
    }

    function getIdNumber() {
        const ids = [];
        // Sélectionner tous les inputs dont le name commence par "designation_"
        document.querySelectorAll("input[name^='designation_']").forEach(input => {
            const match = input.name.match(/^designation_(\d+)$/);
            if (match) {
                ids.push(parseInt(match[1], 10));
            }
        });
        return ids;
    }

    function extractProductValue(id) {
        const designationInput = document.querySelector("[name='designation_"+id+"']");
        const idProduitInput = document.querySelector("[name='idProduit_"+id+"']");
        const quantiteInput = document.querySelector("[name='qte_"+id+"']");
        const prixInput = document.querySelector("[name='pu_"+id+"']");
        const remiseMontantInput = document.querySelector("[name='remiseMontant_"+id+"']");
        const photoInput = document.querySelector("[name='photo_"+id+"']");
        const referenceInput = document.querySelector("[name='reference_"+id+"']");
        const basePriceKgInput = document.querySelector("[name='basePriceKg_"+id+"']");
        const compteVenteInput = document.querySelector("[name='compte_"+id+"']");


        // Get the row element
        const row = quantiteInput ? quantiteInput.closest('tr') : null;

        // FIX: Check the hidden unite input instead of a select
        const unitInput = document.querySelector("[name='unite_"+id+"']");

        if (!designationInput || !quantiteInput || !prixInput) {
            return null;
        }

        const designation = designationInput.value.trim();
        if (!designation) {
            return null;
        }

        const quantite = Number(quantiteInput.value);
        const prixunitaire = Number(prixInput.value);
        const remiseMontant = remiseMontantInput ? Number(remiseMontantInput.value) : 0;

        // FIX: Determine if the product is weight-based using the hidden input value (UNT00004)
        const isWeightBased = unitInput && unitInput.value === "UNT00004";

        return {
            id: idProduitInput ? idProduitInput.value : '',
            designation,
            reference: referenceInput?.value || '',
            quantite: isNaN(quantite) ? 0 : quantite,
            prixunitaire: isNaN(prixunitaire) ? 0 : prixunitaire,
            originalPrice: basePriceKgInput?.value || prixunitaire,
            remiseMontant: isNaN(remiseMontant) ? 0 : remiseMontant,
            urlPhoto: photoInput.value,
            isWeightBased: isWeightBased,
            compte: compteVenteInput ? compteVenteInput.value : ''
        };
    }

    function gatherProductData() {
        const ids = getIdNumber();
        const products = [];
        ids.forEach(id => {
            const product = extractProductValue(id);
            if (product) {
                products.push(product);
            }
        });
        return products;
    }
    function checkAndUpdateListener(id) {
        const input = document.getElementById(id);
        if (input) {
            if (!input.dataset.listenerAdded) {
                const update = () => {
                    const products = gatherProductData();
                    save(products);
                    console.log(products);
                };
                input.addEventListener('change', update);
                input.addEventListener('input', update);
                input.dataset.listenerAdded = 'true'; // marque en mémoire
            }
        }
    }

    function setupLinkListeners() {
        document.querySelectorAll("td a").forEach(link => {
            if (!link.dataset.listenerAdded) {
                link.addEventListener("click", () => {
                    sync();
                });
                link.dataset.listenerAdded = "true";
            }
        });
    }


    function setupListeners() {
        const ids = getIdNumber();
        ids.forEach(id => {
            checkAndUpdateListener("idProduit_" + id+"libelle");
            checkAndUpdateListener("designation_" + id);
            checkAndUpdateListener("qte_" + id);
            checkAndUpdateListener("pu_" + id);
            checkAndUpdateListener("remise_" + id);
            checkAndUpdateListener("remiseMontant_" + id);
        });
        setupLinkListeners();
    }

    function save(products) {
        // Exemple de sauvegarde dans localStorage
        localStorage.setItem('products', JSON.stringify(products));
        sendProducts(products);
        console.log('Données sauvegardées:', products);
    }

    function sync() {
        setupListeners();
        // Optionnel : appeler gatherProductData() pour initialiser l'état
        const products = gatherProductData();
        save(products);
        console.log("product sync", products);
    }

    document.addEventListener("DOMContentLoaded", function() {
        sync();
        console.log("Caisse script loaded");
    });

    // now setup socket connection
    const my_ip = window.location.hostname;
    const socket = io(my_ip+":3000"); // ton serveur socket
    socket.on("connect", () => {
        console.log("Connecté au serveur socket avec l'ID:", socket.id);
        // S'identifier en tant que caissier
        socket.emit("register", "caissier");
    });
    socket.on("registered", (data) => {
        console.log("Enregistré en tant que:", data);
    });
    socket.on("disconnect", () => {
        console.log("Déconnecté du serveur socket");
    });
    function sendProducts(produits = null) {
        let products = null;
        if (produits) {
            products = produits;
        } else {
            products = gatherProductData();
        }

        socket.emit("send_products", products);
        //console.log("Produits envoyés au serveur:", products);
    }
    // Envoyer les produits toutes les 30 secondes
    setInterval(sendProducts, 30000);

</script>

<script>
    let currentEditRow = null;

    document.addEventListener("click", function (e) {
        const btn = e.target.closest(".btn-modifier");
        if (!btn) {
            return;
        }

        currentEditRow = btn.closest("tr");
        if (!currentEditRow) {
            return;
        }

        const modalQuantite = document.getElementById("modalQuantite");
        const modalRemise = document.getElementById("modalRemise");
        const modalPrix = document.getElementById("modalPrix");
        const modalPhoto = document.getElementById("modalPhoto");
        const modalArticle = document.getElementById("modalArticle");
        const modalCode = document.getElementById("modalCode");

        //Récupération correcte des données depuis les inputs cachés
        const photoInput = currentEditRow.querySelector("input[name^='photo_']");
        const designationInput = currentEditRow.querySelector("input[name^='designation_']");
        const idProduitInput = currentEditRow.querySelector("input[name^='idProduit_']");
        const qteInput = currentEditRow.querySelector("input[name^='qte_']");
        const remiseInput = currentEditRow.querySelector("input[name^='remiseMontant_']");
        const prixUnitaireInput = currentEditRow.querySelector("input[name^='pu_']");

        //Affichage de l'image
        if (modalPhoto && photoInput) {
            const photoValue = photoInput.value;
            modalPhoto.src = resolveProductImage(photoValue);
            modalPhoto.onerror = function() {
                this.src = `${pageContext.request.contextPath}/assets/img/products/no_image.png`;
            };
        }

        //Affichage du nom de l'article
        if (modalArticle && designationInput) {
            modalArticle.textContent = designationInput.value || "Aucun article";
        }

        //Affichage de l'ID/Code produit
        if (modalCode && idProduitInput) {
            modalCode.textContent = idProduitInput.value || "--";
        }

        //Affichage du prix formaté
        if (modalPrix && prixUnitaireInput) {
            const prixValue = parseAmount(prixUnitaireInput.value || 0);
            modalPrix.textContent = formatAmount(prixValue, true);
        }

        //Valeurs pour les champs modifiables
        const qteValue = parseAmount(qteInput?.value || 0);
        const remiseValue = parseAmount(remiseInput?.value || 0);

        if (modalQuantite) {
            modalQuantite.value = Number.isInteger(qteValue) ? qteValue : qteValue.toFixed(2);
        }
        if (modalRemise) {
            modalRemise.value = remiseValue.toString();
        }
    });

    const modificationModal = document.getElementById("modif");
    if (modificationModal) {
        const minusBtn = document.getElementById("modalMinus");
        if (minusBtn) {
            minusBtn.addEventListener("click", function() {
                adjustModalQuantity(-1);
            });
        }

        const plusBtn = document.getElementById("modalPlus");
        if (plusBtn) {
            plusBtn.addEventListener("click", function() {
                adjustModalQuantity(1);
            });
        }

        modificationModal.addEventListener("click", function(e){
            if (!e.target.matches(".btn.btn-small.btn-primary")) {
                return;
            }
            if (!currentEditRow) {
                return;
            }

            const modalQuantite = document.getElementById("modalQuantite");
            const modalRemise = document.getElementById("modalRemise");

            const newQte = parseAmount(modalQuantite?.value || 0);
            const newRem = parseAmount(modalRemise?.value || 0);

            const qteInput = currentEditRow.querySelector("input[name^='qte_']");
            const remInput = currentEditRow.querySelector("input[name^='remiseMontant_']");

            if (qteInput) {
                qteInput.value = newQte;
            }
            if (remInput) {
                remInput.value = newRem;
            }

            //Change Ste

            // La remise saisie dans le modal est le montant TOTAL pour la ligne à la
            // quantité choisie ; on en déduit la base par unité pour que les futures
            // variations de quantité (boutons +/-) continuent à faire varier la remise
            // proportionnellement.
            currentEditRow.dataset.remiseUnitaire = newQte > 0 ? (newRem / newQte) : newRem;

            //Change Ste

            const quantityCell = qteInput ? qteInput.closest('td') : currentEditRow.cells[3];
            if (quantityCell) {
                const qteDisplay = Number.isInteger(newQte) ? newQte : newQte.toFixed(2);
                setCellDisplay(quantityCell, qteDisplay.toString());
            }

            const remiseCell = remInput ? remInput.closest('td') : currentEditRow.cells[5];
            if (remiseCell) {
                setCellDisplay(remiseCell, formatAmount(newRem));
            }

            updateTotals();

            if (modalQuantite) {
                modalQuantite.value = (Number.isInteger(newQte) ? newQte : newQte.toFixed(2)).toString();
            }
            if (modalRemise) {
                modalRemise.value = newRem.toString();
            }

            if (typeof $ !== "undefined" && typeof $('#modif').modal === "function") {
                $('#modif').modal('hide');
            } else if (typeof bootstrap !== "undefined" && bootstrap.Modal) {
                const modalInstance = bootstrap.Modal.getInstance(modificationModal);
                if (modalInstance) {
                    modalInstance.hide();
                }
            }
            sync();
        });
    }

</script>

<%--eto mode de paiement ( set caisse selon mode paiement ) pour tpe et espece seulement --%>
<script>
    function setPaymentMode(mode) {
        let form = document.getElementById("venteForm");

        let old = document.getElementById("paymentModeInput");
        if (old) old.remove();

        let hidden = document.createElement("input");
        hidden.type = "hidden";
        hidden.name = "modePaiement";
        hidden.value = mode;
        hidden.id = "paymentModeInput";
        form.appendChild(hidden);
    }
</script>

<script>
    function setPaymentWithRef(mode, refInputId) {
        let form = document.getElementById("venteForm");
        if (!form) return;

        document.querySelectorAll("#venteForm input#paymentModeInput, #venteForm input#paymentRefInput")
            .forEach(el => el.remove());

        let refValue = document.getElementById(refInputId)?.value || "";

        let hiddenMode = document.createElement("input");
        hiddenMode.type = "hidden";
        hiddenMode.name = "modePaiement";
        hiddenMode.value = mode;
        hiddenMode.id = "paymentModeInput";
        form.appendChild(hiddenMode);

        let hiddenRef = document.createElement("input");
        hiddenRef.type = "hidden";
        hiddenRef.name = "referencePaiement";
        hiddenRef.value = refValue;
        hiddenRef.id = "paymentRefInput";
        form.appendChild(hiddenRef);

        form.submit();
    }
</script>
<%--montant a retourner payement espece--%>
<script>
    const recapRemisesRetourner = document.getElementById('montantRetourner');
    const valeurEspeceInput = document.getElementById('valeurEspece');
    const radios = document.querySelectorAll('input[name="payment-method"]');

    // Stefan's Block added Start: For validation checks on single payments
    function getPaymentInputId(mode) {
        const mapping = {
            'especes': 'valeurEspece',
            'mvola':   'montantMvola',
            'orange':  'montantOrange',
            'airtel':  'montantAirtel',
            'cheque':  'montantCheque',
            'visa':    'montantVisa'
        };
        return mapping[mode] || '';
    }

    function showAmountError(input, msg) {
        let el = document.getElementById('amount-error');
        const parentDiv = input.closest('.form-input') || input.parentNode;

        if (!el) {
            el = document.createElement('div');
            el.id = 'amount-error';
            el.className = 'error-message';
            el.style.cssText = 'color:red;margin-top:5px;font-size:14px;font-weight:bold;' +
                'background:#ffe6e6;padding:5px;border:1px solid #ff0000;border-radius:4px;';
            console.log("SHOWING AMOUNT ERROR:", msg); //ADDED JS
            parentDiv.appendChild(el);
        } else if (el.parentNode !== parentDiv) {
            parentDiv.appendChild(el);
        }

        el.textContent = msg;
        el.style.display = 'block';
    }

    function hideAmountError() {
        const el = document.getElementById('amount-error');
        if (el) el.style.display = 'none';
    }

    // Retourne true si le montant du mode sélectionné couvre le total.
    function checkSingleModeAmount() {

        const multiplePaymentCheckbox = document.getElementById('multiple-payment');

        if (multiplePaymentCheckbox && multiplePaymentCheckbox.checked) {
            hideAmountError();
            return true;
        }

        const validateButton = document.querySelector('.btn-primary.btn-large');
        const selectedRadio = document.querySelector('input[name="payment-method"]:checked');
        if (!selectedRadio) return true;

        const paymentType = selectedRadio.value;
        const inputId = getPaymentInputId(paymentType);
        const input = document.getElementById(inputId);
        if (!input) return true;

        const totalElement = document.getElementById("totalGeneral");
        const total = parseAmount(totalElement.textContent);
        const rawValue = input.value.replace(/\D/g, '');
        const numericValue = rawValue ? parseInt(rawValue, 10) : 0;

        // Pour les modes autres qu'espèces, une référence est aussi obligatoire
        if (paymentType !== 'especes') {
            const refInputId = getRefInputId(paymentType);
            const refInput = document.getElementById(refInputId);
            const refValue = refInput?.value.trim() || '';

            if (refValue === '') {
                // showAmountError(input, 'Veuillez saisir la référence avant de valider le paiement.');
                if (validateButton) {
                    validateButton.disabled = true;
                    validateButton.style.opacity = '0.6';
                    validateButton.style.cursor = 'not-allowed';
                }
                return false;
            }
        }

        if (numericValue < 0 || numericValue < total) {
            showAmountError(input, 'Montant insuffisant. Montant requis : ' + formatAmount(total, true));
            if (validateButton) {
                validateButton.disabled = true;
                validateButton.style.opacity = '0.6';
                validateButton.style.cursor = 'not-allowed';
            }
            return false;
        }

        hideAmountError();
        return true;
    }

    document.getElementById('multiple-payment').addEventListener('change', function () {
        checkSingleModeAmount();
    });

    // Stefan's Block added end: For validation checks on single payments

    function updateRecap(value) {

        if (value >= 0) {
            recapRemisesRetourner.textContent = formatAmount(value,true);
            document.getElementById("aretourner").value = Number(value);
            // Ensure it uses the amount styling for positive values
            recapRemisesRetourner.className = "h520pxSemibold";
        } else {
            recapRemisesRetourner.textContent = "Montant payé inférieur";
            // Use smaller text for error messages
            document.getElementById("aretourner").value = 0;
            recapRemisesRetourner.className = "Body14pxRegular";
        }
    }
    function calculerRetour() {
        const totalElement = document.getElementById("totalGeneral");
        console.log("TOTAL="+parseAmount(totalElement.textContent));
        const selectedRadio = document.querySelector('input[name="payment-method"]:checked');
        let aRetourner = 0;
        if (selectedRadio && selectedRadio.value === 'especes') {
            const total = parseAmount(totalElement.textContent);
            const paiement = parseAmount(valeurEspeceInput.value);
            if (total > 0) {
                aRetourner = paiement - total;
                console.log("A retourner:", aRetourner);
                updateRecap(aRetourner);
            }
        }
        return aRetourner
    }
    function pasteMontantPayer(value){
        const montantPayehtml = document.getElementById("montantPayerTexte");
        montantPayehtml.textContent = formatAmount(value,true);
    }

    function pasteMontantPayerMultiple(){
        let somme = 0;
        ['valeurEspece', 'montantMvola', 'montantOrange', 'montantAirtel', 'montantCheque', 'montantVisa'].forEach(inputId => {
            const input = document.getElementById(inputId);
            console.log(input)
            if (input) {

                const rawValue = input.value.replace(/\D/g, '');
                console.log("RAW MULTI", rawValue);
                if (rawValue) {
                    const numericValue = parseInt(rawValue, 10);
                    somme += numericValue;
                }
            }
        });
        console.log("Montant Payer: " + formatAmount(somme,true));
        pasteMontantPayer(somme);
    }

    // valeurEspeceInput.addEventListener('input', calculerRetour);
    valeurEspeceInput.addEventListener('input', function(e) {
        const multiplePayment = document.getElementById('multiple-payment').checked;
        const amountError = document.getElementById('amount-error');
        if (multiplePayment) {

            const errorElement = document.getElementById('espece-error');
            if (errorElement) errorElement.style.display = 'none';

            const selectionStart = this.selectionStart;
            const rawValue = this.value.replace(/\D/g, '');
            if (!rawValue) {
                this.value = '';
                checkPaymentValidation();
                return;
            }
            const numericValue = parseInt(rawValue, 10);
            this.value = numericValue.toLocaleString('fr-FR') + ' Ar';
            this.setSelectionRange(this.value.length - 3, this.value.length - 3);

            pasteMontantPayerMultiple()
            checkPaymentValidation();

            //ADDED JS
            if (amountError) {
                console.log("HIDING AMOUNT ERROR");
                amountError.style.display = 'none';
            }

            return;
        }

        const selectionStart = this.selectionStart;
        const rawValue = this.value.replace(/\D/g, '');
        if (!rawValue) {
            this.value = '';
            pasteMontantPayer(0);
            updateRecap(0);
            return;
        }
        const numericValue = parseInt(rawValue, 10);
        this.value = numericValue.toLocaleString('fr-FR') + ' Ar';

        const totalElement = document.getElementById("totalGeneral");
        const total = parseAmount(totalElement.textContent);

        // if (numericValue < total) {
        //     let errorElement = document.getElementById('espece-error');
        //     if (!errorElement) {
        //         errorElement = document.createElement('div');
        //         errorElement.id = 'espece-error';
        //         errorElement.className = 'error-message';
        //         errorElement.style.color = 'red';
        //         errorElement.style.marginTop = '5px';
        //         errorElement.style.fontSize = '14px';
        //         errorElement.style.fontWeight = 'bold';
        //         errorElement.style.backgroundColor = '#ffe6e6';
        //         errorElement.style.padding = '5px';
        //         errorElement.style.border = '1px solid #ff0000';
        //         errorElement.style.borderRadius = '4px';
        //         const parentDiv = this.closest('.form-input');
        //         parentDiv.appendChild(errorElement);
        //     }
        //     errorElement.textContent = 'Le montant saisi est insuffisant. Montant requis: ' + formatAmount(total, true);
        //     errorElement.style.display = 'block';
        //
        //     const validateButton = document.querySelector('.btn-primary.btn-large');
        //     if (validateButton) {
        //         validateButton.disabled = true;
        //         validateButton.style.opacity = '0.6';
        //         validateButton.style.cursor = 'not-allowed';
        //     }
        // } else {
        //     const errorElement = document.getElementById('espece-error');
        //     if (errorElement) errorElement.style.display = 'none';
        //
        //     // const validateButton = document.querySelector('.btn-primary.btn-large');
        //     // if (validateButton) {
        //     //     validateButton.disabled = false;
        //     //     validateButton.style.opacity = '1';
        //     //     validateButton.style.cursor = 'pointer';
        //     // }
        // }

        checkSingleModeAmount();

        const aRetourner = calculerRetour();
        pasteMontantPayer(numericValue);
        sendMessage("PAYE: "+formatNumberWithSpaces(numericValue)+" Ar||"+"MONNAIE: "+formatNumberWithSpaces(aRetourner)+" Ar");
        checkPaymentValidation();
        this.setSelectionRange(this.value.length - 3, this.value.length - 3);
    });

    // Add validation listeners for all payment method inputs
    ['montantMvola','montantOrange',
        'montantAirtel','montantCheque',
        'montantVisa'].forEach(inputId => {
        const input = document.getElementById(inputId);
        if (input) {
            input.addEventListener('input', function() {
                const multiplePayment = document.getElementById('multiple-payment').checked;
                const rawValue = this.value.replace(/\D/g, '');
                console.log("TT",this)
                console.log("RAW",rawValue)
                if (!rawValue) {
                    this.value = '';
                    pasteMontantPayer(0);
                    return;
                }
                const numericValue = parseInt(rawValue, 10);
                console.log("NumericValue ",numericValue)
                this.value = numericValue.toLocaleString('fr-FR') + ' Ar';
                if (multiplePayment){
                    pasteMontantPayerMultiple();
                }else {
                    pasteMontantPayer(numericValue);
                    checkSingleModeAmount(); // Added By Stefan

                }
                updateRecap(0);
                checkPaymentValidation();
                this.setSelectionRange(this.value.length - 3, this.value.length - 3);
            });
            input.addEventListener('change', function() {
                checkPaymentValidation();
            });
        }
    });

    // Add validation on form submission
    document.getElementById('venteForm').addEventListener('submit', function(e) {

        //Taloha: Commented by Stefan
        // const multiplePayment = document.getElementById('multiple-payment');
        // const isMultiplePayment = multiplePayment && multiplePayment.checked;
        //
        // if (isMultiplePayment) {
        //     return true;
        // }
        //
        // const totalElement = document.getElementById("totalGeneral");
        // const total = parseAmount(totalElement.textContent);
        // const rawValue = valeurEspeceInput.value.replace(/\D/g, '');
        // const numericValue = rawValue ? parseInt(rawValue, 10) : 0;
        //
        // // Check if 'especes' is selected and amount is insufficient
        // const selectedRadio = document.querySelector('input[name="payment-method"]:checked');
        // // if (selectedRadio && selectedRadio.value === 'especes') {
        // //     if (numericValue < total) {
        // //         e.preventDefault(); // Prevent form submission
        // //         alert('Le montant saisi en espèces est insuffisant pour effectuer le paiement. Montant requis: ' + formatAmount(total, true));
        // //         // Masque le loader
        // //         loader.style.display = 'none';
        // //         return false;
        // //     }
        // // }

        //Vaovao: Added By Stefan
        const multiplePayment = document.getElementById('multiple-payment');
        const isMultiplePayment = multiplePayment && multiplePayment.checked;

        if (isMultiplePayment) {
            return true; // géré ailleurs par attachSubmitGuard()
        }

        if (!checkSingleModeAmount()) {
            e.preventDefault();
            e.stopImmediatePropagation();

            const loaderEl = document.getElementById('globalLoader');
            if (loaderEl) {
                loaderEl.style.display = 'none';
                loaderEl.classList.add('d-none');
            }

            const submitBtn = this.querySelector('button[type="submit"].btn-primary.btn-large');
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.style.opacity = '1';
                submitBtn.style.cursor = 'pointer';
                submitBtn.style.pointerEvents = 'auto';
                submitBtn.innerHTML = 'Payer';
                submitBtn.style.backgroundColor = '';
            }

            const selectedRadio = document.querySelector('input[name="payment-method"]:checked');
            const inputId = selectedRadio ? getPaymentInputId(selectedRadio.value) : 'valeurEspece';
            const input = document.getElementById(inputId);

            const totalElement = document.getElementById("totalGeneral");
            const total = parseAmount(totalElement.textContent);

            alert('Le montant saisi est insuffisant. Montant requis : ' + formatAmount(total, true));

            if (input) input.focus();
            return false;
        }
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        var btn = document.getElementById('btnClavierABC');
        var modal = document.getElementById('clavier-abc');

        if (!btn || !modal) return;

        // Fonction pour ouvrir le modal
        function openModal() {
            // Empêcher d'ouvrir plusieurs fois
            if (modal.classList.contains('in')) return;

            modal.style.display = 'block';
            modal.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');

            // Légère temporisation pour activer la transition .fade -> .in
            setTimeout(function() {
                modal.classList.add('in');
            }, 10);
        }

        // Fonction pour fermer le modal
        function closeModal() {
            modal.classList.remove('in');
            modal.setAttribute('aria-hidden', 'true');
            document.body.classList.remove('modal-open');

            // Attendre la fin de la transition (300ms environ comme Bootstrap)
            setTimeout(function() {
                modal.style.display = 'none';
            }, 300);
        }

        // Clic sur le bouton (ou tap mobile)
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            openModal();
        });
        btn.addEventListener('touchstart', function(e) {
            e.preventDefault();
            openModal();
        });

        // Clic sur la zone hors de la modale
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeModal();
            }
        });

        // Clic sur un bouton de fermeture interne (si présent)
        modal.addEventListener('click', function(e) {
            if (e.target.classList.contains('close')) {
                closeModal();
            }
        });

        // Fermeture avec la touche ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && modal.classList.contains('in')) {
                closeModal();
            }
        });
        function addLinkAccueilLogo() {
            const img = document.getElementById("site-logo");
            const link = document.createElement("a");
            link.href = "<%=lien%>?but=accueil.jsp";

            img.parentNode.insertBefore(link, img);
            link.appendChild(img);
        }
        addLinkAccueilLogo();
    });
</script>


<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    (function() {
        var loaderElem = document.getElementById('globalLoader');
        if (loaderElem) {
            loaderElem.style.display = 'none';
            loaderElem.style.setProperty('display', 'none', 'important');
            if (loaderElem.classList) {
                loaderElem.classList.add('d-none');
            }
        }
    })();
    alert('<%=e.getMessage()%>');
</script>
<% }%>
