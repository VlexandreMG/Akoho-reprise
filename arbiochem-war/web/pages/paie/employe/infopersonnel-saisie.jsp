
<%@page import="paie.employe.EmployeComplet"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageInsert"%>
<%@ page import="paie.categorie.CategoriePaie" %>
<%@ page import="java.util.LinkedHashMap" %>

<%
    try {
        String titre = "Saisie des informations du personnel";
        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification des informations du personnel";
        }

        String autreparsley = "data-parsley-range='[8, 40]' required";
        String classe = "paie.employe.EmployeComplet";
        String apres = "paie/employe/personnel-fiche-portrait.jsp";

        EmployeComplet ec = new EmployeComplet();
        ec.setNomTable("EMPLOYE_COMPLET");

        PageInsert pi = new PageInsert(ec, request, (user.UserEJB) session.getValue("u"));
        String[] ordre = {"dateembauche","matricule", "nom", "prenom", "idCivilite", "date_naissance", "lieu_naissance_commune", "sexe", "numero_cin", "date_cin", "date_dupl_cin", "lieu_delivrance_cin", "adresse","direction", "telephone", "email", "cheminImage", "situation_matrimoniale", "acte_naissance", "nbenfant", "cturgence_nom_prenom", "cturgence_telephone1", "idfonction", "idcategorie_paie", "code_postal", "numero_cnaps", "mode_paiement", "idBanque", "idAgence", "banque_numero_compte","retraiteCompl"};
        pi.getFormu().setOrdre(ordre);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("nom").setLibelle("Nom (*)");
        pi.getFormu().getChamp("prenom").setLibelle("Pr&eacute;noms (*)");
        Liste[] liste = new Liste[13];
        TypeObjet s = new TypeObjet();
        s.setNomTable("sexe");
        liste[0] = new Liste("sexe",s,"val","id");
        TypeObjet sm = new TypeObjet();
        sm.setNomTable("situation_matrimoniale");
        liste[1] = new Liste("situation_matrimonial",sm,"val","id");
        TypeObjet t = new TypeObjet();
        t.setNomTable("type_contrat");
        liste[2] = new Liste("typeContrat",t,"val","id");


        TypeObjet regionObjet = new TypeObjet();
        regionObjet.setNomTable("log_direction");

        liste[3] = new Liste("direction", regionObjet, "val", "id");
        liste[3].setDefaut("DIR00001");
        CategoriePaie objet = new CategoriePaie();
        objet.setNomTable("categorie_paie");
        liste[4] = new Liste("idcategorie_paie",objet, "val", "id");

        TypeObjet qualPaie = new TypeObjet();
        qualPaie.setNomTable("QUALIFICATION_PAIE");
        liste[5] = new Liste("idqualification",qualPaie, "val", "id");

        TypeObjet modePaiementObjet = new TypeObjet();
        modePaiementObjet.setNomTable("PAIE_MODEPAIEMENT");
        liste[6] = new Liste("mode_paiement", modePaiementObjet, "val", "id");

        TypeObjet formationdiplome = new TypeObjet();
        formationdiplome.setNomTable("formation_diplome");
        liste[7] = new Liste("formation", formationdiplome, "val", "id");

        TypeObjet departement = new TypeObjet();
        departement.setNomTable("DEPARTEMENT");
        liste[8] = new Liste("idDepartement", departement, "val", "id");

        TypeObjet civ = new TypeObjet();
        civ.setNomTable("CIVILITE");
        liste[9] = new Liste("idCivilite", civ, "val", "id");

        TypeObjet bnq = new TypeObjet();
        bnq.setNomTable("Banque");
        liste[10] = new Liste("idBanque", bnq, "val", "id");

        TypeObjet statutPaie = new TypeObjet();
        statutPaie.setNomTable("PAIE_STATUT");
        liste[11] = new Liste("idStatut", statutPaie, "val", "id");

        liste[12] = new Liste("retraiteCompl");
        liste[12].makeListeOuiNon();
        
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("service").setPageAppelComplete("paie.log.LogService","id","log_service_libelle");
        pi.getFormu().getChamp("idfonction").setPageAppelComplete("paie.edition.PaieFonction","id","PAIE_FONCTIONLIBELLE");
        pi.getFormu().getChamp("idcategorie_paie").setPageAppelComplete("paie.categorie.CategoriePaie","id","CATEGORIE_PAIE_LIB");
        
        pi.getFormu().getChamp("id_pers").setVisible(false);
        pi.getFormu().getChamp("lieu_naissance_commune").setLibelle("Lieu de naissance (*)");
        pi.getFormu().getChamp("numero_cin").setLibelle("Num&eacute;ro CIN (*)");
        pi.getFormu().getChamp("date_dupl_cin").setLibelle("Date De Duplicata CIN");
        pi.getFormu().getChamp("idCivilite").setLibelle("Civilit&eacute");
        pi.getFormu().getChamp("mere").setLibelle("Nom de la M&egrave;re");
        pi.getFormu().getChamp("pere").setLibelle("Nom du P&egrave;re");
        pi.getFormu().getChamp("idAgence").setLibelle("Agence");
        pi.getFormu().getChamp("idAgence").setPageAppelComplete("paie.employe.BanqueAgenceLib","id","BanqueAgenceLib");

        pi.getFormu().getChamp("adresse").setLibelle("Adresse (*)");
        pi.getFormu().getChamp("nationalite").setVisible(false);
        pi.getFormu().getChamp("nationalite").setDefaut("Malagasy");
        pi.getFormu().getChamp("situation_matrimonial").setLibelle("Situation matrimoniale");
        pi.getFormu().getChamp("idcategorie").setVisible(false);
        //pi.getFormu().getChamp("indicegrade").setVisible(false);
        pi.getFormu().getChamp("matricule_patron").setVisible(false);
        pi.getFormu().getChamp("initiale").setVisible(false);
        pi.getFormu().getChamp("date_naissance").setLibelle("Date de naissance (*)");
        pi.getFormu().getChamp("sexe").setLibelle("Genre");
        pi.getFormu().getChamp("date_cin").setLibelle("Date De D&eacute;livrance CIN (*)");
        pi.getFormu().getChamp("lieu_delivrance_cin").setLibelle("Lieu De D&eacute;livrance CIN (*)");
        pi.getFormu().getChamp("fokotany").setVisible(false);
        pi.getFormu().setNbColonne(2);
        pi.getFormu().getChamp("matricule").setLibelle("Matricule propre (*)");
