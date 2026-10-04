<%@page import="faturefournisseur.As_BonDeCommande"%><%-- Importe la classe As_BonDeCommande : modèle métier (entité) représentant un bon de commande fournisseur ; c'est la classe "mère" dont hérite As_BonDeCommandeCpl utilisée plus bas. --%>
<%@page import="affichage.PageRecherche"%><%-- Importe la classe PageRecherche : outil du framework qui génère une page de liste/recherche (formulaire de filtres + tableau des résultats + pagination + récapitulatif). --%>
<%@page import="bean.TypeObjet"%><%-- Importe la classe TypeObjet : bean générique servant à charger une table de références ; ici il alimente la liste déroulante des modes de paiement (table MODEPAIEMENT). --%>
<%@page import="affichage.Liste"%><%-- Importe la classe Liste : permet de transformer un champ de formulaire en liste déroulante (menu select) alimentée par une source de données. --%>
<%@ page import="java.util.Map" %><%-- Importe l'interface Java standard java.util.Map : collection clé/valeur ; sert ici à déclarer la variable lienTab (menu clic droit du tableau). --%>
<%@ page import="java.util.HashMap" %><%-- Importe la classe Java standard java.util.HashMap : implémentation concrète de Map ; sert ici à instancier lienTab (new HashMap()). --%>
<%@ page import="faturefournisseur.As_BonDeCommandeCpl" %><%-- Importe la classe As_BonDeCommandeCpl : version "complétée" du bon de commande (hérite de As_BonDeCommande) avec des champs supplémentaires (libellés, montants, état, livraison) ; c'est l'objet réellement utilisé pour construire la liste. --%>

<% try{
    String[] etatVal = {"","1","11","0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Vis&eacute;e(s)","Annul&eacute;e(s)"};
    
    String[] etatValLiv = {"","0","1","2","3"};
    String[] etatAffLiv = {"Tous","Non Trait&eacute;","Trait&eacute; partiellement", "Trait&eacute;","Trait&eacute; avec surplus"};
    As_BonDeCommandeCpl f = new As_BonDeCommandeCpl();
    f.setNomTable("As_BonDeCommande_MERETRAITE ");
    String listeCrt[] = {"id","daty","designation","fournisseurlib","modepaiementlib","reference","refproforma"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","reference","designation","modepaiementlib","fournisseurlib", "idServiceLib","refproforma","etatlib","traite"};
    PageRecherche pr = new PageRecherche(f, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de commande fournisseur");
    String awhere = "";
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        awhere += " and etat=" + request.getParameter("etat");
    }
    if(request.getParameter("livraison")!=null && request.getParameter("livraison").compareToIgnoreCase("")!=0) {
        awhere += " and idtraite= '"+request.getParameter("livraison")+"'";
    }
    pr.setAWhere(awhere);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("bondecommande/bondecommande-arbiochem-liste.jsp");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence"); 
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation"); 
    pr.getFormu().getChamp("fournisseurlib").setLibelle("Fournisseur");
    pr.getFormu().getChamp("refproforma").setLibelle("R&eacute;f&eacute;rence proforma");

    TypeObjet modePaiement= new TypeObjet();
    modePaiement.setNomTable("MODEPAIEMENT");
    Liste[] liste = new Liste[1];
    liste[0] = new Liste("modepaiementlib", modePaiement, "val", "val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("modepaiementlib").setLibelle("Mode de paiement");
//    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = null;

    pr.setNpp(50);

    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap(); 
        lienTab.put("modifier",pr.getLien() + "?but=bondecommande/bondecommande-modif.jsp"); 
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=bondecommande/bondecommande-arbiochem-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Date","R&eacute;f&eacute;rence","D&eacute;signation","Mode de paiement","Fournisseur", "D&eacute;partement","R&eacute;f&eacute;rence proforma","&Eacute;tat","Livraison"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=bondecommande/bondecommande-arbiochem-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir un bon de commande</a>"
    );
    pr.getTableau().setLienFille("bondecommande/inc/bondecommande-liste-detail.jsp&id=");
%>
<script>
    function changerDesignation() {
        document.filtre.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="filtre">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12" style="margin-top: 12px;">
                    <div class="col-md-2 nopadding" style="width: 271px" >
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
                        <label class="input-label" for="livraison">Livraison  :</label>
                        <select name="livraison" class="champ form-control" id="livraison" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < etatAffLiv.length; i++ ){ %>
                            <% if(request.getParameter("livraison") !=null && request.getParameter("livraison").compareToIgnoreCase(etatValLiv[i]) == 0) {%>
                            <option value="<%= etatValLiv[i] %>" selected> <%= etatAffLiv[i] %> </option>
                            <% } else { %>
                            <option value="<%= etatValLiv[i] %>"> <%= etatAffLiv[i] %> </option>
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
