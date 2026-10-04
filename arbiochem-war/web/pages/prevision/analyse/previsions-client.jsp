<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRechercheGroupe"%>
<%@ page import="prevision.PrevisionTiers" %>
<%@ page import="java.util.Map" %>
<%@ page import="bean.ValeurEtiquette" %>
<%@ page import="utils.UtilitaireClinique" %>

<% try{
    PrevisionTiers o = new PrevisionTiers();
    o.setNomTable("PREVISION_TIERS");
    String[] listeCrt = {"daty"};
    String[] listeInt = {"daty"};
    String[] pourcentage = {};
    String[] colGr = {"tierslib"};
    String[] colGrCol = {};
    String[] somDefaut = {"credit","debit"};
    PageRechercheGroupe pr = new PageRechercheGroupe(o, request, listeCrt, listeInt, 4, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setTitre("Pr&eacute;visions par client");
    pr.setApres("previsions-client.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");

    pr.setNpp(500);
    pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=.jsp");
    String[] lienTableau = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(somDefaut);

    ValeurEtiquette[][] tabEtiquette = pr.getTableau().getValeurEtiquette();
    Map<String, String[]> dataChart = UtilitaireClinique.transformerEtiquetteToMapTotal(tabEtiquette);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%=pr.getTitre()%></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="analyse" id="analyse">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <ul>
            <li>Somme Cr&eacute;dit</li>
            <li>Somme D&eacute;bit</li>
        </ul>
        <br>
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
    let dataCredit = [];
    let dataDebit = [];

    <%
    for (Map.Entry<String, String[]> entry : dataChart.entrySet()) {
        String key = entry.getKey();
        if (key == null || key.trim().isEmpty()) continue;

        String[] values = entry.getValue();
        double credit = 0;
        double debit = 0;

        if (values != null) {
            if (values.length > 0) {
                try { credit = UtilitaireClinique.parseNombreFrancais(values[0]); } catch(Exception e) {}
            }
            if (values.length > 1) {
                try { debit = UtilitaireClinique.parseNombreFrancais(values[1]); } catch(Exception e) {}
            }
        }
    %>
    labels.push("<%= key.replace("\"", "\\\"") %>");
    dataCredit.push(<%= credit %>);
    dataDebit.push(<%= debit %>);
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
                    label: 'Cr\u00e9dit',
                    data: dataCredit,
                    backgroundColor: 'rgba(75, 192, 192, 0.6)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                },
                {
                    label: 'D\u00e9bit',
                    data: dataDebit,
                    backgroundColor: 'rgba(255, 99, 132, 0.6)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: true,
                    position: 'top'
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            let label = context.dataset.label || '';
                            if (label) {
                                label += ': ';
                            }
                            label += new Intl.NumberFormat('fr-FR', {
                                minimumFractionDigits: 2,
                                maximumFractionDigits: 2
                            }).format(context.parsed.y);
                            return label;
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return new Intl.NumberFormat('fr-FR').format(value);
                        }
                    }
                }
            }
        }
    });
</script>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>