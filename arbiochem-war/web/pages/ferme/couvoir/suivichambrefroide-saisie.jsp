<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.couvoir.SuiviChambreFroide" %>
<%@ page import="ferme.couvoir.SuiviChambreFroideDetail" %>
<%@ page import="ferme.configuration.Eclosoir" %>
<%@ page import="ferme.configuration.Incubateur" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%@ page import="ferme.configuration.QualitePoussin" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.couvoir.SuiviChambreFroide";
    String classeFille = "ferme.couvoir.SuiviChambreFroideDetail";
    String nomTableFille = "SUIVICHAMBREFROIDEDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/couvoir/suivichambrefroide-fiche.jsp";

    SuiviChambreFroide mere = new SuiviChambreFroide();
    mere.setNomTable("SUIVICHAMBREFROIDE");
    SuiviChambreFroideDetail fille = new SuiviChambreFroideDetail();
    fille.setNomTable("SUIVICHAMBREFROIDEDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie suivi chambre froide");

    Liste[] liste = new Liste[1];
    Magasin liste0 = new Magasin();
    liste0.setNomTable("MAGASIN2");
    liste[0] = new Liste("idsallestockageoeuf",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idsallestockageoeuf").setLibelle("Salle de stockage œuf");
    pi.getFormu().getChamp("etat").setVisible(false);

    Liste[] listeFille = new Liste[0];
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idresponsable_0").setLibelle("Responsable");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure");
    pi.getFormufle().getChamp("temperature_0").setLibelle("Temp&eacute;rature");
    pi.getFormufle().getChamp("humidite_0").setLibelle("Humidit&eacute;");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idresponsable"),"paie.log.LogPersonnel","id","LOG_PERSONNEL","id","id");

    String[] colOrdre = {"idresponsable","heure","temperature","humidite","remarque"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification suivi chambre froide");
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

