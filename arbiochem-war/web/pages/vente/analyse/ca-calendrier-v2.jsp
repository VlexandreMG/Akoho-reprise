<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="utils.UrlUtils" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Vector" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="vente.CaCalendrier" %>
<%@ page import="utils.CalendarUtil" %>
<%@ page import="vente.CaJourDetailPourCalendrier" %>

<style>
    .table-container {
        max-width: 100%;
        max-height: 80vh;
        overflow-y: auto;
        overflow-x: auto;
        border: 1px solid #ccc;
        padding: 0;
    }

    table {
        border-collapse: collapse;
        width: 100%;
        table-layout: auto;
        min-width: fit-content;
    }

    th, td {
        border: 1px solid #999;
        padding: 6px;
        text-align: right;
        font-size: 12px;
    }

    th {
        background-color: #f2f2f2;
        text-align: center;
        position: sticky;
        top: 0;
        z-index: 2;
    }

    .jour-cell {
        text-align: center;
        position: sticky;
        left: 0;
        background: #fff;
        z-index: 1;
        width: 120px;
    }

    .jour{

        text-align: left;
        position: sticky;
        left: 0;
        background: #fff; /* important pour que le sticky fonctionne bien */
        z-index: 3; /* plus élevé pour qu'elle soit au-dessus des autres */
        min-width: 120px;
        max-width: 120px;
        white-space: nowrap;
    }

    .dimanche {
        background-color: #fdd;
    }

    .ca {
        color: #000;
    }
    .montant{
        text-align: right;
    }

    .total{
        font-weight: bold;
    }

</style>


