<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="declaration.DeclarationTvaLib" %>
<%@ page import="affichage.Liste" %>
<%@ page import="declaration.LiaisonCodeImpotLib" %>

<% try{
    LiaisonCodeImpotLib o = new LiaisonCodeImpotLib();
    o.setNomTable("LIAISONCODELib");
    String[] listeCrt = {"id","idcodeimpot","idcompte"};
    String[] listeInt = {};
    String[] libEntete = {"id","idcodeimpot","idCodeImpotLib","idcompte","formule","taxable"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des codes impôt - compte");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("declaration/liste-codeimpot-compte.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idcodeimpot").setLibelle("Code");
    pr.getFormu().getChamp("idcompte").setLibelle("Compte");


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id", "Code","Libell&eacute;","Compte","Formule", "Taxable"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    //String lienTableau[] = {pr.getLien() + "?but=declaration/fiche-declaration-tva.jsp"};
    //String colonneLien[] = {"id"};
    //pr.getTableau().setLien(lienTableau);
    //pr.getTableau().setColonneLien(colonneLien);
    pr.getFormu().setAnotherButton("<a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=declaration/saisie-codeimpot-compte.jsp&currentMenu=MENDYPAR001\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir des comptes par code imp&ocirc;t\n" +
            "                </a>");
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" >
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
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
<script>
    function changerDesignation() {
        document.vente.submit();
    }
</script>
<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

