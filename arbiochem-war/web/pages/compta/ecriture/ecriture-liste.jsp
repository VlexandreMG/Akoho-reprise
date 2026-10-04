<%-- 
    Document   : ecriture-liste
    Created on : 19-Sep-2024, 17:31:54
    Author     : Kanto
--%>

<%@page import="mg.cnaps.compta.ecriture.ComptaEcritureLib"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="java.sql.Date" %>

<% try{
    String etat = request.getParameter("etat");
    if(etat == null || etat.isEmpty()) etat = "";

    String type = request.getParameter("type");
    if (type == null || type.trim().isEmpty()) {
        type = "COMPTA_ECRITURE_LIB";
    }
    switch (type.toUpperCase()) {
        case "COMPTA_ECRITURE_LIB":
        case "COMPTA_ECRITURE_LIB_VENTE":
        case "COMPTA_ECRITURE_LIB_STOCK":
        case "COMPTA_ECRITURE_LIB_AVOIRFC":
        case "COMPTA_ECRITURE_LIB_ACHAT":
        case "COMPTA_ECRITURE_LIB_MANUELLE":
            type = type.toUpperCase();
            break;

        default:
            type = "COMPTA_ECRITURE_LIB";
            break;
    }


    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));
    ComptaEcritureLib c = new ComptaEcritureLib();
    c.setNomTable(type);
    String listeCrt[] = {"id","designation","daty","montant","exercice","journalcode","idObjet"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","designation", "idObjet","daty","montant","exercice","journalcode","etatlib"};
    PageRecherche pr = new PageRecherche(c, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des &eacute;critures");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compta/ecriture/ecriture-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("montant").setLibelle("Montant");
    pr.getFormu().getChamp("idObjet").setLibelle("Origine");
    pr.getFormu().getChamp("exercice").setLibelle("Exercice");
    pr.getFormu().getChamp("journalcode").setLibelle("Journal");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    if(!etat.isEmpty()){
        pr.setAWhere(" and etat = '"+ etat +"'");
    }
    boolean etatCree = "1".equalsIgnoreCase(etat);
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien

    String origineLien =  pr.getLien() + "?but=compta/ecriture/apresOrigine.jsp";

    String lienTableau[] = {pr.getLien() + "?but=compta/ecriture/ecriture-fiche.jsp", origineLien};
    String colonneLien[] = {"id","idObjet"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(new String[]{"id","id"});
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence","D&eacute;signation", "Origine","Date","Montant","Exercice","journal","&eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("compta/ecriture/inc/sous-ecriture-detail.jsp&id=");
    String[] etatAffiche = { "Tous","Cr&eacute;&eacute;", "Vis&eacute;e" };
    String[] etatPasse = { "","1","11" };
    String formAction = pr.getLien() + "?but=apresValiderCompta.jsp";

    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=compta/ecriture/saisie-ecriture-multiple.jsp&currentMenu=MNDSN286\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une &eacute;criture comptable</a>"
    );
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">

        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="formRecherche" id="formRecherche">

            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

            <div class="col-md-12 mb-5 nopadding">
                <div class="row">

                    <!-- FILTRE ETAT -->
                    <div class="col-md-4">
                        &Eacute;tat :
                        <select name="etat" class="champ form-control" id="etat" onchange="changerEtat()">
                            <%
                                for( int i = 0; i < etatAffiche.length; i++ ){
                                    String selected = "";
                                    if(etat != null && etat.equals(etatPasse[i])){
                                        selected = "selected";
                                    }
                            %>
                            <option value="<%= etatPasse[i] %>" <%= selected %>> <%= etatAffiche[i] %> </option>
                            <%  } %>
                        </select>
                    </div>
                    <div class="row col-md-12 mb-5 nopadding">
                        <div class="row" >
                            <div class="col-md-4 ">
                                <label class="input-label" for="etat">Type :</label>
                                <select name="type" class="champ form-control" id="type" onchange="changerDesignation()" >
                                    <% if (request.getParameter("type") != null && request.getParameter("type").compareToIgnoreCase("COMPTA_ECRITURE_LIB") == 0) {%>
                                    <option value="COMPTA_ECRITURE_LIB" selected>Tous</option>
                                    <% } else { %>
                                    <option value="COMPTA_ECRITURE_LIB" >Tous</option>
                                    <% } %>
                                    <% if (request.getParameter("type") != null && request.getParameter("type").compareToIgnoreCase("COMPTA_ECRITURE_LIB_VENTE") == 0) {%>
                                    <option value="COMPTA_ECRITURE_LIB_VENTE" selected>Vente</option>
                                    <% } else { %>
                                    <option value="COMPTA_ECRITURE_LIB_VENTE">Vente</option>
                                    <% } %>
                                    <% if (request.getParameter("type") != null && request.getParameter("type").compareToIgnoreCase("COMPTA_ECRITURE_LIB_STOCK") == 0) {%>
                                    <option value="COMPTA_ECRITURE_LIB_STOCK" selected>Stock</option>
                                    <% } else { %>
                                    <option value="COMPTA_ECRITURE_LIB_STOCK">Stock</option>
                                    <% } %>
                                    <% if (request.getParameter("type") != null && request.getParameter("type").compareToIgnoreCase("COMPTA_ECRITURE_LIB_AVOIRFC") == 0) {%>
                                    <option value="COMPTA_ECRITURE_LIB_AVOIRFC" selected>Avoir</option>
                                    <% } else { %>
                                    <option value="COMPTA_ECRITURE_LIB_AVOIRFC">Avoir</option>
                                    <% } %>
                                    <% if (request.getParameter("type") != null && request.getParameter("type").compareToIgnoreCase("COMPTA_ECRITURE_LIB_ACHAT") == 0) {%>
                                    <option value="COMPTA_ECRITURE_LIB_ACHAT" selected>Achat</option>
                                    <% } else { %>
                                    <option value="COMPTA_ECRITURE_LIB_ACHAT">Achat</option>
                                    <% } %>
                                    <% if (request.getParameter("type") != null && request.getParameter("type").compareToIgnoreCase("COMPTA_ECRITURE_LIB_MANUELLE") == 0) {%>
                                    <option value="COMPTA_ECRITURE_LIB_MANUELLE" selected>Manuelle</option>
                                    <% } else { %>
                                    <option value="COMPTA_ECRITURE_LIB_MANUELLE">Manuelle</option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </form>
        <form action="<%= formAction %>" method="post" name="ecriture" id="ecriture">

            <input type="hidden" name="bute" value="compta/ecriture/ecriture-liste.jsp">

            <%
                out.println(pr.getTableauRecap().getHtml());
            %>
            <br>

            <div id="sousTotal" style="margin-bottom: 15px; padding: 10px; border-radius: 4px; font-weight: bold;">
                Sous-total: <span id="totalMontant">0.00</span>
            </div>
            <br>

            <%
                if(etatCree){
                    pr.getTableau().setNameBoutton("Valider");
                    out.println(pr.getTableau().getHtmlWithCheckbox());
                } else {
                    out.println(pr.getTableau().getHtml());
                }

                out.println(pr.getBasPage());
            %>

        </form>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>

<script>
        function changerDesignation() {
        document.formRecherche.submit();
    }
    function changerEtat(){
        document.formRecherche.submit();
    }

    function calculerSousTotal() {
        var checkboxes = document.querySelectorAll('input[type="checkbox"]');
        var totalMontant = 0;

        checkboxes.forEach(function(checkbox) {
            if (checkbox.checked) {
                var row = checkbox.closest('tr');
                if (row) {
                    var cells = row.querySelectorAll('td');
                    // La colonne Montant est à l'index 2 (après ID et Date)
                    if (cells.length > 3) {
                        var montantCell = cells[4];
                        var montantText = montantCell.textContent.trim();
                        var montant = parseFloat(montantText.replace(/[^0-9.-]/g, ''));
                        if (!isNaN(montant)) {
                            totalMontant += montant;
                        }
                    }
                }
            }
        });

        document.getElementById('totalMontant').textContent = totalMontant.toFixed(2);
    }

    // Initialiser le calcul au chargement de la page
    document.addEventListener('DOMContentLoaded', function() {
        calculerSousTotal();

        // Ajouter l'event listener sur tous les checkboxes
        var checkboxes = document.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(function(checkbox) {
            checkbox.addEventListener('change', calculerSousTotal);
        });
    });
</script>
