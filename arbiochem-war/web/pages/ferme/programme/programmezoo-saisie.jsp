<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.programme.ProgrammeZootechnique" %>
<%@ page import="ferme.programme.ProgrammeZootechniqueDetails" %>
<%@ page import="affichage.Champ" %>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.programme.ProgrammeZootechnique";
    String classeFille = "ferme.programme.ProgrammeZootechniqueDetails";
    String nomTableFille = "PROGRAMMEZOOTECHNIQUEDETAILS";
    String colonneMere = "idmere";
    String apres = "ferme/programme/programmezoo-fiche.jsp";

    ProgrammeZootechnique mere = new ProgrammeZootechnique();
    mere.setNomTable("PROGRAMMEZOOTECHNIQUE");
    ProgrammeZootechniqueDetails fille = new ProgrammeZootechniqueDetails();
    fille.setNomTable("PROGRAMMEZOOTECHNIQUEDETAILS");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une programme zoo technique");


    pi.getFormu().getChamp("code").setLibelle("Code");
    pi.getFormu().getChamp("idsouche").setLibelle("Souche");
    pi.getFormu().getChamp("version").setLibelle("Version");
    pi.getFormu().getChamp("daty").setLibelle("Date de validit&eacute;");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idsouche").setPageAppelComplete("ferme.configuration.Souche","id","SOUCHE","","");


    pi.getFormufle().getChamp("age_0").setLibelle("&Acirc;ge");
    pi.getFormufle().getChamp("idsexe_0").setLibelle("Sexe");
    pi.getFormufle().getChamp("aliment_0").setLibelle("Aliment (t&ecirc;te/g/j)");
    pi.getFormufle().getChamp("poids_0").setLibelle("Poids (g)");
    pi.getFormufle().getChamp("mortalite_0").setLibelle("Mortalit&eacute; (%)");
    pi.getFormufle().getChamp("pontehebdomadaire_0").setLibelle("Ponte Hebdomadaire (%)");
    pi.getFormufle().getChamp("pontecumulee_0").setLibelle("Ponte Cumul&eacute;e");
    pi.getFormufle().getChamp("oeufcumule_0").setLibelle("Œuf cumul&eacute;");
    pi.getFormufle().getChamp("oacpourcentage_0").setLibelle("OAC (%)");
    pi.getFormufle().getChamp("oachh_0").setLibelle("OAC / HH");
    pi.getFormufle().getChamp("poidsoeuf_0").setLibelle("Poids de l’ œuf");
    pi.getFormufle().getChamp("tauxeclosion_0").setLibelle("Taux d'&eacute;closion");
    pi.getFormufle().getChamp("poussins_0").setLibelle("Poussins / HH");
    pi.getFormufle().getChamp("consoalimentfemelle_0").setLibelle("Consommation d’aliment Femelle (g)");
    pi.getFormufle().getChamp("consoalimentmale_0").setLibelle("Consommation d’aliment M&acirc;le (g)");
    pi.getFormufle().getChamp("femellebw_0").setLibelle("Femelle BW (g)");
    pi.getFormufle().getChamp("malebw_0").setLibelle("M&acirc;le BW (g)");
    pi.getFormufle().getChamp("ratioproduction_0").setLibelle("Ratio de production");
    pi.getFormufle().getChamp("fertilite_0").setLibelle("Fertilit&eacute;");
    pi.getFormufle().getChamp("consommationEau_0").setLibelle("Consommation en Eau");
    pi.getFormufle().getChamp("temperatureMin_0").setLibelle("Temp&Eacute;rature min");
    pi.getFormufle().getChamp("temperatureMax_0").setLibelle("Temp&eacute;rature max");
    pi.getFormufle().getChamp("humiditeMin_0").setLibelle("Humidit&eacute; min");
    pi.getFormufle().getChamp("humiditeMax_0").setLibelle("Humidit&eacute; max");
    pi.getFormufle().getChamp("dureeEclairage_0").setLibelle("Dur&eacute;e &eacute;clairage");
    pi.getFormufle().getChamp("uniformiteCible_0").setLibelle("Uniformit&eacute; cible");
    pi.getFormufle().getChamp("cvMax_0").setLibelle("CV Max");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);

    affichage.Liste[] listef = new Liste[1];
    TypeObjet sexe=new TypeObjet();
    sexe.setNomTable("SEXE");
    listef[0]=new Liste("idsexe",sexe,"val","id");
    pi.getFormufle().changerEnChamp(listef);
    pi.getFormufle().getChamp("idsexe_0").setLibelle("Sexe");
    //Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idsexe"),"bean.TypeObjet","id","SEXE","id","id");

    String[] colOrdre = {"id", "age","idsexe","aliment","poids","mortalite","pontehebdomadaire","pontecumulee","oeufcumule","oacpourcentage","oachh","poidsoeuf","tauxeclosion","poussins","consoalimentfemelle","consoalimentmale","femellebw","malebw","ratioproduction","fertilite","consommationEau","temperatureMin","temperatureMax","humiditeMin","humiditeMax","dureeEclairage","uniformiteCible","cvMax"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une programme zoo technique");
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

