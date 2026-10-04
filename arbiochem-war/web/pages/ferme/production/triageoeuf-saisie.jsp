<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.production.TriageOeuf" %>
<%@ page import="ferme.production.TriageOeufDetail" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.Parquet" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="affichage.Liste" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%@ page import="affichage.Champ" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.production.TriageOeuf";
    String classeFille = "ferme.production.TriageOeufDetail";
    String nomTableFille = "TRIAGEOEUFDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/production/triageoeuf-fiche.jsp";

    TriageOeuf mere = new TriageOeuf();
    mere.setNomTable("TRIAGEOEUF");
    TriageOeufDetail fille = new TriageOeufDetail();
    fille.setNomTable("TRIAGEOEUFDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie triage oeuf");

    Liste[] liste = new Liste[2];

    ParquetBatiment liste1 = new ParquetBatiment();
    liste[1] = new Liste("idparquet",liste1,"val","id");

    Batiment liste0 = new Batiment();
    liste0.setNomTable("BATIMENT");
    liste[0] = new Liste("idbatiment",liste0,"nomBatiment","id");
    liste[0].ajouterVide();
    liste[0].setDeroulanteDependante(liste[1],"idbatiment","onchange");

    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("heuredepart").setLibelle("Heure de d&eacute;part");
    pi.getFormu().getChamp("idoperateur").setLibelle("Op&eacute;rateur");
    pi.getFormu().getChamp("idnumerocollecte").setLibelle("Num&eacute;ro de collecte");
    pi.getFormu().getChamp("idbatiment").setLibelle("B&acirc;timent");
    pi.getFormu().getChamp("idparquet").setLibelle("Parquet");
    pi.getFormu().getChamp("oeuftotal").setLibelle("Total d'œufs");
    pi.getFormu().getChamp("poidsmoyenoeufs").setLibelle("Poids moyen des œufs");
    pi.getFormu().getChamp("idoperateur").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL","id","id");
    pi.getFormu().getChamp("idnumerocollecte").setPageAppelComplete("bean.TypeObjet","id","NUMEROCOLLECTE","id","id");
    pi.getFormu().getChamp("etat").setVisible(false);

    Liste[] listeFille = new Liste[3];
    TypeObjet listeFille0 = new TypeObjet();
    listeFille0.setNomTable("TYPECOLLECTE");
    listeFille[0] = new Liste("idtypecollecte",listeFille0,"val","id");
    TypeObjet listeFille1 = new TypeObjet();
    listeFille1.setNomTable("QUALITETRIAGEOEUF");
    listeFille[1] = new Liste("idqualitetriageoeuf",listeFille1,"val","id");
    Magasin listeFille2 = new Magasin();
    listeFille2.setNomTable("MAGASIN2");
    listeFille[2] = new Liste("iddestination",listeFille2,"val","id");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idtypecollecte_0").setLibelle("Type de collecte");
    pi.getFormufle().getChamp("idqualitetriageoeuf_0").setLibelle("Qualit&eacute; du triage d'œuf");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("iddestination_0").setLibelle("Destination");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);

    String[] colOrdre = {"idtypecollecte","idqualitetriageoeuf","qte","iddestination"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification triage oeuf");
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

