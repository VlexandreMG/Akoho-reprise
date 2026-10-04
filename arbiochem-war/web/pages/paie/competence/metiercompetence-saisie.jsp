<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.competence.Metier" %>
<%@ page import="paie.competence.MetierCompetence" %>
<%@ page import="affichage.Champ" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.competence.CompetenceVal" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.competence.Metier";
    String classeFille = "paie.competence.MetierCompetence";
    String nomTableFille = "METIER_COMPETENCE";
    String colonneMere = "idmetier";
    String apres = "paie/competence/metiercompetence-fiche.jsp";

    Metier mere = new Metier();
    mere.setNomTable("METIER");
    MetierCompetence fille = new MetierCompetence();
    fille.setNomTable("METIER_COMPETENCE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une competence avec metier");


    pi.getFormu().getChamp("val").setLibelle("Valeur");
    pi.getFormu().getChamp("val").setVisible(false);
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("idFonction").setLibelle("Fonction");
    pi.getFormu().getChamp("idFonction").setPageAppelComplete("paie.edition.PaieFonction", "id", "Paie_fonction", "id", "idFonction");

    Liste[] listeFille = new Liste[1];
    CompetenceVal listeFille0 = new CompetenceVal();
    listeFille[0] = new Liste("niveaurequis",listeFille0,"description","val");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idcompetence_0").setLibelle("Comp&eacute;tence");
    pi.getFormufle().getChamp("niveaurequis_0").setLibelle("Difficult&eacute;");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmetier").getListeChamp(),false);
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idcompetence"),"paie.competence.Competance","id","COMPETENCE","id","id");

    String[] colOrdre = {"idcompetence","niveaurequis"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Saisie d'une competence avec metier");
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

