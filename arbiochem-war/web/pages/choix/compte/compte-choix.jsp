<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRechercheChoix"%>
<%@ page import="mg.cnaps.compta.ComptaCompteIngredients" %>

<% try{
    String champReturn = request.getParameter("champReturn");
    String premierChamp = champReturn.split(";")[0]; // "compte_0"
    int x = -1;
    if (premierChamp.contains("_")) {
        String[] parts = premierChamp.split("_");
        x = Integer.parseInt(parts[parts.length - 1]); // récupère le 0
    }
    champReturn += ";idProduit_" + x + ";idProduit_" + x + "libelle";

    System.err.println(champReturn);

    ComptaCompteIngredients o = new ComptaCompteIngredients();
    String[] listeCrt = {"compte","libelle","idIngredient","libelleIngredient"};
    String[] listeInt = {};
    String[] libEntete = {"compte","libelle","idIngredient","libelleIngredient"};
    PageRechercheChoix pr = new PageRechercheChoix(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setTitre("Liste compte");
    pr.setChampReturn(champReturn);
    pr.setApres("compte-choix.jsp");

    pr.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pr.getFormu().getChamp("idIngredient").setLibelle("Id Ingr&eacute;dient");
    pr.getFormu().getChamp("libelleIngredient").setLibelle("Ingr&eacute;dient");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Compte","Libell&eacute;","Id Ingr&eacute;dient","Ingr&eacute;dient"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<html>
<head>
    <meta charset="UTF-8">
    <title><%= pr.getTitre()%></title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <jsp:include page='./../../elements/css.jsp'/>
</head>
<body class="skin-blue sidebar-mini">
<div class="wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre()%></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getApres()%>?champReturn=<%=champReturn%>" method="post" name="fcdetailsliste" id="fcdetailsliste">
            <% out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <form action="./../apresChoix.jsp" method="post" name="frmchx" id="frmchx">
            <input type="hidden" name="champReturn" value="<%=pr.getChampReturn()%>">
            <%
                out.println(pr.getTableau().getHtmlWithRadioButton()); %>
        </form>
        <% out.println(pr.getBasPage());%>
    </section>
</div>
<jsp:include page='./../../elements/js.jsp'/>
</body>
</html>

<script>
    window.addEventListener('DOMContentLoaded', () => {
        const radios = document.querySelectorAll('input[type="radio"][name="choix"]');
        radios.forEach(radio => {
            const tr = radio.closest('tr');
            if (!tr) return;
            // 5ème colonne (index 4)
            const col5 = tr.children[4]?.textContent.trim();
            // 6ème colonne (index 5)
            const col6 = tr.children[4]?.textContent.trim();
            if (col5) {
                radio.value += ";" + col5;
            }
            if (col6) {
                radio.value += ";" + col6;
            }
        });
    });
</script>


<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>


