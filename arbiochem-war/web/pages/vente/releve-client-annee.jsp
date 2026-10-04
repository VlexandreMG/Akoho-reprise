<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 05/08/2025
  Time: 14:02
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="affichage.PageRecherche" %>
<%@page import="affichage.*"%>
<%@ page import="client.ReleveClient" %>
<%  try{

    ReleveClient dmd = new ReleveClient();
    dmd.setNomTable("releveclient");
    String listCrt[] = {"id", "daty", "journal", "reference","idclient", "libelle", "lettre","debit","credit","annee"};
    String listInt[] = {"daty"};
    String libEntete[] = {"id", "daty", "journal", "reference", "clientlib", "libelle", "lettre","debit","credit"};

    PageRecherche pr = new PageRecherche(dmd, request, listCrt, listInt, 3,libEntete, libEntete.length);
    pr.setTitre("RELEVE CLIENT");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/releve-client-annee.jsp");

    pr.getFormu().getChamp("debit").setLibelle("D&eacute;bit");
    pr.getFormu().getChamp("credit").setLibelle("Cr&eacute;dit");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("annee").setLibelle("ann&eacute;e");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idclient").setLibelle("Client");
    pr.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idclient").setPageAppelComplete("client.Client", "id", "CLIENT");

    String[] colSomme = { "debit", "credit", "solde" };
    String[] enteteRecap = {"","Nombre","Somme des d&eacute;bits","Somme des cr&eacute;dits", "Solde"};
    pr.creerObjetPage(libEntete, colSomme);


    String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    String[] attributLien = {"id"};
    pr.getTableau().setAttLien(attributLien);

    String libEnteteAffiche[] = {"id", "Date", "Journal", "R&eacute;f&eacute;rence", "Client", "D&eacute;signation", "Lettre","D&eacute;bit","Cr&eacute;dit"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
        "                <a id='export-btn-excel' class='btn btn-secondary  btn-small btn-bg-white' href='#' onclick='exportExcel()'>\n" +
        "                    <i class='material-symbols-rounded'>download</i> Exporter en excel\n" +
        "                </a>\n"
    );
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
    function exportExcel() {
        // Récupération des champs
        var daty1Value = document.getElementById("daty1").value;
        var daty2Value = document.getElementById("daty2").value;
        var idclient = document.getElementById("idclient").value;

        var exportUrl = "${pageContext.request.contextPath}/ExportExcel?action=RELEVE_CLIENT"
            + "&daty1=" + encodeURIComponent(daty1Value)
            + "&daty2=" + encodeURIComponent(daty2Value)
            + "&annee=" + encodeURIComponent(document.getElementById("annee").value)
            + "&idclient=" + encodeURIComponent(idclient);

        var exportButton = document.getElementById("export-btn-excel");
        exportButton.href = exportUrl;
    }
</script>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>


