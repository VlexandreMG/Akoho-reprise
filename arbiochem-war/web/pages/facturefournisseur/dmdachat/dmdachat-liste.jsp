<%@page import="affichage.PageRecherche"%>
<%@ page import="faturefournisseur.DmdAchatLib" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="bean.*" %>

<% try{
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));
    String[] traiteVal = {"","0","1","2","3"};
    String[] traiteAff = {"Tous","Non Trait&eacute;", "Trait&eacute; Partiellement","Trait&eacute;","Trait&eacute; avec surplus"};
    
    String[] etatVal = {"","1","11","3","4","0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "VIS&Eacute;(e) par Responsable achat", " VIS&Eacute;(E) par Chef de Fabrication","VIS&Eacute;(E) par Le Directeur","Annul&eacute;e(s)"};
    DmdAchatLib o = new DmdAchatLib();
    o.setNomTable("DMDACHATLIB_TRAITE");
    String[] listeCrt = {"id","daty","fournisseurlib","remarque","idMagasinLib","idCategorieLib","idServiceLib","idProvenance"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id", "daty","fournisseurlib","remarque","idMagasinLib","idCategorieLib", "idServiceLib","traite","idProvenanceLib","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt,4, libEntete, libEntete.length);

    pr.setTitre("Liste des demandes d'achat");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("facturefournisseur/dmdachat/dmdachat-liste.jsp");
    String awhere = "";
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        awhere +=  " and etat="+request.getParameter("etat");
    }
    System.out.println("traite===="+request.getParameter("traite"));
    if(request.getParameter("traite")!=null && request.getParameter("traite").compareToIgnoreCase("")!=0) {
        awhere +=  " and idtraite = '"+request.getParameter("traite")+"'";
    }
    System.out.println("awhere===="+awhere);
    pr.setAWhere(awhere);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("fournisseurlib").setLibelle("Fournisseur");
    pr.getFormu().getChamp("idServiceLib").setLibelle("D&eacute;partement");
    

    Liste[] listes = new Liste[3];
    Magasin magasin = new Magasin();
    magasin.setNomTable("MAGASIN2");
    listes[0] = new Liste("idMagasinLib", magasin, "val", "val");
    CategorieIngredient categorieIngredient = new CategorieIngredient();
    categorieIngredient.setNomTable("CATEGORIEINGREDIENT");
    listes[1] = new Liste("idCategorieLib", categorieIngredient, "val", "val");
    TypeObjet prov = new TypeObjet();
    prov.setNomTable("PROVENANCE");
    listes[2] = new Liste("idProvenance", prov, "val", "id");
    pr.getFormu().changerEnChamp(listes);

    pr.getFormu().getChamp("idMagasinLib").setLibelle("Magasin");
    pr.getFormu().getChamp("idCategorieLib").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("remarque").setLibelle("Fournisseur s&eacute;condaire");
    pr.getFormu().getChamp("idProvenance").setLibelle("Provenance");

    String[] colSomme = null;

    pr.setNpp(50);

    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=facturefournisseur/dmdachat/dmdachat-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setLienFille("facturefournisseur/dmdachat/inc/dmdachat-details.jsp&id=");
    pr.getTableau().setColonneLien(colonneLien);

    String[] libEnteteAffiche = {"ID", "Date","Fournisseur","Fournisseur s&eacute;condaire","Magasin","Cat&eacute;gorie", "D&eacute;partement","Traite","Provenance","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=facturefournisseur/dmdachat/dmdachat-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une demande d'achat</a>"
    );

%>
<script>
    function changerDesignation() {
        document.getElementById("dmd-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="dmd-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
           
            <div class="row col-md-12 nopadding" style="margin-top: 12px">
                <div class="col-md-2 nopadding">
                    <label class="input-label" for="etat">&Eacute;tat :</label>
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
                <div class="col-md-2 nopadding">
                    <label class="input-label" for="etat">Trait&eacute; :</label>
                    <select name="traite" class="champ form-control" id="traite" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < traiteAff.length; i++ ){ %>
                        <% if(request.getParameter("traite") !=null && request.getParameter("traite").compareToIgnoreCase(traiteVal[i]) == 0) {%>
                        <option value="<%= traiteVal[i] %>" selected> <%= traiteAff[i] %> </option>
                        <% } else { %>
                        <option value="<%= traiteVal[i] %>"> <%= traiteAff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
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
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>