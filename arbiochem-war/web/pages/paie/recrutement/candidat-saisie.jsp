<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.recrutement.Candidat" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.recrutement.Candidat";
    String nomTable = "CANDIDAT";
    String apres = "paie/recrutement/candidat-fiche.jsp";

    Candidat o = new Candidat();
    o.setNomTable("CANDIDAT");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un nouveau candidat");

    Liste[] liste = new Liste[0];
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("nom").setLibelle("Nom");
    pi.getFormu().getChamp("prenom").setLibelle("Pr&eacute;nom");
    pi.getFormu().getChamp("email").setLibelle("Email");
    pi.getFormu().getChamp("telephone").setLibelle("T&eacute;l&eacute;phone");
    pi.getFormu().getChamp("date_naissance").setLibelle("Date de naissance");
 
    String[] ordre = {"nom","prenom","email","telephone","date_naissance"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un candidat");
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

