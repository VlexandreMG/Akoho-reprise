<%-- 
    Document   : cnaps_affiche
    Created on : 25 janv. 2023, 16:50:02
    Author     : tsikyrami
--%>

<%@page import="paie.cnaps.CnapsAfficheBis"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>

<%
    CnapsAfficheBis dr = new CnapsAfficheBis();

    if (request.getParameter("etat") != null && !request.getParameter("etat").equals("")) {
        dr.setNomTable(request.getParameter("etat"));
    } else {
        dr.setNomTable("CNAPS_T1");
    }


    String listeCrt[] = {"idpersonnel","matricule","numero_cnaps","annee","direction"};
    String listeInt[] = {};
    String libEntete[] = {"IDPERSONNEL","MATRICULE","PERSONNEL","NUMERO_CNAPS","MOIS1","CNAPS_TRAVAILLEUR1","CNAPS_EMPLOYEUR1","MOIS2","CNAPS_TRAVAILLEUR2","CNAPS_EMPLOYEUR2","MOIS3","CNAPS_TRAVAILLEUR3","CNAPS_EMPLOYEUR3","COTISATION_TRAVAILLEUR","COTISATION_EMPLOYEUR"};
//    for (int i=0;i<libEntete.length;i++) {
//        System.out.println("ENTETE --------- "+libEntete[i]);
//    }
//    System.out.println("ETAT : "+request.getParameter("etat"));

    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/cnaps/cnaps_affiche.jsp");
    pr.setTitre("CNAPS");

    affichage.Champ[] listes = new affichage.Champ[1];
    TypeObjet m0 = new TypeObjet();
    m0.setNomTable("log_direction");
    listes[0] = new Liste("direction", m0, "val", "id");
    pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("numero_cnaps").setLibelle("Num&eacute;ro CNAPS");
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
    pr.getFormu().getChamp("direction").setLibelle("Direction");
    pr.getFormu().getChamp("idpersonnel").setLibelle("ID Personnel");

    String[] colSomme = {"COTISATION_TRAVAILLEUR","COTISATION_EMPLOYEUR"};
    pr.creerObjetPage(libEntete, colSomme);
    String libEnteteAffiche[] = {"Id Personnel","Matricule", "Personnel", "Num&eacute;ro CNAPS", "Imposable 1er Mois", "CNAPS TRAVAILLEUR 1er Mois", "CNAPS EMPLOYEUR 1er Mois", "Imposable 2&egrave;me Mois", "CNAPS TRAVAILLEUR 2&egrave;me Mois", "CNAPS EMPLOYEUR 2&egrave;me Mois","Imposable 3&egrave;me Mois", "CNAPS TRAVAILLEUR 3&egrave;me Mois", "CNAPS EMPLOYEUR 3&egrave;me Mois", "Cotisation du travailleur", "Cotisation de l'employeur"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String libelleRecap[] = {"","","Somme Cotisation travailleur", "Somme Cotisation employeur"};
    String lienTableau[] = {pr.getLien() + "?but=paie/employe/personnel-fiche-portrait.jsp"};
    String colonneLien[] = {"idpersonnel"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String attributLien[] = {"id"};
    pr.getTableau().setAttLien(attributLien);
    String libRecap[] = {"", "Somme Cotisation travailler", "Somme Cotisation employeur"};
    pr.getTableauRecap().setLibeEntete(libelleRecap);
%>
<script>
    function changerDesignation() {
        document.personnel.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>CNAPS</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/cnaps/cnaps_affiche.jsp" method="post" name="personnel" id="personnel">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <div class="form-group">
                    <label>Trimestre : </label>
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" style="display: inline-block; width: 250px;">
                        <option value="CNAPS_T1" <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("CNAPS_T1") == 0) {
                            out.print(" selected");
                        }%>>1er trimestre</option>
                        <option value="CNAPS_T2" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("CNAPS_T2") == 0) {
                            out.print("selected");
                        }%>>2eme trimestre</option>
                        <option value="CNAPS_T3" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("CNAPS_T3") == 0) {
                            out.print("selected");
                        }%>>3eme trimestre</option>
                        <option value="CNAPS_T4" <%if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("CNAPS_T4") == 0) {
                            out.print("selected");
                        }%>>4eme trimestre</option>
                    </select>
                </div>
            </div>
            <div class="col-md-4"></div>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <center>
            <div class="d-flex justify-content-end mb-3">
                <form id="exportExcelForm" action="../ExportDispatcher"  method="post" class="form-inline" >
                    <input type="hidden" name="action" value="cnaps">
                    <input type="hidden" name="nomTable" value="<%= request.getParameter("etat") %>">
                    <button type="submit" name="Submit" class="btn btn-success"> Exporter </button>
                </form>
            </div>
        </center>
        <br>
        <%
            // String libEnteteAffiche[] = {"Matricule","Nom et pr&eacute;noms","Cnaps", "Embauche", "Debauche", "Mois 1","TP1", "Mois 2","TP2", "Mois 3","TP3", "Total declare","Total plafonne", "Cotisation travailleur", "Cotisation employeur"};
            // pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
