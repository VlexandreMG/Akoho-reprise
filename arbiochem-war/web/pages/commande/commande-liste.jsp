<%@page import="vente.Commande"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="vente.CommandeCpl" %>
<%@ page import="affichage.Liste" %>
<%@ page import="faturefournisseur.ModePaiement" %>

<% try{
    CommandeCpl f = new CommandeCpl();
    String listeCrt[] = {"id","idClientLib","daty","designation","reference"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","reference","idClientLib","designation","remarque","montantttc","etatLib"};

    String[] etatVal = {"","1","11","0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)", "Vis&eacute;e(s)","Annul&eacute;(s)"};
    PageRecherche pr = new PageRecherche(f, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des commandes");

    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(pr.getAWhere() + " and etat=" + request.getParameter("etat"));
    }

    Liste[] liste = new Liste[1];
    ModePaiement mp = new ModePaiement();
//    liste[0] = new Liste("modepaiement",mp,"val","id");
    liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
    liste[0].setLibelle("Magasin");
//    Liste listemode = new Liste("modelivraison");
//
//    String [] affVal = new String[2];
//    String [] aff = new String[2];
//    aff = new String[]{"LIVRAISON","RECUPERATION"};
//    affVal = new String[]{"1","2"};
//    listemode.ajouterValeur(affVal,aff);
//    liste[2] = listemode;
    pr.getFormu().changerEnChamp(liste);

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("commande/commande-liste.jsp");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("idClientLib").setPageAppelComplete("client.Client", "nom", "CLIENT");
//    pr.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = { "montantttc" };
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=commande/commande-fiche.jsp"};
    String colonneLien[] = {"id"};
    String[] enteteRecap = {"","Nombres","Somme des montants TTC"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Date","R&eacute;f&eacute;rence","Client","D&eacute;signation","Remarque","Montant TTC","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=commande/commande-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir une commande</a>"
    );
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
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name = "filtre">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding" style="margin-top: 12px">
                <div class="col-md-2 nopadding">
                            &Eacute;tat
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

