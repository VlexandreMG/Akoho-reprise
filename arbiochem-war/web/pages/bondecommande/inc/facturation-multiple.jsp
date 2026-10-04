<%@page import="faturefournisseur.As_BonDeLivraison_Lib"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<% try{
    As_BonDeLivraison_Lib t = new As_BonDeLivraison_Lib();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","remarque","daty","magasinlib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getAttribute("u"));
    pr.setLien((String) session.getAttribute("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idFactureFournisseur is null and etat = "+ConstanteEtat.getEtatValider()+" and idbc='"+request.getParameter("id")+"'");
    }
    pr.creerObjetPage(libEntete, null);
    String[] libEnteteAffiche =  {"Id","Remarque","Date","Magasin"};
    String[] lienTableau = {pr.getLien() + "?but=bondelivraison/bondelivraison-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <form action="<%= pr.getLien() + "?but=facturefournisseur/facturefournisseur-saisie.jsp&idbc="+request.getParameter("id")%>" method="post"
          onsubmit="supprimerNullIds(this)">
        <input type="hidden" name="acte">
        <% if(pr.getTableau().getHtmlWithCheckbox() != null){
            out.println(pr.getTableau().getHtmlWithCheckbox());
        } else { %>
        <div style="text-align: center;"><h4>Aucune donnée trouvée</h4>
        <% } %>
    </form>
    <%
        out.println(pr.getBasPage());
    %>
</div>
<script>
    function supprimerNullIds(form) {
        form.querySelectorAll('input[name="id"]').forEach(function(input) {
            if (input.value === 'null' || input.value === '') {
                input.parentNode.removeChild(input);
            }
        });
        return true;
    }
</script>
<% } catch (Exception e) {
    e.printStackTrace();%>
    <script language="JavaScript"> alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>



