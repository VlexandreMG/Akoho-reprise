<%@page import="prevision.Prevision" %>
<%@page import="affichage.*" %>
<%@page import="user.*" %>
<%@page import="utils.*" %>
<%@ page import="annexe.Point" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="caisse.*" %>

<%
    try{
        UserEJB user = (UserEJB) session.getValue("u");
        String lien = (String) session.getValue("lien");

        ReportCaisse mapping = new ReportCaisse();
        ReportCaisse fille = new ReportCaisse();
        fille.setNomTable("REPORTCAISSE_CPL");
        Billetage billet = new Billetage();
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(fille,fille, request, nombreLigne ,user);
        pi.setLien(lien);
//        affichage.Champ[] liste = new affichage.Champ[1];
//        liste[0] = new Liste("idPoint",new Point(),"val","id");

//        pi.getFormu().changerEnChamp(liste);

//        pi.getFormu().getChamp("idPoint").setLibelle("Point");
        pi.getFormu().getChamp("daty").setLibelle("Date");
//        pi.getFormu().getChamp("montantTheorique").setLibelle("Montant th&eacute;orique");
//        pi.getFormu().getChamp("montant").setLibelle("Montant");
        pi.getFormu().getChamp("idCaisse").setLibelle("caisse");
//        pi.getFormu().getChamp("explication").setLibelle("Explication");
        pi.getFormu().getChamp("etat").setVisible(false);
//        pi.getFormu().getChamp("explication").setVisible(false);
        pi.getFormu().getChamp("idcaisse").setVisible(false);
        pi.getFormu().getChamp("idUser").setDefaut(user.getUser().getTuppleID());


        String point = session.getAttribute("idPoint").toString();
        String dtJour = Utilitaire.dateDuJour();
        pi.getFormu().getChamp("daty").setDefaut(dtJour);
//        pi.getFormu().getChamp("idPoint").setDefaut(point);
//        pi.getFormu().getChamp("remarque").setDefaut("Cloture de caisse du " + dtJour);


        pi.getFormufle().getChamp("caisseLib_0").setLibelle("Caisse");
        pi.getFormufle().getChamp("montantTheorique_0").setLibelle("Montant Th&eacute;orique");
        pi.getFormufle().getChamp("montant_0").setLibelle("Montant R&eacute;el");
//        pi.getFormufle().getChamp("explication_0").setLibelle("Explication");
        pi.getFormufle().getChampMulitple("id").setVisible(false);
//        pi.getFormufle().getChampMulitple("idCloture").setVisible(false);
        pi.getFormufle().getChampMulitple("idCaisse").setVisible(false);
        pi.getFormufle().getChampMulitple("caisseLib").setAutre("readonly");
//        pi.getFormufle().getChampMulitple("explication").setVisible(false);
        pi.getFormufle().getChampMulitple("montantTheorique").setAutre("readonly");

        pi.getFormufle().getChampMulitple("etat").setVisible(false);

        pi.getFormufle().getChampMulitple("daty").setVisible(false);

        pi.getFormufle().getChampMulitple("heure").setVisible(false);
        pi.getFormufle().getChampMulitple("idUser").setVisible(false);

        String[] order ={"idCaisse","caisseLib", "montantTheorique","montant"};
        pi.getFormufle().setColOrdre(order);



        ReportCaisse[] filles = mapping.genererCaisseAOuvrir(user.getListeCaisseReport(),null);
        pi.getFormufle().setNbLigne(filles.length);
//        System.out.println("filles " + filles.length);
        if(filles!=null && filles.length>0) {
            nombreLigne = filles.length;
            pi.setDefautFille(filles);
        }

        String classeMere = "caisse.ReportCaisse";
        String nomTableMere = "REPORTCAISSE";
        String butApresPost = "caisse/ouveturecaisse/ouverturecaisse-saisie.jsp";
        String classeFille = "caisse.ReportCaisse";
        String colonneMere = "idcloture";


        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<style>
    div#uploadBox {
        display: none;
    }
    .vd-header {
        justify-content: space-between;
    }
    .col-md-12.cardradius {
        margin-top: 0px !important;
    }
    .vente-direct-box{
        z-index: 2000;
        position: relative;
    }
    .btn.btn-secondary, .btn.btn-danger, .btn.btn-tertiary{
        display: none;
    }
    .table > thead > tr > th{
        background-color: var(--VD-content-wrapper-bg);
    }
    .table{
        margin-top: 0px !important;
    }
    #globalLoader {
        display: none;
        position: fixed;
        top: 0; left: 0;
        width: 100vw; height: 100vh;
        z-index: 99999;
        background: rgba(255,255,255,0.7);
        justify-content: center;
        align-items: center;
    }
    .spinner-border {
        display: inline-block;
        width: 4rem;
        height: 4rem;
        vertical-align: text-bottom;
        border: 0.5rem solid var(--VD-main-color);
        border-right-color: transparent;
        border-radius: 50%;
        animation: spinner-border .75s linear infinite;
    }
    @keyframes spinner-border {
        to { transform: rotate(360deg); }
    }
