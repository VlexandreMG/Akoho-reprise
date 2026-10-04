<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.formation.ParticipationFormationLib" %>
<%@ page import="constante.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ParticipationFormationLib o = new ParticipationFormationLib();
    o.setNomTable("PARTICIPATION_FORMATION_LIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une participation au formation");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("matricule").setLibelle("Matricule");
    pc.getChampByName("idActionFormationLib").setLibelle("Action formation");
    pc.getChampByName("categorieEmploye").setLibelle("Cat&eacute;gorie d'employ&eacute;");
    pc.getChampByName("dateinscription").setLibelle("Date d'inscription");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("etatLib").setLibelle("&Eacute;tat");
    pc.getChampByName("idactionformation").setVisible(false);
    pc.getChampByName("idpersonnel").setVisible(false);
    pc.getChampByName("personnel").setLibelle("Personnel");
    pc.getChampByName("etat").setVisible(false);

    String[] ordre = {"id","matricule","personnel","idActionFormationLib","categorieEmploye","dateinscription","remarque","etatLib"};
    pc.setOrdre(ordre);

    String pageRetour = "paie/formation/participation/participationformation-liste.jsp";
    String pageModif = "paie/formation/participation/participationformation-saisie.jsp&acte=update";
    String pageApresDelete = "paie/formation/participation/participationformation-liste.jsp";
    String pageApresValider = "paie/formation/participation/participationformation-fiche.jsp";
    String classe = "paie.formation.ParticipationFormation";
    String nomTable = "PARTICIPATION_FORMATION";

    o = (ParticipationFormationLib) pc.getBase();


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
                        <% if (o.getEtat() <= ConstanteEtat.getEtatCreer()){ %>
                            <% if (!"dg".equalsIgnoreCase(u.getUser().getIdrole())) { %>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                        <a  class="btn btn-secondary pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute="+pageApresValider+"&classe="+classe+"&nomtable="+nomTable %>" style="margin-right: 10px">Valider</a>
                        <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                        <% } %>
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

