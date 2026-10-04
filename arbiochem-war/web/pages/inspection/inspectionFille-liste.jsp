<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="machine.InspectionFilleLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="etatInspection.EtatInspection" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="org.apache.poi.ss.formula.functions.T" %>

<% try{ 
    InspectionFilleLib o = new InspectionFilleLib();
    o.setNomTable("INSPECTIONFILLELIB");
    String[] listeCrt = {"idEtatInspection","idMachineLib","idLigneLib"};
    String[] listeInt = {};
    String[] libEntete = {"idElementLib","idMachineLib","idLigneLib","id","idetatInspectionLib","remarque"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des inspections filles");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("inspection/inspectionFille-liste.jsp");
    
    Liste[] liste = new Liste[2];
    EtatInspection liste0 = new EtatInspection();
    liste0.setNomTable("ETATINSPECTION");
    liste[0] = new Liste("idEtatInspection",liste0,"val","id");
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("ligne");
    liste[1] = new Liste("idLigneLib",liste1,"val","id");

    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("idEtatInspection").setLibelle("&Eacute;tat d'inspection");
    pr.getFormu().getChamp("idMachineLib").setLibelle("Machine");
    pr.getFormu().getChamp("idLigneLib").setLibelle("Ligne");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=inspection/inspectionFille-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"&Eacute;l&eacute;ment","Machine","Ligne","Id","&Eacute;tat d'inspection","Remarque"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

