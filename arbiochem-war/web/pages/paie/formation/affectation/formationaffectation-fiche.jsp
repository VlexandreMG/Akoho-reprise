<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.formation.FormationAffectationLib" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    FormationAffectationLib o = new FormationAffectationLib();
    o.setNomTable("V_FORMATION_AFFECTATION");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'une affectation formation");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("formationlib").setLibelle("Formation");
    pc.getChampByName("personnellib").setLibelle("Personnel");
    pc.getChampByName("etatLib").setLibelle("Status");
    pc.getChampByName("idformation").setVisible(false);
    pc.getChampByName("idpersonnel").setVisible(false);
    pc.getChampByName("etat").setVisible(false);

    String[] ordre = {"id","formationlib","personnellib","etatLib"};
    pc.setOrdre(ordre);

    String pageRetour = "paie/formation/affectation/formationaffectation-liste.jsp";
    String pageModif = "paie/formation/affectation/formationaffectation-saisie.jsp&acte=update";
    String pageApresDelete = "paie/formation/affectation/formationaffectation-liste.jsp";
    String pageApresValider = "paie/formation/affectation/formationaffectation-fiche.jsp";
    String classe = "paie.formation.FormationAffectationLib";

    o = (FormationAffectationLib) pc.getBase();

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
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=Valider&bute="+pageApresValider+"&classe="+classe+"&nomtable=FORMATION_AFFECTATION" %>">Valider</a>
                        <% } %>
                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
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

