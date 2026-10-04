<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.couvoir.TriageQualitePoussinLib" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    TriageQualitePoussinLib o = new TriageQualitePoussinLib();
    o.setNomTable("TRIAGEQUALITEPOUSSIN_LIB");
    String[] listeCrt = {"idLotLib","idIncubateurLib","idEclosoirLib","daty","etatLib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","idLotLib","idIncubateurLib","idEclosoirLib","qtepoussinacontroler","daty", "etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("liste des triage qualite poussin");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/couvoir/triagequalitepoussin-liste.jsp");
    pr.getFormu().getChamp("etatLib").setLibelle("&Eacute;tat");
    Liste listeEtat = new Liste("etatlib");
    String [] aff = new String[]{"","Cr&eacute;&eacute;","Valid&eacute;","Annul&eacute;"};
    String [] affVal = new String[]{"","CREE", "VISEE", "ANNULEE"};
    listeEtat.ajouterValeur(affVal,aff);
    affichage.Champ[] liste = new affichage.Champ[1];
    liste[0] = listeEtat;
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("etatLib").setLibelle("&Eacute;tat");

    pr.getFormu().getChamp("idLotLib").setLibelle("Lot");
    pr.getFormu().getChamp("idIncubateurLib").setLibelle("Incubateur");
    pr.getFormu().getChamp("idEclosoirLib").setLibelle("Eclosoir");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    
    String[] colSomme = {"qtepoussinacontroler"};
    pr.creerObjetPage(libEntete, colSomme);
    
    String[] enteteRecap = {"","Nombre","Somme des quantit&eacute;s de poussins &agrave; contr&ocirc;le"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);

    String[] lienTableau = {pr.getLien() + "?but=ferme/couvoir/triagequalitepoussin-fiche.jsp",pr.getLien() + "?but=ferme/lot/lot-fiche.jsp"};
    String[] colonneLien = {"id","idLotLib"};
    String[] attributLien = {"id","id"};
    String[] valeurLien = {"id","idlot"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setValeurLien(valeurLien);

    String[] libEnteteAffiche = {"Id","Lot","Incubateur","&Eacute;closoir","Quantit&eacute; de poussins &agrave; contr&ocirc;ler","Date","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
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

