<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ferme.pesee.PeseePoussin" %>
<%@ page import="ferme.pesee.PeseePoussinDetail" %>
<%@ page import="affichage.Champ" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="ferme.configuration.ParquetBatiment" %>
<%@ page import="ferme.configuration.Batiment" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="ferme.utils.ConfigPoids" %>
<%@ page import="affichage.PageRecherche" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "ferme.pesee.PeseePoussin";
    String classeFille = "ferme.pesee.PeseePoussinDetail";
    String nomTableFille = "PESEEPOUSSINDETAIL";
    String colonneMere = "idmere";
    String apres = "ferme/pesee/peseepoussin-fiche.jsp";

    ConfigPoids cp = new ConfigPoids();
    String[] listeCrt = {"poidsmin","poidsmax","pas"};
    String[] listeInt = {};
    String[] libEntete = {"poidsmin","poidsmax","pas"};
    PageRecherche pr = new PageRecherche(cp, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/pesee/peseepoussin-saisie.jsp");
    pr.getFormu().getChamp("poidsmin").setLibelle("Poids min");
    pr.getFormu().getChamp("poidsmax").setLibelle("Poids max");
    pr.getFormu().getChamp("pas").setLibelle("Pas");
    String[] colSomme = null;
    pr.setNpp(9999);
    pr.creerObjetPage(libEntete, colSomme);
    String[] libEnteteAffiche = {"Poids min","Poids max","Pas"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String poidsMax = request.getParameter("poidsmax");
    String poidsMin = request.getParameter("poidsmin");
    String pas = request.getParameter("pas");
    PeseePoussinDetail[] poussinDetails = null;

    PeseePoussin mere = new PeseePoussin();
    mere.setNomTable("PESEEPOUSSIN");
    PeseePoussinDetail fille = new PeseePoussinDetail();
    fille.setNomTable("PESEEPOUSSINDETAIL");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie pesee poussin");

    if (poidsMax != null && poidsMin != null && pas != null){
        ConfigPoids[] configPoids = cp.genererPlagePoids(Double.parseDouble(poidsMin), Double.parseDouble(poidsMax), Double.parseDouble(pas));
        poussinDetails = mere.transformerToDetail(configPoids);
        taille = poussinDetails.length;
        pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setDefautFille(poussinDetails);
    }

    Liste[] liste = new Liste[5];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("TYPEPESEE");
    liste[0] = new Liste("idtypepesee",liste0,"val","id");
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("SEXE");
    liste[1] = new Liste("idsexe",liste1,"val","id");
    ParquetBatiment parquet = new ParquetBatiment();
    liste[3] = new Liste("idparquet", parquet, "val", "id");
    liste[2] = new Liste("idbatiment", new Batiment(), "nomBatiment", "id");
    liste[2].ajouterVide();
    liste[2].setDeroulanteDependante(liste[3],"idbatiment","onchange");
    liste[4] = new Liste("idferme", new Magasin(), "val", "id");
    liste[4].setDeroulanteDependante(liste[2], "idferme","onchange");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("datepesee").setLibelle("Date de pes&eacute;e");
    pi.getFormu().getChamp("idtypepesee").setLibelle("Type de pes&eacute;e");
    pi.getFormu().getChamp("idresponsable").setLibelle("Responsable");
    pi.getFormu().getChamp("idferme").setLibelle("Ferme");
    pi.getFormu().getChamp("idbatiment").setLibelle("B&acirc;timent");
    pi.getFormu().getChamp("idlot").setLibelle("Lot");
    pi.getFormu().getChamp("idparquet").setLibelle("Parquet");
    pi.getFormu().getChamp("idsexe").setLibelle("Sexe");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idresponsable").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL","id","id");
//    pi.getFormu().getChamp("idferme").setPageAppelComplete("magasin.Magasin","id","MAGASIN2","id","id");
    pi.getFormu().getChamp("idbatiment").setPageAppelComplete("ferme.configuration.Batiment","id","BATIMENT","id","id");
    pi.getFormu().getChamp("idlot").setPageAppelComplete("ferme.lot.Lot","id","LOT","id","id");
    pi.getFormu().getChamp("idparquet").setPageAppelComplete("ferme.configuration.Parquet","id","PARQUET","id","id");


    pi.getFormufle().getChamp("poids_0").setLibelle("Poids");
    pi.getFormufle().getChamp("nombreoiseaux_0").setLibelle("Nombre oiseaux");
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);

    String[] colOrdre = {"poids","nombreoiseaux"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification pesee poussin");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const exportBtn = document.querySelector('[data-target="#exporter"]'); // Cacher le bouton Exporter
        if (exportBtn) {
            const wrapper = exportBtn.closest(".d-flex");
            (wrapper || exportBtn).style.display = "none";
        }
        const motsCles = document.querySelector(".mots-cless"); // Cacher le bloc mots-clés
        if (motsCles) {
            motsCles.style.display = "none";
        }
    });
</script>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
        <%
            out.println(pr.getFormu().getHtmlEnsemble());
        %>
    </form>
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

