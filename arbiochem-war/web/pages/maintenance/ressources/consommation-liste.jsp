<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.ressources.ConsommationLib" %>

<% try{ 
    ConsommationLib o = new ConsommationLib();
    o.setNomTable("CONSOMMATIONLIB");
    String[] listeCrt = {"id","desce","daty","idMachineLib","idTypeMaintenanceLib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","daty","desce","idMachineLib","idTypeMaintenanceLib","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste de Consommations");
    String etat = request.getParameter("etat");
    if(etat!=null && etat.compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat="+ etat);
    }
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/ressources/consommation-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idMachineLib").setLibelle("Machine");
    pr.getFormu().getChamp("idTypeMaintenanceLib").setLibelle("Type de maintenance");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Date","Description","Machine","Type de maintenance","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] lienTableau = {pr.getLien() + "?but=maintenance/ressources/consommation-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Vis&eacute;e(s)", "Annul&eacute;e(s)"};
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="liste" id="liste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <% for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(etat !=null && etat.compareToIgnoreCase(etatVal[i]) == 0) {%>
                        <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                        <% } else { %>
                        <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                        <% } %>
                        <% } %>
                    </select>
                </div>
            </div>
        </form>
        <br>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<script>
    function changerDesignation() {
        document.liste.submit();
    }
</script>
<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

