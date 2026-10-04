<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.recrutement.Candidatures" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.recrutement.Candidatures";
    String nomTable = "CANDIDATURES";
    String apres = "paie/recrutement/candidature-fiche.jsp";
    String idOffre = request.getParameter("idOffre");

    Candidatures o = new Candidatures();
    o.setNomTable("CANDIDATURES");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un nouveau candidature");

    Liste[] liste = new Liste[0];
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idcandidat").setLibelle("Candidat");
    pi.getFormu().getChamp("idoffreemploie").setLibelle("Offre d'emploi");
    pi.getFormu().getChamp("dateapplication").setLibelle("Date d'application");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("raisonrefus").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idcandidat").setPageAppelComplete("paie.recrutement.Candidat","id","CANDIDAT","id","id");
    pi.getFormu().getChamp("idoffreemploie").setPageAppelComplete("paie.recrutement.OffreEmploi","id","OFFRE_EMPLOI","id","id");
    if (idOffre != null){
        pi.getFormu().getChamp("idoffreemploie").setDefaut(idOffre);
    }
 
    String[] ordre = {"idcandidat","idoffreemploie","dateapplication","remarque","raisonrefus"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un candidature");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