</style>
<link href="${pageContext.request.contextPath}/assets/css/vente-directe.css" rel="stylesheet" type="text/css" />
<div class="vd-header">
    <img src="${pageContext.request.contextPath}/assets/img/logo-lewis.png" alt="logo">
    <%--    <a class="" href="${pageContext.request.contextPath}/pages/module.jsp?but=vente/vente-saisie-directe2.jsp" >--%>
    <a class="" href="${pageContext.request.contextPath}/pages/module.jsp?but=vente/vente-saisie-directe-apj.jsp" >
        <i class="material-symbols-rounded" >point_of_sale</i>
    </a>
</div>
<div class="content-wrapper">
    <form action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" id="venteForm"  data-parsley-validate>
        <div class="col-md-12 nopadding" >
            <h3 class="h520pxSemibold" style="background: white;padding: 16px;margin-top: 10px;border-radius:8px;border: 1px solid var(--Border);">Total  : <span id="montanttotal">0</span><span id="deviseLibelle">Ar</span></h3>
        </div>
        <div class="row">
            <div class="col-md-8">
                <div class="d-none">
                    <%
                        out.println(pi.getFormu().getHtmlInsert());
                    %>
                </div>
                <%
                    out.println(pi.getFormufle().getHtmlTableauInsert());
                %>
            </div>
            <div class="col-md-4">
                <div class="clavier-container vente-direct-box" >
                    <div class="numbers col-md-10 nopadding">
                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="7" >7</button>
                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="8" >8</button>
                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="9" >9</button>
                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="4" >4</button>
                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="5" >5</button>
                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="6" >6</button>
                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="1" >1</button>
                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="2" >2</button>
                        <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="3" >3</button>
                        <button class="btn-clavier btn col-md-12 h142pxRegular" type="button" data-key="0" >0</button>
                    </div>
                    <div class="actions-container col-md-4 nopadding">
                        <button class="btn-clavier btn col-md-12 h142pxRegular delete" type="button" id="deleteBtn2" ><i class="material-symbols-rounded">chevron_left</i></button>
                        <button class="btn-clavier btn col-md-12 h520pxRegular" data-toggle="modal" data-target="#clavier-abc" type="button" >ABC</button>
                    </div>
                </div>
            </div>


        </div>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
<%--        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">--%>
        <input name="nomtable" type="hidden" id="nomtable" value="REPORTCAISSE">

    </form>
</div>

