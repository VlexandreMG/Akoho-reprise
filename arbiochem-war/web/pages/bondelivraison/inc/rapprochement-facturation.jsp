

<%@page import="faturefournisseur.RapprochementFacturation"%>
<%@ page import="affichage.*" %>

<%
    try {
        String lien = (String) session.getValue("lien");
        RapprochementFacturation t = new RapprochementFacturation();
        t.setNomTable("RAPPROCHEMENT_FFOURNISSEUR");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","produit", "produitLib", "unitelib", "quantite", "qtefacturer","resteAfacturer"};

        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien(lien);
        String id =request.getParameter("id");
        if(id != null) {
            pr.setAWhere(" and numbl='"+id+"'");
        }
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"Id", "ID Produit", "Produit", "Unit&eacute;", "Quantit&eacute;", "Quantit&eacute;  factur&eacute;e", "Reste &agrave; facturer"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
          String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"produit"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        if (pr.getTableau().getHtml() != null) {
            out.println(pr.getTableau().getHtml());
        } else {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
    <div class="box-footer">

    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

