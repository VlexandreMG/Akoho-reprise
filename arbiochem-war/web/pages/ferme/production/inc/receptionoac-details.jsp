<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.production.ReceptionOACDetailLib" %>

<% try{ 
    ReceptionOACDetailLib o = new ReceptionOACDetailLib();
    o.setNomTable("RECEPTIONOACDETAIL_LIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idLot","idLotLib","idBatimentLib","idParquetLib","idQualiteTriageOeufLib","qterecus"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=ferme/lot/lot-fiche.jsp"};
    String[] colonneLien = {"idLot"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"ID Lot","Lot","B&acirc;timent","Parquet","Qualit&eacute; triage œuf","Quantit&eacute; re&ccedil;ue"};
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

