
<%@page import="paie.conge.Absence"%>
<%@page import="paie.conge.CongeDroit"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="utilitaire.Utilitaire"%>
<%@ page import="paie.demande.DemandeJustifications" %>
<%@ page import="mg.cnaps.paie.PaiePersonnelElementpaie" %>
<%@ page import="magasin.MagasinCompte" %>
<%
    try{
        MagasinCompte lv = new MagasinCompte();
        lv.setNomTable("MAGASIN_COMPTE_CPL");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","desce","nomCompte"};
        PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and val='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.setNpp(1000);
        pr.creerObjetPage(libEntete, colSomme);
%>
<div class="box-body">
    <%
        String libEnteteAffiche[] = {"ID","Compte","Libell&eacute; du compte"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        String lienTableau[] = {pr.getLien() + "?but=magasin/magasin-compte-fiche.jsp",pr.getLien() };
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {%>
    <div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>



