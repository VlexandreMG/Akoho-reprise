<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.production.triageOeufLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="ferme.production.TriageOeuf" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    triageOeufLib o = new triageOeufLib();
    o.setNomTable("TRIAGEOEUF_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche triage oeuf");
    String id = pc.getBase().getTuppleID();
    TriageOeuf triageOeuf = (TriageOeuf) pc.getBase();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idOperateurLib").setLibelle("Op&eacute;rateur");
    pc.getChampByName("idNumeroCollecteLib").setLibelle("Num&eacute;ro de collecte");
    pc.getChampByName("idBatimentLib").setLibelle("B&acirc;timent");
    pc.getChampByName("idParquetLib").setLibelle("Parquet");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("heuredepart").setLibelle("Heure d&eacute;part");
    pc.getChampByName("oeuftotal").setLibelle("Total &oelig;ufs");
    pc.getChampByName("poidsmoyenoeufs").setLibelle("Poids moyen &oelig;ufs");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("ecart").setLibelle("&Eacute;cart");
    pc.getChampByName("idoperateur").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idnumerocollecte").setVisible(false);
    pc.getChampByName("idbatiment").setVisible(false);
    pc.getChampByName("idparquet").setVisible(false);

    String[] ordre = {"id","idOperateurLib","idNumeroCollecteLib","idBatimentLib","idParquetLib","daty","heuredepart","oeuftotal","poidsmoyenoeufs","ecart"};
    pc.setOrdre(ordre);

    String pageActuel = "ferme/production/triageoeuf-fiche.jsp";
    String pageRetour = "ferme/production/triageoeuf-liste.jsp";
    String pageModif = "ferme/production/triageoeuf-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/production/triageoeuf-liste.jsp";
    String classe = "ferme.production.TriageOeuf";

    Map<String, String> map = new HashMap<>();
    map.put("inc/triageoeuf-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/triageoeuf-details";
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


                        <% if(triageOeuf.getEtat() ==1) { %>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                        <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+ pageActuel +"&classe=" + classe %> " style="margin-right: 10px">Valider</a>
                        <% } else if(triageOeuf.getEtat() >= 11) { %>

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
                <!-- Exemple d'onglet -->
                <li class="<%=map.get("inc/triageoeuf-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/triageoeuf-details">D&eacute;tails</a></li>
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

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

