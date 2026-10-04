<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 29/07/2026
  Time: 16:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="maintenance.ressources.OfNonRattache" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@page import="affichage.*"%>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="fabrication.FabricationFille" %>

<% try{
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));
    FabricationFille o = new FabricationFille();
    o.setNomTable("FABRICATIONFILLEPETRI");
    String[] listeCrt = {"id","daty","libelle","idLigne"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","daty","idIngredients","libelle","qte","Ligne"};

    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des Fabrications de Petri");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idLigne").setLibelle("Ligne");
    pr.getFormu().getChamp("libelle").setLibelle("Produit");

    Liste[] listeDeroulante=new Liste[1];
    listeDeroulante[0]=new Liste("idLigne",new bean.TypeObjet("LIGNE"),"val","id");
    pr.getFormu().changerEnChamp(listeDeroulante);

    String datyString = request.getParameter("date");
    if (datyString != null && !datyString.isEmpty())
    {
        LocalDate date = LocalDate.parse(datyString).minusDays(1);
        String formatted = date.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        pr.getFormu().getChamp("daty1").setDefaut(formatted);
        pr.getFormu().getChamp("daty2").setDefaut(formatted);
    }


    String[] colSomme = null;
    if(request.getParameter("idligne") != null && request.getParameter("idCompteur") != null){
        pr.setAWhere(" and idligne='"+request.getParameter("idligne")+"'");
        String apres = "&idligne="+request.getParameter("idligne") + "&idCompteur="+request.getParameter("idCompteur");
        pr.setApres("maintenance/ressources/fabrication-petri.jsp"+apres);
    }

    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=fabrication/fabrication-fiche.jsp",pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id","idIngredients"};
    String valLien[] = {"idMere","idIngredients"};
    String varColonneLien[] = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setValeurLien(valLien);
    pr.getTableau().setAttLien(varColonneLien);
    pr.getTableau().setColonneLien(colonneLien);

    String[] libEnteteAffiche = {"ID","Date","ID Produit","Produit","Quantit&eacute;","Ligne"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);


%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>

    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="dmd-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <% if(pr.getTableau().getHtmlWithCheckbox() != null){ %>
        <form action="<%=pr.getLien()%>?but=maintenance/ressources/apresRattachementFab.jsp" method="post" name="paye" id="paye">
            <input type="hidden" value="<%=request.getParameter("idCompteur")%>" name="idCompteur" id="idCompteur">
            <%
                pr.getTableau().setNameBoutton("Rattacher");
                pr.getTableau().setNameActe("rattacher");
                out.println(pr.getTableau().getHtmlWithCheckbox());
                out.println(pr.getBasPage());
            %>
        </form>
    </section>
    <% }if(pr.getTableau().getHtmlWithCheckbox() == null)
    {
    %><center><h4>Aucune donn&eacute;e disponible</h4></center><%
    } %>
</div>
<script>
    function changerDesignation() {
        document.liste.submit();
    }
</script>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

