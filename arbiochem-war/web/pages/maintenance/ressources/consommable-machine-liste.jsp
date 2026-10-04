<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.ressources.ConsommableMachineLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<% try{ 
    ConsommableMachineLib o = new ConsommableMachineLib();
    o.setNomTable("CONSOMMABLEMACHINELIB");
    String[] listeCrt = {"id","idMachineLib","idConsommableLib","qte","idTypeMaintenance","frequence"};
    String[] listeInt = {};
    String[] libEntete = {"id","idMachineLib","idTypeMaintenanceLib","qte","idUniteLib","frequenceLib","idConsommableLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste de Consommable Machine");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/ressources/consommable-machine-liste.jsp");

    Liste[] liste = new Liste[2];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("TYPEMAINTENANCE");
    liste[0] = new Liste("idTypeMaintenance",liste0,"val","id");
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("UNITEMAINTENANCE");
    liste[1] = new Liste("frequence",liste1,"val","id");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("frequence").setLibelle("Fr&eacute;quence");
    pr.getFormu().getChamp("idTypeMaintenance").setLibelle("Type de maintenance");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idMachineLib").setLibelle("Machine");
    pr.getFormu().getChamp("idConsommableLib").setLibelle("Consommable");
    pr.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    
    String[] colSomme = {"qte"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme des quantit&eacute;s"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=maintenance/ressources/consommable-machine-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Machine","Type de maintenance","Quantit&eacute;","Unit&eacute;","Fr&eacute;quence","Consommable"};
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