<%
    try{
        String lien = (String) session.getValue("lien");
        user.UserEJB u= (user.UserEJB) session.getValue("u");

        /* Récuperer la date par défaut */
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String dateEncours = request.getParameter("d");
        LocalDate dtJour = LocalDate.now();
        if (dateEncours!=null){
            dateEncours = CalendarUtil.castDateToFormat(dateEncours,DateTimeFormatter.ofPattern("yyyy-MM-dd"),formatter);
            dtJour = LocalDate.parse(dateEncours,formatter);
        }
        if (dateEncours == null || dateEncours.trim().isEmpty()) {
            LocalDate aujourdHui = LocalDate.now();
            dateEncours = aujourdHui.format(formatter);
        }

        String debutEtFinDeSemaine[]=CalendarUtil.getDebutFinAnnee(dtJour,request.getParameter("moisDebut"),request.getParameter("anneeDebut"),request.getParameter("moisFin"),request.getParameter("anneeFin"));
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        CaCalendrier eta=new CaCalendrier(debutEtFinDeSemaine[0],debutEtFinDeSemaine[1]);
        String[] listeDate=eta.getListeMois();
        int [] listeJours=eta.getJours();
        HashMap<String,Double[]> total = eta.getTotal();

        // URL du site
        String urlComplete = request.getRequestURL().toString();
        String queryString = request.getQueryString();

        if (queryString != null) {
            urlComplete += "?" + queryString;
        }
        String lienPrecedent = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,CalendarUtil.castDateToFormat(debutEtFinDeSemaine[2],formatter,DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        String lienSuivant = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,CalendarUtil.castDateToFormat(debutEtFinDeSemaine[3],formatter,DateTimeFormatter.ofPattern("yyyy-MM-dd")));

        String temp="";
        temp=temp+ "<div class=\"modal fade\" id=\"linkModal\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"linkModalLabel\" aria-hidden=\"true\">\r\n" +
                "  <div style='width:60%;background:transparent;' class=\"modal-dialog modal-dialog-centered\" role=\"dialog\">\r\n" + //
                "    <div style=\"border-radius: 16px;padding:15px;overflow-y:auto;height:80vh\" class=\"modal-content\">\r\n" + //
                "      <div class=\"modal-body\">\r\n"+
                "       <div id=\"modalContent\">\r\n>";
        temp +=                "</div>\r\n" + //
                "    </div>\r\n" + //
                "   </div>\r\n" + //
                "  </div>\r\n" + //
                "</div>";
        String bute = "vente/analyse/ca-calendrier-v2.jsp";

        String[] mois = {
                "Janvier", "F&eacute;vrier", "Mars",
                "Avril", "Mai", "Juin",
                "Juillet", "Aout", "Septembre",
                "Octobre", "Novembre", "D&eacute;cembre"
        };
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Tableau CA Journalier</h1>
    </section>
    <div style="width: 100%;display: flex;justify-content: space-between;align-items: end">
        <form class="col-md-6 col-xs-12 nopadding" action="<%=lien%>?but=<%= bute %>" method="Get" style="border-radius: 8px;display: flex;align-items: end;">
            <div class="form-input col-md-4 col-xs-12 nopadding">
                <label class="input-label">Mois & Ann&eacute;e D&eacute;but</label>
                <span style="display: flex;gap: 2px">
                    <select class="form-control" name="moisDebut">
                        <% for (int i = 0; i < mois.length; i++) {
                            String isSelected = "";
                            String moisDebutParam = request.getParameter("moisDebut");
                            if (moisDebutParam != null && moisDebutParam.equals(String.valueOf(i+1))){
                                isSelected = "selected";
                            }
                        %>
                            <option value="<%=i+1%>" <%=isSelected%>><%=mois[i]%></option>
                        <% } %>
                    </select>
                    <% String defaultYear = String.valueOf(LocalDate.now().getYear()); %>
                    <input class="form-control" type="number" name="anneeDebut" value="<%= (request.getParameter("anneeDebut") != null && !request.getParameter("anneeDebut").trim().isEmpty()) ? request.getParameter("anneeDebut") : defaultYear %>">
                </span>
            </div>
            <div class="form-input col-md-4 col-xs-12">
                <label class="input-label">Mois & Ann&eacute;e Fin</label>
                <span style="display: flex;gap: 2px">
                    <select class="form-control" name="moisFin">
                        <% for (int i = 0; i < mois.length; i++) {
                            String isSelected = "";
                            String moisFinParam = request.getParameter("moisFin");
                            if (moisFinParam != null && moisFinParam.equals(String.valueOf(i+1))){
                                isSelected = "selected";
                            }
                        %>
                            <option value="<%=i+1%>" <%=isSelected%>><%=mois[i]%></option>
                        <% } %>
                    </select>
                    <input class="form-control" type="number" name="anneeFin" value="<%= (request.getParameter("anneeFin") != null && !request.getParameter("anneeFin").trim().isEmpty()) ? request.getParameter("anneeFin") : defaultYear %>">
                </span>
            </div>
            <input type='hidden' value='<%=bute%>' name='but'>
            <div class="form-input col-md-4 col-xs-12">
                <button class="btn btn-primary btn-small" style="width: 70%;height: 32px;text-align: center" type="submit">Afficher</button>
            </div>
        </form>
    </div>

    <!-- Légende -->
    <div class="legend">
        <%--    <span class="occupe">Diffuser</span>--%>
        <%--    <span class="disponible">Disponible</span>--%>
        <%--    <span class="en-attente">En attente</span>--%>
    </div>
    <div class="table-container">
        <table>
            <thead>
            <tr style="position: sticky;top:0;z-index: 5;">
                <th class="jour-cell jour">Jours</th>
                <% for(int i=0;i<listeDate.length;i++)
                { %>
                <th class="jour-cell" style="width: 50px;">DATE</th>
                <th class="jour-cell"><%= listeDate[i].toUpperCase() %></th>
                <%  } %>
            </tr>
            </thead>
            <tbody>
                    <% for(int i=0;i<listeJours.length;i++) {
                        int jour= listeJours[i];
                    %>
            <tr>
                <td class="jour-cell jour">
                    <%=jour%>
                </td>
                <% for(int j=0;j<listeDate.length;j++) { %>
                <%
                    CaJourDetailPourCalendrier[] caJours = eta.getReservationByTime(jour,listeDate[j]);
                    if(caJours != null && caJours.length>0) {
                        boolean isDimanche2 = caJours[0].getJourLib().equalsIgnoreCase("Dimanche");
                        double montant = caJours[0].getMontant();
                        String jj = caJours[0].getJourLib().substring(0, 3)+".";
                %>
                <td class="jour-cell <%= isDimanche2 ? "dimanche" : "" %>">
                    <%= jj %>
                </td>
                <td class="jour-cell <%= isDimanche2 ? "dimanche" : "" %> montant">
                    <%= montant > 0 ? String.format("%,.2f", montant) : "-" %>
                </td>
                <%  } else { %>
                <td class="jour-cell">
                    -
                </td>
                <td class="jour-cell montant">
                    -
                </td>
                <% } %>
                <%  } %>

            </tr>
            <%  } %>

            </tbody>
            <tfoot>
            <tr>
                <td class="jour-cell jour  total ">
                    TOTAL CA AR
                </td>
                <% for(int k=0;k<listeDate.length;k++) {
                    Double [] tab = total.get(listeDate[k]);
                %>
                <td class="jour-cell montant total" colspan="2">
                    <%= (tab != null && tab.length > 0 && tab[0] != null && tab[0] > 0) ? String.format("%,.2f", tab[0]) : "-" %>
                </td>
                <%  } %>
            </tr>
            <tr>
                <td class="jour-cell jour  total ">CA JR MOYEN</td>
                <% for(int k=0;k<listeDate.length;k++) {
                    Double [] tab = total.get(listeDate[k]);
                %>
                <td class="jour-cell montant total" colspan="2">
                    <%= (tab != null && tab.length > 1 && tab[1] != null && tab[1] > 0) ? String.format("%,.2f", tab[1]) : "-" %>
                </td>
                <%  } %>
            </tr>
            </tfoot>
        </table>
    </div>
</div>

<% out.println(temp);%>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>

