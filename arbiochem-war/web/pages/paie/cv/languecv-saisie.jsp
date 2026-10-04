<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.cv.CVLangue" %>
<%@ page import="paie.cv.CVLangue" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    String idcv = request.getParameter("idcv");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.cv.CVLangue";
    String classeFille = "paie.cv.CVLangue";
    String nomTableFille = "CV_LANGUE";
    String colonneMere = "idcv";
    //String apres = "paie/cv/cv-fiche.jsp&id"+"="+idcv;
    String apres = "paie/cv/languecv-saisie.jsp&idcv"+"="+idcv;

    CVLangue mere = new CVLangue();
    mere.setNomTable("CV_LANGUE");
    CVLangue fille = new CVLangue();
    fille.setNomTable("CV_LANGUE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie des langues CV");


    pi.getFormu().getChamp("idcv").setVisible(false);
    pi.getFormu().getChamp("langue").setVisible(false);
    pi.getFormu().getChamp("niveaulecture").setVisible(false);
    pi.getFormu().getChamp("niveauecrit").setVisible(false);
    pi.getFormu().getChamp("niveauoral").setVisible(false);


    pi.getFormufle().getChamp("langue_0").setLibelle("Langue");
    pi.getFormufle().getChamp("niveaulecture_0").setLibelle("Niveau de lecture");
    pi.getFormufle().getChamp("niveauecrit_0").setLibelle("Niveau d'&eacute;crit");
    pi.getFormufle().getChamp("niveauoral_0").setLibelle("Niveau oral");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idcv").getListeChamp(),false);
     if(idcv != null){
        Champ.setDefaut(pi.getFormufle().getChampFille("idcv"),idcv);
        Champ.setVisible(pi.getFormufle().getChampFille("idcv"),false);
    }
    String[] colOrdre = {"langue","niveaulecture","niveauecrit","niveauoral"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification des langues CV");
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

