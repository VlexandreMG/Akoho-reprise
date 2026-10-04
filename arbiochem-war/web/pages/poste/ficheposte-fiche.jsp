<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="poste.FichePosteLib" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    FichePosteLib o = new FichePosteLib();
    o.setNomTable("FICHE_POSTE_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une fiche de poste");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("idDepartementLib").setLibelle("D&eacute;partement");
    pc.getChampByName("idDepartementLib").setVisible(false);
    pc.getChampByName("idBuLib").setLibelle("BU");
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("titre").setLibelle("Titre");
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("description").setLibelle("Description");
    pc.getChampByName("missions").setLibelle("Missions");
    pc.getChampByName("exigenceposte").setLibelle("Exigences du poste");
    pc.getChampByName("salairemin").setLibelle("Salaire");
    pc.getChampByName("salairemax").setLibelle("Salaire maximum");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
     pc.getChampByName("idTypeContratLib").setLibelle("Type de contrat");
    pc.getChampByName("daty").setLibelle("Date");
     pc.getChampByName("idNiveauFormationLib").setLibelle("Niveau de formation");
     pc.getChampByName("idPermisLib").setLibelle("Permis");
     pc.getChampByName("idFonction").setLibelle("Id Fonction");
     pc.getChampByName("idFonction").setVisible(false);
     pc.getChampByName("idPermisLib").setVisible(false);
     pc.getChampByName("idFonctionlib").setLibelle("Fonction");
     pc.getChampByName("autre").setLibelle("Autre");
     pc.getChampByName("idCategoriePaieLib").setLibelle("Cat&eacute;gorie de paie");
     pc.getChampByName("idQualificationPaieLib").setLibelle("Qualification de paie");
     pc.getChampByName("conditionTravail").setLibelle("Conditions de travail");
     pc.getChampByName("ModeControle").setLibelle("Mode de controle");
     pc.getChampByName("idQualificationPaieLib").setLibelle("Qualification de paie");
     pc.getChampByName("materielDocument").setLibelle("Mat&eacute;riel de documentation");;
     pc.getChampByName("idNiveauFormation").setVisible(false);
     pc.getChampByName("idBu").setVisible(false);
     pc.getChampByName("idPermis").setVisible(false);
     pc.getChampByName("salairemax").setVisible(false);
    pc.getChampByName("salairemin").setVisible(false);
    pc.getChampByName("iddepartement").setVisible(false);
    pc.getChampByName("idtypecontrat").setVisible(false);
    pc.getChampByName("idCategoriePaie").setVisible(false);
    pc.getChampByName("idQualificationPaie").setVisible(false);
    pc.getChampByName("idFamilleProfessionelLib").setLibelle("Famille professionnelle");
    pc.getChampByName("idMetierLib").setLibelle("M&eacute;tier");
    pc.getChampByName("idEmploiLib").setLibelle("Emploi");
    pc.getChampByName("idCodeRomeLib").setLibelle("Code ROME");
    pc.getChampByName("lieuTravail").setLibelle("Lieu de Travail");

    String[] ordre = {"id","idDepartementLib","titre","reference","description","missions","exigenceposte","salairemin","salairemax", "idBuLib","etat","daty","autre","idCategoriePaieLib", "idQualificationPaieLib","idPermisLib"};
    pc.setOrdre(ordre);

    String pageRetour = "poste/ficheposte-liste.jsp";
    String pageModif = "poste/ficheposte-saisie.jsp&acte=update";
    String pageApresDelete = "poste/ficheposte-liste.jsp";
    String pageApresValider = "poste/ficheposte-fiche.jsp";
    String pageOffreEmploie = "paie/recrutement/offreemploi-saisie.jsp";
    String pageCompetence = "poste/fpcompetences-saisie.jsp";
    String pageObjectif = "poste/objectifindividuel-saisie.jsp";
    String pageActuel = "poste/ficheposte-fiche.jsp";
    String classe = "poste.FichePoste";
    String nomTable = "FICHE_POSTE";
    o = (FichePosteLib) pc.getBase();
    Map<String, String> map = new HashMap<>();
    map.put("inc/detail", "");
    map.put("inc/competences", "");
    map.put("inc/objectif", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/detail";
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
                        <% if (o.getEtat() <= ConstanteEtat.getEtatCreer()){%>
<%--                            <% if (!"dg".equalsIgnoreCase(u.getUser().getIdrole())) { %>--%>
<%--                            <% } %>--%>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute="+pageApresValider+"&classe="+classe+"&nomtable="+nomTable %>">Valider</a>
                        <% } else { %>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageOffreEmploie +"&idficheposte=" + id %>" style="margin-right: 10px">Cr&eacute;er une offre d’emploi</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageCompetence +"&idficheposte=" + id %>" style="margin-right: 10px">Saisir comp&eacute;tences cl&eacute;s requises</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageObjectif +"&idficheposte=" + id %>" style="margin-right: 10px">Saisir objectif individuel</a>
                        <a class="btn btn-secondary pull-right"href="${pageContext.request.contextPath}/ExportPDF?action=imprimer_fiche_poste&id=<%= request.getParameter("id")%>"> Imprimer fiche poste </a>
                        <% } %>
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
                <li class="<%=map.get("inc/detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/detail">D&eacute;tails</a></li>
                  <li class="<%=map.get("inc/competences")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/competences">Comp&eacute;tences</a></li>
                  <li class="<%=map.get("inc/objectif")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/objectif">Objectifs</a></li>          </ul>
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

