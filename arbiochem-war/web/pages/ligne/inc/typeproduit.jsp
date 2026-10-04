<%-- 
    Document   : ecriture-detail
    Created on : 30 juil. 2024, 15:15:57
    Author     : bruel
--%>

<%@page import="annexe.ProduitLib"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Unite"%>
<%@page import="annexe.Categorie"%>
<%@page import="annexe.Produit"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="produits.IngredientsLib" %>
<%@page import="bean.TypeObjet"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="annexe.TypeProduit"%>


<%
    try{
    TypeProduit t = new TypeProduit();
    t.setNomTable("Type_Produit");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "val", "desce"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idligne ='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"R&eacute;f&eacute;rence", "D&eacute;signation", "Description"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        TypeProduit[] liste=(TypeProduit[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         }else
         {
               %><center><h4>Aucune donne trouvee</h4></center><%
         }

        
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>