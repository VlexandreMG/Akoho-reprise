<%@page import="maintenance.planning.DemandeTravauxCpl"%>
<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<%@ page import="piece.PieceMachineLib" %>
<% try{
    PieceMachineLib t = new PieceMachineLib();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idPiece", "idPieceLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idMachine='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().transformerDataString();
    String[] lienTableau = {pr.getLien() + "?but=maintenance/ressources/outils/outils-fiche.jsp"};
    String[] colonneLien = {"idPiece"};
    String[] attLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attLien);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"ID", "Pi&egrave;ce"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }
%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

