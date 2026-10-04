<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="maintenance.travaux.ResultatMaintenanceLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="maintenance.etats.EtatMachine" %>
<%@page import="historique.MapUtilisateur"%>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "maintenance.travaux.ResultatMaintenance";
    String nomTable = "RESULTATMAINTENANCE";
    String apres = "maintenance/travaux/Otravaux-fiche.jsp&id="+request.getParameter("idOrdreTravaux")+"&tab=inc/resultat-maintenance-liste";

    ResultatMaintenanceLib o = new ResultatMaintenanceLib();
    o.setNomTable("RESULTATMAINTENANCELIB");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie du r&eacute;sultat de maintenance");

    Liste[] liste = new Liste[1];
    EtatMachine liste0 = new EtatMachine();
    liste0.setNomTable("ETATMACHINE");
    liste[0] = new Liste("etatmachine",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    MapUtilisateur map = u.getUser();
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idordretravaux").setLibelle("Ordre Travaux");
    pi.getFormu().getChamp("idordretravaux").setDefaut(request.getParameter("idOrdreTravaux"));
    pi.getFormu().getChamp("idordretravaux").setVisible(false);
    pi.getFormu().getChamp("idpersonnel").setDefaut(String.valueOf(u.getUser().getRefuser()));
    pi.getFormu().getChamp("idpersonnelLib").setLibelle("Responsable");
    pi.getFormu().getChamp("idpersonnelLib").setDefaut(map.getNomuser());
    pi.getFormu().getChamp("idpersonnelLib").setAutre("readonly");
    pi.getFormu().getChamp("idpersonnel").setVisible(false);
    pi.getFormu().getChamp("etatmachinelib").setVisible(false);
    pi.getFormu().getChamp("etatmachine").setLibelle("&Eacute;tat Machine");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("prochaineetape").setLibelle("Prochaine &eacute;tape");
    pi.getFormu().getChamp("prochainedaty").setLibelle("Prochaine date");
    pi.getFormu().getChamp("motsClesss").setVisible(false);
 
    String[] ordre = {"daty","idordretravaux","idpersonnel","etatmachine","designation","prochaineetape","prochainedaty"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification du r&eacute;sultat de maintenance");
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

