<%--
    Document   : as-commande-analyse
    Created on : 30 d�c. 2016, 04:57:15
    Author     : Joe
--%>
<%@page import="faturefournisseur.*"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="paie.analyse.SumHsDay" %>
<%@ page import="paie.analyse.ViewVideFiltre" %>
<%@ page import="paie.analyse.SumHsMonth" %>
<%@ page import="paie.analyse.SumHsYear" %>


<%
    try{

        // CHAMP FILTRE
        ViewVideFiltre t = new ViewVideFiltre();
        String listeCrt1[] = {"idDepartement", "idTypeSomme"};
        String listeInt1[] = {};
        String libEntete1[] = {};
        PageRecherche prF = new PageRecherche(t, request, listeCrt1, listeInt1, 3, libEntete1, libEntete1.length);
        prF.setUtilisateur((user.UserEJB) session.getValue("u"));
        prF.setLien((String) session.getValue("lien"));
        prF.setApres("paie/employe/analyse/somme-hs.jsp");

        Liste[] dropDowns = new Liste[2];
        dropDowns[0] = new Liste("idTypeSomme", new TypeObjet("TYPESOMME"), "val", "id");
        dropDowns[1] = new Liste("idDepartement", new TypeObjet("DEPARTEMENT"), "val", "id");
        prF.getFormu().changerEnChamp(dropDowns);
        prF.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement");
        prF.getFormu().getChamp("idTypeSomme").setLibelle("Type de somme");

        String[] colSomme1 = null;
        prF.creerObjetPage(libEntete1, colSomme1);

        // Récupérer les dates pour le graphique
        String dateDebutParam = request.getParameter("dateDebut");
        String dateFinParam = request.getParameter("dateFin");
        if(dateDebutParam == null) dateDebutParam = "";
        if(dateFinParam == null) dateFinParam = "";
        /// ///////////////////

        PageRechercheGroupe pr = null;

        String idTypeSomme = request.getParameter("idTypeSomme");
        System.out.println("idTYpeSomme = " + idTypeSomme);
        if (idTypeSomme == null || idTypeSomme.trim().isEmpty() || idTypeSomme.equalsIgnoreCase("%")) {
            idTypeSomme = "TS1";
            prF.getFormu().getChamp("idTypeSomme").setDefaut("TS1");
        }

        String idDepartement = request.getParameter("idDepartement");

        if (idTypeSomme.equalsIgnoreCase("TS1")) { // par jour
            SumHsDay mvt = new SumHsDay();
            String listeCrt[] = {};
            String listeInt[] = {};
            String[] pourcentage = {};
            String[] colGr = {"departementLib"};
            String[] colGrCol = {"jour"};
            String somDefaut[] = {"avg_hs_per_day"};

            pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
            pr.setLien((String) session.getValue("lien"));

            if (idDepartement != null && !idDepartement.trim().isEmpty() && !idDepartement.equalsIgnoreCase("%")) {
                pr.setAWhere("and idDepartement = '" + idDepartement + "'");
            }

            pr.setUtilisateur((user.UserEJB) session.getValue("u"));

            pr.setNpp(500);
            pr.setApres("paie/employe/analyse/somme-hs.jsp");

            pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=paie/employe/analyse/somme-hs.jsp");
        } else if (idTypeSomme.equalsIgnoreCase("TS2")) { // par mois
            SumHsMonth mvt = new SumHsMonth();
            String listeCrt[] = {};
            String listeInt[] = {};
            String[] pourcentage = {};
            String[] colGr = {"departementLib"};
            String[] colGrCol = {"monthLib"};
            String somDefaut[] = {"avg_hs_per_month"};

            pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
            pr.setLien((String) session.getValue("lien"));

            if (idDepartement != null && !idDepartement.trim().isEmpty() && !idDepartement.equalsIgnoreCase("%")) {
                pr.setAWhere("and idDepartement = '" + idDepartement + "'");
            }

            pr.setUtilisateur((user.UserEJB) session.getValue("u"));

            pr.setNpp(500);
            pr.setApres("paie/employe/analyse/somme-hs.jsp");

            pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=paie/employe/analyse/somme-hs.jsp");
        } else if (idTypeSomme.equalsIgnoreCase("TS3")) { // par annee
            SumHsYear mvt = new SumHsYear();
            String listeCrt[] = {};
            String listeInt[] = {};
            String[] pourcentage = {};
            String[] colGr = {"departementLib"};
            String[] colGrCol = {"annee"};
            String somDefaut[] = {"avg_hs_per_year"};

            pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
            pr.setLien((String) session.getValue("lien"));

            if (idDepartement != null && !idDepartement.trim().isEmpty() && !idDepartement.equalsIgnoreCase("%")) {
                pr.setAWhere("and idDepartement = '" + idDepartement + "'");
            }

            pr.setUtilisateur((user.UserEJB) session.getValue("u"));

            pr.setNpp(500);
            pr.setApres("paie/employe/analyse/somme-hs.jsp");

            pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=paie/employe/analyse/somme-hs.jsp");
        }


%>
<script>
    function changerDesignation() {
        document.analyse.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Analyse somme HS</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/employe/analyse/somme-hs.jsp" method="post" name="analyse" id="analyse">
            <%out.println(prF.getFormu().getHtmlEnsemble());%>

            <!-- Champs de dates pour le graphique -->
            <div class="row d-flex" style="align-items: end">
                <div class="col-md-4">
                    <div class="form-input w-100">
                        <label for="dateDebut">Date d&eacute;but</label>
                        <input type="date" class="form-control" name="dateDebut" id="dateDebut" value="<%= dateDebutParam %>">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-input w-100">
                        <label for="dateFin">Date fin</label>
                        <input type="date" class="form-control" name="dateFin" id="dateFin" value="<%= dateFinParam %>">
                    </div>
                </div>
                <button type="submit" class="btn btn-secondary btn-small btn-bg-white">
                    <i class="material-symbols-rounded">refresh</i> Actualiser graphique
                </button>
            </div>
        </form>

        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>

        <!-- Inclusion du graphique des heures supplémentaires -->
        <div style="margin-top: 30px;">
            <jsp:include page="inc/hs-graphe.jsp" flush="true">
                <jsp:param name="dateDebut" value="<%= dateDebutParam != null ? dateDebutParam : \"\" %>" />
                <jsp:param name="dateFin" value="<%= dateFinParam != null ? dateFinParam : \"\" %>" />
                <jsp:param name="idDepartement" value="<%= idDepartement != null ? idDepartement : \"\" %>" />
            </jsp:include>
        </div>
    </section>
</div>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>