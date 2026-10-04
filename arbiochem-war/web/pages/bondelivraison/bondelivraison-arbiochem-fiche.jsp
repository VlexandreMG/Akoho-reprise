<%-- 
    Document   : encaissement-fiche
    Created on : 3 avr. 2024, 16:22:00
    Author     : Angela
--%>

<%@page import="faturefournisseur.As_BonDeLivraison_Lib"%>
<%@page import="faturefournisseur.As_BonDeLivraison"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%
    try {
        //Information sur les navigations via la page
        String lien = (String) session.getValue("lien");
        String pageModif = "bondelivraison/bondelivraison-modif.jsp";
        String classe = "faturefournisseur.As_BonDeLivraison";
        String pageActuel = "bondelivraison/bondelivraison-arbiochem-fiche.jsp";

        //Information sur la fiche
        As_BonDeLivraison_Lib objet = new As_BonDeLivraison_Lib();
        objet.setNomTable("AS_BONDELIVRAISON_TRAITE");
        PageConsulte pc = new PageConsulte(objet, request, (user.UserEJB) session.getValue("u"));
        objet = (As_BonDeLivraison_Lib) pc.getBase();
        String id = request.getParameter("id");
        pc.getChampByName("id").setLibelle("Id");
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("idFactureFournisseur").setLibelle("ID Facture Fournisseur");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("magasinlib").setLibelle("Magasin");
        pc.getChampByName("magasin").setVisible(false);
        pc.getChampByName("idFournisseur").setVisible(false);
        pc.getChampByName("idTraite").setVisible(false);
        //pc.getChampByName("motsclesss").setVisible(false);
        pc.getChampByName("traite").setLibelle("Livraison");
        pc.getChampByName("idFournisseurLib").setLibelle("Fournisseur");
        pc.getChampByName("remarque").setLibelle("Remarques");
        String idBC = objet.getIdbc();
        if(idBC!=null && idBC.startsWith("BC")){
            pc.getChampByName("idbc").setLien(lien+"?but=bondecommande/bondecommande-arbiochem-fiche.jsp", "id="+objet.getIdbc()+"&libelle=");
        }else if(idBC!=null && idBC.startsWith("FCF")){
            pc.getChampByName("idbc").setLien(lien+"?but=facturefournisseur/facturefournisseur-fiche.jsp", "id="+objet.getIdbc()+"&libelle=");
        }
        pc.getChampByName("idbc").setLibelle("Id Bon de commande");
        if(objet.getIdFactureFournisseur()!=null){
            pc.getChampByName("idFactureFournisseur").setLien(lien+"?but=facturefournisseur/facturefournisseur-fiche.jsp", "id=");
        }
      

        pc.setTitre("Fiche d'un bon de r&eacute;ception");
        Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("bondelivraison-details", "");
        map.put("rapprochement-stock", "");
        map.put("rapprochement-facturation", "");
        map.put("facture-fournisseur", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "bondelivraison-details";
        }
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp";

        String genererMouvement = "stock/mvtstock-saisie.jsp";


%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=bondelivraison/bondelivraison-arbiochem-liste.jsp"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
       <div class="row m-0">

        <div class="col-md-12 nopadding mb-5" >
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body ">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (objet.getEtat() < ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute="+pageActuel+"&classe=" + classe%>" style="margin-right: 10px">Annuler</a>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute="+pageActuel+"&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                           <% } else { %>
                            
                               <a class="btn btn-primary pull-right" href="<%=(String) session.getValue("lien")%>?but=<%= genererMouvement+"&idBLF="+request.getParameter("id") %>">
                            
                                    G&eacute;n&eacute;rer Entr&eacute;e de Stock
                               </a>
                                   <%if(objet.getIdFactureFournisseur()==null||objet.getIdFactureFournisseur().compareTo("")==0)
                            {%>
<%--                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/proforma-saisie.jsp&id="+pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">Insertion Proforma</a>--%>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/facturefournisseur-arbiochem-saisie.jsp&id="+pc.getChampByName("id").getValeur()%>" style="margin-right: 10px">Insertion Facture Fournisseur</a>
                            <%}%>
                           <% }%>
                        
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0" style="margin-top: 30px">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("bondelivraison-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=bondelivraison-details">D&eacute;tails</a></li>
                    <li class="<%=map.get("bondelivraison-mvtstock")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=bondelivraison-mvtstock">Mouvement de Stock</a></li>
                    <li class="<%=map.get("rapprochement-stock")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=rapprochement-stock">Rapprochement de Stock</a></li>
                    <li class="<%=map.get("rapprochement-facturation")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=rapprochement-facturation">Rapprochement de facturation</a></li>
                    
                    <li class="<%=map.get("facture-fournisseur")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=facture-fournisseur">Proforma / Factures</a></li>

                </ul>

                </ul>
                <div class="tab-content">       
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>


<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
