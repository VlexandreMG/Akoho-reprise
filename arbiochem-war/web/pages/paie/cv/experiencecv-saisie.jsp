<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.cv.CVExperience" %>
<%@ page import="paie.cv.CVExperience" %>
<%@ page import="affichage.Champ" %>

<% try{ 
     String idcv = request.getParameter("idcv");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "paie.cv.CVExperience";
    String classeFille = "paie.cv.CVExperience";
    String nomTableFille = "CV_EXPERIENCE";
    String colonneMere = "";
    //String apres = "paie/cv/cv-fiche.jsp&id"+"="+idcv;
    String apres = "paie/cv/experiencecv-saisie.jsp&idcv"+"="+idcv;

    CVExperience mere = new CVExperience();
    mere.setNomTable("CV_EXPERIENCE");
    CVExperience fille = new CVExperience();
    fille.setNomTable("CV_EXPERIENCE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie des experiences d'un CV");


    pi.getFormu().getChamp("idcv").setAutre("readonly");
    pi.getFormu().getChamp("idcv").setVisible(false);
    pi.getFormu().getChamp("entreprise").setVisible(false);
    pi.getFormu().getChamp("posteoccupe").setVisible(false);
    pi.getFormu().getChamp("description").setVisible(false);
    //pi.getFormu().getChamp("etat").setVisible(false);


    pi.getFormufle().getChamp("idcv_0").setLibelle("CV");
    pi.getFormufle().getChamp("entreprise_0").setLibelle("Entreprise");
    pi.getFormufle().getChamp("posteoccupe_0").setLibelle("Poste occup&eacute;");
    pi.getFormufle().getChamp("description_0").setLibelle("Description");
    Champ.setAutre(pi.getFormufle().getChampFille("idcv"),"readonly");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idcv").getListeChamp(),false);
   // Champ.setVisible(pi.getFormufle().getChampMulitple("etat").getListeChamp(),false);

    String[] colOrdre = {"entreprise","posteoccupe","description"};
    if(idcv != null){
        Champ.setDefaut(pi.getFormufle().getChampFille("idcv"),idcv);
        Champ.setVisible(pi.getFormufle().getChampFille("idcv"),false);
    }
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification des experiences d'un C CV");
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

