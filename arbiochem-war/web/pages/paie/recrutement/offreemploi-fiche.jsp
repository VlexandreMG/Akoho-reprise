<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.recrutement.OffreEmploiLib" %>
<%@ page import="constante.ConstanteEtat" %>
<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    OffreEmploiLib o = new OffreEmploiLib();
    o.setNomTable("offre_emploilib");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un offre emploi");
    String id = pc.getBase().getTuppleID();
    o = (OffreEmploiLib) pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idficheposte").setLibelle("Id fiche de poste");
    pc.getChampByName("titre").setLibelle("Titre");
    pc.getChampByName("description").setLibelle("Description");
    pc.getChampByName("mission").setLibelle("Missions");
    pc.getChampByName("exigenceposte").setLibelle("Exigences du poste");
    pc.getChampByName("idtypecontratlib").setLibelle("Type de contrat");
    pc.getChampByName("salairemin").setLibelle("Salaire");
    pc.getChampByName("salairemin").setVisible(false);
    pc.getChampByName("salairemax").setLibelle("Salaire maximum");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("datepublication").setLibelle("Date de publication");
    pc.getChampByName("datefermeture").setLibelle("Date de fermeture");
    pc.getChampByName("idtypecontrat").setVisible(false);
    pc.getChampByName("salairemax").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
     pc.getChampByName("idfichepostelib").setLibelle("Fiche de poste");
    pc.getChampByName("idficheposte").setLien(lien+"?but=poste/ficheposte-fiche.jsp","id=");

    String[] ordre = {"id","idficheposte","titre","description","mission","exigenceposte","idtypecontratlib","salairemin","salairemax","etat","datepublication","datefermeture"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "paie/recrutement/offreemploi-saisie.jsp&acte=update";
    String pageApresDelete = "paie/recrutement/offreemploi-liste.jsp";
    String classe = "paie.recrutement.OffreEmploi";

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
                       <% if (o.getEtat() < ConstanteEtat.getEtatValider()) {%>
                            <% if (!"dg".equalsIgnoreCase(u.getUser().getIdrole())) { %>
                                 <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                             <% }%>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=paie/recrutement/offreemploi-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                        <% }%>
                         <% if (o.getEtat() == ConstanteEtat.getEtatValider()) {%>
                           <!--   <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=cloturer&id=" + request.getParameter("id") + "&bute=vente/vente-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Cloturer</a> -->  
                           <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=paie/recrutement/candidature-saisie.jsp&idOffre=" + request.getParameter("id")%> " style="margin-right: 10px">Saisir candidature</a>
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

