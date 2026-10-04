<%--
  Created by IntelliJ IDEA.
  User: safidy
  Date: 27/03/2026
  Time: 13:53
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.absence.TypeAbsenceLib" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    TypeAbsenceLib o = new TypeAbsenceLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche du type d'absence");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Libelle");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("nbjour").setLibelle("Nombre de jour");
    pc.getChampByName("frequencelib").setLibelle("Fr&eacute;quence");

    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("frequence").setVisible(false);
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");

    String pageRetour = "paie/absence/typeabsence-liste.jsp";
    String classe = "paie.absence.TypeAbsence";

    String pageActuel = "paie/absence/typeabsence-fiche.jsp";



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


