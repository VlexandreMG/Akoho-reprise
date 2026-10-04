<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="compteur.CompteurElectriciteMere" %>
<%@ page import="compteur.CompteurElectricite" %>
<%@ page import="machine.Ligne" %>
<%@ page import="machine.Machine" %>
<%@ page import="affichage.Liste" %>
<%@ page import="affichage.Champ" %>
<%@ page import="produits.Ingredients" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "compteur.CompteurElectriciteMere";
    String classeFille = "compteur.CompteurElectricite";
    String nomTableFille = "COMPTEURELECTRICITE";
    String colonneMere = "idmere";
    String apres = "compteur/releve-electricite-multiple-fiche.jsp";

    CompteurElectriciteMere mere = new CompteurElectriciteMere();
    mere.setNomTable("COMPTEURELECTRICITEMERE");
    CompteurElectricite fille = new CompteurElectricite();
    fille.setNomTable("COMPTEURELECTRICITE");
    int taille = 1;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie de compteur Electricite");
    Liste[] liste = new Liste[1];
    Ligne liste0 = new Ligne();
    liste0.setNomTable("LIGNE");
    liste[0] = new Liste("ligne",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("ligne").setLibelle("Ligne");
    pi.getFormu().getChamp("remarque").setVisible(false);
    pi.getFormu().getChamp("remarque").setDefaut("init");
    pi.getFormu().getChamp("etat").setVisible(false);

    Liste[] listeFille = new Liste[2];
    Ingredients ingredientMachine = new Ingredients();
    ingredientMachine.setNomTable("AS_INGREDIENT_MACHINE");
    listeFille[0] = new Liste("idmachine", ingredientMachine,"libelle","id");

    Ingredients ingredientsConsommable = new Ingredients();
    ingredientsConsommable.setNomTable("AS_INGREDIENTS_ELECTRICITE");
    listeFille[1] = new Liste("idcategorie", ingredientsConsommable,"libelle","id");


    pi.getFormufle().changerEnChamp(listeFille);

    pi.getFormufle().getChamp("ancien_0").setLibelle("Ancienne Index");
    pi.getFormufle().getChamp("idcategorie_0").setLibelle("Cat&eacute;gorie");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure");
    pi.getFormufle().getChamp("valeur_0").setLibelle("Nouvelle index");
    for(int i=0;i<taille;i++){
        pi.getFormufle().getChamp("heure_"+i).setType("time");
        pi.getFormufle().getChamp("remarque_"+i).setVisible(false);
        pi.getFormufle().getChamp("remarque_"+i).setDefaut("init");
    }
    pi.getFormufle().getChamp("idmachine_0").setLibelle("Machine");
    Champ.setVisible(pi.getFormufle().getChampMulitple("daty").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("idligne").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("ecart").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmagasin").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("etat").getListeChamp(),false);
    Champ.setAutre(pi.getFormufle().getChampMulitple("ancien").getListeChamp(),"readOnly");
    Champ.setAutre(pi.getFormufle().getChampMulitple("idmachine").getListeChamp(),"onchange=loadDefaultValue()");

    String[] colOrdre = {"idmachine", "idcategorie" ,"ancien","valeur","remarque","heure"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification de compteur Electricite");
        String blocage = " tabindex='-1' onkeydown='return false' onmousedown='return false' onpaste='return false' style='pointer-events:none;'";
        pi.getFormu().getChamp("daty").setAutre("readonly" + blocage);
        pi.getFormu().getChamp("ligne").setAutre(blocage);
    }
    String appelDependante = "dependanteMultiple(valeurLigne,'" + listeFille[0].getNom() + "','"
            + ingredientMachine.getNomTable() + "','" + ingredientMachine.getClass().getName() + "','idligne','"
            + listeFille[0].getColValeur() + "','" + listeFille[0].getColAffiche() + "')";
    Champ champLigne = pi.getFormu().getChamp("ligne");
    String autreLigne = champLigne.getAutre() == null ? "" : champLigne.getAutre();
    champLigne.setAutre(autreLigne + " onchange=\"var valeurLigne=this.value;" + appelDependante + ";\"loadDefaultValue();");

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

<script>

    async function loadDefaultValue() {
        const idLigne     = document.getElementById("ligne").value.trim();
        const idMachine = document.getElementById("idmachine_0").value.trim();
        if (!idLigne || !idMachine) {
            return;
        }
        const url = "<%=request.getContextPath()%>/CompteurElectriciteServlet?idLigne=" + encodeURIComponent(idLigne) + "&idMachine=" + encodeURIComponent(idMachine);
        try {
            const response = await fetch(url);
            if (!response.ok) {
                const err = await response.json();
                alert("Erreur : " + err.error);
                return;
            }
            const result = await response.json();
            console.log(result)
            document.getElementById("ancien_0").value = result.valeur ?? 0;
        } catch (error) {
            console.error("Erreur inattendu :", error);
        }
    }

    window.addEventListener('load', function () {
        var champLigne = document.getElementById('ligne');
        if (!champLigne || typeof dependanteMultiple !== 'function') {
            return;
        }
        var valeurLigne = champLigne.value;
    <%=appelDependante%>
    loadDefaultValue();
});

</script>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

