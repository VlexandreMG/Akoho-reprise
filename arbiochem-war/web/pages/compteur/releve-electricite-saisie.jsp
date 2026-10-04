<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.ZonedDateTime"%>
<%@page import="java.time.ZoneId"%>
<%@ page import="user.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*"%>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="compteur.CompteurElectricite" %>
<% try{
    UserEJB u = (UserEJB) session.getAttribute("u");
    CompteurElectricite compteur = new CompteurElectricite();
    PageInsert pi = new PageInsert(compteur, request, u);
    pi.setLien((String) session.getAttribute("lien"));

    Ingredients ingredientsConsommable = new Ingredients();
    ingredientsConsommable.setNomTable("AS_INGREDIENTS_ELECTRICITE");
    Liste[] liste = new affichage.Liste[3];
    liste[0] = new Liste("idcategorie", ingredientsConsommable,"libelle","id");
    IngredientMaintenance im= new IngredientMaintenance("AS_INGREDIENT_MACHINE");
    if(request.getParameter("idLigne") != null){
        im.setIdLigne(request.getParameter("idLigne"));
        pi.getFormu().getChamp("idligne").setDefaut(request.getParameter("idLigne"));
    }
    liste[1] = new Liste("idmachine", im, "libelle", "id");
    liste[2] = new Liste("idligne",   new TypeObjet("ligne"), "val", "id");
//    liste[2].setDeroulanteDependante(liste[1],"idligne","onchange");

    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idcategorie").setLibelle("Cat&eacute;gorie");
    pi.getFormu().getChamp("idligne").setLibelle("Ligne");
    pi.getFormu().getChamp("idmagasin").setVisible(false);
    pi.getFormu().getChamp("idmachine").setLibelle("Machine");
//    pi.getFormu().getChamp("idMachine").setVisible(false);
     ZoneId zoneMadagascar = ZoneId.of("Africa/Nairobi");
     ZonedDateTime now = ZonedDateTime.now(zoneMadagascar);
     DateTimeFormatter format = DateTimeFormatter.ofPattern("HH:mm");
     String heureactuel = now.format(format);
    pi.getFormu().getChamp("heure").setDefaut(heureactuel);
    pi.getFormu().getChamp("heure").setType("time");
    pi.getFormu().getChamp("ecart").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("ancien").setAutre("readonly");
    pi.getFormu().getChamp("ancien").setLibelle("Ancienne index");
    pi.getFormu().getChamp("valeur").setLibelle("Nouvelle index");
    pi.getFormu().getChamp("idcategorie").setAutre("onchange=\" loadDefaultValue();\"");
    pi.getFormu().getChamp("idligne").setAutre("onchange=\"loadDefaultValue();dependante(this.value,'idmachine','AS_INGREDIENT_MACHINE','maintenance.ressources.IngredientMaintenance','idligne','id','libelle');\"");
    pi.getFormu().getChamp("idmachine").setAutre("onchange=\"loadDefaultValue();\"");

    String blocage = " tabindex='-1' onkeydown='return false' onmousedown='return false' onpaste='return false' style='pointer-events:none;'";
    String idMere = request.getParameter("idMere");
    if(request.getParameter("idMere")!= null && request.getParameter("idLigne") != null) {
        pi.getFormu().getChamp("idmere").setDefaut(idMere);
        pi.getFormu().getChamp("idligne").setAutre("readonly "+blocage);
        pi.getFormu().getChamp("idmere").setAutre("readonly "+blocage);
        pi.getFormu().getChamp("idmere").setLibelle("R&eacute;f&eacute;rence");
    }

    String[] formOrder={"daty","idcategorie","ancien"};
    pi.getFormu().setOrdre(formOrder);
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1 class="box-title">Saisie d'un relev&eacute;</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="appro" id="appro" >
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="acte" value="insert">
        <input name="bute" type="hidden" id="bute" value="compteur/releve-electricite-multiple-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="compteur.CompteurElectricite">
        <input name="nomtable" type="hidden" id="nomtable" value="CompteurElectricite">
    </form>
</div>

<style>
    .form-input[hidden] {
        display: none !important;
    }
</style>

<script>
    function displayIdTranche() {
        const idCategorie = document.getElementById("idcategorie");
        const idTranche = document.getElementById("idTranche");
        if (!idCategorie || !idTranche) return;
        let blocTranche = idTranche.closest(".form-input");
        if (!blocTranche) return;

        const isElectricite = idCategorie.value === "<%=ConstanteMaintenance.CATEGORIE_ELECTRICITE%>";
        blocTranche.hidden = !isElectricite;
    }

    async function loadDefaultValue() {
        const idLigne     = document.getElementById("idligne").value.trim();
        const idCategorie = document.getElementById("idcategorie").value.trim();
        const idMachine = document.getElementById("idmachine").value.trim();
        if (!idLigne || !idCategorie) {
            return;
        }
        const url = "<%=request.getContextPath()%>/CompteurElectriciteServlet?idLigne=" + encodeURIComponent(idLigne) + "&idCategorie=" + encodeURIComponent(idCategorie)+"&idMachine="+encodeURIComponent(idMachine);
        try {
            const response = await fetch(url);
            if (!response.ok) {
                const err = await response.json();
                alert("Erreur : " + err.error);
                return;
            }
            const result = await response.json();
            document.getElementById("ancien").value = result.valeur ?? 0;
        } catch (error) {
            console.error("Erreur inattendu :", error);
        }
    }

    window.addEventListener("load", function () {
        displayIdTranche();
        loadDefaultValue();
    });
</script>
<%} catch (Exception e) {
    e.printStackTrace(); %>
    <script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>
