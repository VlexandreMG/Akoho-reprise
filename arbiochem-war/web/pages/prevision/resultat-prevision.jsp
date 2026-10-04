<%-- 
    Document   : resultat-prevision
    Created on : 20 ao�t 2024, 16:06:28
    Author     : Estcepoire
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.TableauRecherche"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="prevision.Prevision"%>
<%@page import="prevision.AdminPrevision"%>
<%@page import="affichage.Graphe"%>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="java.util.Arrays" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%
    Prevision minimum=null;
    try {
        String[] intervalles = {};
        String[] criteres = {};
        String[] libEntete = {"daty","soldeInitial", "debit", "credit", "soldeFinale"};
        String[] libEnteteAffiche = {"Date","Solde initial", "d&eacute;pense", "recette", "Solde final"};
        PageRecherche pr = new PageRecherche(new Prevision(), request, criteres, intervalles, 3, libEntete, libEntete.length);
        String moisDefaut=Utilitaire.getMois(Utilitaire.dateDuJour());
        
        String anneeDefaut=Utilitaire.getAnnee(Utilitaire.dateDuJour());
        String[] debutFinDefaut=Utilitaire.getBorneDatyMoisAnnee(moisDefaut, anneeDefaut);
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        String[] colSomme = null;
        String lien = (String) session.getValue("lien");
        String grouper="semaine";
        if(request.getParameter("grouper")!=null) grouper = request.getParameter("grouper");
        String defaultDatyFiltre = request.getParameter("datyFiltre") != null ? request.getParameter("datyFiltre"):Utilitaire.dateDuJour();
        String defaultDatyDebut = request.getParameter("datyDebut") != null ? request.getParameter("datyDebut"):debutFinDefaut[0];
        String defaultDatyFin = request.getParameter("datyFin") != null ? request.getParameter("datyFin"):debutFinDefaut[1];

        //graphe
        String colAbs = "datyG"+grouper;
%>

<style>
    .strong{
        font-size: 15px;
        padding-top: 4px;
    }
</style>

<div class="content-wrapper">
    <section class="content-header">
        <h1>R&eacute;sultat pr&eacute;visionnel</h1>
    </section>
    <form action="<%=lien%>?but=prevision/resultat-prevision.jsp" method="post">
        <div class='col-md-12 cardradius'>
            <div class="input-container">
                <div class="form-input">
                    <label class="input-label" >Date du jour</label>
                    <input class="form-control" id="datyFiltre" onmouseover="datepicker('datyFiltre')" type="textbox" name="datyFiltre" value="<%= defaultDatyFiltre %>" >
                </div>
                <div class="form-input">
                    <label class="input-label" >Date de d&eacute;but</label>
                    <input class="form-control" id="datyDebut" onmouseover="datepicker('datyDebut')" type="textbox" name="datyDebut" value="<%= defaultDatyDebut %>">
                </div>
                <div class="form-input">
                    <label class="input-label" >Date de fin</label>
                    <input class="form-control" id="datyFin" onmouseover="datepicker('datyFin')" type="textbox" name="datyFin" value="<%=defaultDatyFin %>">
                </div>
                <div class="form-input">
                    <label class="input-label" >Grouper par :</label>
                    <select class="form-control" name="grouper">
                        <option value="">Jour</option>
                        <option value="semaine" <%if(grouper.compareToIgnoreCase("semaine")==0)out.print("selected");%>>Semaine</option>
                        <option value="mois" <%if(grouper.compareToIgnoreCase("mois")==0)out.print("selected");%>>Mois</option>
                    </select>
                </div>
                <br>
                <br>
                <br>
                <div class='col-xs-12 nopadding'>
                    <button type="submit" class='btn btn-primary pull-right' style='margin-right: 0;'>Afficher la pr&eacute;vision</button>
                </div>
            </div>
        </div>
        <div class="col-md-12 nopadding">
            <h2 class="h520pxSemibold" style="margin-bottom: 0" >Graphe</h2>
        </div>
        <div class="cardradius col-md-12 mb-5 m-0">
            <canvas id="solde"></canvas>
        </div>
        <div class="cardradius col-md-12 mb-5 m-0">
            <canvas id="recette"></canvas>
        </div>
        <div class="cardradius col-md-12 mb-5 m-0">
            <canvas id="depense"></canvas>
        </div>
            <%
                    if ("POST".equalsIgnoreCase(request.getMethod())) {
                        String datyFiltre = request.getParameter("datyFiltre");
                        String datyDebut = request.getParameter("datyDebut");
                        String datyFin = request.getParameter("datyFin");
                        
                        if (datyFiltre.isEmpty() == false || datyDebut.isEmpty() == false || datyFin.isEmpty() == false) {
                            AdminPrevision ap = new AdminPrevision();
                            ap.getPrevision(datyFiltre, datyDebut, datyFin,grouper);
                            minimum=ap.getMinimum();
                            pr.creerObjetPage(libEntete,colSomme);
                            pr.getTableau().setData(ap.getListePrev());
                            pr.getTableau().transformerDataString();
                            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
                            Graphe g = new Graphe(ap.getListePrev(),colAbs,new String[]{"soldeFinale"},new String[]{"Solde Final"},"solde","daty");
                            g.setCouleurs(new String[]{"#2563EB"});
                            g.setBgCouleurs(new String[]{"#2563EB"});
                            Graphe g1 = new Graphe(ap.getListePrev(),colAbs,new String[]{"credit"},new String[]{"Recette"},"recette","daty");
                            g1.setCouleurs(new String[]{"#16A34A"});
                            g1.setBgCouleurs(new String[]{"#16A34A"});
                            Graphe g2 = new Graphe(ap.getListePrev(),colAbs,new String[]{"debit"},new String[]{"Dépense"},"depense","daty");
                            g2.setCouleurs(new String[]{"#F1C40F"});
                            g2.setBgCouleurs(new String[]{"#F1C40F"});
                            out.println("<h2 class=\"h520pxSemibold\" >Tableau</h2>");
                            out.println(g.getHtml());
                            out.println(g1.getHtml());
                            out.println(g2.getHtml());
                            out.println(pr.getTableau().getHtml());
                        }
                    }
                    if(minimum!=null) { %>
                    <div id="toremove">
                        <table>

                            <tr id="minimum-values">
                                <%
                                    for( int i = 0; i < libEntete.length - 2; i++ ){ 
                                        out.println("<td></td>");
                                }
                                %>
                                <td style="padding: 10px">
                                    <strong class="strong">
                                        Date minimum : <%= utilitaire.Utilitaire.format(minimum.getDaty()) %>
                                    </strong>
                                </td>
                                <td style="text-align: right; padding: 10px">
                                    <strong class="strong">
                                        Solde minimum : <%= utilitaire.Utilitaire.formaterAr(minimum.getSoldeFinale()) %>
                                    </strong>
                                </td>
                            </tr>
                        </table>
                    </div>

                <%    }
        
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
    </form>
                
</div>
    <script>
        let tableContainer = $("tbody");
        let min = $("#minimum-values").clone();
        min.attr('id', 'min');
        tableContainer.append( min );
        $("#toremove").remove();
        
    </script>
