<%@page import="inventaire.InventaireLib"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="magasin.Magasin"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@page import="user.UserEJB"%>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    Magasin mag = u.getMagasin();
    InventaireLib inventaire = new InventaireLib();
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        inventaire.setNomTable(request.getParameter("etat"));
    }else{
        inventaire.setNomTable("INVENTAIRELIB");
    }
    
    String listeCrt[] = {"id","designation","daty","idMagasin"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","heure","designation",  "montantQuantite","idMagasinlib","remarque","etatlib"};

    PageRecherche pr = new PageRecherche(inventaire, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(mag != null){
        pr.setAWhere("AND IDMAGASIN='"+mag.getId()+"'");
    }

    Liste[] listes = new Liste[1];
    listes[0] = new Liste("idMagasin", new Magasin(), "val", "id");

    pr.setTitre("Liste des inventaires");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("inventaire/inventaire-liste.jsp");
    pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    if(mag != null){
        pr.getFormu().getChamp("idMagasin").setAutre("disabled");
        pr.getFormu().getChamp("idMagasin").setDefaut(mag.getId());
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=inventaire/inventaire-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=inventaire/inventaire-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Date","Heure","D&eacute;signation","Valeur Quantit&eacute;","Magasin","Remarque","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("inventaire/inventairefille-liste.jsp&id=");
        pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=inventaire/inventaire-saisie.jsp&currentMenu=MNDN000000021\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un inventaire</a>"
    );
%>
<script>
    function changerDesignation() {
        document.invliste.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="invliste"  id="invliste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" >
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("INVENTAIRELIB") == 0) {%>
                        <option value="INVENTAIRELIB" selected>Tous</option>
                        <% } else { %>
                        <option value="INVENTAIRELIB" >Tous</option>
                        <% } %>
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("INVENTAIRELIB_CREE") == 0) {%>
                        <option value="INVENTAIRELIB_CREE" selected>Cr&eacute;&eacute;(s)</option>
                        <% } else { %>
                        <option value="INVENTAIRELIB_CREE">Cr&eacute;&eacute;(s)</option>
                        <% } %>
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("INVENTAIRELIB_VALIDEE") == 0) {%>
                        <option value="INVENTAIRELIB_VALIDEE" selected>Valid&eacute;(s)</option>
                        <% } else { %>
                        <option value="INVENTAIRELIB_VALIDEE">Valid&eacute;(s)</option>
                        <% } %>
                        <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("INVENTAIRELIB_ANNULEE") == 0) {%>
                        <option value="INVENTAIRELIB_ANNULEE" selected>Annul&eacute;(s)</option>
                        <% } else { %>
                        <option value="INVENTAIRELIB_ANNULEE">Annul&eacute;(s)</option>
                        <% } %>
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



