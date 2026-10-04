<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.recrutement.Candidatureslib" %>
<%@ page import="constante.ConstanteEtat" %>
<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    Candidatureslib o = new Candidatureslib();
    o.setNomTable("candidatureslib");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un candidature");
    String id = pc.getBase().getTuppleID();
    o = (Candidatureslib) pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idcandidat").setLibelle("Id Candidat");
     pc.getChampByName("idcandidatlib").setLibelle("Nom & pr&eacute;nom");
    pc.getChampByName("idoffreemploie").setLibelle("Id Offre d'emploi");
     pc.getChampByName("idoffreemploielib").setLibelle("Offre d'emploi");
    pc.getChampByName("dateapplication").setLibelle("Date d'application");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("raisonrefus").setLibelle("Raison du refus");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("idcandidat").setLien(lien+"?but=paie/recrutement/candidat-fiche.jsp","id=");
    pc.getChampByName("idoffreemploie").setLien(lien+"?but=paie/recrutement/offreemploi-fiche.jsp","id=");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("raisonrefus").setVisible(false);

    String[] ordre = {"id","idcandidat","idoffreemploie","dateapplication","remarque","raisonrefus","etatlib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "paie/recrutement/candidature-saisie.jsp&acte=update";
    String pageApresDelete = "paie/recrutement/candidature-liste.jsp";
    String pageActuel = "paie/recrutement/candidature-fiche.jsp";
    String classe = "paie.recrutement.Candidatures";

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
                      <% if (o.getEtat() == ConstanteEtat.getEtatCreer()) {%>
                        <% if (!"dg".equalsIgnoreCase(u.getUser().getIdrole())) { %>
                             <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <% }%>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                         <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/recrutement/candidature-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                         <a class="btn btn-success pull-right"
                           href="<%= lien + "?but=paie/recrutement/apresCandidature.jsp&id=" + id + "&acte=refuser&bute=" + pageActuel + "&classe="+classe%>"
                           style="margin-right: 10px">
                            Refuser
                        </a>
                         <% }%>
                         <% if (o.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                         <a class="btn btn-success pull-right" 
                            href="<%= lien + "?but=entretient/entretient-saisie.jsp&idCandidature=" + id %>" 
                            style="margin-right: 10px">
                             Enregistrer un entretient
                            </a>
                          <% }%>
                        
                    </div>
                    <br/>
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

