<%@page import="faturefournisseur.DmdAchatFilleLib"%>
<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.DmdAchatFille" %>

<%
    try{
        DmdAchatFilleLib t = new DmdAchatFilleLib();
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"idproduit","designation","quantite","unite"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setAWhere(" AND idmere='"+request.getParameter("id")+"'");
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String[] libEnteteAffiche =  {"Id produit","D&eacute;signation","Quantit&eacute;","Unit&eacute;"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idproduit"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><center><h4>Aucune donne trouv&eacute;e</h4></center><%
    }

%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>