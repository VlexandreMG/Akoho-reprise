<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.batiment.BatimentVideSanitaireLib" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    BatimentVideSanitaireLib o = new BatimentVideSanitaireLib();
    o.setNomTable("BATIMENTVIDESANITAIRE_LIB");
    String[] listeCrt = {"id","idBatimentLib","idFermeLib","idResponsableLib","daty", "etatLib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","idFermeLib","idBatimentLib","idResponsableLib","heuredebut","heurefin","daty","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des batiment vide sanitaire");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("ferme/batiment/batimentvidesanitaire-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idBatimentLib").setLibelle("B&acirc;timent");
    pr.getFormu().getChamp("idFermeLib").setLibelle("Ferme");
    pr.getFormu().getChamp("idResponsableLib").setLibelle("Responsable");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    Liste listeEtat = new Liste("etatlib");
    String [] aff = new String[]{"","Cr&eacute;&eacute;","Valid&eacute;","Annul&eacute;"};
    String [] affVal = new String[]{"","CREE", "VISEE", "ANNULEE"};
    listeEtat.ajouterValeur(affVal,aff);
    affichage.Champ[] liste = new affichage.Champ[1];
    liste[0] = listeEtat;
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("etatLib").setLibelle("&Eacute;tat");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=ferme/batiment/batimentvidesanitaire-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Ferme","B&acirc;timent","Responsable","Heure de d&eacute;but","Heure de fin","Date","&Eacute;tat"};
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