<style>
    .custom-modal {
        position: fixed;
        inset: 0;
        display: none;
        justify-content: center;
        z-index: 1999;
        font-family: "Inter", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }

    .custom-modal.is-open {
        display: flex;
    }

    .custom-modal-overlay {
        position: absolute;
        inset: 0;
        overflow: auto;
        background: rgba(15, 23, 42, 0.48);
        backdrop-filter: blur(2px);
    }

    .custom-modal-dialog {
        position: relative;
        z-index: 1;
        width: min(420px, 92vw);
        max-height: 85vh;  /* Limit the modal height to viewport */
        background: #ffffff;
        border-radius: 18px;
        box-shadow: 0 28px 60px rgba(15, 23, 42, 0.28);
        padding: 28px 28px 24px;
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .custom-modal-close {
        position: absolute;
        top: 18px;
        right: 18px;
        border: none;
        background: transparent;
        font-size: 24px;
        line-height: 1;
        color: #64748b;
        cursor: pointer;
        transition: color 0.2s ease;
    }

    .custom-modal-close:hover {
        color: #0f172a;
    }

    .custom-modal-title {
        font-size: 20px;
        font-weight: 600;
        color: #0f172a;
        margin: 0;
    }

    .custom-modal-subtitle {
        font-size: 14px;
        color: #475569;
        margin: 0;
    }

    .custom-modal-body {
        display: flex;
        flex-direction: column;
        gap: 12px;
        flex: 1;            /* Allow the body to grow and fill available space */
        overflow-y: auto;   /* Enable vertical scrolling when content exceeds available space */
        margin: 12px 0;     /* Add some margin for visual separation */
    }

    .denomination-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
        padding: 12px;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        background: linear-gradient(135deg, rgba(248, 250, 252, 0.95), rgba(241, 245, 249, 0.9));
    }

    .denomination-label {
        font-size: 15px;
        font-weight: 500;
        color: #0f172a;
    }

    .denomination-input {
        width: 120px;
        padding: 8px 12px;
        border: 1px solid #cbd5f5;
        border-radius: 10px;
        font-size: 15px;
        text-align: right;
        background: #f8fafc;
        color: #0f172a;
        transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .denomination-input:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        background: #ffffff;
    }

    .custom-modal-total {
        font-size: 16px;
        font-weight: 600;
        color: #0f172a;
        text-align: right;
        margin-top: 4px;
    }

    .custom-modal-footer {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        margin-top: 8px;
    }

    .custom-modal-btn {
        min-width: 110px;
        border-radius: 10px;
        padding: 10px 16px;
        border: none;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: transform 0.15s ease, box-shadow 0.15s ease;
    }

    .custom-modal-btn.primary {
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        color: #ffffff;
        box-shadow: 0 14px 30px rgba(37, 99, 235, 0.3);
    }

    .custom-modal-btn.primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 18px 34px rgba(37, 99, 235, 0.35);
    }

    .custom-modal-btn.secondary {
        background: #e2e8f0;
        color: #1e293b;
    }

    .custom-modal-btn.secondary:hover {
        background: #cbd5f5;
    }

    @media (max-width: 520px) {
        .denomination-row {
            flex-direction: column;
            align-items: flex-start;
        }

        .denomination-input {
            width: 100%;
        }

        .custom-modal-footer {
            flex-direction: column-reverse;
        }

        .custom-modal-btn {
            width: 100%;
        }
    }
</style>

