<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/aigledor/chartPlugins/Chart.min.js"></script>

<style>
    .rh-ratio-table {
        width: 100%;
        border-collapse: collapse;
    }
    .rh-ratio-table th,
    .rh-ratio-table td {
        padding: 3px 7px;
        border: 1px solid #dde3ec;
        white-space: nowrap;
        vertical-align: middle;
    }
    .rh-ratio-table th {
        font-size: 10px;
        font-weight: 700;
    }
    .rh-ratio-table td {
        font-size: 11px;
    }
    .rh-ratio-table .text-right {
        text-align: right;
    }
    .rh-ratio-table tbody tr:hover {
        background-color: #f0f7f0;
    }
    .chart-title {
        font-family: "DM Sans";
        font-weight: bold;
        font-size: 16px !important;
        text-align: start !important;
    }
</style>
<div id="dashboard-rh-page">
    <div class="content-wrapper">

        <!-- PAGE HEADER -->
        <section class="content-header">
            <h1>Dashboard RH - Effectifs</h1>
            <nav class="breadcrumb-container">
                <a href="#">Accueil <span class="material-symbols-rounded">arrow_forward_ios</span></a>
                <a href="#" class="active">Dashboard RH</a>
            </nav>
        </section>

        <section class="content">
            <!-- Filter info bar -->
            <div class="value-container d-flex">
                <div class="form-value"><strong>Date Min</strong>: 01/01/2026</div>
                <div class="form-value"><strong>Date Max</strong>: 02/04/2026</div>
            </div>

            <br>

            <!-- ============================================================
                 ROW 1 : Graph 1 + Graph 2
            ============================================================ -->
            <div class="row gap-2">

                <!-- GRAPH 1 : Évolution des effectifs par type de contrat -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">1. Evolution des effectifs par type de contrat</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container">
                                    <canvas id="graphEffectifContrat"></canvas>
                                </div>
                                <!-- Legend -->
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#C5B8E8;"></span> CDI
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#B8D9B0;"></span> JOURNALIER
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- GRAPH 2 : Répartition des effectifs CDI H/F par catégorie pro -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">2. Répartition des effectifs CDI H/F par catégorie pro</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <!-- KPI Total -->
                                <div class="kpi-effectif">
                                    <span class="kpi-label">EFFECTIF TOTAL</span>
                                    <span class="kpi-value">549</span>
                                </div>
                                <div class="chart-container">
                                    <canvas id="graphRepartitionCDI"></canvas>
                                </div>
                                <!-- Legend -->
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#7BC8C8;"></span> Femme / Homme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#555;"></span> Homme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#E8A09A;"></span> Femme
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /row 1 -->

            <!-- ============================================================
                 ROW 2 : Graph 3 + Graph 4 (Pyramides des âges)
            ============================================================ -->
            <div class="row gap-2" style="margin-top:16px;">

                <!-- GRAPH 3 : Pyramide des âges CDI -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">3. Pyramide des âges CDI</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container-tall">
                                    <canvas id="graphPyramideCDI"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#E8A09A;"></span> Femme / Homme Femme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#7BC8C8;"></span> Homme
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- GRAPH 4 : Pyramide des âges JOURNALIERS -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">4. Pyramide des âges JOURNALIERS</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container-tall">
                                    <canvas id="graphPyramideJournalier"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#E8A09A;"></span> Femme / Homme Femme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#7BC8C8;"></span> Homme
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /row 2 -->


            <!-- ============================================================
                 ROW 3 : Graph 5 + Graph 6
            ============================================================ -->
            <div class="row gap-2" style="margin-top:16px;">

                <!-- GRAPH 5 : Pyramide des anciennetées CDI -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">5. Pyramide des anciennetées CDI</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container-tall">
                                    <canvas id="graphPyramideAnciennete"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#7BC8C8;"></span> Femme / Homme Femme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#E8A09A;"></span> Homme
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- GRAPH 6 : Anciennetées CDI / Catégorie pro -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">6. Anciennetées CDI / Catégorie pro</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container-tall">
                                    <canvas id="graphAncienneteCategorie"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#E8A09A;"></span> Femme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#7BC8C8;"></span> Femme / Homme Homme
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /row 3 -->

            <!-- ============================================================
                 ROW 4 : Graph 7 + Graph 8
            ============================================================ -->
            <div class="row gap-2" style="margin-top:16px;">

                <!-- GRAPH 7 : Répartition H/F CDI -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">7. Répartition H/F CDI</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container" style="height:320px;">
                                    <canvas id="graphRepartitionHFCDI"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#E8A09A;"></span> Femme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#7BC8C8;"></span> Homme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#A8C87A;"></span> Total Result
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- GRAPH 8 : Répartition H/F Journaliers -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">8. Répartition H/F Journaliers</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container" style="height:320px;">
                                    <canvas id="graphRepartitionHFJournalier"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#E8A09A;"></span> Femme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#7BC8C8;"></span> Homme
                                    </div>
                                    <div class="legend-row">
                                        <span class="legend-dot" style="background:#A8C87A;"></span> Total Result
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /row 4 -->

            <div class="row gap-2" style="margin-top:16px;">

                <!-- GRAPH 12 : Salaire de base CDI H/F par catégorie pro -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">12. Salaire de base CDI H/F par catégorie pro</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container" style="height:300px;">
                                    <canvas id="graphSalaireCategorie"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row"><span class="legend-dot" style="background:#7BC8C8;"></span> Femme / Homme Homme</div>
                                    <div class="legend-row"><span class="legend-dot" style="background:#E8A09A;"></span> Femme</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- GRAPH 13 : H SUP CDI H/F -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">13. H SUP CDI H/F</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container" style="height:300px;">
                                    <canvas id="graphHSupCDI"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row"><span class="legend-dot" style="background:#7BC8C8;"></span> Femme / Homme Homme</div>
                                    <div class="legend-row"><span class="legend-dot" style="background:#E8A09A;"></span> Femme</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /row 5 -->

            <!-- ============================================================
                 ROW 6 : Graph 14 + Graph 15
            ============================================================ -->
            <div class="row gap-2" style="margin-top:16px;">

                <!-- GRAPH 14 : Salaire de base CDI H/F OUVRIER par tranche d'ancienneté -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">14. Salaire de base CDI H/F OUVRIER par tranche d'ancienneté</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container-tall" style="height:400px;">
                                    <canvas id="graphSalaireOuvrier"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row"><span class="legend-dot" style="background:#E8A09A;"></span> Femme</div>
                                    <div class="legend-row"><span class="legend-dot" style="background:#7BC8C8;"></span> Femme / Homme Homme</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- GRAPH 15 : Salaire de base CDI H/F CADRE par tranche d'ancienneté -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title">15. Salaire de base CDI H/F CADRE par tranche d'ancienneté</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card dashboard-chart-box">
                            <div class="box-body">
                                <div class="chart-container-tall" style="height:400px;">
                                    <canvas id="graphSalaireCadre"></canvas>
                                </div>
                                <div style="display:flex;justify-content:center;gap:18px;margin-top:8px;">
                                    <div class="legend-row"><span class="legend-dot" style="background:#E8A09A;"></span> Femme</div>
                                    <div class="legend-row"><span class="legend-dot" style="background:#7BC8C8;"></span> Femme / Homme Homme</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /row 6 -->

            <div class="row gap-2" style="margin-top:16px;">

                <!-- SECTION 16 : RATIO SALAIRE vs SME -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title" style="text-align:center;font-size:1rem;">16. RATIO SALAIRE vs SME</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card">
                            <div class="box-body" style="padding:12px 14px;">

                                <!-- Sub-table 1: Salaire vs SME vs Subsistantiel + Salaire vs Grille -->
                                <table class="table table-bordered table-condensed rh-ratio-table" style="font-size:11px;margin-bottom:10px;">
                                    <thead>
                                    <tr>
                                        <th rowspan="2" style="vertical-align:middle;background:#f5f5f5;"></th>
                                        <th colspan="3" style="text-align:center;background:#e8f0e8;color:#2e5a2e;">Salaire vs SME vs Subsistantiel</th>
                                        <th colspan="3" style="text-align:center;background:#e8f0e8;color:#2e5a2e;">Salaire vs Grille</th>
                                    </tr>
                                    <tr>
                                        <th class="contenuetable">Femme</th>
                                        <th class="contenuetable">Homme</th>
                                        <th class="contenuetable">Total</th>
                                        <th class="contenuetable">Femme</th>
                                        <th class="contenuetable">Homme</th>
                                        <th class="contenuetable">Total</th>
                                    </tr>
                                    </thead>
                                    <tbody id="ratioTableBody">
                                    <!-- Rows injected by JS -->
                                    </tbody>
                                </table>

                                <!-- Sub-table 2: Salaire moyen Cadre / Non cadre -->
                                <table class="table table-bordered table-condensed rh-ratio-table" style="font-size:11px;margin-bottom:0;">
                                    <thead>
                                    <tr>
                                        <th style="background:#f5f5f5;"></th>
                                        <th class="contenuetable">Femme</th>
                                        <th class="contenuetable">Homme</th>
                                        <th class="contenuetable">Total</th>
                                        <th class="contenuetable">Ratio</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>Salaire moyen Cadre</td>
                                        <td class="text-right">1 472 235</td>
                                        <td class="text-right">1 738 937</td>
                                        <td class="text-right">1 605 586</td>
                                        <td class="text-right">0,85</td>
                                    </tr>
                                    <tr>
                                        <td>Salaire moyen non cadre</td>
                                        <td class="text-right">408 722</td>
                                        <td class="text-right">423 246</td>
                                        <td class="text-right">415 984</td>
                                        <td class="text-right">0,97</td>
                                    </tr>
                                    <tr style="font-weight:bold;">
                                        <td>Ratio cadre / non cadre</td>
                                        <td class="text-right">3,6</td>
                                        <td class="text-right">4,1</td>
                                        <td class="text-right">3,9</td>
                                        <td class="text-right">0,88</td>
                                    </tr>
                                    </tbody>
                                </table>

                            </div>
                        </div>
                    </div>
                </div>

                <!-- SECTION : SALAIRE DE SUBSISTANCE -->
                <div class="col-md-6 col-sm-12">
                    <div class="chart-title" style="text-align:center;font-size:1rem;">SALAIRE DE SUBSISTANCE</div>
                    <div class="dashboard-card-wrapper">
                        <div class="box dashboard-card">
                            <div class="box-body" style="padding:12px 14px;">

                                <!-- Header notes -->
                                <p style="font-size:11px;margin-bottom:4px;color:#2e5a2e;font-weight:600;">
                                    Salaire de subsistance =&gt; Moyenne des <u>SME</u>
                                </p>
                                <p style="font-size:11px;margin-bottom:10px;color:#c0392b;font-weight:600;">
                                    Salaire de subsistance 2024 = 404 500 ar
                                </p>

                                <!-- Salaire moyen de subsistance KPI -->
                                <div style="display:flex;align-items:baseline;gap:16px;margin-bottom:14px;border-bottom:1px solid #eee;padding-bottom:8px;">
                                    <span style="font-size:11px;font-weight:700;color:#333;">Salaire moyen de subsistance</span>
                                    <span style="font-size:13px;font-weight:700;color:#1a6060;">404 500,0</span>
                                </div>

                                <!-- Main subsistance table -->
                                <table class="table table-bordered table-condensed rh-ratio-table" style="font-size:11px;margin-bottom:10px;">
                                    <thead>
                                    <tr>
                                        <th style="background:#f5f5f5;"></th>
                                        <th class="contenuetable">Femme</th>
                                        <th class="contenuetable">Homme</th>
                                        <th class="contenuetable">Total</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>Salaire moyen Cadre</td>
                                        <td class="text-right">1 472 235</td>
                                        <td class="text-right">1 738 937</td>
                                        <td class="text-right">1 605 586</td>
                                    </tr>
                                    <tr>
                                        <td>Salaire moyen non cadre</td>
                                        <td class="text-right">408 722</td>
                                        <td class="text-right">423 246</td>
                                        <td class="text-right">415 984</td>
                                    </tr>
                                    <tr style="background:#fff8e1;">
                                        <td style="color:#c0392b;font-weight:600;">Ecart vs salaire de subsistance Cadre</td>
                                        <td class="text-right" style="color:#c0392b;">1 067 735</td>
                                        <td class="text-right" style="color:#c0392b;">1 334 437</td>
                                        <td class="text-right" style="color:#c0392b;">1 201 086</td>
                                    </tr>
                                    <tr style="background:#fff8e1;">
                                        <td style="color:#c0392b;font-weight:600;">Ecart vs salaire de subsistance Non Cadre</td>
                                        <td class="text-right" style="color:#c0392b;">4 222</td>
                                        <td class="text-right" style="color:#c0392b;">18 746</td>
                                        <td class="text-right" style="color:#c0392b;">11 484</td>
                                    </tr>
                                    </tbody>
                                </table>

                                <!-- Conclusion text -->
                                <div style="font-size:11px;color:#333;line-height:1.7;margin-top:8px;">
                                    <p style="margin-bottom:4px;">
                                        =&gt; En moyenne un Cadre Axelle gagne <strong>1 201 086 ar</strong> de plus que le salaire subsistance
                                    </p>
                                    <p style="margin-bottom:0;">
                                        =&gt; En moyenne un Non Cadre Axelle gagne <strong>11 484 ar</strong> de plus que le salaire subsistance
                                    </p>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /row 7 -->

        </section>
    </div>
