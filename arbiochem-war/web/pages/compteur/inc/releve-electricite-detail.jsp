<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="compteur.CompteurElectriciteLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>


<%
    try{
    CompteurElectriciteLib o = new CompteurElectriciteLib();
    o.setNomTable("COMPTEURELECTRICITELIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"idmachinelib", "IdCategorieLib","ancien", "valeur", "ecart", "pu", "montant"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des compteurs electricites");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmere ='"+request.getParameter("id")+"' ORDER BY idmachinelib,id ASC");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=.jsp"};
    String colonneLien[] = {""};
    String valLien[] = {""};
    String varColonneLien[] = {""};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setValeurLien(valLien);
    pr.getTableau().setAttLien(varColonneLien);
    pr.getTableau().setColonneLien(colonneLien);

    String[] libEnteteAffiche = {"Machine","Cat&eacute;gorie","Ancienne index", "Nouvelle index", "&Eacutecart", "Prix unitaire", "Montant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    Map<String,String> lienTab=new HashMap<>();
    lienTab.put("modifier",pr.getLien() + "?but=compteur/releve-electricite-saisie.jsp&acte=update");
    pr.getTableau().setLienClicDroite(lienTab);
%>

<div class="box-body">
    <section class="content">
        <form action="<%=pr.getLien()%>?but=apresMultiple.jsp" method="post" name="paye" id="paye">
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
        </form>
    </section>

</div>
<script>
    function changerDesignation() {
        document.paye.submit();
    }
</script>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>
