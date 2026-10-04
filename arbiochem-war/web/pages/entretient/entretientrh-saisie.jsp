<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="entretien.EntretienRH" %>
<%@ page import="entretien.EntretienRHDetails" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="affichage.Champ" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "entretien.EntretienRH";
    String classeFille = "entretien.EntretienRHDetails";
    String nomTableFille = "ENTRETIENRH_DETAIL";
    String colonneMere = "identRetientRh";
    String apres = "entretient/entretientrh-fiche.jsp";

    EntretienRH mere = new EntretienRH();
    mere.setNomTable("ENTRETIENRH");
    EntretienRHDetails fille = new EntretienRHDetails();
    fille.setNomTable("ENTRETIENRH_DETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'une entretien RH");

    Liste[] liste = new Liste[2];
    String[] aff0 = {"0","1"};
    String[] val0 = {"Interne","Externe"};
    liste[0] = new Liste("typeEntretient",val0, aff0);
    String[] aff1 = {"1","2","3","4","5"};
    String[] val1 = {"1","2","3","4","5"};
    liste[1] = new Liste("experienceCandidat",aff1, val1);
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("typeEntretient").setLibelle("Type d'entretien");
    pi.getFormu().getChamp("typeEntretient").setAutre("onchange=\"gererChampsEntretien()\"");
    pi.getFormu().getChamp("nomPrenomCandidat").setLibelle("Nom et pr&eacute;nom du candidat");
    pi.getFormu().getChamp("idPersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("idFonction").setLibelle("Fonction");
    pi.getFormu().getChamp("idDirection").setLibelle("Direction");
    pi.getFormu().getChamp("idEvaluateur").setLibelle("Evaluateur");
    pi.getFormu().getChamp("motivationCandidat").setLibelle("Motivation du candidat");
    pi.getFormu().getChamp("motivationCandidat").setType("textarea");
    pi.getFormu().getChamp("ambitionProfessionel").setLibelle("Ambition professionnelle");
    pi.getFormu().getChamp("ambitionProfessionel").setType("textarea");
    pi.getFormu().getChamp("pretentionSalariale").setLibelle("Pr&eacute;tention salariale");
    pi.getFormu().getChamp("remunerationActuel").setLibelle("R&eacute;mun&eacute;ration actuelle");
    pi.getFormu().getChamp("appreciationCandidat").setLibelle("Appr&eacute;ciation du candidat");
    pi.getFormu().getChamp("commentaires").setLibelle("Commentaires");
    pi.getFormu().getChamp("commentaires").setType("textarea");
    pi.getFormu().getChamp("experienceCandidat").setLibelle("Exp&eacute;rience du candidat");
    pi.getFormu().getChamp("atout").setLibelle("Atout");
    pi.getFormu().getChamp("atout").setType("textarea");
    pi.getFormu().getChamp("faiblesses").setLibelle("Faiblesses");
    pi.getFormu().getChamp("faiblesses").setType("textarea");
    pi.getFormu().getChamp("pointVigilance").setLibelle("Point de vigilance");
    pi.getFormu().getChamp("pointVigilance").setType("textarea");
    pi.getFormu().getChamp("conclustion").setLibelle("Conclusion");
    pi.getFormu().getChamp("conclustion").setType("textarea");
    pi.getFormu().getChamp("idPersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");
    pi.getFormu().getChamp("idFonction").setPageAppelComplete("paie.edition.PaieFonction","id","PAIE_FONCTION","id","id");
    pi.getFormu().getChamp("idDirection").setPageAppelComplete("bean.TypeObjet","id","LOG_DIRECTION","id","id");
    pi.getFormu().getChamp("idEvaluateur").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");

    Liste[] listeFille = new Liste[2];
    TypeObjet listeFille0 = new TypeObjet();
    listeFille0.setNomTable("CATEGORIEEVALENTRETIENT");
    listeFille[0] = new Liste("idCategorieEvaluation",listeFille0,"val","id");
    String[] aff1f = {"1","2","3","4"};
    String[] val1f = {"1","2","3","4"};
    listeFille[1] = new Liste("note",aff1f, val1f);
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idCategorieEvaluation_0").setLibelle("Cat&eacute;gorie d'&eacute;valuation");
    pi.getFormufle().getChamp("critere_0").setLibelle("Crit&egrave;re");
    pi.getFormufle().getChamp("note_0").setLibelle("Note");
    pi.getFormufle().getChamp("observation_0").setLibelle("Observation");
    Champ.setVisible(pi.getFormufle().getChampMulitple("identRetientRh").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
    for (int i = 0; i < taille; i++) {
        pi.getFormufle().getChamp("critere_"+i).setType("textarea");
    }
//    Champ.setT(pi.getFormufle().getChampMulitple("critere").getListeChamp(), "textarea");

    String[] colOrdre = {"id","idCategorieEvaluation","critere","note","observation"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une entretien RH");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<script type="text/javascript">
    function gererChampsEntretien() {
        var typeSelect = document.getElementsByName("typeEntretient")[0];
        if (!typeSelect) return;

        var val = typeSelect.value;
        var inputPersonnel = document.getElementsByName("idPersonnel")[0];
        var inputCandidat = document.getElementsByName("nomPrenomCandidat")[0];

        // Fonction pour masquer/afficher un champ et son label lié
        function toggleChamp(element, afficher) {
            if (!element) return;

            // 1. Masquer/Afficher le conteneur du champ (le div de saisie)
            var container = element.parentElement;
            if (container) {
                container.style.display = afficher ? '' : 'none';
            }

            // 2. Masquer/Afficher le label lié (grâce à l'attribut 'for')
            // On cherche le label qui a for="idPersonnel" ou for="nomPrenomCandidat"
            var label = "";
            if(element.name == "idPersonnel"){
                label = document.querySelector('label[for="Personnel"]');
            } else {
                label = document.querySelector('label[for="Nom et prénom du candidat"]');
            }
            if (label) {
                // Si le label est dans un div (common dans les frameworks), on masque le div parent du label
                if (label.parentElement.tagName.toLowerCase() === 'div') {
                    label.parentElement.style.display = afficher ? '' : 'none';
                } else {
                    label.style.display = afficher ? '' : 'none';
                }
            }

            // 3. Gestion du bouton d'appel "..." (si présent)
            var btnAppel = document.getElementById("p_appel_" + element.name);
            if (btnAppel) {
                btnAppel.style.display = afficher ? '' : 'none';
            }
        }

        // Si Externe (val == "1") : Masquer Personnel, Afficher Candidat
        if (val === "1") {
            toggleChamp(inputPersonnel, false);
            toggleChamp(inputCandidat, true);
        }
        // Si Interne (val == "0") : Afficher Personnel, Masquer Candidat
        else {
            toggleChamp(inputPersonnel, true);
            toggleChamp(inputCandidat, false);
        }
    }

    // Exécution au chargement
    window.addEventListener('DOMContentLoaded', function() {
        gererChampsEntretien();
    });
</script>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

