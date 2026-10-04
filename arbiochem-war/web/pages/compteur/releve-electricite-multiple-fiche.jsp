<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="compteur.CompteurElectriciteMere" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="compteur.CompteurElectriciteMereLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    CompteurElectriciteMereLib o = new CompteurElectriciteMereLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche de compteur electricite");
    String id = pc.getBase().getTuppleID();
    CompteurElectriciteMereLib compteur = (CompteurElectriciteMereLib) pc.getBase();
    String ligne = compteur.getLigne();
    int etat = compteur.getEtat();
    String date = compteur.getDaty().toString();

    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("lignelib").setLibelle("Ligne");
    pc.getChampByName("montant").setLibelle("Montant");
    pc.getChampByName("etat").setLibelle("Etat");
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("remarque").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("ligne").setVisible(false);

    String[] ordre = {"daty","lignelib"};
    pc.setOrdre(ordre);

    String pageActuel = "compteur/releve-electricite-multiple-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = "compteur/releve-electricite-saisie.jsp";
    String pageRattacheFichier = "maintenance/ressources/of-non-rattache.jsp";
    String classe = "compteur.CompteurElectriciteMere";

    Map<String, String> map = new HashMap<>();
    map.put("inc/releve-electricite-detail", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/releve-electricite-detail";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

<div class="row m-0">
    <div class="col-md-3"></div>
    <div class="col-md-6">
        <div class="box-fiche">
            <div class="box">
                <div class="box-body">
                    <%
                        out.println(pc.getHtml());
                    %>
                    <br/>
                    <div class="box-footer">
                        <% if(etat < 11 ) { %>
                            <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=compteur/releve-electricite-multiple-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Valider</a>
                            <a class="btn btn-info pull-right"  href="<%= lien + "?but="+ pageModif +"&idMere=" + id + "&idLigne="+ ligne%>" style="margin-right: 10px">Ajouter Relev&eacute;</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=maintenance/ressources/fabrication-petri.jsp&idCompteur=" + id+"&idligne="+compteur.getLigne()+"&date="+compteur.getDaty() %>" style="margin-right: 10px">Rattacher Fabrication</a>
                            <a class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute=compteur/releve-electricite-multiple-fiche.jsp&classe=" + classe%>">Annuler</a>
                        <% } %>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row m-0">
    <div class="col-md-12 nopadding">
        <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
                <li class="<%=map.get("inc/releve-electricite-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/releve-electricite-detail">D&eacute;tails</a></li>
                <li class="<%=map.get("inc/fabrication-petri-rattache")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&etat=<%= etat%>&tab=inc/fabrication-petri-rattache">Fabrication rattach&eacute;e</a></li>
            </ul>
            <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                        <jsp:param name="etat" value="<%= etat %>" />
                        <jsp:param name="type" value="electricite" />
                    </jsp:include>
            </div>
        </div>
        
        </div>
    </div>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

