<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.batiment.BatimentVideSanitaireLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="ferme.batiment.BatimentVideSanitaire" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    BatimentVideSanitaireLib o = new BatimentVideSanitaireLib();
    o.setNomTable("BATIMENTVIDESANITAIRE_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une batiment vide sanitaire");
    String id = pc.getBase().getTuppleID();
    BatimentVideSanitaire batimentVideSanitaire = (BatimentVideSanitaire) pc.getBase();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idBatimentLib").setLibelle("B&acirc;timent");
    pc.getChampByName("idFermeLib").setLibelle("Ferme");
    pc.getChampByName("idResponsableLib").setLibelle("Responsable");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("heuredebut").setLibelle("Heure de d&eacute;but");
    pc.getChampByName("heurefin").setLibelle("Heure de fin");
    pc.getChampByName("idFerme").setVisible(false);
    pc.getChampByName("idbatiment").setVisible(false);
    pc.getChampByName("idresponsable").setVisible(false);
    pc.getChampByName("etatLib").setVisible(false);
    pc.getChampByName("etat").setLibelle("&Eacute;tat");

    String[] ordre = {"id","idFermeLib","idBatimentLib","idResponsableLib","daty","heuredebut","heurefin", "etat"};
    pc.setOrdre(ordre);

    String pageActuel = "ferme/batiment/batimentvidesanitaire-fiche.jsp";
    String pageRetour = "ferme/batiment/batimentvidesanitaire-liste.jsp";
    String pageModif = "ferme/batiment/batimentvidesanitaire-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/batiment/batimentvidesanitaire-liste.jsp";
    String classe = "ferme.batiment.BatimentVideSanitaire";

    Map<String, String> map = new HashMap<>();
    map.put("inc/batimentvidesanitaire-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/batimentvidesanitaire-details";
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
                        <% if (batimentVideSanitaire.getEtat() < ConstanteEtat.getEtatValider()) { %>
                        <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute="+pageActuel+"&classe="+classe %>">Valider</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
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
                <li class="<%=map.get("inc/batimentvidesanitaire-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/batimentvidesanitaire-details">D&eacute;tails</a></li>
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

