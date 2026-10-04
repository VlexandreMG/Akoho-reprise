<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ferme.pesee.PeseePoussinLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="java.util.LinkedHashMap" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    PeseePoussinLib o = new PeseePoussinLib();
    o.setNomTable("PESEEPOUSSIN_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche pesee poussin");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Identifiant");
    pc.getChampByName("idtypepeseelib").setLibelle("Type de pes&eacute;e");
    pc.getChampByName("idresponsablelib").setLibelle("Responsable");
    pc.getChampByName("idfermelib").setLibelle("Ferme");
    pc.getChampByName("idbatimentlib").setLibelle("B&acirc;timent");
    pc.getChampByName("idlotlib").setLibelle("Lot");
    pc.getChampByName("idparquetlib").setLibelle("Parquet");
    pc.getChampByName("idsouchelib").setLibelle("Souche");
    pc.getChampByName("idsexelib").setLibelle("Sexe");
    pc.getChampByName("dateeclosion").setLibelle("Date d'&eacute;closion");
    pc.getChampByName("agejour").setLibelle("&Acirc;ge en jours");
    pc.getChampByName("agesemaine").setLibelle("&Acirc;ge en semaines");
    pc.getChampByName("nombreoiseauxpeses").setLibelle("Nombre d'oiseaux pes&eacute;s");
    pc.getChampByName("poidstotal").setLibelle("Poids total");
    pc.getChampByName("poidsmoyen").setLibelle("Poids moyen");
    pc.getChampByName("ecarttype").setLibelle("&Eacute;cart-type");
    pc.getChampByName("coefficientvariation").setLibelle("Coefficient de variation");
    pc.getChampByName("limitebasseuniformite").setLibelle("Limite basse d'uniformit&eacute;");
    pc.getChampByName("limitehauteuniformite").setLibelle("Limite haute d'uniformit&eacute;");
    pc.getChampByName("nombreoiseauxdansplage").setLibelle("Nombre d'oiseaux dans la plage");
    pc.getChampByName("uniformite").setLibelle("Uniformit&eacute;");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("datepesee").setLibelle("Date de pes&eacute;e");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idtypepesee").setVisible(false);
    pc.getChampByName("idresponsable").setVisible(false);
    pc.getChampByName("idferme").setVisible(false);
    pc.getChampByName("idbatiment").setVisible(false);
    pc.getChampByName("idlot").setVisible(false);
    pc.getChampByName("idparquet").setVisible(false);
    pc.getChampByName("idsexe").setVisible(false);
    pc.getChampByName("etat").setVisible(false);

    LinkedHashMap<String, String[]> rubriques = new LinkedHashMap<String, String[]>();
    rubriques.put("Information générale", new String[]{
        "idtypepeseelib",
        "idresponsablelib",
        "idfermelib",
        "idbatimentlib",
        "idlotlib",
        "idparquetlib",
        "idsouchelib",
        "idsexelib",
        "dateeclosion",
        "agejour",
        "agesemaine",
        "datepesee",
        "etatlib",
        "remarque"
    });
    rubriques.put("Résultats calculés", new String[]{
        "nombreoiseauxpeses",
        "poidstotal",
        "poidsmoyen",
        "ecarttype",
        "coefficientvariation",
        "limitebasseuniformite",
        "limitehauteuniformite",
        "nombreoiseauxdansplage",
        "uniformite"
    });
    pc.setRubrique(rubriques);
    String[] ordre = {"id","idtypepeseelib","idresponsablelib","idfermelib","idbatimentlib","idlotlib","idparquetlib","idsouchelib","idsexelib","dateeclosion","agejour","agesemaine","nombreoiseauxpeses","poidstotal","poidsmoyen","ecarttype","coefficientvariation","limitebasseuniformite","limitehauteuniformite","nombreoiseauxdansplage","uniformite","etatlib","datepesee","remarque"};
    pc.setOrdre(ordre);

    String pageActuel = "ferme/pesee/peseepoussin-fiche.jsp";
    String pageRetour = "ferme/pesee/peseepoussin-liste.jsp";
    String pageModif = "ferme/pesee/peseepoussin-saisie.jsp&acte=update";
    String pageApresDelete = "ferme/pesee/peseepoussin-liste.jsp";
    String classe = "ferme.pesee.PeseePoussin";

    Map<String, String> map = new HashMap<>();
    map.put("inc/peseepoussin-det", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/peseepoussin-det";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
    o = (PeseePoussinLib) pc.getBase();
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
                        <% if (o.getEtat() < ConstanteEtat.getEtatValider()) { %>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute="+pageActuel+"&classe="+classe %>" style="margin-right: 10px">Valider</a>
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
                <li class="<%=map.get("inc/peseepoussin-det")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/peseepoussin-det">D&eacute;tails</a></li>
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

