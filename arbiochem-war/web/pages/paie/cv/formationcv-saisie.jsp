<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.cv.CVFormation" %>
<%@ page import="paie.cv.CVFormation" %>
<%@ page import="affichage.Champ" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="paie.cv.Diplome" %>

<% try{ 
    String idcv = request.getParameter("idcv");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.cv.CVFormation";
    String classeFille = "paie.cv.CVFormation";
    String nomTableFille = "CV_FORMATION";
    String colonneMere = "idcv";
     String apres = "paie/cv/formationcv-saisie.jsp&idcv"+"="+idcv;

    CVFormation mere = new CVFormation();
    mere.setNomTable("CV_FORMATION");
    CVFormation fille = new CVFormation();
    fille.setNomTable("CV_FORMATION");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie des formations CV");


    pi.getFormu().getChamp("idcv").setVisible(false);
    pi.getFormu().getChamp("etablissement").setVisible(false);
    pi.getFormu().getChamp("iddiplome").setVisible(false);
    pi.getFormu().getChamp("domaine").setVisible(false);
    pi.getFormu().getChamp("datedebut").setVisible(false);
    pi.getFormu().getChamp("datefin").setVisible(false);

    Liste[] listeFille = new Liste[1];
    Diplome listeFille0 = new Diplome();
    listeFille0.setNomTable("DIPLOME");
    listeFille[0] = new Liste("iddiplome",listeFille0,"libelle","id");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("etablissement_0").setLibelle("&Eacute;tablissement");
    pi.getFormufle().getChamp("iddiplome_0").setLibelle("Dipl&ocirc;me");
    pi.getFormufle().getChamp("domaine_0").setLibelle("Domaine");
    pi.getFormufle().getChamp("datedebut_0").setLibelle("Date de d&eacute;but");
    pi.getFormufle().getChamp("datefin_0").setLibelle("Date de fin");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idcv").getListeChamp(),false);
     if(idcv != null){
        Champ.setDefaut(pi.getFormufle().getChampFille("idcv"),idcv);
        Champ.setVisible(pi.getFormufle().getChampFille("idcv"),false);
    }
    String[] colOrdre = {"etablissement","iddiplome","domaine","datedebut","datefin"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une formation CV");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=paie/avance/apresMultipleAvance.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTableFille%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="idMere" type="hidden" id="idMere" value="<%= idcv %>">
       <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

