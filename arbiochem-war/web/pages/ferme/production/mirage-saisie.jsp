<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.production.Mirage" %>
<%@ page import="ferme.production.MirageDetail" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="maintenance.ressources.Machine" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.production.Mirage";
    String classeFille = "ferme.production.MirageDetail";
    String nomTableFille = "MIRAGEDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/production/mirage-fiche.jsp";

    Mirage mere = new Mirage();
    mere.setNomTable("MIRAGE");
    MirageDetail fille = new MirageDetail();
    fille.setNomTable("MIRAGEDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie mirage");

    Liste[] liste = new Liste[1];
    Machine liste0 = new Machine();
    liste0.setNomTable("MACHINE");
    liste[0] = new Liste("idmachine",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("nombreoeufsinitial").setLibelle("Nombre d'œufs initial");
    pi.getFormu().getChamp("idmachine").setLibelle("Machine");

    Liste[] listeFille = new Liste[3];
    ParquetBatiment listeFille1 = new ParquetBatiment();
    listeFille1.setNomTable("PARQUET_BATIMENT_LIB");
    listeFille[1] = new Liste("idparquet",listeFille1,"val","id");
    Batiment listeFille0 = new Batiment();
    listeFille0.setNomTable("BATIMENT");
    listeFille[0] = new Liste("idbatiment",listeFille0,"nomBatiment","id");
    listeFille[0].ajouterVide();
    listeFille[0].setDeroulanteDependante(listeFille[1],"idbatiment","onchange");
    TypeObjet listeFille2 = new TypeObjet();
    listeFille2.setNomTable("QUALITEMIRAGE");
    listeFille[2] = new Liste("idqualitemirage",listeFille2,"val","id");
    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("idbatiment_0").setLibelle("B&acirc;timent");
    pi.getFormufle().getChamp("idparquet_0").setLibelle("Parquet");
    pi.getFormufle().getChamp("idqualitemirage_0").setLibelle("Qualit&eacute; mirage");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);

    String[] colOrdre = {"idbatiment","idparquet","idqualitemirage","qte","remarque"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification mirage");
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

