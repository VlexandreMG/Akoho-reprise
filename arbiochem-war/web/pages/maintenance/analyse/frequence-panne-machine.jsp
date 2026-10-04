<%--
  Created by IntelliJ IDEA.
  User: Tsinjoniaina
  Date: 08/12/2025
  Time: 16:19
  To change this template use File | Settings | File Templates.
--%>
<%@page import="utils.ConstanteAsync"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRechercheGroupe"%>
<%@ page import="maintenance.planning.FrequencePanneMachine" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="maintenance.utils.ConstanteMaintenance" %>

<!-- Styles personnalisés pour espacement -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/box-layout.css">
<%
    try {
        UserEJB u = (user.UserEJB) session.getValue("u");
        FrequencePanneMachine frequencePanneMachine = new FrequencePanneMachine();

        String listeCrt[] = {"daty"};
        String listeInt[] = {"daty"};

        String[] pourcentage = {};
        String somDefaut[] = {"qte"};
        String colGrCol[] = {"idMachineLib"};
        String[] colDefaut = {"daty"};

        PageRechercheGroupe pr = new PageRechercheGroupe(frequencePanneMachine, request, listeCrt, listeInt, 3, colGrCol, somDefaut, pourcentage, 4, 0);

        pr.setUtilisateur(u);
        pr.setLien((String) session.getValue("lien"));
        pr.setAWhere(" AND IDENTITE = '"+ ConstanteMaintenance.ENTITE_MACHINE +"'");

        pr.getFormu().getChamp("daty1").setLibelle("Date d&eacute;but");
        pr.getFormu().getChamp("daty2").setLibelle("Date fin");

        pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.soustraireJourDate(7));
        pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

        pr.setApres("maintenance/analyse/frequence-panne-machine.jsp");
        pr.setNpp(2000);

        String lienRedir = pr.getLien() + "?but=maintenance/planning/planning-machine-liste.jsp&fromAnalyse=true";
        if (request.getParameter("daty1") != null && !request.getParameter("daty1").isEmpty()) lienRedir += "&datedebut1=" + request.getParameter("daty1");
        if (request.getParameter("daty2") != null && !request.getParameter("daty2").isEmpty()) lienRedir += "&datedebut2=" + request.getParameter("daty2");
        pr.creerObjetPageCroise(colDefaut, lienRedir);

        String lib[] = {" ","nombre","somme des quantit&eacute;s"};
        pr.getTableauRecap().setLibeEntete(lib);
        String titre = "Analyse de la fr&eacute;quence des pannes par machine";
        String desce = "Analyse de la fr&eacute;quence des pannes par machine";

%>

<div class="content-wrapper" style="margin-bottom: 50px;">
    <section class="content-header">
        <h1>Fréquence des pannes par machine</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres()%>" method="post" name="formulaire" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getHtmlWithEvaluation(ConstanteAsync.API_URL, ConstanteAsync.API_KEY, titre, desce));
            
            out.println(pr.getTableau().getHtml());
        %>
    </section>
    <% //out.println(pr.getBasPage()); %>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
