<%--
    Document   : as-produits-fiche
    Created on : 1 dc. 2016, 10:40:08
    Author     : Joe
--%>

<%@page import="produits.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="affichage.Champ" %>
<%@ page import="utils.ConstanteArbiochem" %>
<%
    UserEJB u=(user.UserEJB) session.getValue("u");
    IngredientsLib a = new IngredientsLib();
    a.setNomTable("as_ingredients_lib");
    DecimalFormat df = new DecimalFormat("0.##################");
    PageConsulte pc = new PageConsulte(a, request, u);

    //pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("unite").setLibelle("Unit&eacute;");
    pc.getChampByName("libelle").setLibelle("Libell&eacute;");
    pc.getChampByName("typestock").setLibelle("Type de stock");
    pc.getChampByName("composelib").setLibelle("Compos&eacute;");
    pc.getChampByName("IdDepartementLib").setLibelle("D&eacute;partement");
    pc.getChampByName("REFQUALIFICATIONLIB").setLibelle("Classification");
    pc.getChampByName("REFPOSTLIB").setLibelle("Poste");
    pc.getChampByName("pu").setLibelle("Prix Unitaire");
    pc.getChampByName("nbpiece").setLibelle("Contenu du carton");
    pc.getChampByName("nbpiece").setVisible(false);
    pc.getChampByName("quantiteparpack").setLibelle("Quantit&eacute; par pack");
    pc.getChampByName("quantiteparpack").setVisible(false);
    pc.getChampByName("bienOuServ").setLibelle("Bien ou Service");
    pc.getChampByName("categorieingredient").setLibelle("Cat&eacute;gorie");
    pc.getChampByName("etatlib").setLibelle("Disponibilit&eacute;");
    pc.getChampByName("etatlib").setVisible(false);
    pc.getChampByName("pv").setLibelle("Prix de vente");
    pc.getChampByName("typeProduit").setVisible(false);
    pc.getChampByName("idligne").setVisible(false);
    pc.getChampByName("parfums").setVisible(false);
    pc.getChampByName("actif").setVisible(false);
    pc.getChampByName("Compte_sortie_stock").setLibelle("Compte de variation de stock");
    pc.getChampByName("Compte_stock").setLibelle("Compte de stock");
    pc.getChampByName("compte_ristourne").setLibelle("Compte de ristourne");
    pc.getChampByName("idFamilleLib").setVisible(false);
    pc.getChampByName("compte_vente").setLibelle("Compte de produits(vente)");
    pc.getChampByName("compte_achat").setLibelle("Compte de charges(achat)");
    pc.getChampByName("tva").setLibelle(" Taxe de Valeur Ajout&eacute; ( TVA )");
    pc.getChampByName("idFournisseur").setVisible(false);
    pc.getChampByName("idFournisseurLib").setLibelle("Fournisseur");
    pc.getChampByName("Libellevente").setLibelle("Libell&eacute; de vente");
    pc.getChampByName("bienOuServ").setVisible(false);
    pc.getChampByName("REFPOSTLIB").setVisible(false);
    pc.getChampByName("REFQUALIFICATIONLIB").setVisible(false);
    pc.getChampByName("photo").setVisible(false);
    pc.getChampByName("daty").setVisible(false);
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("calorie").setLibelle("Poids en Kg");
    pc.getChampByName("REFQUALIFICATION").setVisible(false);
    pc.getChampByName("REFPOST").setVisible(false);
    pc.getChampByName("idcategorieingredient").setVisible(false);
    pc.getChampByName("idcategorie").setVisible(false);
    pc.getChampByName("compose").setVisible(false);
    pc.getChampByName("idUnite").setVisible(false);
    pc.getChampByName("typeProduitLib").setLibelle("Type de produit");

    pc.setTitre("Consultation composant");
    Ingredients base = (Ingredients) (pc.getBase());
    String isDispo = (pc.getChampByName("etatlib") != null) ? pc.getChampByName("etatlib").getValeur() : "";

    RecetteLib[] liste = base.getRecette(null, null);
    Recette[] listeBase = base.decomposerBase(null);
    RecetteLib[] listerecette = base.getRecetteIngredient(null, null);
    double montantTotal = AdminGen.calculSommeDouble(listeBase, "qtetotal");
    if(base.getCompose()>0 && pc.getChampByName("pu") != null) pc.getChampByName("pu").setValeurDirect(Utilitaire.formaterAr (montantTotal));
    if(base.getCompose()==0 && pc.getChampByName("pu") != null) pc.getChampByName("pu").setValeurDirect(Utilitaire.formaterAr(base.getPu()));

    boolean isDG=false;
    if(u.getUser().isSuperUser()) isDG=true;

    //insert multiple recette
    try {
        RecetteLib[] liste2 = base.getRecette("AlimentPoussin_LIBCOMPLET", null);

        String[] typePoussin = ConstanteArbiochem.type_prd_poussin;

        String typeProduit = base.getTypeProduit();
        int estPoussin = Utilitaire.estIlDedans(typeProduit, typePoussin);

        String classeMere = "produits.RecetteMere";
        String classeFille = "produits.RecetteFille";
        String nomTableFille = "RECETTE_FILLE";
        String colonneMere = "idMere";

        RecetteMere mere = new RecetteMere();
        mere.setNomTable("RECETTE_MERE");
        RecetteFilleLib fille = new RecetteFilleLib();
        fille.setNomTable("RECETTE_FILLE_LIB");
        int taille = 5;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
        pi.setLien((String) session.getValue("lien"));
        pi.setTitre("insert");


        pi.getFormu().getChamp("idProduit").setLibelle("Produit");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("nomRecette").setLibelle("Nom de la recette");
        pi.getFormu().getChamp("version").setLibelle("Version");
        pi.getFormu().getChamp("idProduit").setDefaut(request.getParameter("id"));
        pi.getFormu().getChamp("idProduit").setAutre("readonly");
        if (estPoussin < 0) {
            affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idIngredient"), "produits.IngredientVente", "id", "as_ingredients_lib", "idUnite;unite", "idUnite;idUniteLib");
        }
        pi.getFormufle().getChamp("idIngredient_0").setLibelle("Ingr&eacute;dient");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("idUnite_0").setLibelle("Id Unit&eacute;");
        pi.getFormufle().getChamp("idUniteLib_0").setLibelle("Unit&eacute;");
        Champ.setAutre(pi.getFormufle().getChampMulitple("idUniteLib").getListeChamp(),"readonly");
        Champ.setVisible(pi.getFormufle().getChampMulitple("idIngredientLib").getListeChamp(),false);
        Champ.setVisible(pi.getFormufle().getChampMulitple("idMere").getListeChamp(),false);
        Champ.setVisible(pi.getFormufle().getChampMulitple("idUnite").getListeChamp(),false);

        String[] colOrdre = {"idIngredient","qte","idUnite","idUniteLib"};
        pi.getFormufle().setColOrdre(colOrdre);

        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();





        //Liste des recttes
        RecetteMereLib t = new RecetteMereLib();
      String[] libEntete= new String[]{"id", "idProduit", "idProduitLib", "daty", "nomRecette", "version"};
      PageRecherche pr = new PageRecherche(t, request, new String[]{}, new String[]{},4, libEntete, libEntete.length);
      pr.setLien((String) session.getValue("lien"));
      pr.setAWhere(" and IDPRODUIT = '"+request.getParameter("id")+"'");

      pr.setUtilisateur(u);
      String[] colSomme = null;
      pr.creerObjetPage(libEntete, colSomme);
      String[] libEnteteAffiche = {"ID","ID Produit","D&eacute;signation","Date","Nom de la recette", "Version"};
      pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      pr.getTableau().setLienFille("produits/inc/recette-fille.jsp&idMere=");

        RecetteMereLib[] recetteMereLibs = (RecetteMereLib[]) pr.getTableau().getData();
        String idMereCorrect = new RecetteMereLib().compare(recetteMereLibs, liste);


        AlimentPoussin proc2 = new AlimentPoussin();
        proc2.setNomTable("AlimentPoussin_LIBCOMPLET");
        PageInsert pi2 = new PageInsert(proc2, request, u);
        pi2.setLien((String) session.getValue("lien"));
        pi2.getFormu().getChamp("idProduits").setLibelle("Produits");
        pi2.getFormu().getChamp("idProduits").setAutre("readonly");
        pi2.getFormu().getChamp("idproduits").setDefaut(request.getParameter("id"));
        pi2.getFormu().getChamp("idUnite").setLibelle("Unit&eacute;");
        pi2.getFormu().getChamp("idUnite").setAutre("readonly");
        pi2.getFormu().getChamp("unite").setVisible(false);
        pi2.getFormu().getChamp("libIngredients").setVisible(false);
        pi2.getFormu().getChamp("idingredients").setLibelle("Ingr&eacute;dient");
        if (estPoussin >= 0) {
            pi2.getFormu().getChamp("idingredients").setPageAppelCompleteAWhere("produits.IngredientsLib", "id", "as_ingredients_lib", "idunite;unite", "unite;idUnite", "");
        }
        pi2.getFormu().getChamp("quantite").setLibelle("Quantit&eacute;");

        pi2.getFormu().getChamp("idProduits").setAutre("readonly");
        pi2.getFormu().setNbColonne(2);

        String[] ordre2 = {"idProduits","idingredients","idUnite","quantite"};
        pi2.getFormu().setOrdre(ordre2);
        pi2.preparerDataFormu();
%>
<style>
    .col-md-12.cardradius {
        border: none;
        border-top: none !important;
        padding: 0;
        margin-bottom: 20px;
    }
</style>
<div class="content-wrapper onepage-container">
    <h1 class="main-title"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-ingredients-liste.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-12 mb-5" style="padding-bottom: 0;padding-top: 10px;">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <a class="btn btn-secondary pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&acte=dupliquer&id=" + request.getParameter("id")%>&classe=produits.Ingredients&nomtable=AS_INGREDIENTS&nomClasseFille=produits.Recette&nomColonneMere=idproduits&bute=produits/as-ingredients-arbiochem-fiche.jsp" style="margin-right: 10px">Dupliquer</a>
                        <a class="btn btn-secondary pull-right"  href="<%=(String) session.getValue("lien") + "?but=produits/as-ingredients-saisie.jsp&id=" + request.getParameter("id")+"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-secondary pull-right"  href="<%=(String) session.getValue("lien") + "?but=produits/tarifIngredients/tarifIngredients-saisie.jsp&idIng=" + request.getParameter("id")%>" style="margin-right: 10px">Ajouter Tarif</a>
                        <%  if(isDispo.equals("INDISPONIBLE")) {%> <a class="btn btn-primary pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&acte=disponible&isdispo=true&&id=" + request.getParameter("id")%>" style="margin-right: 10px">Disponible</a><%}%>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <%
        if (estPoussin >= 0) {
    %>
    <h1 class="h520pxSemibold m-0" >Ajout aliment poussin</h1>
    <div class="row m-0">
        <div class="col-md-12 mb-5" >
            <form id="maForme"  onsubmit='insertAjING(event)' >
                <div class="box-fiche">
                    <div class="box">
                        <div class="box-body">
                            <%
                                pi2.getFormu().makeHtmlInsertTabIndex();
                                out.println(pi2.getFormu().getHtmlInsert());
                            %>
                            <input name="acte" type="hidden" id="nature" value="insert">
                            <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-arbiochem-fiche.jsp&id=<%=request.getParameter("id")%>">
                            <input name="classe" type="hidden" id="classe" value="produits.AlimentPoussin">
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <h1 class="h520pxSemibold m-0">Composition aliment poussin</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol nopadding mb-5" style="padding-bottom: 0;padding-top: 10px;" >
            <div class="box-fiche box-fiche-space">
                <div class="box">

                    <form  id="incident" onsubmit='modifEtatMultING(event)' enctype="multipart/form-data">
                        <!--<form action="<%=(String) session.getValue("lien")%>?but=modifierEtatMultiple.jsp" method="post" name="incident" id="incident"> -->
                        <div class="box-body table-responsive">
                            <input type="hidden" name="bute" value="produits/as-ingredients-arbiochem-fiche.jsp&id=<%=request.getParameter("id")%>"/>
                            <input type="hidden" name="acte" id="acte"/>




                            <table class="table table-bordered">
                                <thead>
                                <tr>
                                    <th class="contenuetable" align="center" valign="top" >
                                        <input onclick="CocheToutCheckbox(this, 'id')" type="checkbox">
                                    </th>
                                    <th class="contenuetable" >Ingr&eacute;dient</th>
                                    <th class="contenuetable">Quantit&eacute;</th>

                                    <th class="contenuetable">Unit&eacute;</th>
                                </tr>
                                </thead>

                                <tbody>
                                <%
                                    for (int i = 0; i < liste2.length; i++) {
                                %>
                                <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                    <td align="center">
                                        <input type="checkbox" value="<%=liste2[i].getId()%>_<%=i%>" name="ids" id="<%=liste2[i].getId()%>_<%=i%>">
                                    </td>

                                    <td  align="center"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-ingredients-arbiochem-fiche.jsp&id=<%=liste2[i].getIdingredients()%>"><%=liste2[i].getLibIngredients()%></a></td>
                                    <td width="14%" align="center"><input type="text" id="quantite<%=i%>" name="quantite" value="<%=(new DecimalFormat("#.########")).format(liste2[i].getQuantite())%>" onchange="synchro(this,<%=liste2[i].getId()%>_<%=i%>.value)"></td>
                                    <td  align="right"><%=liste2[i].getIdunite()%></td>
                                </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                            <div class="box-footer">
                                <button type="submit" name="acte" value="modifier_aliment" class="btn btn-secondary pull-right" style="margin-right: -8px;" onclick="document.getElementById('acte').value='modifier_aliment'" >Modifier</button>
                                <button type="submit" name="acte" value="supprimer_aliment" class="btn btn-danger pull-left" style="position: absolute;right: 0;margin-right: 110px;" onclick="document.getElementById('acte').value='supprimer_aliment'" >Supprimer</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <%
        } else {
    %>

    
    
    <h1 class="h520pxSemibold m-0" >Ajout Composant</h1>
    <div class="row m-0">
        <div class="col-md-12 mb-5" >
<%--            <form id="maForme"  onsubmit='insertAjING(event)' >--%>
                <form id="maForme" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
                <div class="box-fiche">
                    <div class="box">
                        <div class="box-body">
                            <%
                                out.println(pi.getFormu().getHtmlInsert());
                                out.println(pi.getFormufle().getHtmlTableauInsert());
                            %>
                            <input name="acte" type="hidden" id="nature" value="insert">
                            <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-arbiochem-fiche.jsp&id=<%=request.getParameter("id")%>">
                            <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
                            <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
                            <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
                            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
                            <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <h1 class="h520pxSemibold m-0">Composition principale</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol nopadding mb-5" style="padding-bottom: 0;padding-top: 10px;" >
            <div class="box-fiche box-fiche-space">
                <div class="box">
                    <form  id="incident" onsubmit='modifEtatMultING(event)' enctype="multipart/form-data">
                        <div class="box-body table-responsive">
                            <input type="hidden" name="bute" value="produits/as-ingredients-arbiochem-fiche.jsp&id=<%=request.getParameter("id")%>"/>
                            <input type="hidden" name="acte" id="acte"/>
                            <table class="table table-bordered">
                                <thead>
                                <tr>
                                    <th class="contenuetable" align="center" valign="top" >
                                        <input onclick="CocheToutCheckbox(this, 'id')" type="checkbox">
                                    </th>
                                    <th class="contenuetable" >Ingr&eacute;dient</th>
                                    <th class="contenuetable">Quantit&eacute;</th>
                                    <th class="contenuetable">Unit&eacute;</th>
                                </tr>
                                </thead>
                                <tbody>
                                <%
                                    for (int i = 0; i < liste.length; i++) {
                                %>
                                <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                    <td align="center">
                                        <input type="checkbox" value="<%=liste[i].getId()%>_<%=i%>" name="ids" id="<%=liste[i].getId()%>_<%=i%>">
                                    </td>
                                    <td  align="center"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-ingredients-arbiochem-fiche.jsp&id=<%=liste[i].getIdingredients()%>"><%=liste[i].getLibelleingredient()%></a></td>
                                    <td width="14%" align="center"><input type="text" id="quantite<%=i%>" name="quantite" value="<%=(new DecimalFormat("#.########")).format(liste[i].getQuantite())%>" onchange="synchro(this,<%=liste[i].getId()%>_<%=i%>.value)"></td>
                                    <td  align="right"><%=liste[i].getValunite()%></td>
                                </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>
                            <div class="box-footer">
                                <button type="submit" name="acte" value="modifier_recette" class="btn btn-secondary pull-right" style="margin-right: -8px;" onclick="document.getElementById('acte').value='modifier_recette'" >Modifier</button>
                                <button type="submit" name="acte" value="supprimer_recette" class="btn btn-danger pull-left" style="position: absolute;right: 0;margin-right: 110px;" onclick="document.getElementById('acte').value='supprimer_recette'" >Supprimer</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <h1 class="h520pxSemibold m-0">Liste des recettes</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <form action="<%=pr.getLien()%>?but=produits/apresValidationRecette.jsp" method="post" name="incident" id="incident">
            <input type="hidden" name="bute" value="produits/as-ingredients-arbiochem-fiche.jsp"/>
            <input type="hidden" name="acte" value="validerMultiple"/>
            <input type="hidden" name="idIngredient" value="<%=pc.getBase().getTuppleID()%>"/>
            <% if (pr.getTableau().getHtmlWithCheckbox() != null) {
                out.println(pr.getTableau().getHtmlWithCheckbox());
            } else { %>
                <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
            <% } %>
        </form>
    </div>

    <h1 class="h520pxSemibold m-0">D&eacute;composition finale</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol nopadding mb-5">
            <div class="box-fiche box-fiche-space">
                <div class="box">
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th class="contenuetable">Ingr&eacute;dient</th>
                                <th class="contenuetable">Quantit&eacute;</th>
                                <th class="contenuetable">Unit&eacute;</th>
                                <th class="contenuetable">Prix Unitaire</th>
                                <th class="contenuetable">Montant</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                for (int i = 0; i < listeBase.length; i++) {
                            %>
                            <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                <td  align="center"><%=listeBase[i].getLibIngredients()%></td>
                                <td  align="right"><%=df.format(listeBase[i].getQuantite())%></td>
                                <td  align="right"><%=listeBase[i].getUnite()%></td>
                                <td  align="right"><%=Utilitaire.formaterAr(listeBase[i].getQteav())%></td>
                                <td  align="right"><%=Utilitaire.formaterAr(listeBase[i].getQtetotal())%></td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                        <h3 class="asi-fiche-cout h617pxSemibold"> Co&ucirc;t de revient : <%=Utilitaire.formaterAr(montantTotal)%> Ar</h3>
                        <% if(base.getPv()>0){ %>
                        <h3 class="asi-fiche-cout h617pxSemibold m-0">Marge brute : <%=Utilitaire.formaterAr(base.getPv()- montantTotal)%> Ar</h3>
                        <%}%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <h1 class="h520pxSemibold m-0" >Autres Composants concern&eacute;s</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol nopadding mb-5">
            <div class="box-fiche box-fiche-space">
                <div class="box">
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th class="contenuetable">Produit</th>
                                <th class="contenuetable">Quantit&eacute;</th>
                                <th class="contenuetable">Unit&eacute;</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                for (int i = 0; i < listerecette.length; i++) {
                            %>
                            <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                <td  align="center"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-ingredients-arbiochem-fiche.jsp&id=<%=listerecette[i].getIdproduits()%>"><%=listerecette[i].getLibelleproduit()%></a></td>
                                <td  align="right"><%=listerecette[i].getQuantite()%></td>
                                <td  align="right"><%=listerecette[i].getValunite()%></td>
                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%
        }
        if(base.getCompose()==0){
        HistoriquePrixIng[] histopu =base.getHistoriquePu(null,"pu","HISTORIQUEPUINGTRIE");
    %>
    <h1 >Historique prix achat</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol nopadding mb-5">
            <div class="box-fiche">
                <div class="box box-asi-fiche">
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th class="contenuetable">Date</th>
                                <th class="contenuetable">Prix unitaire d&#39; Achat</th>
                                <th class="contenuetable">Remarque</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                if( histopu!=null&&histopu.length>0){
                                    for (int i = 0; i < histopu.length; i++) {
                            %>
                            <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                <td  align="right"><%=Utilitaire.formatterDaty(histopu[i].getDaty())%></td>
                                <td  align="right"><%=Utilitaire.formaterAr(histopu[i].getPu())%> Ar</td>
                                <td  align="right"><%=Utilitaire.remplacerNull(histopu[i].getRemarque())%></td>
                            </tr>
                            <%
                                    }}
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%}%>
    <%if(base.getCompose()>0){
        HistoriquePrixIng[] histopv =base.getHistoriquePu(null,"pv","HISTORIQUEPVINGTRIE");%>
    <h1 class="h520pxSemibold m-0" >Historique prix de vente</h1>
    <div class="row lolHisto m-0">
        <div class="col-md-6 lol nopadding mb-5 lolHisto-bas">
            <div class="box-fiche">
                <div class="box box-asi-fiche">
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th class="contenuetable">Date</th>
                                <th class="contenuetable">Prix unitaire</th>
                                <th class="contenuetable">Remarque</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                if( histopv!=null&&histopv.length>0){
                                    for (int i = 0; i < histopv.length; i++) {
                            %>
                            <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                <td  align="right"><%=Utilitaire.formatterDaty(histopv[i].getDaty())%></td>
                                <td  align="right"><%=Utilitaire.formaterAr(histopv[i].getPu())%> Ar</td>
                                <td  align="right"><%=Utilitaire.remplacerNull(histopv[i].getRemarque())%></td>
                            </tr>
                            <%
                                    }}
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%}%>
    <%if(base.getCompose()>0){
        TarifIngredientsLib[] histopv =base.getHistoriqueTarif(null,"TARIF_INGREDIENTS_MAX_LIB");%>
    <h1 class="h520pxSemibold m-0" >Historique Tarif</h1>
    <div class="row lolHisto m-0">
        <div class="col-md-12 nopadding mb-5 lolHisto-bas">
            <div class="box-fiche">
                <div class="box box-asi-fiche">
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th class="contenuetable">Date</th>
                                <th class="contenuetable">Type client</th>
                                <th class="contenuetable">Prix unitaire</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                if( histopv!=null&&histopv.length>0){
                                    for (int i = 0; i < histopv.length; i++) {
                            %>
                            <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                <td  align="right"><%=Utilitaire.formatterDaty(histopv[i].getDaty())%></td>
                                <td  align="right"><%=Utilitaire.remplacerNull(histopv[i].getIdtypeclientlib())%></td>
                                <td  align="right"><%=Utilitaire.formaterAr(histopv[i].getPrixUnitaire())%> Ar</td>
                            </tr>
                            <%
                                    }}
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%}%>
</div>
</div>
<script>
    function validerCheckbox(idCheckbox) {
        const checkbox = document.querySelector(
            'input[type="checkbox"][value="' + idCheckbox + '"]'
        );
        if (checkbox) {
            checkbox.disabled = true;
            checkbox.checked = true;
        } else {
            console.log("Checkbox introuvable : " + idCheckbox);
        }
    }


    window.onload = function() {
        validerCheckbox("<%=idMereCorrect%>");
    };
</script>
<%
    } catch (Exception e)
    {
        e.printStackTrace();
    }
%>
<script>
    const secondRow = document.querySelectorAll('.row')[3];
    if(secondRow){
        const colMd3Divs = secondRow.querySelectorAll('div.col-md-3');
        colMd3Divs.forEach(div => {
            div.classList.remove('col-md-3');
            div.classList.add('col-md-1');
        });
        const colMd6Div = secondRow.querySelector('div.col-md-6');
        if (colMd6Div) {
            colMd6Div.classList.remove('col-md-6');
            colMd6Div.classList.add('col-md-12');
        }
    }
</script>