<%@page import="faturefournisseur.DmdAchatFilleLib"%>
<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.PlanCommande" %>

<%
    try{
        PlanCommande pc = new PlanCommande();

        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"idproduit","designation","quantite","daty"};
        PageRecherche pr = new PageRecherche(pc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setAWhere(" AND idDmdAchat='"+request.getParameter("id")+"'");
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;

        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String[] libEnteteAffiche =  {"Id produit","D&eacute;signation","Quantit&eacute;", "Date"};

        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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