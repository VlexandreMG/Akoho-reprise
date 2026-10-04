<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="utilisateur.ActionRole" %>
<%@ page import="affichage.Liste" %>
<%@ page import="utilitaire.ConstanteUser" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="lc.Direction" %>

<%
    try{
        ActionRole t = new ActionRole();
        t.setNomTable("ActionRolesLibelle");
        String[] listeCrt = {"id","nomTableObjet","action", "direction","utilisateur","groupetable"};
        String[] listeInt = {};
        String[] libEntete = {"id","nomtableobjet","action", "direction", "utilisateur","groupetable","roleminimum"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Liste des actions r&ocirc;le");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[3];
        Direction liste0 = new Direction();
        liste[0] = new Liste("direction",liste0,"libelledir","libelledir");
        liste[1] = new Liste("action", ConstanteUser.actionParRole, ConstanteUser.actionParRole);
        liste[2] = new Liste("groupeTable", ConstanteUser.listePacquet, ConstanteUser.listePacquet);
        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("nomtableObjet").setLibelle("Nom table");
        pr.getFormu().getChamp("groupetable").setLibelle("Groupe");
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);


        String lienTableau[] = {pr.getLien() + "?but=role/role-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);

        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        String[] libEnteteAffiche =  {"ID","Nom table","Action", "Direction", "Utilisateur","Groupe","R&ocirc;le minimum"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>