<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="proforma.*" %>
<%@ page import="affichage.PageRecherche" %>
<%@page import="affichage.*"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%  try{

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    ProformaLib dmd = new ProformaLib();
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        dmd.setNomTable(request.getParameter("etat"));
    }
    String listCrt[] = {"id", "idMagasin", "idclientlib","daty","montantttc","montantTva", "numeroProforma"};
    String listInt[] = {"daty","montantttc","montantTva"};
    String libEntete[] = {"id", "numeroProforma","daty", "idclientLib","idMagasinLib", "montantttc","montantTva","etatlib"};

    PageRecherche pr = new PageRecherche(dmd, request, listCrt, listInt, 3,libEntete, libEntete.length);
    pr.setTitre("Liste des proformas");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/proforma/proforma-liste.jsp");
    Liste[] liste = new Liste[1];
    liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("montantttc1").setLibelle("Montant (TTC) min");
    pr.getFormu().getChamp("montantttc2").setLibelle("Montant (TTC) max");
    pr.getFormu().getChamp("montantTva1").setLibelle("Montant (TVA) min");
    pr.getFormu().getChamp("montantTva2").setLibelle("Montant (TVA) max");
    //pr.getFormu().getChamp("montantPaye1").setLibelle("Montant Pay&eacute; min");
    //pr.getFormu().getChamp("montantPaye2").setLibelle("Montant Pay&eacute; max");
    //pr.getFormu().getChamp("montantreste1").setLibelle("Montant Restant min");
    //pr.getFormu().getChamp("montantreste2").setLibelle("Montant Restant max");

    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("numeroProforma").setLibelle("Num&eacute;ro du proforma");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("idClientLib").setPageAppelComplete("client.Client", "nom", "CLIENT");

    String[] colSomme = { "montantttc", "montanttva" };
    String[] enteteRecap = {"","Nombre","Somme des montants TTC","Somme des montants TVA"};
    pr.creerObjetPage(libEntete, colSomme);


    String lienTableau[] = {pr.getLien() + "?but=vente/proforma/proforma-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    String[] attributLien = {"id"};
    pr.getTableau().setAttLien(attributLien);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=vente/proforma/proforma-saisie.jsp&currentMenu=MNDNAN001\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un proforma" +
            "                </a>"
    );


    String libEnteteAffiche[] = {"id", "Num&eacute;ro du proforma","date", "Client","Magasin", "montant (TTC)","montant (TVA)","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/proforma/inc/proforma-detail-liste.jsp&id=");
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="liste" id="liste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
             <div class="row col-md-12">
                <div class="col-md-3" >
                    <label class="input-label" for="etat">&Eacute;tat :</label>
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" >
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("PROFORMA_CPL") == 0) {%>
                        <option value="PROFORMA_CPL" selected>Tous</option>
                        <% } else { %>
                        <option value="PROFORMA_CPL" >Tous</option>
                        <% } %>
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("PROFORMA_CPL_CREE") == 0) {%>
                        <option value="PROFORMA_CPL_CREE" selected>Cr&eacute;&eacute;(s)</option>
                        <% } else { %>
                        <option value="PROFORMA_CPL_CREE">Cr&eacute;&eacute;(s)</option>
                        <% } %>
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("PROFORMA_CPL_VISEE") == 0) {%>
                        <option value="PROFORMA_CPL_VISEE" selected>Vis&eacute;(s)</option>
                        <% } else { %>
                        <option value="PROFORMA_CPL_VISEE">Vis&eacute;(s)</option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-4"></div>
            </div>
        </form>
         <br>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
            <%
                out.println(pr.getTableau().getHtml());
            %>

        <br>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    function changerDesignation() {
        document.getElementById("liste").submit();
    }
</script>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>


