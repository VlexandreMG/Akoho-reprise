<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="compteur.CompteurElectriciteMereLib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="machine.Ligne" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{ 
    CompteurElectriciteMereLib o = new CompteurElectriciteMereLib();
    o.setNomTable("COMPTEURELECTRICITEMERELIB");
    String[] listeCrt = {"daty","ligne"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","daty","lignelib", "consommation", "etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("compteur/releve-electricite-multiple-liste.jsp");

    String [] val = new String[]{"%","1","11", "3","0"};
    String [] aff = new String[]{"Tous","Cr&eacute;&eacute;","Vis&eacute; par Chef de Fabrication", "Vis&eacute; par Releveur","Annul&eacute;"};
    
    Liste[] liste = new Liste[1];
    Ligne liste0 = new Ligne();
    liste0.setNomTable("LIGNE");
    liste[0] = new Liste("ligne",liste0,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.getDebutSemaineString());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.getFinSemaineString());
    pr.getFormu().getChamp("ligne").setLibelle("Ligne");

    System.out.println("request.getParameter(\"etat\") : "+request.getParameter("etat"));
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        if (request.getParameter("etat").equalsIgnoreCase("%")) pr.setAWhere(" ");
        else pr.setAWhere(" and etat=" + request.getParameter("etat")+" ");
    }


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] libEnteteAffiche = {"ID","Date","Ligne", "Consommation", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String lienTableau[] = {pr.getLien() + "?but=compteur/releve-electricite-multiple-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    pr.getTableau().setLienFille("compteur/inc/releve-electricite-detail.jsp&id=");

    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=compteur/releve-electricite-multiple-saisie.jsp&currentMenu=MENDYN1781507344256825\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un relev&eacute;</a>"
    );
%>
<script>
    function changerDesignation() {
        document.comptelec.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="comptelec">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-4">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <% for( int i = 0; i < aff.length; i++ ){ %>
                        <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(val[i]) == 0) {%>
                        <option value="<%= val[i] %>" selected> <%= aff[i] %> </option>
                        <% } else { %>
                        <option value="<%= val[i] %>"> <%= aff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
                <div class="col-md-4"></div>
            </div>
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
<% }%>

