<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="machine.InspectionFilleLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    InspectionFilleLib o = new InspectionFilleLib();
    o.setNomTable("INSPECTIONFILLELIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("idElementLib").setLibelle("&Eacute;l&eacute;ment");
    pc.getChampByName("idEtatInspectionLib").setLibelle("&Eacute;tat inspection");
    pc.getChampByName("idMachineLib").setLibelle("Machine");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idLigne").setLibelle("ID Ligne");
     pc.getChampByName("idLigneLib").setLibelle("Ligne");
    //pc.getChampByName("motsclesss").setVisible(false);
    pc.getChampByName("idMachine").setVisible(false);
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("idMere").setVisible(false);
    pc.getChampByName("idElement").setVisible(false);
    pc.getChampByName("idEtatInspection").setVisible(false);

    String[] ordre = {"idElementLib","idEtatInspectionLib","idMachineLib","remarque"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "inspection/inspection-saisie.jsp&acte=update";
    String pageApresDelete = "inspection/inspectionFille-liste.jsp";
    String classe = "machine.InspectionFilleLib";

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

