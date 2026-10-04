<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.couvoir.MiseEnIncubateur" %>
<%@ page import="ferme.couvoir.MiseEnIncubateurDetail" %>
<%@ page import="ferme.configuration.Incubateur" %>
<%@ page import="affichage.Champ" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.couvoir.MiseEnIncubateur";
    String classeFille = "ferme.couvoir.MiseEnIncubateurDetail";
    String nomTableFille = "MISEENINCUBATEURDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/couvoir/miseneincubateur-fiche.jsp";

    MiseEnIncubateur mere = new MiseEnIncubateur();
    mere.setNomTable("MISEENINCUBATEUR");
    MiseEnIncubateurDetail fille = new MiseEnIncubateurDetail();
    fille.setNomTable("MISEENINCUBATEURDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie mise en incubateur");

    Liste[] liste = new Liste[1];
    Incubateur liste0 = new Incubateur();
    liste0.setNomTable("INCUBATEUR");
    liste[0] = new Liste("idincubateur",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("datemiseenmachine").setLibelle("Date de mise en machine");
    pi.getFormu().getChamp("dateeclosionprevue").setLibelle("Date d'&eacute;closion pr&eacute;vue");
    pi.getFormu().getChamp("idincubateur").setLibelle("Incubateur");
    pi.getFormu().getChamp("idresponsable").setLibelle("Responsable");
    pi.getFormu().getChamp("temperateurcible").setLibelle("Temp&eacute;rature cible");
    pi.getFormu().getChamp("humiditecible").setLibelle("Humidit&eacute; cible");
    pi.getFormu().getChamp("heureprechauffage").setLibelle("Heure de pr&eacute;chauffage");
    pi.getFormu().getChamp("heuredebutincubation").setLibelle("Heure de d&eacute;but d'incubation");
    pi.getFormu().getChamp("idresponsable").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL","id","id");

    Liste[] listeFille = new Liste[2];
    ParquetBatiment listeFille1 = new ParquetBatiment();
    listeFille1.setNomTable("PARQUET_BATIMENT_LIB");
    listeFille[1] = new Liste("idparquet",listeFille1,"val","id");
    Batiment listeFille0 = new Batiment();
    listeFille0.setNomTable("BATIMENT");
    listeFille[0] = new Liste("idbatiment",listeFille0,"nomBatiment","id");
    listeFille[0].ajouterVide();
    listeFille[0].setDeroulanteDependante(listeFille[1],"idbatiment","onchange");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idlot_0").setLibelle("Lot");
    pi.getFormufle().getChamp("idbatiment_0").setLibelle("B&acirc;timent");
    pi.getFormufle().getChamp("idparquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("heuredemarrage_0").setLibelle("Heure de d&eacute;marrage");
    pi.getFormufle().getChamp("heurefin_0").setLibelle("Heure de fin");
    pi.getFormufle().getChamp("dateponte_0").setLibelle("Date de ponte");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("poidsmoyen_0").setLibelle("Poids moyen");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idlot"),"ferme.lot.Lot","id","LOT","id","id");

    String[] colOrdre = {"idlot","idbatiment","idparquet","heuredemarrage","heurefin","dateponte","qte","poidsmoyen"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification mise en incubateur");
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

