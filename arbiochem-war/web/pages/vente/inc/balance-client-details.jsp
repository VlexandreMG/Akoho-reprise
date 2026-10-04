<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.StatFille" %>


<%
  try{
    StatFille t = new StatFille();
    t.setNomTable("StatFille");
    String listeCrt[] = {"famille", "idclient","idprovince","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] =  {"id", "libelle","qte", "montant"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
      pr.setAWhere(" and famille='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
  <%
    String libEnteteAffiche[] =  {"ID", "Libell&eacute;","Quantit&eacute;",  "Montant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    StatFille[] liste=(StatFille[]) pr.getTableau().getData();
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