</div>

<!-- ============================================================
     CHART.JS SCRIPTS
============================================================ -->

<!-- ============================================================
CHART.JS SCRIPTS
============================================================ -->
<script>
    // Récupération des données dynamiques via la Servlet Java
    fetch('${pageContext.request.contextPath}/dashboard-rh-data')
        .then(function(response) {
            if (!response.ok) throw new Error("Erreur HTTP: " + response.status);
            return response.json();
        })
        .then(function(apiData) {

            /* ==================== GRAPH 1 ==================== */
            var ctx1 = document.getElementById('graphEffectifContrat').getContext('2d');
            new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: ["1","2","3","4","5","6","7","8","9","10","11","12","Total\nResult"],
                    datasets: [
                        { label: 'JOURNALIER', data: apiData.graph1.journalier, backgroundColor: '#B8D9B0', borderColor: '#9fc895', borderWidth: 1, stack: 'stack0' },
                        { label: 'CDI', data: apiData.graph1.cdi, backgroundColor: '#C5B8E8', borderColor: '#b0a0d8', borderWidth: 1, stack: 'stack0' }
                    ]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    scales: {
                        xAxes: [{ stacked: true, gridLines: { color: 'rgba(0,0,0,0.06)' }, ticks: { fontSize: 11, fontColor: '#555' } }],
                        yAxes: [{ stacked: true, ticks: { min: 0, max: 120, stepSize: 20, fontSize: 11, fontColor: '#555', callback: function(val) { return val.toFixed(2) + '%'; } }, gridLines: { color: 'rgba(0,0,0,0.06)' } }]
                    },
                    legend: { display: false },
                    tooltips: {
                        mode: 'index',
                        callbacks: { label: function(item, data) { return data.datasets[item.datasetIndex].label + ': ' + item.yLabel.toFixed(2) + '%'; } }
                    },
                    plugins: { datalabels: false },
                    animation: {
                        onComplete: function() {
                            var ctx = this.chart.ctx;
                            ctx.font = 'bold 9px Arial'; ctx.fillStyle = '#333'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
                            this.data.datasets.forEach(function(dataset, i) {
                                var meta = this.getDatasetMeta(i);
                                meta.data.forEach(function(bar, index) {
                                    var val = dataset.data[index];
                                    var pos = bar.getCenterPoint();
                                    if (val > 3) ctx.fillText(val.toFixed(2) + ' %', pos.x, pos.y);
                                });
                            }, this);
                        }
                    }
                }
            });

            /* ==================== GRAPH 2 ==================== */
            var femmeHomme_pct = apiData.graph2.femmeHomme.map(function(v, i) { return (v / apiData.graph2.totals[i]) * 100; });
            var femme_pct = apiData.graph2.femme.map(function(v, i) { return (v / apiData.graph2.totals[i]) * 100; });

            var ctx2 = document.getElementById('graphRepartitionCDI').getContext('2d');
            new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: ['OUVRIER', 'CADRE', 'DIRECTEUR', 'Total Result'],
                    datasets: [
                        { label: 'Femme / Homme', data: femmeHomme_pct, backgroundColor: '#7BC8C8', borderColor: '#5ab0b0', borderWidth: 1, stack: 'stack0', _raw: apiData.graph2.femmeHomme },
                        { label: 'Femme', data: femme_pct, backgroundColor: '#E8A09A', borderColor: '#d08880', borderWidth: 1, stack: 'stack0', _raw: apiData.graph2.femme }
                    ]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    scales: {
                        xAxes: [{ stacked: true, gridLines: { color: 'rgba(0,0,0,0.06)' }, ticks: { fontSize: 11, fontColor: '#555' } }],
                        yAxes: [{ stacked: true, ticks: { min: 0, max: 100, stepSize: 10, fontSize: 11, fontColor: '#555', callback: function(val) { return val + '%'; } }, gridLines: { color: 'rgba(0,0,0,0.06)' } }]
                    },
                    legend: { display: false },
                    tooltips: {
                        mode: 'index',
                        callbacks: { label: function(item, data) { var ds = data.datasets[item.datasetIndex]; return ds.label + ': ' + ds._raw[item.index] + ' (' + item.yLabel.toFixed(1) + '%)'; } }
                    },
                    animation: {
                        onComplete: function() {
                            var ctx = this.chart.ctx;
                            ctx.font = 'bold 12px Arial'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
                            this.data.datasets.forEach(function(dataset, i) {
                                var meta = this.getDatasetMeta(i);
                                ctx.fillStyle = i === 0 ? '#1a6060' : '#7a2020';
                                meta.data.forEach(function(bar, index) {
                                    var raw = dataset._raw[index];
                                    if (dataset.data[index] > 5) ctx.fillText(raw, bar.getCenterPoint().x, bar.getCenterPoint().y);
                                });
                            }, this);
                        }
                    }
                }
            });

            /* ==================== GRAPH 3 ==================== */
            var ctx3 = document.getElementById('graphPyramideCDI').getContext('2d');
            new Chart(ctx3, {
                type: 'horizontalBar',
                data: {
                    labels: ['18 à 24 ans','25 à 29 ans','30 à 34 ans','35 à 39 ans','40 à 44 ans','45 à 49 ans','50 à 54 ans','55 à 59 ans','60 à 64 ans','Total Result'],
                    datasets: [
                        { label: 'Femme / Homme Femme', data: apiData.graph3.femme, backgroundColor: '#E8A09A', borderColor: '#d08880', borderWidth: 1 },
                        { label: 'Homme', data: apiData.graph3.homme, backgroundColor: '#7BC8C8', borderColor: '#5ab0b0', borderWidth: 1 }
                    ]
                },
                options: getButterflyOptions()
            });

            /* ==================== GRAPH 4 ==================== */
            var ctx4 = document.getElementById('graphPyramideJournalier').getContext('2d');
            new Chart(ctx4, {
                type: 'horizontalBar',
                data: {
                    labels: ['18 à 24 ans','25 à 29 ans','30 à 34 ans','35 à 39 ans','40 à 44 ans','45 à 49 ans','50 à 54 ans','55 à 59 ans','60 à 64 ans','65 à 99 ans','Total Result'],
                    datasets: [
                        { label: 'Femme / Homme Femme', data: apiData.graph4.femme, backgroundColor: '#E8A09A', borderColor: '#d08880', borderWidth: 1 },
                        { label: 'Homme', data: apiData.graph4.homme, backgroundColor: '#7BC8C8', borderColor: '#5ab0b0', borderWidth: 1 }
                    ]
                },
                options: getButterflyOptions()
            });

            /* ==================== GRAPH 5 ==================== */
            var ctx5 = document.getElementById('graphPyramideAnciennete').getContext('2d');
            new Chart(ctx5, {
                type: 'horizontalBar',
                data: {
                    labels: ['0 à 3 ans','3 à 6 ans','7 à 10 ans','11 à 14 ans','15 à 19 ans','20 à 24 ans','25 à 29 ans','30 à 34 ans','Err:509','Total Result'],
                    datasets: [
                        { label: 'Femme / Homme Femme', data: apiData.graph5.femme, backgroundColor: '#7BC8C8', borderColor: '#5ab0b0', borderWidth: 1 },
                        { label: 'Homme', data: apiData.graph5.homme, backgroundColor: '#E8A09A', borderColor: '#d08880', borderWidth: 1 }
                    ]
                },
                options: getButterflyOptions()
            });

            /* ==================== GRAPH 6 ==================== */
            var ctx6 = document.getElementById('graphAncienneteCategorie').getContext('2d');
            new Chart(ctx6, {
                type: 'horizontalBar',
                data: {
                    labels: ['M1 - 1A','M2 - 1B','OS1 - 2A','OS2 - 2B','OS3 - 3A','OP1A - 3B','OP1B - 4A','OP2A - 4B','OP2B - 5A','OP3 - 5B','HC','DIR','(empty)'],
                    datasets: [
                        { label: 'Femme', data: apiData.graph6.femme, backgroundColor: '#E8A09A', borderColor: '#d08880', borderWidth: 1 },
                        { label: 'Femme / Homme Homme', data: apiData.graph6.hommeHomme, backgroundColor: '#7BC8C8', borderColor: '#5ab0b0', borderWidth: 1 }
                    ]
                },
                options: { responsive: true, maintainAspectRatio: false, legend: { display: false } }
            });

            /* ==================== GRAPH 7 & 8 ==================== */
            createDoughnut('graphRepartitionHFCDI', apiData.graph7);
            createDoughnut('graphRepartitionHFJournalier', apiData.graph8);

            /* ==================== GRAPH 12 ==================== */
            var ctx12 = document.getElementById('graphSalaireCategorie').getContext('2d');
            new Chart(ctx12, {
                type: 'bar',
                data: {
                    labels: ['OUVRIER', 'CADRE', 'Total Result'],
                    datasets: [
                        { label: 'Femme / Homme Homme', data: apiData.graph12.femmeHommeHomme, backgroundColor: '#7BC8C8', borderColor: '#5ab0b0', borderWidth: 1 },
                        { label: 'Femme', data: apiData.graph12.femme, backgroundColor: '#E8A09A', borderColor: '#d08880', borderWidth: 1 }
                    ]
                },
                options: getStandardBarOptions()
            });

            /* ==================== GRAPH 13 ==================== */
            var ctx13 = document.getElementById('graphHSupCDI').getContext('2d');
            new Chart(ctx13, {
                type: 'bar',
                data: {
                    labels: ['1','2','3','4','5','6','7','8','9','10','11','12','Total\nResult'],
                    datasets: [
                        { label: 'Femme / Homme Homme', data: apiData.graph13.femmeHommeHomme, backgroundColor: '#7BC8C8', borderColor: '#5ab0b0', borderWidth: 1 },
                        { label: 'Femme', data: apiData.graph13.femme, backgroundColor: '#E8A09A', borderColor: '#d08880', borderWidth: 1 }
                    ]
                },
                options: getStandardBarOptions()
            });

            /* ==================== GRAPH 14 ==================== */
            var ancLabels14 = ['0 à 3 ans','3 à 6 ans','7 à 10 ans','11 à 14 ans','15 à 19 ans','20 à 24 ans','25 à 29 ans','30 à 34 ans','Err:509','Total Result'];
            createSalaryHBar('graphSalaireOuvrier', ancLabels14, apiData.graph14);

            /* ==================== GRAPH 15 ==================== */
            var ancLabels15 = ['0 à 3 ans','3 à 6 ans','7 à 10 ans','11 à 14 ans','15 à 19 ans','20 à 24 ans','25 à 29 ans','30 à 34 ans','Err:509'];
            createSalaryHBar('graphSalaireCadre', ancLabels15, apiData.graph15);

            /* ==================== TABLEAU RATIO (SECTION 16) ==================== */
            var tbody = document.getElementById('ratioTableBody');
            apiData.ratioRows.forEach(function(row) {
                var tr = document.createElement('tr');
                if (row[7]) { tr.style.fontWeight = 'bold'; tr.style.color = '#c0392b'; }
                var cells = [row[0], row[1], row[2], row[3], row[4], row[5], row[6]];
                cells.forEach(function(val, i) {
                    var td = document.createElement('td');
                    td.style.textAlign = i === 0 ? 'left' : 'right';
                    td.textContent = val;
                    tr.appendChild(td);
                });
                tbody.appendChild(tr);
            });

        })
        .catch(function(error) {
            console.error('Erreur lors du chargement des données du dashboard:', error);
        });

    /* ============================================================
       FONCTIONS UTILITAIRES POUR RÉDUIRE LE CODE DUPLIQUÉ
    ============================================================ */

    function getButterflyOptions() {
        return {
            responsive: true, maintainAspectRatio: false,
            scales: {
                xAxes: [{ ticks: { fontSize: 10, fontColor: '#555', callback: function(val) { return val.toLocaleString('fr-FR'); } } }],
                yAxes: [{ ticks: { fontSize: 10, fontColor: '#555' } }]
            },
            legend: { display: false },
            tooltips: {
                mode: 'index',
                callbacks: { label: function(item, data) { return data.datasets[item.datasetIndex].label + ': ' + Math.abs(item.xLabel).toLocaleString('fr-FR'); } }
            },
            animation: {
                onComplete: function() {
                    var ctx = this.chart.ctx;
                    ctx.font = 'bold 9px Arial'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
                    this.data.datasets.forEach(function(dataset, di) {
                        var meta = this.getDatasetMeta(di);
                        ctx.fillStyle = di === 0 ? '#7a2020' : '#1a6060';
                        meta.data.forEach(function(bar, index) {
                            var rawVal = dataset.data[index];
                            var displayVal = Math.abs(rawVal);
                            if (displayVal === 0) return;
                            var xPos = di === 0 ? bar._model.x + 20 : bar._model.x - 20;
                            ctx.fillText(displayVal.toLocaleString('fr-FR'), xPos, bar._model.y);
                        });
                    }, this);
                }
            }
        };
    }

    function createDoughnut(canvasId, dataArr) {
        var ctx = document.getElementById(canvasId).getContext('2d');
        new Chart(ctx, {
            type: 'doughnut',
            data: { labels: ['Femme', 'Homme', 'Total Result'], datasets: [{ data: dataArr, backgroundColor: ['#E8A09A', '#7BC8C8', '#A8C87A'], borderColor: ['#d08880', '#5ab0b0', '#8aaa58'], borderWidth: 2 }] },
            options: {
                responsive: true, maintainAspectRatio: false, cutoutPercentage: 55, legend: { display: false },
                animation: {
                    onComplete: function() {
                        var ctx = this.chart.ctx; ctx.font = 'bold 14px Arial'; ctx.textAlign = 'center'; ctx.textBaseline = 'middle';
                        var meta = this.getDatasetMeta(0); var dataset = this.data.datasets[0]; var colors = ['#7a2020', '#1a6060', '#3a5a1a'];
                        meta.data.forEach(function(arc, index) {
                            var val = dataset.data[index];
                            var midAngle = arc._model.startAngle + (arc._model.endAngle - arc._model.startAngle) / 2;
                            var radius = (arc._model.innerRadius + arc._model.outerRadius) / 2;
                            ctx.fillStyle = colors[index];
                            ctx.fillText(val + ' %', arc._model.x + Math.cos(midAngle) * radius, arc._model.y + Math.sin(midAngle) * radius);
                        });
                    }
                }
            }
        });
    }

    function getStandardBarOptions() {
        return {
            responsive: true, maintainAspectRatio: false, legend: { display: false },
            scales: {
                yAxes: [{ ticks: { beginAtZero: true, fontSize: 10, callback: function(val) { return val.toLocaleString('fr-FR'); } } }]
            },
            tooltips: {
                mode: 'index',
                callbacks: { label: function(item, data) { return data.datasets[item.datasetIndex].label + ': ' + Number(item.yLabel).toLocaleString('fr-FR'); } }
            }
        };
    }

    function createSalaryHBar(canvasId, labels, dataObj) {
        var ctx = document.getElementById(canvasId).getContext('2d');
        new Chart(ctx, {
            type: 'horizontalBar',
            data: {
                labels: labels,
                datasets: [
                    { label: 'Femme', data: dataObj.femme, backgroundColor: '#E8A09A', borderColor: '#d08880', borderWidth: 1 },
                    { label: 'Femme / Homme Homme', data: dataObj.hommeHomme, backgroundColor: '#7BC8C8', borderColor: '#5ab0b0', borderWidth: 1 }
                ]
            },
            options: {
                responsive: true, maintainAspectRatio: false, legend: { display: false },
                scales: { xAxes: [{ ticks: { beginAtZero: true, callback: function(val) { return val.toLocaleString('fr-FR'); } } }] },
                animation: {
                    onComplete: function() {
                        var ctx = this.chart.ctx; ctx.font = '9px Arial'; ctx.textBaseline = 'middle'; ctx.textAlign = 'left';
                        this.data.datasets.forEach(function(dataset, di) {
                            var meta = this.getDatasetMeta(di); ctx.fillStyle = di === 0 ? '#7a2020' : '#1a6060';
                            meta.data.forEach(function(bar, index) {
                                var val = dataset.data[index];
                                if (val) ctx.fillText(val.toLocaleString('fr-FR'), bar._model.x + 3, bar._model.y);
                            });
                        }, this);
                    }
                }
            }
        });
    }
</script>
</body>
</html>