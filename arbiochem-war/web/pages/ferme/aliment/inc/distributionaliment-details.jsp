<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.aliment.DistributionAlimentDetailLib" %>

<% try{
    DistributionAlimentDetailLib o = new DistributionAlimentDetailLib();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idBatimentLib","idParquetlib","idAlimentLib","idLotStock","qte","rationParTete"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp"};
    String colonneLien[] = {"idLotStock"};
    String attLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attLien);
    pr.getTableau().setColonneLien(colonneLien);
    String[] libEnteteAffiche = {"Batiment","Parquet","Aliment","ID Lot Stock","Quantit&eacute;","Ration par t&ecirc;te"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        } else{ %>
            <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

