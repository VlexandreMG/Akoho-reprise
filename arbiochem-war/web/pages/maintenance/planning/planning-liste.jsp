<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.configuration.TypeMaintenance" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.*" %>
<%@ page import="maintenance.planning.PlanningCpl" %>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>

<% try{
    PlanningCpl t = new PlanningCpl();
    String listeCrt[] = {"id","refObjet","idTypeMaintenance","idMachine","datedebut","frequence","estPeriodique","etat","uniteLib", "idLigne", "idSituation"};
    String listeInt[] = {"datedebut","frequence"};
    String libEntete[] = {"id","refObjet","idTypeMaintenanceLib","idMachineLib","datedebut","duree","frequence","uniteLib","estPeriodiqueLib","idLigneLib","idSituationLib","etatLib"};
    String libEnteteAffiche[] = {"ID","Description","Type de maintenance","&Eacute;l&eacute;ment","Date de d&eacute;but","Dur&eacute;e","Fr&eacute;quence","Unit&eacute;","Est p&eacute;riodique","Ligne","Situation","&Eacute;tat"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des plannings");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/planning/planning-liste.jsp");

    Liste[] liste = new Liste[7];
    TypeMaintenance c = new TypeMaintenance();
    liste[0] = new Liste("idTypeMaintenance",c,"val","id");
    String[] etatValP = {"","0","1"};
    String[] etatAffP = {"Tous","NON", "OUI"};
    liste[1] = new Liste("estPeriodique",etatAffP,etatValP);
    String[] etatVal = {"","1","11"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;", "Valid&eacute;"};
    liste[2] = new Liste("etat",etatAff,etatVal);
    TypeObjet unite = new TypeObjet();
    unite.setNomTable("UNITEMAINTENANCE");
    liste[3] = new Liste("uniteLib",unite,"val","val");
    IngredientMaintenance im= new IngredientMaintenance("AS_INGREDIENT_MACHINE");
    liste[4] = new Liste("idMachine", im, "libelle", "id");
    liste[5] = new Liste("idLigne",   new TypeObjet("ligne"), "val", "id");
    liste[5].setDeroulanteDependante(liste[4],"idligne","onchange");
    liste[6] = new Liste("idSituation",   new TypeObjet("situation"), "val", "id");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("refObjet").setLibelle("Description");
    pr.getFormu().getChamp("uniteLib").setLibelle("Unit&eacute;");
    pr.getFormu().getChamp("idMachine").setLibelle("&Eacute;l&eacute;ment");
    pr.getFormu().getChamp("idTypeMaintenance").setLibelle("Type de maintenance");
    pr.getFormu().getChamp("frequence1").setLibelle("Fr&eacute;quence min");
    pr.getFormu().getChamp("frequence2").setLibelle("Fr&eacute;quence max");
    pr.getFormu().getChamp("datedebut1").setLibelle("Date de d&eacute;but min");
    pr.getFormu().getChamp("datedebut2").setLibelle("Date de d&eacute;but max");
    pr.getFormu().getChamp("estPeriodique").setLibelle("Est p&eacute;riodique");
    pr.getFormu().getChamp("idLigne").setLibelle("Ligne");
    pr.getFormu().getChamp("idSituation").setLibelle("Situation");
    pr.getFormu().getChamp("etat").setLibelle("&Eacute;tat");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=maintenance/planning/planning-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/planning/planning-saisie.jsp&currentMenu=MNDNMT0127\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir une maintenance planifi&eacute;e" +
            "                </a>"
    );

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



