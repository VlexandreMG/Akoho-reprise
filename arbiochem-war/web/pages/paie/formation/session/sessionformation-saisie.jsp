<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formation.session.SessionFormation" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.formation.session.SessionFormation";
    String nomTable = "SESSION_FORMATION";
    String apres = "paie/formation/session/sessionformation-fiche.jsp";

    SessionFormation o = new SessionFormation();
    o.setNomTable("SESSION_FORMATION");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une session formation");

    Liste[] liste = new Liste[0];
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idactionformation").setLibelle("Action de formation");
    pi.getFormu().getChamp("datedebut").setLibelle("Date de d&eacute;but");
    pi.getFormu().getChamp("datefin").setLibelle("Date de fin");
    pi.getFormu().getChamp("nbheureprevue").setLibelle("Nombre d'heures pr&eacute;vues");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idactionformation").setPageAppelComplete("paie.formation.action.ActionFormation","id","ACTION_FORMATION","id","id");

    String idActionFormation = request.getParameter("idActionFormation");

    if (idActionFormation != null) {
        pi.getFormu().getChamp("idactionformation").setDefaut(idActionFormation);
    }
    String[] ordre = {"idactionformation","datedebut","datefin","nbheureprevue","remarque"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une session formation");
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

