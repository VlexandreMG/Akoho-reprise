<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.batiment.BatimentVideSanitaire" %>
<%@ page import="ferme.batiment.BatimentVideSanitaireDetail" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.batiment.BatimentVideSanitaire";
    String classeFille = "ferme.batiment.BatimentVideSanitaireDetail";
    String nomTableFille = "BATIMENTVIDESANITAIREDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/batiment/batimentvidesanitaire-fiche.jsp";

    BatimentVideSanitaire mere = new BatimentVideSanitaire();
    mere.setNomTable("BATIMENTVIDESANITAIRE");
    BatimentVideSanitaireDetail fille = new BatimentVideSanitaireDetail();
    fille.setNomTable("BATIMENTVIDESANITAIREDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une batiment vide sanitaire");


    pi.getFormu().getChamp("idbatiment").setLibelle("B&acirc;timent");
    pi.getFormu().getChamp("idresponsable").setLibelle("Responsable");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("heuredebut").setLibelle("Heure de d&eacute;but");
    pi.getFormu().getChamp("heurefin").setLibelle("Heure de fin");
    pi.getFormu().getChamp("heuredebut").setType("time");
    pi.getFormu().getChamp("heurefin").setType("time");
    pi.getFormu().getChamp("idbatiment").setPageAppelComplete("ferme.configuration.Batiment","id","BATIMENT","id","id");
    pi.getFormu().getChamp("idresponsable").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL","id","id");
    pi.getFormu().getChamp("etat").setVisible(false);


    pi.getFormufle().getChamp("idproduit_0").setLibelle("Produit");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.Ingredients","id","AS_INGREDIENTS","id","id");

    String[] colOrdre = {"id","idproduit","qte","remarque"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une batiment vide sanitaire");
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

