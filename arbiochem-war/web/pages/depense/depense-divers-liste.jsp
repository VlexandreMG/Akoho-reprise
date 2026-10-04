<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="depense.DepenseDiversLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="bean.TypeObjet" %>
<% try{ 
    DepenseDiversLib o = new DepenseDiversLib();
    o.setNomTable("DEPENSEDIVERSLIB");
    String[] listeCrt = {"id","fournisseurLib","remarque","daty","acheteur","idModepaiement","serviceLib","idSectionLib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","daty","remarque","fournisseurLib","acheteur","compteCheque","idModePaiementLib","serviceLib","idSectionLib","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }
    pr.setTitre("Liste des d&eacute;penses diverse");
    pr.setUtilisateur((user.UserEJB) session.getAttribute("u"));
    pr.setLien((String) session.getAttribute("lien"));
    pr.setApres("depense/depense-divers-liste.jsp");
    Liste[] liste = new Liste[1];
    String[] aff0 = {"Tous","Ch&egrave;que","Esp&egrave;ce"};
    String[] val0 = {"%","0001","0002"};
    liste[0] = new Liste("idModepaiement",aff0, val0);
    /*TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("MAGASIN2");
    liste[1] = new Liste("idMagasin",liste1,"val","id");
    CategorieIngredient categorieIngredient = new CategorieIngredient();
    categorieIngredient.setNomTable("CATEGORIEINGREDIENTLIB_ACHT");
    liste[2] = new Liste("idCategorie",categorieIngredient,"val","id");*/
    pr.getFormu().changerEnChamp(liste);

   // pr.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    //pr.getFormu().getChamp("idCategorie").setLibelle("Cat&eacute;gorie");
    pr.getFormu().getChamp("serviceLib").setLibelle("D&eacute;partement");
    pr.getFormu().getChamp("idSectionLib").setLibelle("Section");
    pr.getFormu().getChamp("idModepaiement").setLibelle("Mode de paiement");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("fournisseurLib").setLibelle("Fournisseur");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("acheteur").setLibelle("Acheteur");

    pr.setNpp(50);
    pr.creerObjetPage(libEntete, null);
    String[] lienTableau = {pr.getLien() + "?but=depense/depense-divers-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Date","Remarque","Fournisseur","Acheteur","Compte ch&egrave;que","Mode de paiement","D&eacute;partement","Section","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=depense/depense-divers-saisie.jsp\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisie d'une d&eacute;pense diverse\n" +
            "                </a>"
    );

    String[] etatVal = {"","0","1","3","4","5","11"};
    String[] etatAff = {"Tous","Annul&eacute;e(s)", "Cr&eacute;&eacute;e(s)", "Vis&eacute;e(s) par Chef de D&eacutepartement","Vis&eacute;e(s) par Directeur de D&eacutepartement","Vis&eacute;e(s) par Contr&ocirc;le","Vis&eacute;e(s) par Le Directeur"};

%>
%>
<script>
    function submitEtat() {
        document.depense.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="depense" id="depense">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding" style="margin-top: 12px">
                <div class="col-md-2 nopadding">
                    <label class="input-label" for="etat">&Eacute;tat :</label>
                    <select name="etat" class="champ form-control" id="etat" onchange="submitEtat()">
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

