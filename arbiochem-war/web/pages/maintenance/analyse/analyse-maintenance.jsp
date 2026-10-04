<%--
    Document   : as-commande-analyse
    Created on : 30 d�c. 2016, 04:57:15
    Author     : Joe
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<%@page import="vente.VenteDetailsLib"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.Calendar"%>
<%@ page import="bean.ValeurEtiquette" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="static rapport.UtilitaireSocobis.parseNombreFrancais" %>
<%@ page import="compteur.CompteurCpl" %>
<%@ page import="rapport.UtilitaireSocobis" %>
<%@ page import="utils.ConstanteAsync" %>

<%
  try{
    CompteurCpl mvt = new CompteurCpl();
    String nomTable = "compteurcpl";
    mvt.setNomTable(nomTable);

    String listeCrt[] = {"id","daty","idLigneLib","idCategorieLib"};
    String listeInt[] = {"daty"};
    String[] pourcentage = {};
    String[] colGr = {"idLigneLib","idCategorieLib"};
    String[] colGrCol = {};
    String somDefaut[] = {"ecart"};

    PageRechercheGroupe pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String apreswhere = "";
    String debutSem=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
    if(request.getParameter("daty1")==null&&request.getParameter("daty2")==null)
      apreswhere= "and daty >= TO_DATE('"+debutSem+"','DD/MM/YYYY') and daty <= TO_DATE('"+utilitaire.Utilitaire.dateDuJour()+"','DD/MM/YYYY')";
    Calendar calendar = Calendar.getInstance();
    int month = calendar.get(Calendar.MONTH) + 1; // January is 0
    int year = calendar.get(Calendar.YEAR);
    String order = "";
    if(request.getParameter("order")!=null && request.getParameter("order").compareToIgnoreCase("")!=0){
      order+= (" "+ request.getParameter("order"));
    }
    String[] grouper = new String[1];
    if(request.getParameter("grouper")!=null && request.getParameter("grouper").compareToIgnoreCase("")!=0){
      grouper[0]=request.getParameter("grouper");
      pr.setColGroupeDefaut(grouper);
    }
    pr.setOrdre(order);
    pr.setAWhere(apreswhere);
    pr.getFormu().getChamp("daty1").setDefaut(debutSem);
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idCategorieLib").setLibelle("Categorie");
    pr.getFormu().getChamp("idLigneLib").setLibelle("Ligne");
    pr.setNpp(500);
    pr.setApres("maintenance/analyse/analyse-maintenance.jsp");
    pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=");

    ValeurEtiquette[][] tabEtiquette = pr.getTableau().getValeurEtiquette();

    Map<String, String[]> dataChart = UtilitaireSocobis.transformerEtiquetteToMapTotalMerge(tabEtiquette);
    for (Map.Entry<String, String[]> entry : dataChart.entrySet()) {
      System.out.println(entry.getKey() + " => " + Arrays.toString(entry.getValue()));
    }

    String titreGraph = "Analyse comparative de la consommation &eacute;lectrique par ligne";
    String description = "Graphique comparatif illustrant les &eacute;carts de consommation &eacute;lectrique entre les lignes";
%>
<style>
  #myChart {
    width: 100% !important;
    height: auto !important;
  }
</style>
<script>
  function changerDesignation() {
    document.analyse.submit();
  }
  $(document).ready(function() {
    $('.box table tr').each(function() {
      $(this).find('td:last, th:last').hide();
    });
  });
  function alignTableCells() {
    const tbody = document.querySelector('tbody');
    if (!tbody) return;

    const rows = tbody.querySelectorAll('tr');

    rows.forEach((row) => {
      const cells = row.querySelectorAll('td');
      if (cells.length > 0) {
        cells[0].style.textAlign = 'center';
        cells[0].style.verticalAlign = 'middle';
      }
      if (cells.length > 1) {
        cells[1].style.textAlign = 'right';
      }
    });
  }
  document.addEventListener('DOMContentLoaded', alignTableCells);
</script>
<div class="content-wrapper">
  <section class="content-header">
    <h1>Analyse des maintenances</h1>
  </section>
  <section class="content">
    <form action="<%=pr.getLien()%>?but=maintenance/analyse/analyse-maintenance.jsp" method="post" name="analyse" id="analyse">
      <%out.println(pr.getFormu().getHtmlEnsemble());%>
    </form>
    <ul>
      <li>La premi&egrave;re ligne correspond &agrave; une ligne de production</li>
    </ul>
    <%
      String lienTableau[] = {};
      pr.getTableau().setLien(lienTableau);
      pr.getTableau().setColonneLien(somDefaut);%>
    <br>
    <%out.println(pr.getHtmlWithEvaluation(ConstanteAsync.API_URL, ConstanteAsync.API_KEY, titreGraph, description));%>
    <%
      out.println(pr.getTableau().getHtml());
      out.println(pr.getBasPage());
    %>

    <h2 class="h520pxSemibold">Graphe</h2>

    <div class="cardradius">
      <canvas id="myChart"></canvas>
    </div>
  </section>
</div>

<script>
  let labels = [];
  let data1 = [];

  <%
  for (Map.Entry<String, String[]> entry : dataChart.entrySet()) {

      String key = entry.getKey();
      if (key.trim().isEmpty()) {
          continue;
      }

      String[] values = entry.getValue();

      double v1 = 0;

      if (values != null ) {
          v1 = parseNombreFrancais(values[0]);
      }
  %>
  labels.push("<%= key %>");
  data1.push(<%= v1 %>);
  <%
  }
  %>
</script>

<script>
  const ctx = document.getElementById('myChart').getContext('2d');


  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [
        {
          label: 'Écart',
          data: data1,
          backgroundColor: 'rgba(255, 99, 132, 0.6)'
        },
      ]
    },
    options: {
      responsive: true,
      scales: {
        y: {
          beginAtZero: true
        }
      }
    }
  });
</script>

<%
  }catch(Exception e){
    e.printStackTrace();
  }
%>