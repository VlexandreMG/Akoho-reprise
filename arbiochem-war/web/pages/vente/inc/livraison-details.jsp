<%@page import="vente.AsBonDeLivraisonClientFilleCPL"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    AsBonDeLivraisonClientFilleCPL t = new AsBonDeLivraisonClientFilleCPL();
    t.setNomTable("AS_BLCLFILLEGRP_VENTE_CPL_V");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"daty","idproduitlib","quantite","unitelib","id"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idVente='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"Date","Produit", "Quantit&eacute;","Unit&eacute;","ID Bon de livraison"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String lienTableau[] = {pr.getLien() + "?but=bondelivraison-client/bondelivraison-client-fiche.jsp",pr.getLien() };
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);

        AsBonDeLivraisonClientFilleCPL[] liste=(AsBonDeLivraisonClientFilleCPL[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
         {
               %><center><h4>Aucune donne trouvee</h4></center><%
         }

        
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>
