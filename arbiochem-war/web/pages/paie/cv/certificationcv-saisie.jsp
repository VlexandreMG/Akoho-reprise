<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.cv.CVCertification" %>
<%@ page import="paie.cv.CVCertification" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    String idcv = request.getParameter("idcv");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.cv.CVCertification";
    String classeFille = "paie.cv.CVCertification";
    String nomTableFille = "CV_CERTIFICATION";
    String colonneMere = "idcv";
     //String apres = "paie/cv/cv-fiche.jsp&id"+"="+idcv;
     String apres = "paie/cv/certificationcv-saisie.jsp&idcv"+"="+idcv;

    CVCertification mere = new CVCertification();
    mere.setNomTable("CV_CERTIFICATION");
    CVCertification fille = new CVCertification();
    fille.setNomTable("CV_CERTIFICATION");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie des certifications CV");


    pi.getFormu().getChamp("idcv").setVisible(false);
    pi.getFormu().getChamp("nomcertification").setVisible(false);
    pi.getFormu().getChamp("organisme").setVisible(false);
    pi.getFormu().getChamp("dateobtention").setVisible(false);


    pi.getFormufle().getChamp("nomcertification_0").setLibelle("Nom de la certification");
    pi.getFormufle().getChamp("organisme_0").setLibelle("Organisme");
    pi.getFormufle().getChamp("dateobtention_0").setLibelle("Date d'obtention");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idcv").getListeChamp(),false);
    if(idcv != null){
        Champ.setDefaut(pi.getFormufle().getChampFille("idcv"),idcv);
        Champ.setVisible(pi.getFormufle().getChampFille("idcv"),false);
    }
    String[] colOrdre = {"nomcertification","organisme","dateobtention"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification des certifications CV");
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

