<%@page import="vente.CaJournalier"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.util.Map" %>
<%@page import="affichage.*"%>

<% try{
    CaJournalier f = new CaJournalier();
    f.setNomTable("CA_MENSUEL");
    String listeCrt[] = {"annee","mois"};
    String listeInt[] = {"mois"};
    String libEntete[] = {"annee","moislib","montant"};
    PageRecherche pr = new PageRecherche(f, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste ca mensuel");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/analyse/camensuel.jsp");

    //pr.getFormu().getChamp("annee1").setLibelle("Annee min");
//    pr.getFormu().getChamp("daty1").setLibelle("Date min");
//    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    affichage.Champ[] liste = new affichage.Champ[2];
    Liste listeMois = new Liste("mois1");
    listeMois.makeListeMois();
    liste[0] = listeMois;

    Liste listeMois2 = new Liste("mois2");
    listeMois2.makeListeMois();
    liste[1] = listeMois2;

    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("mois1").setLibelle("mois min");
    pr.getFormu().getChamp("mois2").setLibelle("mois max");
    pr.getFormu().getChamp("annee").setLibelle("ann&eacute;e");
    pr.getFormu().getChamp("annee").setDefaut(Utilitaire.getAnneeEnCours());
    // pr.getFormu().getChamp("mois").setDefaut(Utilitaire.getMoisEnCoursReel()+"");
    //pr.getFormu().getChamp("mois").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = {"montant"};
    pr.creerObjetPage(libEntete, colSomme);
    String enteteRecap[] = {"","Nombre","Somme des montants"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    String libEnteteAffiche[] = {"Ann&eacute;e","Mois","Montant"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    // Filtre par année
    String annee = Utilitaire.getAnneeEnCours();
    if (request.getParameter("annee") != null && !request.getParameter("annee").isEmpty()) {
        annee = request.getParameter("annee");
    }
    pr.setAWhere(" and annee = '"+ annee+"'");
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <%-- Filtre année --%>
        <div class="cardradius" style="margin-bottom: 20px;">
            <form action="<%=(String)session.getAttribute("lien") %>?but=vente/analyse/camensuel.jsp" method="post">
                <div class="d-flex" style="align-items: end;gap: 8px">
                    <div class="col-md-2 nopadding">
                        <label for="anneeFiltre" class="form-label">Ann&eacute;e</label>
                        <input type="number" id="anneeFiltre" name="annee" class="form-control"
                               value="<%= (request.getParameter("annee") != null && !request.getParameter("annee").isEmpty())
                                ? request.getParameter("annee")
                                : Utilitaire.getAnneeEnCours() %>">
                    </div>
                    <div class="col-md-2 nopadding d-flex align-items-end">
                        <button type="submit" class="btn btn-primary btn-small" style="padding: 6px 16px;">Appliquer</button>
                    </div>
                </div>
            </form>
        </div>
        <%--        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">--%>
        <%--            <%--%>
        <%--                out.println(pr.getFormu().getHtmlEnsemble());--%>
        <%--            %>--%>
        <%--        </form>--%>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>

        <%
            }catch(Exception e){

                e.printStackTrace();
            }
        %>

        <%
            // Utiliser le même paramètre annee pour le graphique
            String anneeGrapheParam = request.getParameter("annee");
            if (anneeGrapheParam == null || anneeGrapheParam.isEmpty()) {
                anneeGrapheParam = Utilitaire.getAnneeEnCours();
            }

            int anneeGraphe = Integer.parseInt(anneeGrapheParam);
            int moisGraphe = 0;

            Map<String, Double> caMensuel = vente.GrapheCaJournalier.getDataChartCaMensuel(anneeGraphe);
        %>


        <%
            String[] moisNoms = new java.text.DateFormatSymbols(java.util.Locale.FRENCH).getMonths();
            String moisNom = (moisGraphe > 0) ? moisNoms[moisGraphe - 1] : "";
        %>

        <div class="cardradius">
            <div class="card-body">
                <canvas id="c_ca_journalier"></canvas>
                <h5 class="card-title text-center">
                    CA mensuel (Ann&eacute;e <%= anneeGraphe %>)
                </h5>
            </div>
        </div>

        <%
            affichage.Graphe g = new affichage.Graphe(new Map[]{caMensuel}, "CA",
                    new String[]{""}, new String[]{""}, "c_ca_journalier", "");
            g.setTypeGraphe("bar"); // courbe
            g.setCouleurs(utils.ConstanteAsync.couleurs);
            g.setBgCouleurs(utils.ConstanteAsync.couleurs);
            out.println(g.getHtml("ctx_caj"));
        %>

    </section>
</div>
