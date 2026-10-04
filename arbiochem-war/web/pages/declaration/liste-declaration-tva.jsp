<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="declaration.DeclarationTvaLib" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    DeclarationTvaLib o = new DeclarationTvaLib();
    o.setNomTable("DECLARATIONTVALIB");
    String[] listeCrt = {"id","designation"};
    String[] listeInt = {};
    String[] libEntete = {"id","designation","datydebut","datyfin","montantpayer","payementLib","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des d&eacute;clarations ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("declaration/liste-declaration-tva.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"R&eacute;f&eacute;rence","D&eacute;signation","Date de d&eacute;but","Date de Fin","Montant pay&eacute;","&Eacute;tat de Payement","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String lienTableau[] = {pr.getLien() + "?but=declaration/fiche-declaration-tva.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getFormu().setAnotherButton("<a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=declaration/declaration-tva.jsp&currentMenu=MENDYN176638DECL001\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir une d&eacute;claration de TVA\n" +
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
        <div class="row col-md-12 nopadding">
            <div class="col-md-2 nopadding">
                <label class="input-label" for="etat">&Eacute;tat :</label>
                <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" >
                    <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("mvtstocklib") == 0) {%>
                    <option value="declarationtvalib" selected>Tous</option>
                    <% } else { %>
                    <option value="declarationtvalib" >Tous</option>
                    <% } %>
                    <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("declarationtvalibcreer") == 0) {%>
                    <option value="declarationtvalibcreer" selected>Cr&eacute;&eacute;</option>
                    <% } else { %>
                    <option value="declarationtvalibcreer">Cr&eacute;&eacute;</option>
                    <% } %>
                    <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("declarationtvalibvalider") == 0) {%>
                    <option value="declarationtvalibvalider" selected>Vis&eacute;</option>
                    <% } else { %>
                    <option value="declarationtvalibvalider">Vis&eacute;</option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-4"></div>
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

