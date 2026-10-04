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

        pi.getFormu().getChamp("service").setVisible(false);
        pi.getFormu().getChamp("idfonction").setVisible(false);
        pi.getFormu().getChamp("idcategorie_paie").setVisible(false);
        pi.getFormu().getChamp("id_pers").setVisible(false);
        pi.getFormu().getChamp("lieu_naissance_commune").setVisible(false);
        pi.getFormu().getChamp("numero_cin").setVisible(false);
        pi.getFormu().getChamp("date_dupl_cin").setVisible(false);
        pi.getFormu().getChamp("idCivilite").setVisible(false);
        pi.getFormu().getChamp("mere").setVisible(false);
        pi.getFormu().getChamp("pere").setVisible(false);
        pi.getFormu().getChamp("idAgence").setVisible(false);
        pi.getFormu().getChamp("adresse").setVisible(false);
        pi.getFormu().getChamp("nationalite").setVisible(false);
        pi.getFormu().getChamp("situation_matrimonial").setVisible(false);
        pi.getFormu().getChamp("idcategorie").setVisible(false);
        pi.getFormu().getChamp("indicegrade").setVisible(false);
        pi.getFormu().getChamp("matricule_patron").setVisible(false);
        pi.getFormu().getChamp("initiale").setVisible(false);
        pi.getFormu().getChamp("date_naissance").setVisible(false);
        pi.getFormu().getChamp("sexe").setVisible(false);
        pi.getFormu().getChamp("date_cin").setVisible(false);
        pi.getFormu().getChamp("lieu_delivrance_cin").setVisible(false);
        pi.getFormu().getChamp("fokotany").setVisible(false);
        pi.getFormu().getChamp("matricule").setVisible(false);
        pi.getFormu().getChamp("direction").setVisible(false);
        pi.getFormu().getChamp("mode_paiement").setVisible(false);
        pi.getFormu().getChamp("idBanque").setVisible(false);
        pi.getFormu().getChamp("banque_numero_compte").setVisible(false);
        pi.getFormu().getChamp("permis_conduire").setVisible(false);
        pi.getFormu().getChamp("chemin_permis").setVisible(false);
        pi.getFormu().getChamp("cturgence_telephone1").setVisible(false);
        pi.getFormu().getChamp("echelon").setVisible(false);
        pi.getFormu().getChamp("cturgence_telephone3").setVisible(false);
        pi.getFormu().getChamp("datesaisie").setVisible(false);
        pi.getFormu().getChamp("vehiculee").setVisible(false);
        pi.getFormu().getChamp("droit_hs").setVisible(false);
        pi.getFormu().getChamp("heurehebdomadaire").setVisible(false);
        pi.getFormu().getChamp("numero_cnaps").setVisible(false);
        pi.getFormu().getChamp("telephone").setVisible(false);
        pi.getFormu().getChamp("classee").setVisible(false);
        pi.getFormu().getChamp("statut").setVisible(false);
        pi.getFormu().getChamp("code_agence_banque").setVisible(false);
        pi.getFormu().getChamp("banque_compte_cle").setVisible(false);
        pi.getFormu().getChamp("cturgence_nom_prenom").setVisible(false);
        pi.getFormu().getChamp("cturgence_telephone2").setVisible(false);
        pi.getFormu().getChamp("cheminImage").setVisible(false);
        pi.getFormu().getChamp("banque_code").setVisible(false);
        pi.getFormu().getChamp("date_dernierpromo").setVisible(false);
        pi.getFormu().getChamp("heuremensuel").setVisible(false);
        pi.getFormu().getChamp("numero_ostie").setVisible(false);
        pi.getFormu().getChamp("nbenfant").setVisible(false);
        pi.getFormu().getChamp("duree").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("ctg").setVisible(false);
        pi.getFormu().getChamp("idconjoint").setVisible(false);
        pi.getFormu().getChamp("idqualification").setVisible(false);
        pi.getFormu().getChamp("personnel_etat").setVisible(false);
        pi.getFormu().getChamp("acte_naissance").setVisible(false);
        pi.getFormu().getChamp("dateembauche").setVisible(false);
        pi.getFormu().getChamp("heurejournalier").setVisible(false);
        pi.getFormu().getChamp("indice_fonctionnel").setVisible(false);
        pi.getFormu().getChamp("temporaire").setVisible(false);
        pi.getFormu().getChamp("mail").setVisible(false);
        pi.getFormu().getChamp("code_postal").setVisible(false);
        pi.getFormu().getChamp("idCiviliteLib").setVisible(false);
        pi.getFormu().getChamp("idBanqueLib").setVisible(false);
        pi.getFormu().getChamp("codeAgence").setVisible(false);
        pi.getFormu().getChamp("idAgenceLib").setVisible(false);

        pi.getFormu().setNbColonne(2);

        ////////////////////////////
        Liste[] liste = new Liste[3];
        TypeObjet formationdiplome = new TypeObjet();
        formationdiplome.setNomTable("formation_diplome");
        liste[0] = new Liste("formation", formationdiplome, "val", "id");

        TypeObjet t = new TypeObjet();
        t.setNomTable("type_contrat");
        liste[1] = new Liste("typeContrat",t,"val","id");

        TypeObjet departement = new TypeObjet();
        departement.setNomTable("DEPARTEMENT");
        liste[2] = new Liste("idDepartement", departement, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("indesirable").setLibelle("Dur&eacute;e si P&eacute;riode D'essaie Ou CDD (mois)");
        pi.getFormu().getChamp("discipline").setLibelle("Discipline");
        pi.getFormu().getChamp("formation").setLibelle("Formation/dipl&ocirc;me");
        pi.getFormu().getChamp("anneeExperience").setLibelle("Ann&eacute;e d'exp&eacute;rience au poste");
        pi.getFormu().getChamp("debutcontrat").setLibelle("Date De D&eacute;but Du Contrat (*)");
        pi.getFormu().getChamp("fincontrat").setLibelle("Date De Fin Du Contrat");
        pi.getFormu().getChamp("typeContrat").setLibelle("Type De Contrat (*)");
        pi.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement (*)");

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