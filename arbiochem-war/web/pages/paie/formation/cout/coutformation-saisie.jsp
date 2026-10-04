<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formation.CoutFormation" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.formation.CoutFormation";
    String nomTable = "COUT_FORMATION";
    String apres = "paie/formation/cout/coutformation-fiche.jsp";

    CoutFormation o = new CoutFormation();
    o.setNomTable("COUT_FORMATION");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une cout de formation");

    Liste[] liste = new Liste[1];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("DEVISE");
    liste[0] = new Liste("iddevise",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idactionformation").setLibelle("Action de formation");
    pi.getFormu().getChamp("coutpedagogiquehoraire").setLibelle("Co&ucirc;t p&eacute;dagogique horaire");
    pi.getFormu().getChamp("coutpedagogiquetotal").setLibelle("Co&ucirc;t p&eacute;dagogique total");
    pi.getFormu().getChamp("coutpedagogiquetotal").setVisible(false);
    pi.getFormu().getChamp("coutindirecte").setLibelle("Co&ucirc;t indirect");
    pi.getFormu().getChamp("coutdeplacement").setLibelle("Co&ucirc;t de d&eacute;placement");
    pi.getFormu().getChamp("couthebergement").setLibelle("Co&ucirc;t d'h&eacute;bergement");
    pi.getFormu().getChamp("coutrestauration").setLibelle("Co&ucirc;t de restauration");
    pi.getFormu().getChamp("autrecout").setLibelle("Autre co&ucirc;t");
    pi.getFormu().getChamp("coutparstagiaire").setLibelle("Co&ucirc;t par stagiaire");
    pi.getFormu().getChamp("totalheurestagiaire").setLibelle("Total d'heures stagiaire");
    pi.getFormu().getChamp("iddevise").setLibelle("Devise");
    pi.getFormu().getChamp("iddevise").setDefaut("Ar");
    pi.getFormu().getChamp("idactionformation").setPageAppelComplete("paie.formation.action.ActionFormation","id","ACTION_FORMATION","id","id");

    String idActionFormation = request.getParameter("idActionFormation");

    if (idActionFormation != null) {
        pi.getFormu().getChamp("idactionformation").setDefaut(idActionFormation);
    }
    String[] ordre = {"idactionformation","coutpedagogiquehoraire","coutpedagogiquetotal","coutdeplacement","couthebergement","coutrestauration","autrecout","coutparstagiaire","totalheurestagiaire","iddevise"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une cout de formation");
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

