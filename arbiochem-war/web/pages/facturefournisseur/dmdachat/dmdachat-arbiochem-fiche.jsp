<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="faturefournisseur.DmdAchatLib" %>

<%
    try{
        String lien = (String) session.getValue("lien");
        DmdAchatLib t = new DmdAchatLib();
        t.setNomTable("DMDACHATLIB_TRAITE");
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (DmdAchatLib) pc.getBase();
        String id=pc.getBase().getTuppleID( );
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("daty").setLibelle("Date de la demande d'achat");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("fournisseurLib").setLibelle("Fournisseur");
        pc.getChampByName("fournisseur").setVisible(false);
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("idProvenance").setVisible(false);
        pc.getChampByName("idObjet").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("dateLimite").setLibelle("Date limite de livraison");
        pc.getChampByName("idMagasinLib").setLibelle("Magasin");
        pc.getChampByName("idCategorieLib").setLibelle("Cat&eacute;gorie");
        pc.getChampByName("idObjet").setLibelle("Origine");
        pc.getChampByName("traite").setLibelle("Trait&eacute;");
        pc.getChampByName("idServiceLib").setLibelle("D&eacute;partement");
        pc.getChampByName("idProvenanceLib").setLibelle("Provenance");
       // pc.getChampByName("idBc").setLibelle("ID Bon De Commande");
        //  pc.getChampByName("refproforma").setLibelle("R&eacute;f&eacute;rence proforma");
          pc.getChampByName("idTraite").setVisible(false);

        pc.setTitre("Fiche de demande d'achat");
        String pageModif = "facturefournisseur/dmdachat/dmdachat-arbiochem-saisie.jsp";
        String pageActuel = "facturefournisseur/dmdachat/dmdachat-arbiochem-fiche.jsp";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/dmdachat-details", "");
        map.put("inc/bondecommande-liste", "");
        map.put("inc/plancommande-liste", "");
         map.put("inc/commentaire-arbiochem-liste", "");

        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/dmdachat-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        DmdAchatLib da=(DmdAchatLib)pc.getBase();
        String traite = da.getTraite();

        String titreGenerer = "G&eacute;n&eacute;rer Bon de commande";
        String lienGenerer = "bondecommande/bondecommande-saisie.jsp&iddmdachat=" + id;

        if (traite.compareToIgnoreCase("Oui") == 0) {
            titreGenerer = "Modifier Bon de commande";
            lienGenerer = "bondecommande/bondecommande-saisie.jsp&acte=update&id=" + da.getIdbc();
        }
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=facturefournisseur/dmdachat/dmdachat-arbiochem-liste.jsp"%> ><i class="fa fa-angle-left"></i></a><% out.println(pc.getTitre()); %></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if(da.getEtat()<11){ %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=facturefournisseur/dmdachat/dmdachat-arbiochem-fiche.jsp&classe=faturefournisseur.DmdAchatArbiochem&nomtable=DMDACHAT"%> " style="margin-right: 10px">Valider</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&acte=annuler&id=" + id + "&bute=facturefournisseur/dmdachat/dmdachat-arbiochem-fiche.jsp&classe=faturefournisseur.DmdAchat"%>" style="margin-right: 10px">Annuler</a>
                            <% } %>
<%--                            <% if(da.getEtat()>=11 && !da.getIdTraite().equals("2")){ %>--%>
                            <% if(da.getEtat()>=11 ){ %>

<%--                           <a class="btn btn-secondary pull-right" href="<%= lien + "?but=" + lienGenerer %>" style="margin-right: 10px"><%= titreGenerer %></a> <!-- <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/facturefournisseur-saisie.jsp&iddmdachat=" + id %> " style="margin-right: 10px">Insertion Facture Fournisseur</a> -->--%>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=bondecommande/bondecommande-arbiochem-saisie.jsp?iddmdachat=" + pc.getChampByName("id").getValeur()%>" style="margin-right: 10px"><%= titreGenerer %></a>
                            <% } %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=facturefournisseur/plancommande-arbiochem-saisie.jsp&iddmdachat=" + id %> " style="margin-right: 10px">Plan de Commande</a>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/dmdachat/commentaire-demande-arbiochem-saisie.jsp&id=" + id +"&bute="+pageActuel%> " style="margin-right: 10px">Ajouter commentaire</a>
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get("inc/dmdachat-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/dmdachat-details">D&eacute;tails</a></li>
                    <li class="<%=map.get("inc/bondecommande-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-liste">Bon de commande</a></li>
                    <li class="<%=map.get("inc/dmdachatsuivicommande-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/dmdachatsuivicommande-details">Suivi de commande</a></li>
                    <li class="<%=map.get("inc/plancommande-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/plancommande-details">Plan de Commande</a></li>
                    <li class="<%=map.get("inc/commentaire-arbiochem-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/commentaire-arbiochem-liste">Commentaire</a></li>
                    <li class="<%=map.get("inc/historique-validation")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/historique-validation">Historique de Validation</a></li>
                   
                </ul>   
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>


</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>