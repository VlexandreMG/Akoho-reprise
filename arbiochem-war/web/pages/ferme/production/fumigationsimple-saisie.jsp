<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.production.Fumigation" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "ferme.production.Fumigation";
    String nomTable = "FUMIGATION";
    String apres = "ferme/production/fumigation-fiche.jsp";

    Fumigation o = new Fumigation();
    o.setNomTable("FUMIGATION");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une fumigation");


    Liste[] liste = new Liste[3];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("NUMEROCOLLECTE");
    liste[0] = new Liste("idnumerovague",liste0,"val","id");
    ParquetBatiment liste2 = new ParquetBatiment();
    liste[2] = new Liste("idParquet",liste2,"val","id");
    Batiment liste1 = new Batiment();
    liste1.setNomTable("BATIMENT");
    liste[1] = new Liste("idBatiment",liste1,"nomBatiment","id");
    liste[1].ajouterVide();
    liste[1].setDeroulanteDependante(liste[2],"idbatiment","onchange");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idnumerovague").setLibelle("Num&eacute;ro de vague");
    pi.getFormu().getChamp("idoperateur").setLibelle("Op&eacute;rateur");
    pi.getFormu().getChamp("idlot").setLibelle("Lot");
    pi.getFormu().getChamp("idBatiment").setLibelle("B&acirc;timent");
    pi.getFormu().getChamp("idParquet").setLibelle("Parquet");
    pi.getFormu().getChamp("nombreoac").setLibelle("Nombre OAC");
    pi.getFormu().getChamp("heuredebutfumigation").setLibelle("Heure de d&eacute;but de fumigation");
    pi.getFormu().getChamp("heurefinfumigation").setLibelle("Heure de fin de fumigation");
    pi.getFormu().getChamp("heuredebutextraction").setLibelle("Heure de d&eacute;but d'extraction");
    pi.getFormu().getChamp("heurefinextraction").setLibelle("Heure de fin d'extraction");
    pi.getFormu().getChamp("idproduit").setLibelle("Produit");
    pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("temperaturemin").setLibelle("Temp&eacute;rature minimale");
    pi.getFormu().getChamp("temperaturemax").setLibelle("Temp&eacute;rature maximale");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idoperateur").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL","id","id");
    pi.getFormu().getChamp("idlot").setPageAppelComplete("ferme.lot.Lot","id","LOT","id","id");
    pi.getFormu().getChamp("idproduit").setPageAppelComplete("produits.Ingredients","id","AS_INGREDIENTS","id","id");
    pi.getFormu().getChamp("heuredebutfumigation").setType("time");
    pi.getFormu().getChamp("heurefinfumigation").setType("time");
    pi.getFormu().getChamp("heuredebutextraction").setType("time");
    pi.getFormu().getChamp("heurefinextraction").setType("time");

    String[] ordre = {"daty","idnumerovague","idoperateur","idlot","idBatiment","idParquet","nombreoac","heuredebutfumigation","heurefinfumigation","heuredebutextraction","heurefinextraction","idproduit","qte","temperaturemin","temperaturemax"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une fumigation");
        pi.getFormu().getChamp("id").setVisible(false);
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