//        pi.getFormu().getChamp("matricule").setVisible(false);

        pi.getFormu().getChamp("direction").setLibelle("Ville");
        pi.getFormu().getChamp("indicegrade").setLibelle("Indice");
        pi.getFormu().getChamp("mode_paiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("idfonction").setLibelle("Fonction (*)");
        pi.getFormu().getChamp("idBanque").setLibelle("Banque");
        
        pi.getFormu().getChamp("banque_numero_compte").setLibelle("Num&eacute;ro de compte");
        pi.getFormu().getChamp("permis_conduire").setVisible(false);
        pi.getFormu().getChamp("chemin_permis").setVisible(false);
        pi.getFormu().getChamp("cturgence_telephone1").setLibelle("T&eacute;l. Contact D'urgence");
        
        pi.getFormu().getChamp("echelon").setVisible(false);
        pi.getFormu().getChamp("cturgence_telephone3").setVisible(false);
        pi.getFormu().getChamp("datesaisie").setVisible(false);
        pi.getFormu().getChamp("vehiculee").setVisible(false);
        
        pi.getFormu().getChamp("droit_hs").setVisible(false);
        pi.getFormu().getChamp("heurehebdomadaire").setVisible(false);
        pi.getFormu().getChamp("numero_cnaps").setLibelle("Num&eacute;ro CNAPS (*)");
        pi.getFormu().getChamp("typeContrat").setLibelle("Type De Contrat (*)");

        pi.getFormu().getChamp("indesirable").setLibelle("Dur&eacute;e si P&eacute;riode D'essaie Ou CDD (mois)");
        pi.getFormu().getChamp("telephone").setLibelle("T&eacute;l&eacute;phone (*)");
        pi.getFormu().getChamp("idcategorie_paie").setLibelle("Cat&eacute;gorie personnel (*)");
        pi.getFormu().getChamp("discipline").setLibelle("Discipline");

        pi.getFormu().getChamp("retraiteCompl").setDefaut("1");
        pi.getFormu().getChamp("retraiteCompl").setLibelle("Retraite Compl&eacute;mentaire");

        pi.getFormu().getChamp("anneeExperience").setLibelle("Ann&eacute;e d'exp&eacute;rience au poste");
        pi.getFormu().getChamp("debutcontrat").setLibelle("Date De D&eacute;but Du Contrat (*)");
        
        pi.getFormu().getChamp("classee").setVisible(false);
        pi.getFormu().getChamp("statut").setVisible(false);
        pi.getFormu().getChamp("code_agence_banque").setVisible(false);
        pi.getFormu().getChamp("banque_compte_cle").setVisible(false);
        pi.getFormu().getChamp("cturgence_nom_prenom").setLibelle("Nom Du Contact D'urgence");
        pi.getFormu().getChamp("cturgence_telephone2").setVisible(false);
        //pi.getFormu().getChamp("adresse_ligne2").setLibelle("Commune");
        //pi.getFormu().getChamp("code_postal").setLibelle("Code postal");
        pi.getFormu().getChamp("service").setLibelle("Section");
         //pi.getFormu().getChamp("region").setLibelle("Lieu d'affectation");
        pi.getFormu().getChamp("formation").setLibelle("Formation/dipl&ocirc;me");

        pi.getFormu().getChamp("cheminImage").setVisible(false);
        //pi.getFormu().getChamp("cheminImage").setLibelle("Nom de l'image");
//        pi.getFormu().getChamp("cheminImage").setType("file");
   
        pi.getFormu().getChamp("banque_code").setVisible(false);
        pi.getFormu().getChamp("date_dernierpromo").setVisible(false);
        pi.getFormu().getChamp("heuremensuel").setVisible(false);
        pi.getFormu().getChamp("numero_ostie").setLibelle("Num&eacute;ro OSTIE/OMSIE");
        pi.getFormu().getChamp("numero_ostie").setVisible(false);
        pi.getFormu().getChamp("nbenfant").setLibelle("Enfant(S) &Agrave; Charge");
        pi.getFormu().getChamp("duree").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("ctg").setVisible(false);
        pi.getFormu().getChamp("idconjoint").setVisible(false);
        pi.getFormu().getChamp("idqualification").setLibelle("Classification");
        pi.getFormu().getChamp("personnel_etat").setVisible(false);
        pi.getFormu().getChamp("fincontrat").setLibelle("Date De Fin Du Contrat");
        pi.getFormu().getChamp("acte_naissance").setLibelle("Nom Du Ou De La Conjoint(e) L&eacute;gale");
        pi.getFormu().getChamp("dateembauche").setLibelle("Date D'embauche (*)");
        pi.getFormu().getChamp("heurejournalier").setVisible(false);
        pi.getFormu().getChamp("indice_fonctionnel").setVisible(false);
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("temporaire").setVisible(false);
        pi.getFormu().getChamp("mail").setLibelle("Adresse Email (*)");
        pi.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement (*)");
        pi.getFormu().getChamp("code_postal").setLibelle("Code postal");
        pi.getFormu().getChamp("idStatut").setLibelle("Statut");

        pi.getFormu().getChamp("idfonction").setPageAppelInsert("paie/fonction/paiefonction-saisie.jsp", "idfonction;idfonctionlibelle", "id;val");
        pi.getFormu().getChamp("service").setPageAppelInsert("paie/service/service-saisie.jsp", "service;servicelibelle", "id;libelle");
        pi.getFormu().getChamp("idAgence").setPageAppelInsert("paie/employe/banqueagence-saisie.jsp", "idAgence;idAgencelibelle", "id;nom");

        pi.getFormu().getChamp("idCiviliteLib").setVisible(false);
        pi.getFormu().getChamp("idBanqueLib").setVisible(false);
        pi.getFormu().getChamp("codeAgence").setVisible(false);
        pi.getFormu().getChamp("idAgenceLib").setVisible(false);
        pi.getFormu().getChamp("code_postal").setVisible(false);

        pi.getFormu().getChamp("salaireBase").setLibelle("Salaire de base");
        pi.getFormu().getChamp("salaireBase").setAutre("onChange='getTauxHoraire()'");
        
        pi.getFormu().getChamp("tauxHoraire").setLibelle("Taux Horaire");
        pi.getFormu().getChamp("tauxHoraire").setAutre("readonly");


        LinkedHashMap<String, String[]> rubriques = new LinkedHashMap<String, String[]>();

        rubriques.put("&Eacute;tat Civil", new String[]{
                "dateembauche",
                "matricule",
                "sexe",
                "idCivilite",
                "nom",
                "prenom",
                "date_naissance",
                "lieu_naissance_commune",
                "numero_cin",
                "date_cin",
                "lieu_delivrance_cin",
                "date_dupl_cin",
                "pere",
                "mere",
                "acte_naissance",
                "situation_matrimonial",
                "nbenfant",
                "adresse",
                "direction",
                "telephone",
                "mail",
                "cturgence_nom_prenom",
                "cturgence_telephone1"

        });

        rubriques.put("Statut personnel", new String[]{
//                "dateembauche",
                "idqualification",
                "idfonction",
                "service",
                "idcategorie_paie",
                "salaireBase",
                "tauxHoraire",
                "indicegrade",
                "idStatut"
        });

        rubriques.put("Organisme", new String[]{
                "numero_cnaps",
                "mode_paiement",
                "idBanque",
                "idAgence",
                "banque_numero_compte",
                "numero_ostie",
        });

       // rubriques.put("Informations personnelles", new String[]{
//                "nom",
//                "prenom",
//                "sexe",
//                "date_naissance",
//                "lieu_naissance_commune",
//                "situation_matrimonial",
//                "acte_naissance",
//                "nbenfant"
//        });

//        rubriques.put("Informations d'identit&eacute; (CIN)", new String[]{
//                "numero_cin",
//                "date_cin",
//                "date_dupl_cin",
//                "lieu_delivrance_cin"
//        });
//
//        rubriques.put("Coordonnées & contact", new String[]{
//                "adresse",
//                "code_postal",
//                "telephone",
//                "mail",
//                "cturgence_nom_prenom",
//                "cturgence_telephone1"
//        });
//
//        rubriques.put("Situation professionnelle", new String[]{
//                "idfonction",
//                "idcategorie_paie",
//                "idqualification",
//                "discipline",
//                "anneeExperience",
//                "service",
//                "idDepartement",
//                "direction"
//        });
//
//        rubriques.put("Contrat & carri&egrave;re", new String[]{
//                "typeContrat",
//                "debutcontrat",
//                "fincontrat",
//                "dateembauche",
//                "indesirable"
//        });
//
//        rubriques.put("Paie & organismes sociaux", new String[]{
//                "mode_paiement",
//                "banque_numero_compte",
//                "numero_cnaps",
//                "numero_ostie"
//        });
//
//        rubriques.put("Autres informations", new String[]{
//                "remarque"
//        });

// Application au formulaire
        pi.getFormu().setRubrique(rubriques);



        //String[] colOrdre = {"nom", "prenom", "dateembauche", "date_naissance", "lieu_naissance_commune", "sexe", "telephone", "mail", "adresse", "numero_cin", "date_cin", "date_dupl_cin", "lieu_delivrance_cin", "situation_matrimonial","service", "idDepartement", "acte_naissance", "direction", "temporaire","indesirable", "debutcontrat", "fincontrat", "mode_paiement", "banque_numero_compte", "idfonction", "cturgence_nom_prenom", "cturgence_telephone1", "numero_cnaps", "numero_ostie", "nbenfant","idcategorie_paie","idqualification","matricule","discipline","anneeExperience","personnel_etat"};
        //pi.getFormu().setOrdre(colOrdre);
        pi.preparerDataFormu();
        
       

        
%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="nn" id="nn" >
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="daty" type="hidden" id="daty" value="<%=Utilitaire.dateDuJour()%>">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classe%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=ec.getNomTable()%>">
    </form>
</div>

<script>
    
    var textFields = document.querySelectorAll('input[type="text"]');
    var index = 0;
    for (index = 0; index < textFields.length; ++index) {
        var textField = textFields[index];
        textField.setAttribute("oninput", "this.value = this.value.toUpperCase()");
    }
    function champMontant(){
        let qual = $('#idqualification').val();
        let catpaie = $('#idcategorie_paie').val();
        
        if(qual && qual != "" && catpaie && catpaie != "" ){
            console.log('tairo!');
            $.ajax({
                type:'GET',
                url:'/fer/MontantInfoPers?idqualification='+qual+'&idcategorie_paie='+catpaie,
                contentType: 'text/html',
                success:function(ma){
                    var data = ma;   
                    console.log(data);
                    $('#montant_af').val(data);
                }
            });
            
        }else{
            console.log('mbola!');
        }
    }

    function cleanNumber(val) {
        if (!val) return 0;

        return parseFloat(
            val
                .toString()
                .replace(/&nbsp;/g, "")   // retire le code HTML
                .replace(/\u00A0/g, "")   // retire espace insécable réel
                .replace(/\s/g, "")       // retire tous les autres espaces
                .replace(",", ".")        // virgule → point
        ) || 0;
    }
    function getTauxHoraire() {
        const salaireBase = cleanNumber(document.getElementById("salaireBase")?.value);
        const tauxHoraireValeur = salaireBase / 173.33;
        document.getElementById("tauxHoraire").value = tauxHoraireValeur.toFixed(2);
        // document.getElementById("tauxHoraire").value =
        //     Intl.NumberFormat('fr-FR', {
        //         minimumFractionDigits: 2,
        //         maximumFractionDigits: 2
        //     }).format(tauxHoraireValeur);
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