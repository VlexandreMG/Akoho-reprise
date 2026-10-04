<%@page import="stock.TransfertStockDetailsCpl"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="demande.DemandeTransfertFilleCpl" %>

<%
    try{
        DemandeTransfertFilleCpl t = new DemandeTransfertFilleCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","idProduit","idProduitLib","quantite", "pu"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and iddemandetransfert='"+request.getParameter("id")+"' ");
        }

//        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
//        String colonneLien[] = {"idProduit"};
//        pr.getTableau().setLien(lienTableau);
//        pr.getTableau().setColonneLien(colonneLien);

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idProduit"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"ID","ID Produit", "D&eacute;signation", "quantit&eacute;", "Prix unitaire"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPageOnglet());
        }else
        {
    %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>


