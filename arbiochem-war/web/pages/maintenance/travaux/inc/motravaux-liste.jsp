
<%@ page import="stock.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>
<%@ page import="maintenance.travaux.MoTravauxLib" %>
<%@ page import="utils.CalendarUtil" %>
<%@ page import="bean.AdminGen" %>


<%
    try{
        MoTravauxLib t = new MoTravauxLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idPersonnelLib","dureeEstimatif","dureeEstimatifLib","montant"};
        String libEnteteAffiche[] = {"id","Personnel","Dur&eacute;e estimative en (s)","Dur&eacute;e estimative","Montant"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            String idFab = request.getParameter("id");
            pr.setAWhere(" and idTravaux='"+idFab+"'");
            pr.setApres("maintenance/travaux/Travaux-fiche.jsp&id="+idFab+"&tab=inc/motravaux-liste");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
//        pr.getTableauRecap().setLibeEntete(new String[]{"","Nombre","Somme des dur&eacute;es estimatives","Montant total"});
//        String lienTableau[] = {pr.getLien() + "?but=facturefournisseur/facturefournisseur-fiche.jsp"};
//        String colonneLien[] = {"id"};
//        pr.getTableau().setLien(lienTableau);
//        pr.getTableau().setColonneLien(colonneLien);
%>

<div class="box-body">
    <%
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getDataDirecte() != null && pr.getTableau().getDataDirecte().length > 0) {
    %>
    <div id="tableau-wrapper">
        <% out.println(pr.getTableau().getHtml()); %>
    </div>
    <table class="table">
        <tr>
            <td><b>Dur&eacute;e Totale en heure :</b></td>
            <%
                MoTravauxLib[] m = (MoTravauxLib[]) pr.getTableau().getData();
                double somme = m[0].getSommeDuree(m);
            %>
            <td><b><%= CalendarUtil.secondToHMS((long) somme) %></b></td>
        </tr>
        <tr>
            <td><b>Montant Total:</b></td>
            <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(), "montant")) %> Ar</b></td>
        </tr>
    </table>
    <% } else { %>
    <center><h4>Aucune donn&eacute;e trouvee</h4></center>
    <% } %>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

