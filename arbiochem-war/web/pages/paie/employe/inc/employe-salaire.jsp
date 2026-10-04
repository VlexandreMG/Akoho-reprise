<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.CategorieQualificationLib" %>
<%
    try{
        CategorieQualificationLib o = new CategorieQualificationLib();
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"nomPersonnel","matricule","montant","categorieLib","qualificationLib"};
        PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setAWhere(" AND id ='"+request.getParameter("id")+"'");

        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
%>
<div class="box-body">
    <%
        String[] libEnteteAffiche = {"Nom et pr&eacute;nom(s)","Matricule","Montant","Cat&eacute;gorie de qualification","Qualification"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {%>
    <div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>



