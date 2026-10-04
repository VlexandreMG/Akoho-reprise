<%@page import="maintenance.planning.DemandeTravauxCpl"%>
<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<% try{
    DemandeTravauxCpl t = new DemandeTravauxCpl();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","description","daty","dateBesoin","idMachineLib","idSituationLib","idDepartementLib","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmachine='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().transformerDataString();
    String[] lienTableau = {pr.getLien() + "?but=maintenance/demandetravaux/demandetravaux-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"ID","Description","Date","Date de besoin","&Eacute;l&eacute;ment","Situation","D&eacute;partement","&Eacute;tat"};
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

