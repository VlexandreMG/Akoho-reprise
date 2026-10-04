<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.onBoarding.CheckListMere" %>
<%@ page import="paie.onBoarding.CheckListFille" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.onBoarding.TypeDocumentCheckList" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.onBoarding.CheckListMere";
    String classeFille = "paie.onBoarding.CheckListFille";
    String nomTableFille = "CHECKLIST_FILLE";
    String colonneMere = "idchecklistmere";
    String apres = "paie/onBoarding/checkentree-fiche.jsp";

    CheckListMere mere = new CheckListMere();
    mere.setNomTable("CHECKLIST_MERE");
    CheckListFille fille = new CheckListFille();
    fille.setNomTable("CHECKLIST_FILLE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie d'une check list");

    if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")) {
        String typecheckliste = request.getParameter("typecheckliste");
        int type = Integer.parseInt(typecheckliste);
        CheckListFille[] checkListFilles = mere.getDataCheckListByType(type);
        taille = checkListFilles.length;
        pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setDefautFille(checkListFilles);
        Liste[] listeFille = new Liste[3];
        listeFille[0] = new Liste("est_coche");
        listeFille[0].makeListeOuiNon();
        listeFille[1] = new Liste("idtypedocument", new TypeDocumentCheckList(),"val","id");
        TypeObjet direction = new TypeObjet();
        direction.setNomTable("LOG_DIRECTION");
        listeFille[2] = new Liste("idresponsable", direction, "val", "id");
        pi.getFormufle().changerEnChamp(listeFille);

        pi.getFormufle().getChamp("idtypedocument_0").setLibelle("Type de document");
        pi.getFormufle().getChamp("idresponsable_0").setLibelle("Responsable");
        pi.getFormufle().getChamp("contenue_0").setLibelle("Contenu");
        pi.getFormufle().getChamp("est_coche_0").setLibelle("Check");
        Champ.setVisible(pi.getFormufle().getChampMulitple("idchecklistmere").getListeChamp(),false);
        for (int i = 0; i < taille; i++) {
            pi.getFormufle().getChamp("contenue_"+i).setType("textarea");
        }
    }
    Liste[] liste = new Liste[1];
    String[] aff0 = {"Entree","Sortie"};
    String[] val0 = {"0","1"};
    liste[0] = new Liste("typecheckliste",aff0, val0);
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("typecheckliste").setLibelle("Type de checklist");
    pi.getFormu().getChamp("typecheckliste").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");

    Liste[] listeFille = new Liste[3];
    listeFille[0] = new Liste("est_coche");
    listeFille[0].makeListeOuiNon();
    listeFille[1] = new Liste("idtypedocument", new TypeDocumentCheckList(),"val","id");
    TypeObjet direction = new TypeObjet();
    direction.setNomTable("LOG_DIRECTION");
    listeFille[2] = new Liste("idresponsable", direction, "val", "id");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idtypedocument_0").setLibelle("Type de document");
    pi.getFormufle().getChamp("idresponsable_0").setLibelle("Responsable");
    pi.getFormufle().getChamp("contenue_0").setLibelle("Contenu");
    pi.getFormufle().getChamp("est_coche_0").setLibelle("Check");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idchecklistmere").getListeChamp(),false);
    for (int i = 0; i < taille; i++) {
        pi.getFormufle().getChamp("contenue_"+i).setType("textarea");
    }



    String[] colOrdre = {"idtypedocument","idresponsable","contenue","est_coche"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une check list");
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
        %>
        <div id="butfillejsp">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        </div>
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
    // Exécution automatique au chargement initial de la page
    window.addEventListener('load', function() {
        const selectChecklist = document.querySelector('select[name="typecheckliste"]');
        if (selectChecklist) {
            const changeEvent = new Event('change', { bubbles: true });
            selectChecklist.dispatchEvent(changeEvent);
        }
    });
</script>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>