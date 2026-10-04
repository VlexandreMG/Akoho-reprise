<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="entretien.Entretient" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    Entretient o = new Entretient();
    o.setNomTable("V_ENTRETIENT");

    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un entretien");

    String id = pc.getBase().getTuppleID();

    // 🔥 Libellés
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idCandidature").setLibelle("Candidature");
    pc.getChampByName("idCandidature").setLien(lien + "?but=paie/recrutement/candidature-fiche.jsp","id=");
//    pc.getChampByName("idInterviewer").setLibelle("Intervieweur");
    pc.getChampByName("idInterviewer").setVisible(false);
    pc.getChampByName("dateEntretient").setLibelle("Date de l'entretien");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("score").setLibelle("Score de l’entretien");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("idCandidatLib").setLibelle("Nom du candidat");
    pc.getChampByName("idInterviewerLib").setLibelle("Nom du responsable de l'entretien");

    // 🔥 Ordre affichage
    String[] ordre = {
        "id",
        "idCandidature",
            "idCandidatLib",
            "idInterviewerLib",
        "idInterviewer",
        "dateEntretient",
        "etat",
        "score",
        "remarque"
    };
    pc.setOrdre(ordre);

    // 🔥 Navigation
    String pageRetour = "entretient/entretient-liste.jsp";
    String pageModif = "entretient/entretient-saisie.jsp&acte=update";
    String pageApresDelete = "entretient/entretient-liste.jsp";
     String pageEmbauche = "paie/employe/infopersonnel-saisie.jsp";
    String classe = "entretien.Entretient";
    Entretient entretient = (Entretient) pc.getBase();
%>

<div class="content-wrapper">

<h1 class="box-title">
    <a href="<%= lien + "?but=" + pageRetour%>">
        <i class="fa fa-angle-left"></i>
    </a>
    <%=pc.getTitre()%>
</h1>

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
                        <a class="btn btn-danger pull-left"
                           href="<%= lien + "?but=apresTarif.jsp&id=" + id +
                           "&acte=delete&bute="+pageApresDelete+
                           "&classe="+classe %>">
                            Supprimer
                        </a>
                        <% if(entretient.getEtat() != 11){ %>
                            <% if (!"dg".equalsIgnoreCase(u.getUser().getIdrole())) { %>
                                <a class="btn btn-secondary pull-right"
                                   href="<%= lien + "?but="+ pageModif +"&id=" + id %>"
                                   style="margin-right: 10px">
                                    Modifier
                                </a>
                             <% }%>
                        <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=valider&bute=entretient/entretient-fiche.jsp&classe="+classe %>">
                                    <button class="btn btn-primary pull-right">Valider</button>
                        </a>
                        <% } %>
                         <% if(entretient.getEtat() == 11){ %>
                        <a class="btn btn-default pull-right"  href="<%= lien + "?but="+ pageEmbauche +"&idEntretient=" + id %>" style="margin-right: 10px">Embauche</a>
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
<script>
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>