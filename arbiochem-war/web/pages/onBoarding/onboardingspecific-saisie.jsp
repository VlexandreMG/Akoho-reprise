<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="onBoarding.OnboardingMere" %>
<%@ page import="onBoarding.OnboardingFille" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "onBoarding.OnboardingMere";
    String classeFille = "onBoarding.OnboardingFille";
    String nomTableFille = "ONBOARDING_FILLE";
    String colonneMere = "idMere";
    String apres = "onBoarding/onBoarding-fiche.jsp";

    OnboardingMere mere = new OnboardingMere();
    mere.setNomTable("ONBOARDING_MERE");
    OnboardingFille fille = new OnboardingFille();
    fille.setNomTable("ONBOARDING_FILLE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un on boarding");


    pi.getFormu().getChamp("nom").setLibelle("Titre de l'onboarding");
    pi.getFormu().getChamp("description").setLibelle("Description");
    pi.getFormu().getChamp("idFonction").setLibelle("Fonction");
    pi.getFormu().getChamp("idFonction").setLibelle("Fonction");
    pi.getFormu().getChamp("idFonction").setPageAppelComplete("paie.edition.PaieFonction","id","PAIE_FONCTION","id","id");

    pi.getFormufle().getChamp("titre_0").setLibelle("Titre des t&acirc;che &agrave; faire");
    pi.getFormufle().getChamp("description_0").setLibelle("Description");
    pi.getFormufle().getChamp("rang_0").setLibelle("Rang de priorit&eacute;");
    pi.getFormufle().getChamp("objectif_0").setLibelle("Objectif");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idMere").getListeChamp(),false);

    String[] colOrdre = {"titre","description","rang","objectif"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un on boarding");
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

