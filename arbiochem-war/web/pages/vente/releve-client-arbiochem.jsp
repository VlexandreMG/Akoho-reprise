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
    String listCrt[] = {"id", "daty", "journal", "reference","idclient", "libelle", "lettre","debit","credit"};
    String listInt[] = {"daty"};
    String libEntete[] = {"id", "daty", "journal", "reference", "clientlib", "libelle", "lettre","debit","credit"};

    PageRecherche pr = new PageRecherche(dmd, request, listCrt, listInt, 3,libEntete, libEntete.length);
    pr.setTitre("RELEVE CLIENT");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/releve-client-arbiochem.jsp");

    String[] etatVal = {"%","1"};
    String[] etatAff = {"Tous","Impay&eacute;e(s)"};

    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        if(request.getParameter("etat").compareToIgnoreCase("1")==0){
            pr.setAWhere(" and LETTRE =' '");
        }else if(request.getParameter("etat").compareToIgnoreCase("%")==0){
            pr.setAWhere(" and LETTRE like '%'");
        }
    }
    pr.setOrdre(" ORDER BY daty DESC");
    pr.getFormu().getChamp("debit").setLibelle("D&eacute;bit");
    pr.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("credit").setLibelle("Cr&eacute;dit");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
//    pr.getFormu().getChamp("annee").setLibelle("ann&eacute;e");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idclient").setLibelle("Client");
    pr.getFormu().getChamp("idclient").setPageAppelComplete("client.Client", "id", "CLIENT");

    String[] colSomme = { "debit", "credit", "solde" };
    String[] enteteRecap = {"","Nombre","Somme des d&eacute;bits","Somme des cr&eacute;dits", "Solde"};
    pr.creerObjetPage(libEntete, colSomme);


    String lienTableau[] = {pr.getLien() + "?but=vente/vente-arbiochem-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    String[] attributLien = {"id"};
    pr.getTableau().setAttLien(attributLien);

    String libEnteteAffiche[] = {"id", "Date", "Journal", "R&eacute;f&eacute;rence", "Client", "D&eacute;signation", "Lettre","D&eacute;bit","Cr&eacute;dit"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
    "<a id='print-btn-pdf' class='btn btn-primary btn-small' href='#'>" +
    "<i class='material-symbols-rounded'>picture_as_pdf</i> Imprimer PDF" +
    "</a>&nbsp;" +

    "<a id='export-btn-excel' class='btn btn-success btn-small' href='#'>" +
    "<i class='material-symbols-rounded'>download</i> Exporter Excel" +
    "</a>"
);
%>

<script>
    function changerDesignation() {
        document.filtre.submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="filtre">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12" style="margin-top: 12px;">
                <div class="row">
                    <div class="col-md-2 nopadding" style="width: 271px" >
                        <label class="input-label" for="etat">&Eacute;tat :</label>
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < etatAff.length; i++ ){ %>
                            <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                            <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                            <% } else { %>
                            <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                            <% } %>
                            <%    }
                            %>
                        </select>
                    </div>
                </div>
                </br>
            </div>
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
    document.addEventListener("DOMContentLoaded", function () {

        document.getElementById("export-btn-excel").addEventListener("click", exportExcel);
        document.getElementById("print-btn-pdf").addEventListener("click", printPdf);

        function exportExcel(event) {
            event.preventDefault();

            var daty1 = document.getElementById("daty1").value;
            var daty2 = document.getElementById("daty2").value;
            var idclient = document.getElementById("idclient").value;

            var exportUrl = "${pageContext.request.contextPath}/ExportExcel?action=RELEVE_CLIENT"
                    + "&daty1=" + encodeURIComponent(daty1)
                    + "&daty2=" + encodeURIComponent(daty2)
                    + "&idclient=" + encodeURIComponent(idclient);

            window.location.href = exportUrl;
        }

        function printPdf(event) {
            event.preventDefault();

            var daty1 = document.getElementById("daty1").value;
            var daty2 = document.getElementById("daty2").value;
            var idclient = document.getElementById("idclient").value;

            var pdfUrl = "${pageContext.request.contextPath}/ExportPDF?action=imprimer_releve_client"
                    + "&daty1=" + encodeURIComponent(daty1)
                    + "&daty2=" + encodeURIComponent(daty2)
                    + "&idclient=" + encodeURIComponent(idclient);

            window.location.href = pdfUrl;
        }

    });
</script>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>


