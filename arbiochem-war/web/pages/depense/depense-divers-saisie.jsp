<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="depense.DepenseDivers" %>
<%@ page import="depense.DepenseDiversFille" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="prevision.Service" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "depense.DepenseDivers";
    String classeFille = "depense.DepenseDiversFille";
    String nomTableFille = "DEPENSEDIVERSFILLE";
    String colonneMere = "idMere";
    String apres = "depense/depense-divers-fiche.jsp";

    DepenseDivers mere = new DepenseDivers();
    mere.setNomTable("DEPENSEDIVERS");
    DepenseDiversFille fille = new DepenseDiversFille();
    fille.setNomTable("DEPENSEDIVERSFILLE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une D&eacute;pense Divers");

    Liste[] liste = new Liste[3];
    String[] aff0 = {"Ch&egrave;que","Esp&egrave;ce"};
    String[] val0 = {"0001","0002"};
    liste[0] = new Liste("idModepaiement",aff0, val0);
    CategorieIngredient categorieIngredient = new CategorieIngredient();
    categorieIngredient.setNomTable("CATEGORIEINGREDIENTLIB_ACHT");
    //liste[1] = new Liste("idCategorie",categorieIngredient,"val","id");
    liste[1] = new Liste("idSection",new TypeObjet("SECTION_LIB"),"val","id");
    Service departement = new Service();
    departement.setNomTable("departementDivers");
    liste[2] = new Liste("service",departement,"libelle","id");
    liste[2].setDeroulanteDependante(liste[1],"idService","onchange");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("fournisseur").setLibelle("Fournisseur");
    pi.getFormu().getChamp("fournisseur").setDefaut("FRNDIV01");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("idModepaiement").setLibelle("Mode de paiement");
    pi.getFormu().getChamp("compteCheque").setLibelle("Compte ch&egrave;que");
    pi.getFormu().getChamp("compteCheque").setPageAppelComplete("mg.cnaps.compta.ComptaCompte", "compte", "COMPTA_COMPTE");
    pi.getFormu().getChamp("acheteur").setLibelle("Acheteur");
    pi.getFormu().getChamp("idSection").setLibelle("Section");
    pi.getFormu().getChamp("idMagasin").setVisible(false);
    pi.getFormu().getChamp("idCategorie").setVisible(false);
    pi.getFormu().getChamp("etat").setLibelle("&Eacute;tat");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("daty").setAutre("readonly");
    pi.getFormu().getChamp("service").setLibelle("D&eacute;partement");
    pi.getFormu().getChamp("fournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","FOURNISSEUR","","");

    pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
    pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
    pi.getFormufle().getChamp("tva_0").setLibelle("TVA");

    for(int i = 0; i < taille; i++){
        pi.getFormufle().getChamp("quantite_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("pu_"+i).setAutre("onChange='calculerMontant("+i+")'");
        pi.getFormufle().getChamp("tva_"+i).setAutre("onChange='calculerMontant("+i+")'");
    }

    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","id;libelle;pu","idproduit;designation;pu");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMere"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idProduit"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);

    String[] colOrdre = {"id","idMere","idProduit","designation","quantite","pu","tva"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification du D&eacute;pense Divers");
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
        %>
        <div class="col-md-12 cardradius">
            <h3 class="fontinter" style="background: white; padding: 16px; margin-top: 10px; border-radius: 16px;">
                Total : <span id="montanttotal">0</span> Ar
            </h3>
        </div>
        <%
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
    function formatNumber(number) {
        if (isNaN(number)) return '';
        return number.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }

    function calculerMontant(indice) {
        var pu  = parseFloat(document.getElementById('pu_' + indice).value.replace(/\s/g, '')) || 0;
        var qte = parseFloat(document.getElementById('quantite_' + indice).value.replace(/\s/g, '')) || 0;
        var montant = pu * qte;

        mettreAJourTotal();
    }

    function mettreAJourTotal() {
        var val = 0;
        $('input[id^="pu_"]').each(function(index) {
            var puEl  = document.getElementById('pu_' + index);
            var qteEl = document.getElementById('quantite_' + index);
            var tvaEl = document.getElementById('tva_' + index);
            if (puEl && qteEl) {
                var pu  = parseFloat(puEl.value.replace(/\s/g, '')) || 0;
                var qte = parseFloat(qteEl.value.replace(/\s/g, '')) || 0;
                var tva = tvaEl ? (parseFloat(tvaEl.value.replace(/\s/g, '')) || 0) : 0;
                val += pu * qte * (1 + tva / 100);
            }
        });
        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(val));
    }

    $(document).ready(function () {
        mettreAJourTotal();
    });
</script>
<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

