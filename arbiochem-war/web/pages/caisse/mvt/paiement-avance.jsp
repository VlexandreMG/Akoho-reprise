<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.avance.PaiementAvance2" %>
<%@ page import="paie.avance.BilletageFille" %>
<%@ page import="caisse.Caisse" %>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.avance.Avance" %>
<%@ page import="paie.employe.ConstantePaie" %>

<% try{
    Avance av = new Avance();
    String[] ids = request.getParameterValues("ids");
    if(ids!=null && !ids.equals("")){
        Avance tempAvance = new Avance();
        av =  tempAvance.getAvance(ids[0]);
    }
    String idAv = request.getParameter("idAvance");
    if (idAv!=null && !idAv.equals("")){
        Avance tempAvance = new Avance();
        av =  tempAvance.getAvance(idAv);
    }
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.avance.PaiementAvance2";
    String classeFille = "paie.avance.BilletageFille";
    String nomTableFille = "BILLETAGEFILLE";
    String colonneMere = "idMere";
    String apres = "paie/avance/avance-fiche.jsp";
    int[] listeBillet = {20000,10000,5000,2000,1000,500,200,100};
    PaiementAvance2 mere = new PaiementAvance2();
    BilletageFille fille = new BilletageFille();
    fille.setNomTable("BILLETAGEFILLE");
    int taille = listeBillet.length;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Paiement d'une avance");


    Liste[] listes = new Liste[1];
    listes[0] = new Liste("idCaisse", new Caisse(),"val", "id");
    String[] order = {"daty"};
    pi.getFormu().setOrdre(order);
    pi.getFormu().changerEnChamp(listes);
    pi.getFormu().changerEnChamp(listes);
    pi.getFormu().getChamp("designation").setDefaut("Sortie du paiement de l'avancement de "+av.getIdpersonnel() + " le " +utilitaire.Utilitaire.dateDuJour());
    pi.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
    pi.getFormu().getChamp("datycomptabilisation").setLibelle("Date de comptabilisation");
    pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pi.getFormu().getChamp("idPrevision").setLibelle("ID Prevision");

    pi.getFormu().getChamp("idtraite").setVisible(false);
    pi.getFormu().getChamp("taux").setVisible(false);
    pi.getFormu().getChamp("taux").setDefaut("0");
    pi.getFormu().getChamp("idDevise").setVisible(false);
    pi.getFormu().getChamp("idDevise").setDefaut("AR");
    pi.getFormu().getChamp("compte").setVisible(false);
    pi.getFormu().getChamp("etatversement").setVisible(false);

    pi.getFormu().getChamp("debit").setLibelle("d&eacute;bit");
    pi.getFormu().getChamp("debit").setDefaut(av.getMontant()+"");
    pi.getFormu().getChamp("idCaisse").setLibelle("Caisse");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idModePaiement").setVisible(false);
    pi.getFormu().getChamp("idmvtcaissemere").setVisible(false);
    pi.getFormu().getChamp("idVirement").setVisible(false);
    pi.getFormu().getChamp("idVenteDetail").setVisible(false);
    pi.getFormu().getChamp("idOp").setVisible(false);
    pi.getFormu().getChamp("idOrigine").setVisible(false);
    pi.getFormu().getChamp("idOrigine").setDefaut(av.getId());
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("credit").setVisible(false);
    pi.getFormu().getChamp("idTiers").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2 ");
    pi.getFormu().getChamp("idTiers").setLibelle("Personnel");
    pi.getFormu().getChamp("idTiers").setDefaut(av.getIdpersonnel());
    pi.getFormu().getChamp("idTypePaiement").setLibelle("Type Paiement");
    pi.getFormu().getChamp("idTypePaiement").setDefaut(ConstantePaie.TYPE_PAIEMENT_AVANCE);
    pi.getFormu().getChamp("idTypePaiement").setVisible(false);

    pi.getFormufle().getChamp("billet_0").setLibelle("Billet");
    pi.getFormufle().getChamp("nombreBillet_0").setLibelle("Nombre");
    for (int i = 0; i < listeBillet.length; i++) {
        pi.getFormufle().getChamp("idMere_"+i).setVisible(false);
        pi.getFormufle().getChamp("billet_"+i).setDefaut(listeBillet[i]+"");
    }
    String[] colOrdre = {"idMere","billet","nombreBillet"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un paiement d'une avance");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<style>
    #addLines {
        margin-right: 8px !important;
    }
    .box-footer.borderless.nopadding .btn.btn-secondary {
        margin-right: 8px;
    }

</style>
<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <div id="infoMontant" class="col-md-12 cardradius" style="margin: 10px 0; padding: 10px;">
            <strong>Montant de l'avance à payer: <%=av.getMontant()%> Ar</strong>
            <div id="totalBillets" style="margin-top: 5px; font-weight: bold;"></div>
        </div>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
        <input name="montantAvance" type="hidden" value="<%=av.getMontant()%>">
    </form>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const target = document.getElementById("addLines");

        if (target) {
            const btnEnregistrer = document.createElement("button");
            btnEnregistrer.type = "submit";
            btnEnregistrer.className = "btn btn-primary pull-right";
            btnEnregistrer.textContent = "Enregistrer le paiement";

            const btnAnnuler = document.createElement("button");
            btnAnnuler.type = "button";
            btnAnnuler.className = "btn btn-secondary pull-right";
            btnAnnuler.setAttribute("onclick", "history.back();");
            btnAnnuler.textContent = "Annuler";

            target.insertAdjacentElement("beforebegin", btnEnregistrer);
            target.insertAdjacentElement("beforebegin", btnAnnuler);
        }
    });
