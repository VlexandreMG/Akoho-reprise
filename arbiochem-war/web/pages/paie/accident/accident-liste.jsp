<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.accident.AccidentLib" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="machine.Machine" %>

<% try{ 
    AccidentLib o = new AccidentLib();
    o.setNomTable("V_ACCIDENT_LIB");
    String[] listeCrt = {"id","id_personnel_lib","matricule","id_lieu_lib","id_type_accident_lib","id_gravite_lib", "id_Machine", "daty"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","id_personnel_lib","matricule","id_type_accident_lib","id_gravite_lib","id_lieu_lib","id_machine_lib","daty"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des accidents");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/accident/accident-liste.jsp");
    Liste[] liste = new Liste[3];
    TypeObjet typeAccident = new TypeObjet();
    typeAccident.setNomTable("type_accident");
    liste[0] = new Liste("id_type_accident_lib",typeAccident,"val","val");
    TypeObjet gravite = new TypeObjet();
    gravite.setNomTable("gravite_accident");
    liste[1] = new Liste("id_gravite_lib", gravite, "val", "val");
    Machine machine = new Machine();
    liste[2] = new Liste("id_Machine", machine, "val", "id");

    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("id_lieu_lib").setLibelle("Lieu");
    pr.getFormu().getChamp("id_type_accident_lib").setLibelle("Type d'accident");
    pr.getFormu().getChamp("id_gravite_lib").setLibelle("Gravit&eacute;");
    pr.getFormu().getChamp("id_personnel_lib").setLibelle("Nom du personnel");
    pr.getFormu().getChamp("id_Machine").setLibelle("Machine");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour() + "");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour() + "");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Nom du personnel","Matricule","Type d'accident","Gravit&eacute;","Lieu","Machine","Date"};

    String lienTableau[] = {pr.getLien() + "?but=paie/accident/accident-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
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

