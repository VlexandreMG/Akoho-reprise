
<%@page import="fabrication.*"%>
<%@page import="affichage.*"%>

<% try{
    RessourceParFabricationLib bc = new RessourceParFabricationLib();
    bc.setNomTable("RESSOURCEPARFAB_CPL_RECTIF");
    String lien = "";
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "idFabrication","matricule","idPosteLib","etatlib"};
    String libEnteteAffiche[] =  {"ID", "Fabrication","Matricule","Poste","&Eacute;tat"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("fabrication/fabrication-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/fabrication-hs");
    String[] colSomme = null;

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idFabrication='"+request.getParameter("id")+"'");
    }
    pr.setNpp(500);

    pr.creerObjetPage(libEntete, colSomme);

//    String lienTableau[] = {pr.getLien() + "?but=personnel/personnel-fiche.jsp",pr.getLien() + "?but=fabrication/heureSup-fiche.jsp"};
//    String colonneLien[] = {"idPersonne","id"};
//    String[] attributLien = {"id","id"};
//    String colonneModal[] = {"idPersonne","id"};
//    pr.getTableau().setLien(lienTableau);
//    pr.getTableau().setColonneLien(colonneLien);
//    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
//    pr.getTableau().setModalOnClick(true,colonneModal);
    pr.getTableau().setAfficheBouttondevalider(false);
    pr.getTableau().setNameBoutton("Valider");
%>
<% if(pr.getTableau().getHtmlWithCheckbox()!=null){ %>
<div class="box-body">
    <section class="">
        <form action="<%= pr.getLien() + "?but=apresMultiple.jsp"%>" method="post" >
            <input name="classe" type="hidden" id="classe" value="fabrication.RessourceParFabrication">
            <input name="nomtable" type="hidden" id="nomtable" value="RESSOURCEPARFABRICATION">
            <input name="acte" type="hidden" id="acte" value="validerMultiple">
            <input type="hidden" name="bute" value="fabrication/fabrication-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/fabrication-ressource" %>">
            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
        </form>
    </section>
</div>
<% if(pr.getTableau().getData() != null && pr.getTableau().getData().length>0) {%>
<%--<a class="btn btn-primary pull-left"  href="<%= lien + "?but=fabrication/ressource-modif-multiple.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Modifier</a>--%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const targetBtn = document.querySelector(".nav-tabs-custom .box-footer .btn.btn-secondary.pull-right");

        if (targetBtn) {
            $('.nav-tabs-custom .box-footer .btn.btn-secondary.pull-right').addClass('btn-primary');
            $('.nav-tabs-custom .box-footer .btn.btn-secondary.pull-right').removeClass('btn-secondary');
            const currentUrl = window.location.href;
            const urlParams = new URLSearchParams(window.location.search);
            const id = urlParams.get("id");

            const lien = "<%= lien %>"; // si tu veux garder la variable JSP
            console.log("lien :"+lien);

            const newBtn = document.createElement("a");
            newBtn.className = "btn btn-secondary pull-right";
            newBtn.href = `${lien}?but=fabrication/ressource-modif-multiple.jsp&id=${id}`;
            newBtn.style.marginRight = "10px";
            newBtn.textContent = "Modifier";
            targetBtn.insertAdjacentElement("afterend", newBtn);
        }
    });
</script>
<% } %>
<% }else{ %>
<h2 class='no-data-msg' style='margin-left:0' >Aucune donn&eacute;e disponible</h2>
<% } %>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>







