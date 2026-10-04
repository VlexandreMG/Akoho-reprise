<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="onBoarding.EmployeOnBoardingSession" %>
<%@ page import="onBoarding.EmployeOnBoardingChecklist" %>
<%@ page import="onBoarding.EmployeOnboardingChecklistLib" %>
<%@ page import="affichage.Champ" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="onBoarding.OnboardingMere" %>
<%@ page import="onBoarding.OnboardingFille" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "onBoarding.EmployeOnBoardingSession";
    String classeFille = "onBoarding.EmployeOnBoardingChecklist";
    String nomTableFille = "EMPLOYEE_ONBOARDING_CHECKLIST";
    String colonneMere = "idSessionOnboarding";
    String apres = "onBoarding/employeeonboarding-fiche.jsp";

    EmployeOnBoardingSession mere = new EmployeOnBoardingSession();
    mere.setNomTable("EMPLOYEE_ONBOARDING_SESSIONS");
    EmployeOnboardingChecklistLib fille = new EmployeOnboardingChecklistLib();
    fille.setNomTable("employeeOnboardingChecklistCPL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("");

    affichage.Liste[] listeMere = new affichage.Liste[1];
    OnboardingMere onboardingMere = new OnboardingMere();
    onboardingMere.setNomTable("ONBOARDING_MERE");
    listeMere[0] = new Liste("idOnboarding", onboardingMere, "nom", "id");
    pi.getFormu().changerEnChamp(listeMere);
//    affichage.Liste[] liste = new affichage.Liste[1];
//    Liste l1 = new Liste("estTerminer",new TypeObjet("OUINON"),"desce","val");
//    liste[0] = l1;
//    pi.getFormufle().changerEnChamp(liste);

    pi.getFormu().getChamp("idPersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("idOnboarding").setAutre("onchange=\"updateFille(event, 'formId')\"");
    pi.getFormu().getChamp("idOnboarding").setLibelle("Onboarding");
    pi.getFormu().getChamp("dateDebut").setValeur(Utilitaire.dateDuJour());
    pi.getFormu().getChamp("dateDebut").setVisible(false);
    pi.getFormu().getChamp("dateFin").setVisible(false);
    pi.getFormu().getChamp("etat").setValeur("1");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("progression").setVisible(false);
    pi.getFormu().getChamp("idPersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","log_personnel_v2","id","id");
//    pi.getFormu().getChamp("idOnboarding").setPageAppelComplete("onBoarding.OnboardingMere","id","ONBOARDING_MERE","id","id");

    pi.getFormufle().getChamp("idSessionOnboarding_0").setLibelle("Session onboarding");
//    pi.getFormufle().getChamp("estTerminer_0").setLibelle("Termin&eacute;");
//    pi.getFormufle().getChamp("dateFin_0").setLibelle("Date de fin");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("idOnboardingItem_0").setLibelle("ID");
    pi.getFormufle().getChamp("idOnboardingItemlib_0").setLibelle("T&acirc;che &agrave; faire de l'onboarding");

    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idOnboardingItem"),"onBoarding.OnboardingFille","id","onboarding_fille","id","id");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idSessionOnboarding").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("estTerminer").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("dateFin").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("estTerminerLib").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("etat_0").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("etatLib_0").getListeChamp(),false);

    if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")) {
        String idOnboarding = request.getParameter("idOnboarding");
        if (idOnboarding != null && !idOnboarding.isEmpty()){
            OnboardingFille onboardingFille = new OnboardingFille();
            onboardingFille.setIdMere(idOnboarding);
            OnboardingFille[] onboardingFilles = onboardingFille.getByIdMere();
            taille = onboardingFilles.length;
            for (int i = 0; i < taille; i++) {
                pi.getFormufle().getChamp("idOnboardingItem_"+i).setDefaut(onboardingFilles[i].getId());
                pi.getFormufle().getChamp("idOnboardingItemlib_"+i).setDefaut(onboardingFilles[i].getTitre());
                pi.getFormufle().getChamp("idOnboardingItem_"+i).setAutre("readonly");
                pi.getFormufle().getChamp("idOnboardingItemlib_"+i).setAutre("readonly");
            }
            Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idOnboardingItem"),"onBoarding.OnboardingFille","id","onboarding_fille","id","id");
        }
    }


    String[] colOrdre = {"idOnboardingItem","idOnboardingItemlib", "estTerminer","dateFin","remarque"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("");
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

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