</script>
<script type="text/javascript">
    // Variables globales
    var montantAvance = <%=av.getMontant()%>;
    var listeBillet = [<%for(int i = 0; i < listeBillet.length; i++){%><%=listeBillet[i]%><%if(i < listeBillet.length-1){%>,<%}%><%}%>];

    function validerMontantBillets() {
        var sommeBillets = calculerSommeBillets();

        if (Math.abs(sommeBillets - montantAvance) > 0.01) {
            alert('ERREUR: Le montant total des billets (' + sommeBillets + ' Ar) ne correspond pas au montant de l\'avance (' + montantAvance + ' Ar).\n\nVeuillez ajuster les quantités de billets pour que le total soit exactement ' + montantAvance + ' Ar.');
            return false;
        }

        if (sommeBillets === 0) {
            alert('ERREUR: Aucun billet n\'a été saisi. Veuillez saisir au moins un billet.');
            return false;
        }

        return true;
    }

    function calculerSommeBillets() {
        var sommeBillets = 0;

        for(var i = 0; i < listeBillet.length; i++) {
            var nombreBilletElement = document.querySelector('input[name="nombreBillet_' + i + '"]');
            if(nombreBilletElement && nombreBilletElement.value) {
                var rawValue = nombreBilletElement.value;
                var cleanedValue = rawValue.toString().replace(/\s+/g, '');
                var nombreBillet = parseInt(cleanedValue, 10) || 0;
                var valeurBillet = listeBillet[i];
                sommeBillets += nombreBillet * valeurBillet;
            }
        }

        return sommeBillets;
    }

    function mettreAJourAffichage() {
        var sommeBillets = calculerSommeBillets();
        var totalElement = document.getElementById('totalBillets');

        if(totalElement) {
            var diff = montantAvance - sommeBillets;
            var message = 'Total billets saisis: ' + sommeBillets + ' Ar';

            if(Math.abs(diff) > 0.01 && sommeBillets > 0) {
                totalElement.style.color = 'red';
                var ecart = Math.abs(diff);
                if(diff > 0) {
                    message += ' | Il manque ' + ecart + ' Ar';
                } else {
                    message += ' | Il y a un surplus de ' + ecart + ' Ar';
                }
                message += ' <span style="color: red;">❌</span>';
            } else if(sommeBillets === montantAvance) {
                totalElement.style.color = 'green';
                message += ' <span style="color: green;">✓ OK</span>';
            } else {
                totalElement.style.color = 'black';
            }

            totalElement.innerHTML = message;
        }
    }

    function normaliserValeurNumerique(valeur) {
        if(valeur === null || valeur === undefined) return '';
        var digitsOnly = valeur.toString().replace(/[^0-9-]/g, '');
        if(digitsOnly === '' || digitsOnly === '-') return '';
        var nombre = parseInt(digitsOnly, 10);
        if(isNaN(nombre)) return '';
        // Regroupement par milliers avec un espace fin (non-breakable) standard
        return nombre.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ' ');
    }

    function normaliserChampsNumeriques() {
        var champs = document.querySelectorAll('input[name="debit"], input[name^="billet_"], input[name^="nombreBillet_"], input[name="montantAvance"]');
        champs.forEach(function(champ) {
            if(!champ) return;
            champ.value = normaliserValeurNumerique(champ.value);
        });
    }

    function nettoyerEspacesNumeriques() {
        var champs = document.querySelectorAll('input[name="debit"], input[name^="billet_"], input[name^="nombreBillet_"], input[name="montantAvance"]');
        champs.forEach(function(champ) {
            if(champ && champ.value) {
                champ.value = champ.value.toString().replace(/\s+/g, '');
            }
        });
    }

    // Initialisation après chargement de la page
    document.addEventListener('DOMContentLoaded', function() {
        const boutonsASupprimer = document.querySelectorAll('[name="Submit2"]');

        // Parcourt la liste et supprime chaque élément trouvé
        boutonsASupprimer.forEach(bouton => {
            bouton.remove();
        });
        // Ajouter les événements sur les champs de saisie
        for(var i = 0; i < listeBillet.length; i++) {
            var nombreBilletElement = document.querySelector('input[name="nombreBillet_' + i + '"]');
            if(nombreBilletElement) {
                // Valeur par défaut à 0
                if(!nombreBilletElement.value || nombreBilletElement.value === '') {
                    nombreBilletElement.value = '0';
                }
                // Suppression des espaces éventuels ajoutés par la librairie
                nombreBilletElement.value = nombreBilletElement.value.toString().replace(/\s+/g, '');

                // Événements pour la mise à jour en temps réel
                nombreBilletElement.addEventListener('input', mettreAJourAffichage);
                nombreBilletElement.addEventListener('blur', mettreAJourAffichage);

                // Validation du format numérique
                nombreBilletElement.addEventListener('input', function(e) {
                    var value = e.target.value;
                    if(value && !/^\d+$/.test(value.replace(/\s+/g, ''))) {
                        e.target.style.borderColor = 'red';
                        e.target.title = 'Veuillez saisir uniquement des nombres entiers';
                    } else {
                        e.target.style.borderColor = '';
                        e.target.title = '';
                    }
                });
            }
        }

        // Normalisation d’affichage des nombres (supprime/replace les espaces mal placés)
        normaliserChampsNumeriques();

        // Nettoyage et validation avant soumission
        var form = document.getElementById('formId');
        if(form) {
            form.addEventListener('submit', function(e) {
                nettoyerEspacesNumeriques();
                if(!validerMontantBillets()) {
                    e.preventDefault();
                }
            });
        }

        // Affichage initial
        mettreAJourAffichage();
    });
</script>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>
