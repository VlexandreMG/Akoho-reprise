<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="mg.cnaps.compta.ecriture.ComptaEcritureLib" %>
<%@ page import="affichage.PageRecherche" %>
<%@ page import="utilitaire.*"%>
<%
    ComptaEcritureLib ecr = new ComptaEcritureLib();
    String dateJour = utilitaire.Utilitaire.dateDuJour();
    ecr.setNomTable("compta_ecriture_lib");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","designation","daty","montant","exercice","journalcode","etatlib"};
    PageRecherche pr = new PageRecherche(ecr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and journal='"+request.getParameter("id")+"' and daty=TO_DATE('"+dateJour+"','DD/MM/YYYY')");
    }
    pr.setApres("#");
    String[] colSomme = null;
    pr.setNpp(10);
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=compta/ecriture/ecriture-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    int nombreLigne = pr.getTableau().getData().length;
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence","D&eacute;signation","Date","Montant","Exercice","journal","&eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<%
    if (pr.getTableau().getHtml() != null) {
        out.println(pr.getTableau().getHtml());
        out.println(pr.getBasPage());
    } else {
%>
<div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div>
<%
    }
%>

