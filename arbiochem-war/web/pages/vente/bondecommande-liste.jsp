<%@page import="vente.BonDeCommandeCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="faturefournisseur.ModePaiement"%>



<% try{ 
    BonDeCommandeCpl bdc = new BonDeCommandeCpl();
    String nomTable = "BONDECOMMANDE_CLIENT_CPL_M";

       bdc.setNomTable(nomTable);
    String listeCrt[] = {"id","remarque","designation","reference","modepaiement","daty","idclientlib","numeroBc"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","idclientlib","designation","reference","modepaiementlib","remarque","numeroBc","facturelib","etatlib","montantTTCAR"};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de commande client");
    if (request.getParameter("etat") != null && request.getParameter("etat").isEmpty() == false) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }

    if (request.getParameter("statut") != null && request.getParameter("statut").isEmpty() == false) {
        if(request.getParameter("statut").compareToIgnoreCase("1")==0){
            pr.setAWhere(" and nbfacture>0");
        }else if(request.getParameter("statut").compareToIgnoreCase("0")==0){
            pr.setAWhere(" and nbfacture=0");
        }
    }
    // Changer en Liste
    // Initialisation Liste

    Liste[] liste = new Liste[1];
    ModePaiement mp = new ModePaiement();
    liste[0] = new Liste("modepaiement",mp,"val","id");
    pr.getFormu().changerEnChamp(liste);

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/bondecommande-liste.jsp");
   
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("reference").setLibelle("r&eacute;f&eacute;rence");
     pr.getFormu().getChamp("modepaiement").setLibelle("Mode de  paiement");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("idClientLib").setPageAppelComplete("client.Client", "nom", "CLIENT");
    pr.getFormu().getChamp("numeroBc").setLibelle("Num&eacute;ro du bon de commande");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    //  pr.getFormu().getChamp("daty").setLibelle("daty");

    if(request.getParameter("id")!=null && request.getParameter("id").compareToIgnoreCase("")!=0) {
        pr.getFormu().getChamp("id").setDefaut(request.getParameter("id"));
    }
    if(request.getParameter("etaty")!=null && request.getParameter("etaty").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat>=" + request.getParameter("etaty"));
    }


    String[] colSomme = {"montantTTCAR"};
    pr.setNpp(100);
    pr.creerObjetPage(libEntete, colSomme);
    String[] enteteRecap = {"","Nombres","Somme des montants TTC AR"};

    pr.getTableauRecap().setLibeEntete(enteteRecap);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/bondecommande/bondecommande-fiche.jsp"};    
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("vente/bondecommande/inc/bondecommande-detail.jsp&id=");
    String libEnteteAffiche[] = {"Id","Date","Client","D&eacute;signation","r&eacute;f&eacute;rence","Mode de paiement","Remarque","Num BC","Statut","&Eacute;tat","TTC MGA"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatVal = {"","1", "11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)","Valid&eacute;(s)","Annul&eacute;(s)"};

    String[] etatVal2 = {"","1","0"};
    String[] etatAff2 = {"Tous","Factur&eacute;","Non Factur&eacute;"};

    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=vente/bondecommande/bondecommande-saisie.jsp&currentMenu=MNDN000000001071\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir un bon de commande</a>"
    );
%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 noppadding">
                <div class="col-md-2 noppadding" >
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
                <div class="col-md-2 noppadding" >
                    <label class="input-label" for="etat">Statut :</label>
                    <select name="statut" class="champ form-control" id="statut" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < etatAff2.length; i++ ){ %>
                        <% if(request.getParameter("statut") !=null && request.getParameter("statut").compareToIgnoreCase(etatVal2[i]) == 0) {%>
                        <option value="<%= etatVal2[i] %>" selected> <%= etatAff2[i] %> </option>
                        <% } else { %>
                        <option value="<%= etatVal2[i] %>"> <%= etatAff2[i] %> </option>
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
