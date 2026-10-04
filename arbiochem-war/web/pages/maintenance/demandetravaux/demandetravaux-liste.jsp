<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="maintenance.configuration.Situation" %>
<%@ page import="affichage.Liste" %>
<%@ page import="maintenance.ressources.Machine" %>
<%@ page import="maintenance.planning.DemandeTravauxCpl" %>
<%@ page import="maintenance.ressources.DepartementMaintenance" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    DemandeTravauxCpl t = new DemandeTravauxCpl();
    if ("true".equals(request.getParameter("fromAnalyse"))) {
        t.setNomTable("DEMANDETRAVAUX_CPL_NOMBRE");
    }
    String listeCrt[] = {"id","description","idMachineLib","idSituation","daty","dateBesoin","prioriteLib","estExistant","idDepartement","idTypeMaintenance"};
    String listeInt[] = {"daty","dateBesoin"};
    String libEntete[] = {"id","description","daty","dateBesoin","idMachineLib","idSituationLib","idDepartementLib","prioriteLib","estExistantLib","idTypeMaintenanceLib","etatLib"};
    String libEnteteAffiche[] = {"ID","Description","Date de la demande","Date de besoin","&Eacute;l&eacute;ment","Situation","D&eacute;partement","Priorit&eacute;","Probl&egrave;me d&eacute;j&agrave; rencontr&eacute;","Type de maintenance","&Eacute;tat"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des demandes de travaux");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/demandetravaux/demandetravaux-liste.jsp");

    Liste[] liste = new Liste[5];
//    Entite c = new Entite();
//    liste[0] = new Liste("idEntite",c,"val","id");
    liste[0] = new Liste("idTypeMaintenance",new TypeObjet("TYPEMAINTENANCE"),"val","id");
    Situation c2 = new Situation();
    liste[1] = new Liste("idSituation",c2,"val","id");
    liste[2] = new Liste("estExistant");
    liste[2].makeListeOuiNon();
    DepartementMaintenance c4 = new DepartementMaintenance();
    liste[3] = new Liste("idDepartement",c4,"val","id");
    liste[4] = new Liste("prioriteLib",new TypeObjet("priorite"),"val","val");
    pr.getFormu().changerEnChamp(liste);
    if (request.getParameter("etat") != null) {
        System.out.println("etat==="+request.getParameter("etat"));
        if(request.getParameter("etat").compareToIgnoreCase("") != 0)pr.setAWhere(" and etat="+request.getParameter("etat"));
    }

    pr.getFormu().getChamp("idTypeMaintenance").setLibelle("Type de maintenance");
//    pr.getFormu().getChamp("idEntite").setLibelle("Entit&eacute;");
    pr.getFormu().getChamp("idMachineLib").setLibelle("&Eacute;l&eacute;ment");
    pr.getFormu().getChamp("idSituation").setLibelle("Situation");
    pr.getFormu().getChamp("daty1").setLibelle("Date de la demande du");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.getDebutSemaineString());
    pr.getFormu().getChamp("daty2").setLibelle("Date de la demande au");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.getFinSemaineString());
    pr.getFormu().getChamp("dateBesoin1").setLibelle("Date de besoin min");
    pr.getFormu().getChamp("dateBesoin2").setLibelle("Date de besoin max");
    pr.getFormu().getChamp("prioriteLib").setLibelle("Priorit&eacute;");
    pr.getFormu().getChamp("estExistant").setLibelle("Probl&egrave;me d&eacute;j&agrave; rencontr&eacute;");
    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement de maintenance ");


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=maintenance/demandetravaux/demandetravaux-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/demandetravaux/demandetravaux-saisie.jsp&currentMenu=MNDNMT0126\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir une demande de travaux" +
            "                </a>"
    );
    String[] etatVal = {"","1","11"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Valid&eacute;e(s)"};
%>
<script>
    function changerDesignation() {
        document.getElementById("bdlc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" id="bdlc-liste--form" >
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding  ">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                        <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                        <% } else { %>
                        <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
            </div>
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