<div id="montantModal" class="custom-modal" aria-hidden="true">
    <div class="custom-modal-overlay" id="montantModalOverlay"></div>
    <div class="custom-modal-dialog" role="dialog" aria-labelledby="montantModalTitle">
        <button type="button" class="custom-modal-close" id="montantModalClose" aria-label="Fermer">&times;</button>
        <h3 class="custom-modal-title" id="montantModalTitle">Billetage</h3>
        <p class="custom-modal-subtitle">Indiquez le nombre de billets pour chaque coupure.</p>
        <div class="custom-modal-body">
            <div class="denomination-row">
                <span class="denomination-label">20&nbsp;000 Ar</span>
                <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="20000">
            </div>
            <div class="denomination-row">
                <span class="denomination-label">10&nbsp;000 Ar</span>
                <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="10000">
            </div>
            <div class="denomination-row">
                <span class="denomination-label">5&nbsp;000 Ar</span>
                <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="5000">
            </div>
            <div class="denomination-row">
                <span class="denomination-label">2&nbsp;000 Ar</span>
                <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="2000">
            </div>
            <div class="denomination-row">
                <span class="denomination-label">1&nbsp;000 Ar</span>
                <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="1000">
            </div>
            <div class="denomination-row">
                <span class="denomination-label">500 Ar</span>
                <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="500">
            </div>
            <div class="denomination-row">
                <span class="denomination-label">200 Ar</span>
                <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="200">
            </div>
            <div class="denomination-row">
                <span class="denomination-label">100 Ar</span>
                <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="100">
            </div>
            <div class="denomination-row">
                <span class="denomination-label">50 Ar</span>
                <input type="text" class="form-control denomination-input" inputmode="numeric" data-denomination="50">
            </div>
        </div>

        <div class="custom-modal-total">Total : <span id="montantModalTotal">0 Ar</span></div>
        <div class="custom-modal-footer">
            <button type="button" class="custom-modal-btn secondary" id="montantModalCancel">Annuler</button>
            <button type="button" class="custom-modal-btn primary" id="montantModalValidate">Valider</button>
        </div>
    </div>
    <div class="custom-modal-dialog d-none">
        <div class="clavier-container vente-direct-box" >
            <div class="numbers col-md-10 nopadding">
                <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="1" >1</button>
                <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="2" >2</button>
                <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="3" >3</button>
                <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="4" >4</button>
                <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="5" >5</button>
                <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="6" >6</button>
                <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="7" >7</button>
                <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="8" >8</button>
                <button class="btn-clavier btn col-md-3 h142pxRegular" type="button" data-key="9" >9</button>
                <button class="btn-clavier btn col-md-12 h142pxRegular" type="button" data-key="0" >0</button>
            </div>
            <div class="actions-container col-md-4 nopadding">
                <button class="btn-clavier btn col-md-12 h142pxRegular delete" type="button" id="deleteBtn2" ><i class="fa fa-angle-left"></i></button>
                <button class="btn-clavier btn col-md-12 h520pxRegular" data-toggle="modal" data-target="#clavier-abc" type="button" >ABC</button>
            </div>
        </div>
    </div>
</div>
<div id="globalLoader" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:99999;background:rgba(255,255,255,0.7);justify-content:center;align-items:center;">
    <div style="text-align:center;">
        <div class="spinner-border"  role="status"></div>
        <div style="margin-top:1rem;font-size:1.2rem;color:(--VD-main-color)">Chargement...</div>
    </div>
</div>
<script>
    // Loader
    var loader = document.getElementById('globalLoader');
    // Affiche le loader dès le début
    loader.style.display = 'flex';

    // Masque le loader quand la page est complètement chargée
    window.addEventListener('load', function() {
        loader.style.display = 'none';
    });

    // Affiche le loader lors de la soumission du formulaire
    document.addEventListener('DOMContentLoaded', function() {
        var form = document.getElementById('venteForm');
        if (form && loader) {
            form.addEventListener('submit', function() {
                loader.style.display = 'flex';
            });
        }
    });
