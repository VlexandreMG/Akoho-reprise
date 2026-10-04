<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.recrutement.Candidatureslib" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>

<% try{
    String etat = request.getParameter("etat");
    if(etat == null || etat.isEmpty()) etat = "";

    Candidatureslib o = new Candidatureslib();
    o.setNomTable("candidatureslib");
    String[] listeCrt = {"id","idcandidatlib","idoffreemploielib","dateapplication"};
    String[] listeInt = {"dateapplication"};
    String[] libEntete = {"id","idcandidat","idcandidatlib","idoffreemploielib","dateapplication","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);

    if(!etat.isEmpty()){
        pr.setAWhere(" and etat = '"+ etat +"'");
    }

    pr.setTitre("Liste des candidatures");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/recrutement/candidature-liste.jsp");
    
    Liste[] liste = new Liste[0];
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idcandidatlib").setLibelle("Nom & pr&eacute;nom");
    pr.getFormu().getChamp("idoffreemploielib").setLibelle("Offre d'emploi");
    pr.getFormu().getChamp("dateapplication1").setLibelle("Date d'application min");
    pr.getFormu().getChamp("dateapplication2").setLibelle("Date d'application max");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=paie/recrutement/candidature-fiche.jsp",pr.getLien() + "?but=paie/recrutement/candidat-fiche.jsp"};
    String[] colonneLien = {"id","idcandidat"};
    String[] attributLien = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Id Candidat","Nom & pr&eacute;nom","Offre d'emploi","Date d'application","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=paie/recrutement/candidature-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir une nouvelle candidature\n" +
                    "                </a>"
    );

    String[] etatAffiche = { "Tous","Cr&eacute;&eacute;", "Vis&eacute;e" , "Embauch&eacute;e", "Refus&eacute;e"};
    String[] etatPasse = { "","1","11","13","-1" };
%>
<script>

    function changerEtat(){
        document.formRecherche.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="formRecherche" id="formRecherche">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="col-md-12 mb-5 nopadding">
                <div class="row">
            <div class="col-md-2" style="margin-top: 10px !important;">
                &Eacute;tat :
                <select name="etat" class="champ form-control" id="etat" onchange="changerEtat()">
                    <%
                        for( int i = 0; i < etatAffiche.length; i++ ){
                            String selected = "";
                            if(etat != null && etat.equals(etatPasse[i])){
                                selected = "selected";
                            }
                    %>
                    <option value="<%= etatPasse[i] %>" <%= selected %>> <%= etatAffiche[i] %> </option>
                    <%  } %>
                </select>
            </div>
            </div>
            </div>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

