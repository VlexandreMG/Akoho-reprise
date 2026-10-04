<%-- 
    Document   : ecriture-detail
    Created on : 30 juil. 2024, 15:15:57
    Author     : bruel
--%>

<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="stock.MvtStockLib"%>
<%@page import="stock.MvtStock"%>
<%@ page import="stock.MvtStockFilleLib" %>


<%
    try{
        MvtStockFilleLib o = new MvtStockFilleLib();
    o.setNomTable("MVTSTOCKFILLELIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"daty", "idMvtStock","idProduitlib","sortie"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des mouvements de stock non rattach&eacute;es");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idObjet ='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp"};
    String colonneLien[] = {"idMvtStock"};
    String valLien[] = {"idMvtStock"};
    String varColonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setValeurLien(valLien);
    pr.getTableau().setAttLien(varColonneLien);
    pr.getTableau().setColonneLien(colonneLien);

    String[] libEnteteAffiche = {"Date","R&eacute;ference ID Mouvement Stock", "Produit", "Sortie"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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