</script>
<script>
    function formatWithThousandSeparator(num) {
        if (num === null || num === undefined || num === '') {
            return '';
        }

        let str = num.toString().replace(/[,\s]/g, '');

        let parsed = parseFloat(str);
        if (isNaN(parsed)) {
            return str;
        }

        return parsed.toLocaleString('fr-FR', {
            maximumFractionDigits: 0,
            useGrouping: true
        });
    }

    function addThousandSeparator(input) {
        if (!input) return;

        let start = input.selectionStart;
        let end = input.selectionEnd;

        let originalValue = input.value.replace(/[,\s]/g, '');

        if (originalValue !== '' && !isNaN(originalValue)) {
            let formattedValue = formatWithThousandSeparator(originalValue);

            if (input.value !== formattedValue) {
                input.value = formattedValue;

                let newStart = start;
                let newEnd = end;

                if (start <= originalValue.length) {
                    let originalBeforeCursor = originalValue.substring(0, start);
                    let formattedBeforeCursor = formatWithThousandSeparator(originalBeforeCursor);
                    newStart = formattedBeforeCursor.length;
                    newEnd = newStart + (end - start);
                }

                newStart = Math.min(newStart, input.value.length);
                newStart = Math.max(0, newStart);
                newEnd = Math.min(newEnd, input.value.length);
                newEnd = Math.max(newStart, newEnd);

                input.setSelectionRange(newStart, newEnd);
            }
        }
    }

    function handleNumberInput(event) {
        let input = event.target;
        if (input.name && (input.name.includes('montant') || input.name.includes('Montant'))) {
            let valueWithoutSpaces = input.value.replace(/[,\s]/g, '');
            if (valueWithoutSpaces === '' || !isNaN(valueWithoutSpaces)) {
                setTimeout(() => {
                    let cursorPos = input.selectionStart;

                    let originalValue = input.value.replace(/[,\s]/g, '');

                    if (originalValue !== '' && !isNaN(originalValue)) {
                        let formattedValue = formatWithThousandSeparator(originalValue);

                        if (input.value !== formattedValue) {
                            input.value = formattedValue;

                            if (cursorPos <= originalValue.length) {
                                let formattedBeforeCursor = formatWithThousandSeparator(originalValue.substring(0, cursorPos));
                                cursorPos = formattedBeforeCursor.length;
                            }

                            cursorPos = Math.min(cursorPos, input.value.length);
                            cursorPos = Math.max(0, cursorPos);

                            input.setSelectionRange(cursorPos, cursorPos);
                        }
                    }
                }, 10);
            }
        }
    }

    function applyThousandSeparators() {
        let amountInputs = document.querySelectorAll('input[name*="montant" i]');

        amountInputs.forEach(input => {
            if (input.value && input.value.trim() !== '') {
                let originalValue = input.value.replace(/[,\s]/g, '');
                if (originalValue !== '' && !isNaN(originalValue)) {
                    input.value = formatWithThousandSeparator(originalValue);
                }
            }

            input.addEventListener('input', handleNumberInput);
            input.addEventListener('blur', function(e) {
                let input = e.target;
                if (input.name && (input.name.includes('montant') || input.name.includes('Montant'))) {
                    let valueWithoutSpaces = input.value.replace(/[,\s]/g, '');
                    if (valueWithoutSpaces !== '' && !isNaN(valueWithoutSpaces)) {
                        input.value = formatWithThousandSeparator(valueWithoutSpaces);
                    }
                }
            });

            input.addEventListener('focus', function(e) {
                let input = e.target;
                if (input.name && (input.name.includes('montant') || input.name.includes('Montant'))) {
                    input.value = input.value.replace(/[,\s]/g, '');
                }
            });
        });
    }

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
        document.querySelectorAll('.form-control').forEach(input => {
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

        if (typeof $ !== 'undefined' && $(activeInput).data('ui-autocomplete')) {
            $(activeInput).autocomplete('search', activeInput.value);
        }
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

            const inputEvent = new Event('input', { bubbles: true, cancelable: true });
            activeInput.dispatchEvent(inputEvent);
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

        // Initialiser les séparateurs de millier
        applyThousandSeparators();

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
        });

        // Arrêter la répétition si on relâche en dehors du document
        document.addEventListener('mouseup', stopRepeat);
        document.addEventListener('touchend', stopRepeat);
    });

    // Rendre les fonctions disponibles globalement
    window.setActiveInput = setActiveInput;
    window.initVirtualKeyboard = initVirtualKeyboard;
