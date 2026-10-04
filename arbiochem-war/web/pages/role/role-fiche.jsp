<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="utilisateur.ActionRole" %>

<%
    try{
        String lien = (String) session.getValue("lien");
        ActionRole t = new ActionRole();
        t.setNomTable("ActionRolesLibelle");
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (ActionRole) pc.getBase();
        String id=pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("nomtableobjet").setLibelle("Nom table");
        pc.getChampByName("roleminimum").setLibelle("R&ocirc;le minimum");
        pc.getChampByName("groupetable").setLibelle("Groupe");
        pc.setTitre("Fiche action role");
        String pageActuel = "role/role-fiche.jsp";
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="#"><i class="fa fa-angle-left"></i></a><% out.println(pc.getTitre()); %></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=role/actionrole-saisie.jsp&acte=update&id=" + id %> " style="margin-right: 10px">Modifier</a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>