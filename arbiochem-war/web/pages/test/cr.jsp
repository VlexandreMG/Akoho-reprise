<%@ page import="rapport.CRJournalier" %>
<%@ page import="java.sql.Date" %>
<%@ page import="utilitaire.Utilitaire" %><%--
  Created by IntelliJ IDEA.
  User: fitia
  Date: 18/07/2026
  Time: 11:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

</body>
</html>

<%
    String hebdo = request.getParameter("hebdo");
    String jour = request.getParameter("jour");

    CRJournalier crJournalier = new CRJournalier();

    try {
        if (hebdo!=null && hebdo.compareToIgnoreCase("true")==0){
            Date dateFin = Date.valueOf("2026-07-17");
            Date dateDebut = utilitaire.Utilitaire.ajoutJourDate(dateFin,-4);

            System.out.println(
                    "Envoi du CR hebdomadaire terminé : "
                            + dateDebut
                            + " au "
                            + dateFin
            );

            crJournalier.sendPageEmailHebdomadaire(
                    dateDebut,
                    dateFin
            );

            Date dateFin2 = Date.valueOf("2026-07-10");
            Date dateDebut2 = utilitaire.Utilitaire.ajoutJourDate(dateFin2,-4);

            System.out.println(
                    "Envoi du CR hebdomadaire terminé : "
                            + dateDebut2
                            + " au "
                            + dateFin2
            );

            crJournalier.sendPageEmailHebdomadaire(
                    dateDebut2,
                    dateFin2
            );
        }
        if (jour!=null && jour.compareToIgnoreCase("true")==0){
            crJournalier.sendPageEmail(Date.valueOf("2026-07-14"));
            crJournalier.sendPageEmail(Date.valueOf("2026-07-15"));
            crJournalier.sendPageEmail(Date.valueOf("2026-07-16"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    System.out.println("Envoi terminé ");
%>