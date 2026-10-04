
<%@page import="vente.VenteDetailsLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="remise.RemiseFille" %>
<%@ page import="remise.RemiseFilleLib" %>


<%
    try{
        RemiseFilleLib t = new RemiseFilleLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "remise", "idcategorieclientlib", "idproduitlib", "categorieproduitlib", "idpointlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setNpp(500);
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idremise='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id", "Remise", "Cat&eacute;gorie client", "Produit", "Cat&eacute;gorie produit", "Point"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

        String lienTableau[] = {pr.getLien() + "?but=prevision/prevision-fiche.jsp",pr.getLien() };
        String colonneLien[] = {"idPrevision"};
        String attLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attLien);
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

