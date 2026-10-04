<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="maintenance.capacitejournalier.CapaciteJournalierLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    CapaciteJournalierLib o = new CapaciteJournalierLib();
    o.setNomTable("");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("");
    String id = pc.getBase().getTuppleID();
    CapaciteJournalierLib base = (CapaciteJournalierLib) pc.getBase();
    String ligne = base.getIdLigne();

    pc.getChampByName("idLigneLib").setLibelle("Ligne");
    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("capacite").setLibelle("Capacit&eacute;");
    pc.getChampByName("idLigne").setVisible(false);
    pc.getChampByName("idLigneLib").setLien(lien+"?but=ligne/ligne-fiche.jsp","id=" + ligne +"&");

    String[] ordre = {"id","idLigneLib","capacite"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "maintenance/configuration/capacite-journalier-saisie.jsp&acte=update";
    String pageApresDelete = "maintenance/configuration/capacite-journalier-liste.jsp";
    String classe = "maintenance.capacitejournalier.CapaciteJournalierLib";

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
                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
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

