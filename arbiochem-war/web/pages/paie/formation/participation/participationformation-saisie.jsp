<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="affichage.Champ" %>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.elementpaie.PaiePersonnelElementpaie" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.formation.ParticipationFormation" %>
<%@ page import="paie.formation.session.SessionFormation" %>
<%@ page import="paie.formation.action.ActionFormation" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    int taille = 10;

    SessionFormation sessionFormation = new SessionFormation();

    SessionFormation[] sess = sessionFormation.getAllSessionFormation();
    String idsessionformation = request.getParameter("idsessionformation");
    ActionFormation[] actionFormations = null;


    ParticipationFormation fille = new ParticipationFormation();

    PageInsertMultiple pi = new PageInsertMultiple(fille, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Enregistrement des participation au formation");

    // Configuration des page appel complete
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idpersonnel"), "paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","id","id");
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idactionformation"), "paie.formation.action.ActionFormation","id","ACTION_FORMATION","id","id");


//    ActionFormation actionFormation = new ActionFormation();
//    Liste[] liste = new Liste[1];
//    liste[0] = new Liste("idactionformation",actionFormation, "intitule", "id");
//    pi.getFormufle().changerEnChamp(liste);
   // ActionFormationBack actionFormation = new ActionFormationBack();
   // Liste[] liste = new Liste[1];
   // liste[0] = new Liste("idactionformation",actionFormation, "intitule", "id");
   // pi.getFormufle().changerEnChamp(liste);
    // Libellés
    pi.getFormufle().getChamp("idactionformation_0").setLibelle("Action de formation");
    pi.getFormufle().getChamp("idpersonnel_0").setLibelle("Personnel");
    pi.getFormufle().getChamp("dateinscription_0").setLibelle("Date d'inscription");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");

    if (actionFormations != null && actionFormations.length > 0){
        for (int i = 0; i < actionFormations.length; i++) {
            pi.getFormufle().getChamp("idactionformation_" + i).setDefaut(actionFormations[i].getId());
        }
    }

    // Ordre des colonnes (même que paiepersonnelelementpaie-saisie.jsp)
    pi.getFormufle().setColOrdre(new String[]{
            "idactionformation",
            "idpersonnel",
            "dateinscription",
            "remarque"
    });

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

    String Apresinsertion = "paie/formation/participation/participationformation-liste.jsp";
    String classe = "paie.formation.ParticipationFormation";
    String nomTable = "PARTICIPATION_FORMATION";
%>

<script>
    // ===== AJOUT : Script pour soumettre le formulaire au changement =====
    function changerDesignation() {
        document.incident.submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pi.getTitre() %></h1>
    </section>
    <section class="content">

        <form action="<%=pi.getLien()%>?but=paie/formation/participation/participationformation-saisie.jsp" method="post" name="incident" id="incident">
            <input name="onchanged" type="hidden" id="onchanged" value="true">
            <div class="row col-md-12 nopadding" style="margin-bottom: 20px;">
                <!-- 
                <div class="col-md-3 nopadding">
                    Session de formation :
                    <select name="idsessionformation" class="champ form-control" id="idsessionformation" onchange="changerDesignation()">
                        <option value="">-- Sélectionnez une session --</option>
                        <%
                            for( int i = 0; i < sess.length; i++ ){
                                String selected = "";
                                if(idsessionformation != null && idsessionformation.equals(sess[i].getId())){
                                    selected = "selected";
                                }
                        %>
                        <option value="<%= sess[i].getId() %>" <%= selected %>> <%= sess[i].getRemarque() %> </option>
                        <% } %>
                    </select>
                </div>
                -->
            </div>
        </form>

        <form id="formId" class='container' action="<%=pi.getLien()%>?but=paie/formation/participation/apresMultiple.jsp" method="post" >
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
            <input name="bute" type="hidden" id="bute" value="<%= Apresinsertion %>">
            <input name="classe" type="hidden" id="classe" value="<%=classe%>">
            <input name="classefille" type="hidden" id="classefille" value="<%=classe%>">
            <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        </form>
    </section>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
