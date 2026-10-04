<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.onBoarding.CheckListFilleLib" %>

<% try{ 
    CheckListFilleLib o = new CheckListFilleLib();
    o.setNomTable("CHECKLIST_FILLE_LIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idTypeDocumentLib","idResponsableLib","contenue","est_cocheLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and IDCHECKLISTMERE='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Type de document","Responsable","Contenu","Check"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setNameActe("valider2");
    pr.getTableau().setNameBoutton("Check");
%>

<div class="box-body">
    <form action="<%= pr.getLien() + "?but=paie/onBoarding/apresCheck.jsp"%>" method="post" >
        <input type="hidden" name="acte">
        <input type="hidden" name="id" value="<%=request.getParameter("id")%>">
        <input type="hidden" name="bute" value="paie/onBoarding/checkentree-fiche.jsp">
        <% if(pr.getTableau().getHtmlWithCheckbox() != null){
            out.println(pr.getTableau().getHtmlWithCheckbox());
        }else { %>
        <div style="text-align: center;"><h4>Aucune donn&eacute;e trouv&eacute;e</h4></div>
        <% } %>
    </form>
</div>

<script>
    window.addEventListener('load', function () {
        const lignes = document.querySelectorAll("table tbody tr");

        lignes.forEach(function (tr) {
            const colonnes = tr.querySelectorAll("td");

            // On s'assure qu'il y a assez de colonnes (Checkbox + 5 colonnes de données)
            if (colonnes.length >= 6) {
                // La valeur "OUI" ou "NON" se trouve dans la dernière colonne (index 5)
                const valeurCheck = colonnes[5].textContent.trim().toUpperCase();

                if (valeurCheck === "OUI") {
                    // 1. Cacher la case à cocher (située dans la première colonne, index 0)
                    const checkbox = colonnes[0].querySelector("input[type='checkbox']");
                    if (checkbox) {
                        checkbox.style.display = "none";
                    }

                    // 2. Colorer la ligne en vert
                    // On applique la couleur sur les cellules pour s'assurer qu'elle surpasse le CSS du framework
                    colonnes.forEach(function (td) {
                        td.style.setProperty("background-color", "#d4edda", "important"); // Vert clair Bootstrap
                        td.style.setProperty("color", "#155724", "important"); // Texte vert foncé
                    });
                }
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

