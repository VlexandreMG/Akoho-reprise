<%-- 
    Document   : classe-saisie.jsp
    Created on : 17 juin 2024, 15:32:16
    Author     : Mirado
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="annexe.Unite"%>
<%@page import="magasin.Magasin"%>
<%@page import="faturefournisseur.*"%>
<%@page import="user.*"%> 
<%@page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="annexe.Point" %>

<%
    try{
    String numbl = request.getParameter("id");
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    As_BonDeLivraison mere = new As_BonDeLivraison();   
    As_BonDeLivraison_Fille_Cpl fille = new As_BonDeLivraison_Fille_Cpl();
    fille.setNumbl(numbl);
    fille.setNomTable("AS_BONDELIVRAISON_LIBCPL");
    int nombreLigne = 10;
    As_BonDeLivraison_Fille_Cpl[] details = (As_BonDeLivraison_Fille_Cpl[]) CGenUtil.rechercher(fille,null,null," and numbl='"+numbl+"' ");
    PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, u, 2);       
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("remarque").setLibelle("Remarques");
    pi.getFormu().getChamp("idbc").setAutre("readonly");
    pi.getFormu().getChamp("idbc").setLibelle("Num. Bon de commande associ&eacute;");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
    pi.getFormu().getChamp("idFactureFournisseur").setLibelle("Num. de facture du fournisseur");
    pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","fournisseur");
    pi.getFormu().getChamp("etat").setVisible(false);
    affichage.Liste[] liste = new Liste[1];
    Point mg = new Point();
    liste[0] = new Liste("magasin",mg,"val","id");
    pi.getFormu().changerEnChamp(liste);

    for (int idx = 0; idx < details.length; idx++) {
             pi.getFormufle().getChamp("id_"+idx).setDefaut(details[idx].getId());
             pi.getFormufle().getChamp("produit_"+idx).setDefaut(details[idx].getProduit());
             pi.getFormufle().getChamp("numbl_"+idx).setDefaut(details[idx].getProduit());
             pi.getFormufle().getChamp("quantite_"+idx).setDefaut(""+details[idx].getQuantite()); 
             pi.getFormufle().getChamp("iddetailsfacturefournisseur_"+idx).setDefaut(""+details[idx].getIddetailsfacturefournisseur()); 
             pi.getFormufle().getChamp("unite_"+idx).setDefaut(""+details[idx].getUnite()); 
             pi.getFormufle().getChamp("unitelib_"+idx).setAutre("readonly");
             pi.getFormufle().getChamp("produitlib_"+idx).setDefaut(""+details[idx].getProduitlib());
             pi.getFormufle().getChamp("produitlib_"+idx).setAutre("readonly");
             pi.getFormufle().getChamp("iddetailsfacturefournisseur_"+idx).setAutre("readonly");
             pi.getFormufle().getChamp("idbc_fille_"+idx).setDefaut(""+details[idx].getIdbc_fille());
    }
    
/*    
    affichage.Liste[] listef = new Liste[1];
    Unite unitf=new Unite();
    listef[0]=new Liste("unite",unitf,"val","id");
    pi.getFormufle().changerEnChamp(listef);
*/    
    pi.getFormufle().getChamp("produit_0").setLibelle("Produits");
    pi.getFormufle().getChamp("unitelib_0").setLibelle("Unit&eacute;");
    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
    pi.getFormufle().getChamp("iddetailsfacturefournisseur_0").setLibelle("facture fournisseur");
    pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
    pi.getFormufle().getChamp("tauxdechange_0").setLibelle("Taux de change");
    
  affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("numbl"),false);
    affichage.Champ.setAutre(pi.getFormufle().getChampFille("designation"),"readonly");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("produitlib"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("unitelib"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("unite"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idbc_fille"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("iddetailsfacturefournisseur"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("pu"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("tauxdechange"),false);
       affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("produit"),"annexe.ProduitLib","id" , "Produit_LIB", "id;idUnite;idUniteLib;val", "produit;unite;unitelib;designation");
    String[] order_form = {"daty","remarque","idbc","idFournisseur","magasin","idFactureFournisseur","etat"};
    pi.getFormu().setOrdre(order_form);
    pi.preparerDataFormu();
    
    String[] order ={"produit", "designation","quantite","pu","tauxdechange"};
    pi.getFormufle().setColOrdre(order);

    //Variables de navigation
    String classeMere = "faturefournisseur.As_BonDeLivraison";
    String classeFille = "faturefournisseur.As_BonDeLivraison_Fille";
    String butApresPost = "bondelivraison/bondelivraison-fiche.jsp";
    String colonneMere = "numbl";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
       
%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1>Modification de bon de réception</h1>
    <!--  -->
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp&id=<%= request.getParameter("id") %>" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        
        <input name="acte" type="hidden" id="nature" value="updateInsert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= pi.getNombreLigne() %>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>
        
</div>

<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>


