<%@ page import="java.util.Map" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="paie.accident.Accident" %>
<%@ page import="maintenance.ressources.Machine" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="paie.demande.DemandeJustifications" %>
<%@ page import="bean.TypeObjet" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Chargement de Chart.js depuis CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<%
    String typeAbsence = request.getParameter("typeAbsence");
    String typeDep = request.getParameter("typeDep");
    String dateDebutParam = request.getParameter("dateDebut");
    String dateFinParam = request.getParameter("dateFin");


    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    java.util.Calendar cal = java.util.Calendar.getInstance();
    String dateFinDefaut = sdf.format(cal.getTime()); // Date actuelle
    cal.add(java.util.Calendar.DAY_OF_MONTH, -30); // 30 jours avant
    String dateDebutDefaut = sdf.format(cal.getTime());

    if(dateDebutParam == null || dateDebutParam.trim().isEmpty()) {
        dateDebutParam = dateDebutDefaut;
    }
    if(dateFinParam == null || dateFinParam.trim().isEmpty()) {
        dateFinParam = dateFinDefaut;
    }

    // Conversion sécurisée des dates
    java.sql.Date dateDebut = null;
    java.sql.Date dateFin = null;
    String errorMessage = null;

    try {
        // Validation du format avant conversion
        if(dateDebutParam.matches("\\d{4}-\\d{2}-\\d{2}")) {
            dateDebut = java.sql.Date.valueOf(dateDebutParam);
        } else {
            throw new IllegalArgumentException("Format de date début invalide: " + dateDebutParam);
        }

        if(dateFinParam.matches("\\d{4}-\\d{2}-\\d{2}")) {
            dateFin = java.sql.Date.valueOf(dateFinParam);
        } else {
            throw new IllegalArgumentException("Format de date fin invalide: " + dateFinParam);
        }
    } catch(IllegalArgumentException e) {
        errorMessage = "Format de date invalide. Utilisez le format YYYY-MM-DD (ex: 2026-02-17). Erreur: " + e.getMessage();
        dateDebutParam = dateDebutDefaut;
        dateFinParam = dateFinDefaut;
        try {
            dateDebut = java.sql.Date.valueOf(dateDebutDefaut);
            dateFin = java.sql.Date.valueOf(dateFinDefaut);
        } catch(Exception ex) {
            // Fallback ultime
            dateDebut = new java.sql.Date(System.currentTimeMillis());
            dateFin = new java.sql.Date(System.currentTimeMillis());
        }
    }




    DemandeJustifications accident = null;
    Map<String, Integer> dataMap = null;
    String chartTitle = "";
    String chartLabel = "";

    try {
        accident = new DemandeJustifications();
        accident.setNomTable("demande_libcomplet");

        dataMap = accident.getNombreAbsenceTypeDepartementPeriode(typeAbsence, typeDep, dateDebut, dateFin);

        StringBuilder titleBuilder = new StringBuilder("Nombre d'absences");
        if(typeAbsence != null && !typeAbsence.isEmpty()) {
            titleBuilder.append(" - Type: ").append(typeAbsence);
        }
        if(typeDep != null && !typeDep.isEmpty()) {
            titleBuilder.append(" - Département: ").append(typeDep);
        }
        titleBuilder.append(" (").append(dateDebutParam).append(" au ").append(dateFinParam).append(")");
        chartTitle = titleBuilder.toString();

        chartLabel = "Nombre d'absences (en jours)";
    } catch(java.sql.SQLException sqle) {
        sqle.printStackTrace();
        if(errorMessage == null || errorMessage.isEmpty()) {
            errorMessage = "Erreur de base de données: " + sqle.getMessage();
        } else {
            errorMessage += " | Erreur SQL: " + sqle.getMessage();
        }
    } catch(Exception e) {
        e.printStackTrace();
        if(errorMessage == null || errorMessage.isEmpty()) {
            errorMessage = "Erreur lors de la récupération des données: " + e.getMessage();
        } else {
            errorMessage += " | Erreur: " + e.getMessage();
        }
    }

    // Préparer les données pour Chart.js
    StringBuilder labelsJs = new StringBuilder("[");
    StringBuilder dataJs = new StringBuilder("[");
    boolean first = true;

    if(dataMap != null && !dataMap.isEmpty()) {
        for(Map.Entry<String, Integer> entry : dataMap.entrySet()) {
            if(!first) {
                labelsJs.append(",");
                dataJs.append(",");
            }
            labelsJs.append("'").append(entry.getKey()).append("'");
            dataJs.append(entry.getValue());
            first = false;
        }
    }
    labelsJs.append("]");
    dataJs.append("]");
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Nombre d'absences par type et département sur une période</h1>
    </section>
    <section class="content">
        <%
            if(errorMessage != null && !errorMessage.isEmpty()) {
        %>
        <div class="alert alert-warning alert-dismissible">
            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
            <h4><i class="icon fa fa-warning"></i> Attention!</h4>
            <%= errorMessage %>
        </div>
        <%
            }
        %>


        <form action="<%=session.getAttribute("lien")%>?but=paie/demande/tauxabsenteisme-graphe.jsp" method="post" id="accident-form">
            <div class="row">
                <div class="col-md-12">
                    <div class="form-inline" style="display:flex; gap:10px; align-items:flex-end; flex-wrap:wrap;">


                        <div class="form-group">
                            <label for="idMachine" style="margin-right:5px;">Type d'absence:</label>
                            <select class="form-control" name="typeAbsence" id="idMachine">
                                <option value="">Tous</option>
                                <%
                                    try {
                                        TypeObjet typeAbsencet= new TypeObjet();
                                        typeAbsencet.setNomTable("TYPEABSENCE");
                                        TypeObjet[] typeAbesences = (TypeObjet[]) CGenUtil.rechercher(typeAbsencet, null, null, "");
                                        if(typeAbesences != null) {
                                            for(TypeObjet m : typeAbesences) {
                                %>
                                <option value="<%= m.getId() %>" <%= (typeAbsence != null && typeAbsence.equals(m.getId())) ? "selected" : "" %>>
                                    <%= m.getDesce() %>
                                </option>
                                <%
                                            }
                                        }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="idMachine" style="margin-right:5px;">Type d&eacute;partement :</label>
                            <select class="form-control" name="typeDep" id="typeDep">
                                <option value="">Tous</option>
                                <%
                                    try {
                                        TypeObjet typedepObj = new TypeObjet();
                                        typedepObj.setNomTable("DEPARTEMENT");
                                        TypeObjet[] typedeps = (TypeObjet[]) CGenUtil.rechercher(typedepObj, null, null, "");
                                        if(typedeps != null) {
                                            for(TypeObjet m : typedeps) {
                                %>
                                <option value="<%= m.getId() %>" <%= (typeDep != null && typeDep.equals(m.getId())) ? "selected" : "" %>>
                                    <%= m.getDesce() %>
                                </option>
                                <%
                                            }
                                        }
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="dateDebut" style="margin-right:5px;">Date Début:</label>
                            <input type="date" class="form-control" name="dateDebut" id="dateDebut" value="<%= dateDebutParam %>">
                        </div>

                        <div class="form-group">
                            <label for="dateFin" style="margin-right:5px;">Date Fin:</label>
                            <input type="date" class="form-control" name="dateFin" id="dateFin" value="<%= dateFinParam %>">
                        </div>

                        <div class="form-group" style="margin-left:auto;">
                            <button type="submit" class="btn btn-primary">Filtrer</button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <br>
        <br>
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><%= chartTitle %></h3>
                    </div>
                    <div class="box-body" style="height:420px;">
                        <%
                            if(dataMap == null || dataMap.isEmpty()) {
                        %>
                        <div class="alert alert-info" style="margin-top:150px; text-align:center;">
                            <h4><i class="icon fa fa-info"></i> Aucune donnée disponible</h4>
                            <p>Aucun absence n'a été trouvé pour les critères sélectionnés.</p>
                        </div>
                        <%
                        } else {
                        %>
                        <canvas id="chart-accidents" style="height:100%;"></canvas>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script>
    (function(){
        console.log('=== DEBUG Chart.js ===');
        console.log('typeof Chart:', typeof Chart);
        console.log('Labels:', <%= labelsJs.toString() %>);
        console.log('Data:', <%= dataJs.toString() %>);

        <% if(dataMap != null && !dataMap.isEmpty()) { %>
        var ctx = document.getElementById('chart-accidents');
        console.log('Canvas element:', ctx);

        if(ctx) {
            try {
                ctx = ctx.getContext('2d');
                console.log('Canvas context:', ctx);

                var chart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: <%= labelsJs.toString() %>,
                        datasets: [{
                            label: "<%= chartLabel %>",
                            data: <%= dataJs.toString() %>,
                            backgroundColor: 'rgba(54, 162, 235, 0.6)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1
                                }
                            }
                        },
                        plugins: {
                            legend: { display: true },
                            title: {
                                display: true,
                                text: "<%= chartTitle %>"
                            }
                        }
                    }
                });
                console.log('Chart created successfully:', chart);
            } catch(error) {
                console.error('Erreur lors de la création du graphique:', error);
            }
        } else {
            console.error('Canvas element not found!');
        }
        <% } else { %>
        console.log('Pas de données à afficher');
        <% } %>
    })();
</script>

