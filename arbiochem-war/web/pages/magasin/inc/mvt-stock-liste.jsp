<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="stock.MvtStockLib" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{ 
    MvtStockLib o = new MvtStockLib();
    o.setNomTable("MVTSTOCKLIB");
    String listeCrt[] = {"designation","idMagasin","idTypeMvStock","daty","idCategorieStock"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","designation","idMagasinlib","idVentelib","idTransfertlib","idTypeMvStocklib","idCategorieStockLib","daty","heure","etatlib"};

    String idMagasin = request.getParameter("id");

    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
//    pr.getFormu().getChamp("id").setDefaut("AA");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    if(idMagasin != null){
        pr.setAWhere(" AND IDMAGASIN='"+idMagasin+"'");
    }
    pr.setTitre("mvt-stock-liste");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("magasin/magasin-fiche.jsp&id="+idMagasin+"&tab=inc/mvt-stock-liste");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"Id","D&eacute;signation","Magasin","Vente","Transfert","Type de mouvement","Cat&eacute;gorie de Stock","Date","Heure","&Eacute;tat"};

    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    pr.getTableau().setLienFille("stock/mvtfille-liste.jsp&id=");
%>

<div class="box-body">
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