</script>
<script>
    (function() {
        const modal = document.getElementById('montantModal');
        if (!modal) {
            return;
        }

        const overlay = document.getElementById('montantModalOverlay');
        const closeBtn = document.getElementById('montantModalClose');
        const cancelBtn = document.getElementById('montantModalCancel');
        const validateBtn = document.getElementById('montantModalValidate');
        const totalLabel = document.getElementById('montantModalTotal');
        const qtyInputs = Array.from(modal.querySelectorAll('input[data-denomination]'));

        let currentInput = null;

        function toNumber(value) {
            if (typeof value !== 'string') {
                value = String(value ?? '');
            }
            const normalized = value.replace(/\s+/g, '').replace(',', '.');
            const parsed = parseFloat(normalized);
            return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
        }

        function computeTotal() {
            return qtyInputs.reduce((sum, input) => {
                const qty = toNumber(input.value);
                const denom = Number(input.dataset.denomination || 0);
                if (!Number.isFinite(denom) || denom <= 0) {
                    return sum;
                }
                return sum + qty * denom;
            }, 0);
        }

        function updateTotal() {
            if (!totalLabel) {
                return;
            }
            const total = computeTotal();
            totalLabel.textContent = total.toLocaleString('fr-FR') + ' Ar';
        }

        function hydrateFromDataset(target) {
            qtyInputs.forEach(input => {
                input.value = '';
            });

            if (!target || !target.dataset || !target.dataset.billetage) {
                updateTotal();
                return;
            }

            try {
                const stored = JSON.parse(target.dataset.billetage);
                qtyInputs.forEach(input => {
                    const denom = input.dataset.denomination;
                    if (stored && Object.prototype.hasOwnProperty.call(stored, denom)) {
                        input.value = stored[denom];
                    }
                });
            } catch (err) {
                console.warn('Impossible de charger le billetage enregistré', err);
            }
            updateTotal();
        }

        function storeCountsOnInput(target) {
            if (!target) {
                return;
            }
            const stored = {};
            let hasValue = false;
            qtyInputs.forEach(input => {
                const qty = toNumber(input.value);
                const denom = input.dataset.denomination;
                if (qty > 0) {
                    stored[denom] = qty;
                    hasValue = true;
                }
            });

            if (hasValue) {
                target.dataset.billetage = JSON.stringify(stored);
            } else {
                delete target.dataset.billetage;
            }
        }

        function disableScroll() {
            document.body.dataset.prevOverflow = document.body.style.overflow;
            document.body.style.overflow = 'hidden';
        }

        function enableScroll() {
            const previous = document.body.dataset.prevOverflow;
            document.body.style.overflow = previous || '';
            delete document.body.dataset.prevOverflow;
        }

        function openModal(target) {
            currentInput = target;
            hydrateFromDataset(target);
            modal.classList.add('is-open');
            modal.setAttribute('aria-hidden', 'false');
            disableScroll();
            setTimeout(() => {
                const firstInput = qtyInputs[0];
                if (firstInput) {
                    firstInput.focus();
                    firstInput.select();
                }
            }, 0);
        }

        function closeModal(applyResult) {
            if (applyResult && currentInput) {
                const total = computeTotal();
                currentInput.value = total > 0 ? total.toString() : '';
                storeCountsOnInput(currentInput);
                currentInput.dispatchEvent(new Event('input', { bubbles: true }));
                currentInput.dispatchEvent(new Event('change', { bubbles: true }));
            }

            modal.classList.remove('is-open');
            modal.setAttribute('aria-hidden', 'true');
            enableScroll();
            currentInput = null;
        }

        function handleTriggerClick(event) {
            const target = event.target;
            if (!target || !target.id || !target.id.startsWith('montant_')) {
                return;
            }
            const parts = target.id.split('_');
            if (parts.length < 2) {
                return;
            }
            const index = parts[parts.length - 1];
            const labelInput = document.getElementById('caisseLib_' + index);
            if (labelInput && labelInput.value && /esp.{1,2}ce/i.test(labelInput.value)) {
                event.preventDefault();
                openModal(target);
            }
        }

        qtyInputs.forEach(input => {
            input.addEventListener('input', updateTotal);
            input.addEventListener('change', updateTotal);
        });

        overlay?.addEventListener('click', () => closeModal(false));
        closeBtn?.addEventListener('click', () => closeModal(false));
        cancelBtn?.addEventListener('click', () => closeModal(false));
        validateBtn?.addEventListener('click', () => closeModal(true));

        document.addEventListener('click', handleTriggerClick, true);

        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape' && modal.classList.contains('is-open')) {
                closeModal(false);
            }
        });
    })();

    window.onload = function() {
        const footers = document.querySelectorAll('.box-footer');
        const lastFooter = footers[footers.length - 1];

        if (lastFooter) {
            // Cacher tous les boutons existants
            const allButtons = lastFooter.querySelectorAll('a, button, input[type="button"], input[type="submit"]');
            allButtons.forEach(btn => {
                btn.style.display = 'none';
            });

            // Ajouter ton bouton "Enregistrer et imprimer"
            lastFooter.innerHTML += `
            <button class="btn btn-primary pull-right"
               style="display:block;margin-right:8px">
               Enregistrer et imprimer le rapport Z
            </button>
        `;
        }
    }
</script>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>