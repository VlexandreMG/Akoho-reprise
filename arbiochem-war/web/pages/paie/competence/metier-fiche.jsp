
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="paie.competence.MetierLib" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    MetierLib o = new MetierLib();
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un M&eacute;tier");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Libell&eacute;");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("idcoderomelib").setLibelle("Code ROME");
    pc.getChampByName("idfamilleprolib").setLibelle("Famille professionnelle");
    pc.getChampByName("idsousfamilleprolib").setLibelle("Sous-famille professionnelle");
//     pc.getChampByName("idFonctionLib").setLibelle("Fonction");
    pc.getChampByName("idcoderome").setVisible(false);

    String[] ordre = {"id","val","desce","idFamilleLib"};
    pc.setOrdre(ordre);

    String pageRetour = "paie/competence/metier-liste.jsp";
    String pageModif = "paie/competence/metier-saisie.jsp&acte=update";
    String pageApresDelete = "paie/competence/metier-liste.jsp";
    String classe = "paie.competence.Metier";

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
                        <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
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
