<%@page import="stock.*"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="stock.TypeMvtStock"%>
<%@ page import="java.util.Map" %>
<%@ page import="utils.*" %>
<%@ page import="java.util.HashMap" %>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    Magasin mag = u.getMagasin();
    MvtStockFilleLib stock = new MvtStockFilleLib();
    stock.setNomTable("mvtstockfillelib");
    
    String [] val = new String[]{"%","1","11", ConstanteStation.TYPEMVTSTOCKINVENTAIRE};
    String [] aff = new String[]{"Tous","Cr&eacute;&eacute;","Vis&eacute;e","ecart inventaire"};
    

    String listeCrt[] = {"id","idMvtStock","idProduit","idMagasin","idProduitlib","dateSql", "mvtsrc"};
    String listeInt[] = {"dateSql"};
    String libEntete[] = {"id","idProduit","idProduitlib","daty","idMagasinLib","idMvtStock","entree","sortie","pu", "montant","mvtsrc","etatlib"};
    PageRecherche pr = new PageRecherche(stock, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des mouvements du stock fille");
    if(mag != null){
        pr.setAWhere("AND IDMAGASIN='"+mag.getId()+"'");
    }
    Liste[] dropDowns = new Liste[1];
    dropDowns[0] = new Liste( "idMagasin", new Magasin(), "val" , "id" );

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("stock/mvtstockfille-liste.jsp");
    pr.getFormu().changerEnChamp(dropDowns);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idProduitlib").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pr.getFormu().getChamp("idProduit").setLibelle("ID Produit");
    pr.getFormu().getChamp("idMvtStock").setLibelle("ID Mouvement de Stock");
    pr.getFormu().getChamp("dateSql1").setLibelle("Date min");
    pr.getFormu().getChamp("dateSql1").setEstMoitier(true);

    pr.getFormu().getChamp("dateSql1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    if(request.getParameter("invdaty") != null&&request.getParameter("invdaty").compareToIgnoreCase("")!=0&&request.getParameter("invdaty").compareToIgnoreCase("null")!=0) {
        if (request.getParameter("invdaty").contains("-")) {
            String formatDate =  Utilitaire.formatterDaty(request.getParameter("invdaty"));
            pr.getFormu().getChamp("dateSql1").setDefaut(formatDate);
        } else {
            pr.getFormu().getChamp("dateSql1").setDefaut(request.getParameter("invdaty"));
        }
    } else if(request.getParameter("clicStock")!=null&&request.getParameter("clicStock").compareToIgnoreCase("")!=0) {
        pr.getFormu().getChamp("dateSql1").setDefaut(Utilitaire.getDebutAnnee(String.valueOf(Utilitaire.stringToInt(Utilitaire.getAnneeEnCours())-1)));
    }

    System.out.println("request.getParameter(\"etat\") : "+request.getParameter("etat"));
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        if (request.getParameter("etat").equalsIgnoreCase("%")){ 
            pr.setAWhere(pr.getAWhere() + " ");
        }else if(request.getParameter("etat").equalsIgnoreCase(ConstanteStation.TYPEMVTSTOCKINVENTAIRE)){
            pr.setAWhere(pr.getAWhere() + " and IDTYPEMVSTOCK='" + request.getParameter("etat")+" '");
        }
        else {
            pr.setAWhere(pr.getAWhere() + " and etat=" + request.getParameter("etat")+" ");
        }
    }

    pr.getFormu().getChamp("dateSql2").setLibelle("Date max");
    pr.getFormu().getChamp("dateSql2").setEstMoitier(true);
    pr.getFormu().getChamp("mvtsrc").setLibelle("Mouvement source");
    pr.getFormu().getChamp("dateSql2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    if(mag != null){
        pr.getFormu().getChamp("idMagasin").setAutre("disabled");
        pr.getFormu().getChamp("idMagasin").setDefaut(mag.getId());
    }
    String[] colSomme = {"entree","sortie"};
    pr.creerObjetPage(libEntete, colSomme);
    String[] libelleSomme = {"","Nombre","Somme des entr&eacute;es","somme des sorties"};
    pr.getTableauRecap().setLibeEntete(libelleSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=stock/mvtstock-fiche.jsp", pr.getLien() + "?but=produits/as-ingredients-fiche.jsp",pr.getLien() + "?but=stock/mvtstockfille-fiche.jsp"};
    String colonneLien[] = {"idmvtstock","idProduit", "mvtsrc"};
    String attributLien[] = {"id","id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID","ID Produit","D&eacute;signation","Date","Magasin","ID Mouvement de Stock","Entr&eacute;e","Sortie","Prix unitaire", "Montant","Mouvement source","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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



