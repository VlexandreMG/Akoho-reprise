<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.cv.CV" %>
<%@ page import="poste.FichePoste" %>
<%@ page import="paie.cv.CVExperience" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.cv.CV";
    String classeFille = "paie.cv.CVExperience";
    String nomTableFille = "CV_EXPERIENCE";
    String colonneMere = "idcv";
    String apres = "paie/cv/cv-fiche.jsp";

    CV mere = new CV();
    mere.setNomTable("CV");
    CVExperience fille = new CVExperience();
    fille.setNomTable("CV_EXPERIENCE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une CV");


    pi.getFormu().getChamp("daty").setLibelle("Date de dėp&ocirc;t");
    pi.getFormu().getChamp("nomcandidat").setLibelle("Nom du candidat");
    pi.getFormu().getChamp("prenomcandidat").setLibelle("Pr&eacute;nom du candidat");
    pi.getFormu().getChamp("titrecv").setLibelle("Titre du CV");
    pi.getFormu().getChamp("resumeprofil").setLibelle("R&eacute;sum&eacute; du profil");
    pi.getFormu().getChamp("idFichePoste").setLibelle("Fiche poste");
    pi.getFormu().getChamp("resumeprofil").setType("textarea");
    pi.getFormu().getChamp("idFichePoste").setPageAppelComplete("poste.FichePoste", "id", "FICHE_POSTE","titre", "");
//    fp[0] = pi.getFormu().getChamp("idFichePoste");
//    Champ[] fp = new Champ[1];
//    Champ.setAutocomplete(fp,"titre", "id", "FICHE_POSTE", "");

    pi.getFormufle().getChamp("entreprise_0").setLibelle("Entreprise");
    pi.getFormufle().getChamp("posteoccupe_0").setLibelle("Poste occup&eacute;");
    pi.getFormufle().getChamp("description_0").setLibelle("Description");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idcv").getListeChamp(),false);

    String[] colOrdre = {"id","entreprise","posteoccupe","description"};
    pi.getFormufle().setColOrdre(colOrdre);
    String[] ordre = {"daty"};
    pi.getFormu().setOrdre(ordre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modifiaction d'une CV");
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

