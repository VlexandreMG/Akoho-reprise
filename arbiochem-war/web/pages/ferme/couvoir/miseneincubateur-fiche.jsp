<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.couvoir.MiseEnIncubateurLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    MiseEnIncubateurLib o = new MiseEnIncubateurLib();
    o.setNomTable("MISEENINCUBATEUR_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche mise en incubateur");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idIncubateurLib").setLibelle("Incubateur");
    pc.getChampByName("idResponsableLib").setLibelle("Responsable");
    pc.getChampByName("datemiseenmachine").setLibelle("Date de mise en machine");
    pc.getChampByName("dateeclosionprevue").setLibelle("Date d'&eacute;closion pr&eacute;vue");
    pc.getChampByName("temperateurcible").setLibelle("Temp&eacute;rature cible");
    pc.getChampByName("humiditecible").setLibelle("Humidit&eacute; cible");
    pc.getChampByName("heureprechauffage").setLibelle("Heure de pr&eacute;chauffage");
    pc.getChampByName("heuredebutincubation").setLibelle("Heure de d&eacute;but d'incubation");
    pc.getChampByName("idincubateur").setVisible(false);
    pc.getChampByName("idresponsable").setVisible(false);

    String[] ordre = {"id","idIncubateurLib","idResponsableLib","datemiseenmachine","dateeclosionprevue","temperateurcible","humiditecible","heureprechauffage","heuredebutincubation"};
    pc.setOrdre(ordre);

    String pageActuel = "ferme/couvoir/miseneincubateur-fiche.jsp";
    String pageRetour = "ferme/couvoir/miseneincubateur-liste.jsp";
    String pageModif = "ferme/couvoir/miseneincubateur-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/couvoir/miseneincubateur-liste.jsp";
    String classe = "ferme.couvoir.MiseEnIncubateurLib";

    Map<String, String> map = new HashMap<>();
    map.put("inc/miseneincubateur-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/miseneincubateur-details";
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
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
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
                <li class="<%=map.get("inc/miseneincubateur-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/miseneincubateur-details">D&eacute;tails</a></li>
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

