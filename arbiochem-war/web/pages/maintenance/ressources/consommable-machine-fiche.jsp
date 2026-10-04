<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="maintenance.ressources.ConsommableMachineLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ConsommableMachineLib o = new ConsommableMachineLib();
    o.setNomTable("CONSOMMABLEMACHINELIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un Consommable Machine");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idMachineLib").setLibelle("Machine");
    pc.getChampByName("frequenceLib").setLibelle("Fr&eacute;quence");
    pc.getChampByName("idTypeMaintenanceLib").setLibelle("Type de maintenance");
    pc.getChampByName("idUniteLib").setLibelle("Unit&eacute;");
    pc.getChampByName("qte").setLibelle("Quantit&eacute;");
    pc.getChampByName("idConsommableLib").setLibelle("Consommable");
    pc.getChampByName("idMachine").setVisible(false);
    pc.getChampByName("idConsommable").setVisible(false);
    pc.getChampByName("idTypeMaintenance").setVisible(false);
    pc.getChampByName("idUnite").setVisible(false);
    pc.getChampByName("frequence").setVisible(false);

    String[] ordre = {"id","idMachineLib","frequenceLib","idTypeMaintenanceLib","idUniteLib","qte"};
    pc.setOrdre(ordre);

    String pageRetour = "maintenance/ressources/consommable-machine-liste.jsp";
    String pageModif = "maintenance/ressources/consommable-machine-saisie.jsp&acte=update";
    String pageApresDelete = "maintenance/ressources/consommable-machine-liste.jsp";
    String classe = "maintenance.ressources.ConsommableMachineLib";

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
                            <a class="btn btn-danger pull-left"  href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>" style="margin-right: 10px">Supprimer</a>
                        </div>
                        <br/>
                    </div>
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

