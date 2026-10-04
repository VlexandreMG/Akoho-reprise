<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.production.Fumigation" %>
<%@ page import="ferme.production.Fumigation" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.production.Fumigation";
    String classeFille = "ferme.production.Fumigation";
    String nomTableFille = "FUMIGATION";
    String colonneMere = "idmere";
    String apres = "ferme/production/fumigation-liste.jsp";

    Fumigation mere = new Fumigation();
    mere.setNomTable("FUMIGATION");
    Fumigation fille = new Fumigation();
    fille.setNomTable("FUMIGATION");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie fumigation");


    pi.getFormu().getChamp("daty").setVisible(false);
    pi.getFormu().getChamp("idnumerovague").setVisible(false);
    pi.getFormu().getChamp("idoperateur").setVisible(false);
    pi.getFormu().getChamp("idlot").setVisible(false);
    pi.getFormu().getChamp("nombreoac").setVisible(false);
    pi.getFormu().getChamp("heuredebutfumigation").setVisible(false);
    pi.getFormu().getChamp("heurefinfumigation").setVisible(false);
    pi.getFormu().getChamp("heuredebutextraction").setVisible(false);
    pi.getFormu().getChamp("heurefinextraction").setVisible(false);
    pi.getFormu().getChamp("idproduit").setVisible(false);
    pi.getFormu().getChamp("qte").setVisible(false);
    pi.getFormu().getChamp("temperaturemin").setVisible(false);
    pi.getFormu().getChamp("temperaturemax").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idBatiment").setVisible(false);
    pi.getFormu().getChamp("idParquet").setVisible(false);

    Liste[] listeFille = new Liste[3];
    TypeObjet listeFille0 = new TypeObjet();
    listeFille0.setNomTable("NUMEROCOLLECTE");
    listeFille[0] = new Liste("idnumerovague",listeFille0,"val","id");
    ParquetBatiment listeFille2 = new ParquetBatiment();
    listeFille[2] = new Liste("idParquet",listeFille2,"val","id");
    Batiment listeFille1 = new Batiment();
    listeFille1.setNomTable("BATIMENT");
    listeFille[1] = new Liste("idBatiment",listeFille1,"nomBatiment","id");
    listeFille[1].ajouterVide();
    listeFille[1].setDeroulanteDependante(listeFille[2],"idbatiment","onchange");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("daty_0").setLibelle("Date");
    pi.getFormufle().getChamp("idnumerovague_0").setLibelle("Num&eacute;ro de vague");
    pi.getFormufle().getChamp("idoperateur_0").setLibelle("Op&eacute;rateur");
    pi.getFormufle().getChamp("idlot_0").setLibelle("Lot");
    pi.getFormufle().getChamp("idBatiment_0").setLibelle("B&acirc;timent");
    pi.getFormufle().getChamp("idParquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("nombreoac_0").setLibelle("Nombre OAC");
    pi.getFormufle().getChamp("heuredebutfumigation_0").setLibelle("Heure de d&eacute;but de fumigation");
    pi.getFormufle().getChamp("heurefinfumigation_0").setLibelle("Heure de fin de fumigation");
    pi.getFormufle().getChamp("heuredebutextraction_0").setLibelle("Heure de d&eacute;but d'extraction");
    pi.getFormufle().getChamp("heurefinextraction_0").setLibelle("Heure de fin d'extraction");
    pi.getFormufle().getChamp("idproduit_0").setLibelle("Produit");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("temperaturemin_0").setLibelle("Temp&eacute;rature minimale");
    pi.getFormufle().getChamp("temperaturemax_0").setLibelle("Temp&eacute;rature maximale");
    Champ.setVisible(pi.getFormufle().getChampMulitple("etat").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idoperateur"),"paie.log.LogPersonnel","id","LOG_PERSONNEL","id","id");
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idlot"),"ferme.lot.Lot","id","LOT","id","id");
    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.Ingredients","id","AS_INGREDIENTS","id","id");
    String[] champsHeure = {"heuredebutfumigation","heurefinfumigation","heuredebutextraction","heurefinextraction"};
    for (String champHeure : champsHeure) {
        for (Champ ch : pi.getFormufle().getChampFille(champHeure)) {
            ch.setType("time");
        }
    }

    String[] colOrdre = {"id","daty","idnumerovague","idoperateur","idlot","idBatiment","idParquet","nombreoac","heuredebutfumigation","heurefinfumigation","heuredebutextraction","heurefinextraction","idproduit","qte","temperaturemin","temperaturemax"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Saisie fumigation");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
//            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
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

