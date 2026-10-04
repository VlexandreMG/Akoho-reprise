<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="poste.FichePoste" %>
<%@ page import="poste.FichePosteFille" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.*" %>
<%@ page import="paie.annexe.BusinessUnit" %>
<%@ page import="paie.categorie.CategoriePaie" %>
<%@ page import="rh.QualificationPaie" %>
<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "poste.FichePoste";
    String classeFille = "poste.FichePosteFille";
    String nomTableFille = "FICHE_POSTE_FILLE";
    String colonneMere = "idficheposte";
    String apres = "poste/ficheposte-fiche.jsp";

    FichePoste mere = new FichePoste();
    mere.setNomTable("FICHE_POSTE");
    FichePosteFille fille = new FichePosteFille();
    fille.setNomTable("FICHE_POSTE_FILLE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'une fiche de poste");

    Liste[] liste = new Liste[3];
    //TypeObjet liste3 = new TypeObjet();
    //liste3.setNomTable("PERMIS");
    //liste[0] = new Liste("idPermis",liste3,"val","id");
    BusinessUnit nu = new BusinessUnit();
    liste[0] = new Liste("idBu",nu,"val","id");
    CategoriePaie categoriePaie = new CategoriePaie();
    liste[1] = new Liste("idCategoriePaie",categoriePaie,"val","id");
    QualificationPaie qualificationPaie = new QualificationPaie();
    liste[2] = new Liste("idQualificationPaie", qualificationPaie , "val", "id");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("iddepartement").setPageAppelComplete("maintenance.ressources.DepartementMaintenance","id","DEPARTEMENT","id","id");
    pi.getFormu().getChamp("idtypecontrat").setPageAppelComplete("bean.TypeObjet","id","TYPE_CONTRAT","id","id");
    pi.getFormu().getChamp("idFamilleProfessionel").setPageAppelComplete("bean.TypeObjet","id","FAMILLE_PROFESSIONNELLE","id","id");
    pi.getFormu().getChamp("idMetier").setPageAppelComplete("bean.TypeObjet","id","METIER","id","id");
    pi.getFormu().getChamp("idEmploi").setPageAppelComplete("bean.TypeObjet","id","emploi","id","id");
    pi.getFormu().getChamp("idCodeRome").setPageAppelComplete("paie.competence.CodeRome","id","code_rome","id","id");
    pi.getFormu().getChamp("idFamilleProfessionel").setLibelle("Famille professionnelle");
    pi.getFormu().getChamp("idMetier").setLibelle("M&eacute;tier");
    pi.getFormu().getChamp("idEmploi").setLibelle("Emploi");
    pi.getFormu().getChamp("idCodeRome").setLibelle("Code ROME");
    pi.getFormu().getChamp("idNiveauFormation").setPageAppelComplete("bean.TypeObjet","id","FORMATION_DIPLOME","id","id");
    pi.getFormu().getChamp("idPermis").setPageAppelComplete("bean.TypeObjet","id","PERMIS","id","id");
    pi.getFormu().getChamp("idFonction").setPageAppelComplete("bean.TypeObjet","id","PAIE_FONCTION","id","id");
    pi.getFormu().getChamp("iddepartement").setLibelle("D&eacute;partement");
    pi.getFormu().getChamp("iddepartement").setVisible(false);
    pi.getFormu().getChamp("idFonction").setLibelle("Fonction");
    pi.getFormu().getChamp("idtypecontrat").setLibelle("Type de contrat");
    pi.getFormu().getChamp("titre").setLibelle("Titre");
    pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pi.getFormu().getChamp("description").setLibelle("Description");
    pi.getFormu().getChamp("missions").setLibelle("Missions");
    pi.getFormu().getChamp("exigenceposte").setLibelle("Exigences du poste");
    pi.getFormu().getChamp("salairemin").setLibelle("Salaire");
    //pi.getFormu().getChamp("salairemax").setLibelle("Salaire maximum");
    pi.getFormu().getChamp("lieuTravail").setLibelle("Lieu de travail");
    pi.getFormu().getChamp("materielDocument").setLibelle("Mat&eacute;riel de documentation");
    pi.getFormu().getChamp("conditionTravail").setLibelle("Conditions de travail");
    pi.getFormu().getChamp("modeControle").setLibelle("Mode de contr&ocirc;le");
    pi.getFormu().getChamp("idNiveauFormation").setLibelle("Niveau de formation");
    pi.getFormu().getChamp("idPermis").setLibelle("Type de permis");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("description").setType("textarea");
    pi.getFormu().getChamp("exigenceposte").setType("textarea");
    pi.getFormu().getChamp("missions").setType("textarea");
    pi.getFormu().getChamp("etat").setLibelle("&Eacute;tat");
    pi.getFormu().getChamp("idBu").setLibelle("BU");
    pi.getFormu().getChamp("autre").setType("textarea");
    pi.getFormu().getChamp("idCategoriePaie").setLibelle("Cat&eacute;gorie de paie");
    pi.getFormu().getChamp("idQualificationPaie").setLibelle("Qualification de paie");
    pi.getFormu().getChamp("idPermis").setVisible(false);
    pi.getFormu().getChamp("salairemin").setVisible(false);
    pi.getFormu().getChamp("salairemax").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);

    String[] ordre = {
            "daty",
            "reference",
            "titre",
            "idBu",
            "iddepartement",
            "idFonction",
            "idtypecontrat",
            "idCategoriePaie",
            "idQualificationPaie",
            "idNiveauFormation",
            "idPermis",
            "lieuTravail",
            "conditionTravail",
            "modeControle",
            "materielDocument",
            "description",
            "missions",
            "exigenceposte",
            "autre",
            "salairemin",
            "salairemax",
            "etat",
            "idFamilleProfessionel","idMetier","idEmploi","idCodeRome"
            
    };
    pi.getFormu().setOrdre(ordre);


    pi.getFormufle().getChamp("titreactivites_0").setLibelle("Titre des activit&eacute;s");
    pi.getFormufle().getChamp("descriptionactivites_0").setLibelle("Description des activit&eacute;s");
    for (int i = 0; i < taille; i++) {
        pi.getFormufle().getChamp("titreactivites_"+i).setType("textarea");
        pi.getFormufle().getChamp("descriptionactivites_"+i).setType("textarea");
    }
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idficheposte"), false);

    String[] colOrdre = {"id", "titreactivites", "descriptionactivites"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    String hiddenActeValue = "insert";
    String id = request.getParameter("id");
    String actionUrl = pi.getLien() + "?but=apresMultiple.jsp";

    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une fiche de poste");
        hiddenActeValue = "updateInsert";
        if (id != null && !id.isEmpty()) {
            actionUrl += "&id=" + id;
        }
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=actionUrl%>" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="<%=hiddenActeValue%>">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>