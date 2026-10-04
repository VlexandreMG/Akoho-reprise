<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="onBoarding.EmployeOnboardingChecklistLib" %>

<% try{ 
    EmployeOnboardingChecklistLib o = new EmployeOnboardingChecklistLib();
    o.setNomTable("EMPLOYEEONBOARDINGCHECKLISTCPL");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"id","idOnboardingItemlib","estTerminerLib","dateFin"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    String id = request.getParameter("id");
    if (!id.isEmpty() && id != null) {
        pr.setAWhere(" AND IDSESSIONONBOARDING = '" + id + "'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

//    String[] lienTableau = {pr.getLien() + "?but=onBoarding/onBoarding-fiche.jsp"};
//    String[] colonneLien = {"idOnboardingItemlib"};
//    String[] attributLien = {"idOnboardingItemlib"};
//    pr.getTableau().setLien(lienTableau);
//    pr.getTableau().setColonneLien(colonneLien);
//    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"ID","T&acirc;che &agrave; faire de l'onboarding","Termin&eacute;","Date de fin"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtmlWithCheckbox() != null){ %>
      <form action="<%=pr.getLien()%>?but=apresOnboarding.jsp" method="post">
       <input name="acte" type="hidden" id="acte" value="validerMultiple">
        <input name="bute" type="hidden" id="bute" value="onBoarding/employeeonboarding-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="onBoarding.EmployeOnBoardingChecklist">
        <%      out.println(pr.getTableau().getHtmlWithCheckbox()); %>
        </form>
        <%
        } else{ %>
            <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const table = document.querySelector("table");
        if (!table) return;

        const headers = table.querySelectorAll("thead th");
        let termineColIndex = -1;

        // Find the index of the "Terminé" column
        headers.forEach((th, index) => {
            if (th.textContent.trim().toLowerCase().includes("termin")) {
                termineColIndex = index;
            }
        });

        if (termineColIndex === -1) return;

        const rows = table.querySelectorAll("tbody tr");

        rows.forEach((row) => {
            const cells = row.querySelectorAll("td");
            if (!cells[termineColIndex]) return;

            const termineValue = cells[termineColIndex].textContent.trim().toLowerCase();

            if (termineValue === "oui") {
                const checkbox = row.querySelector("input[type='checkbox']");
                if (checkbox) {
                    checkbox.checked = true;
                    checkbox.disabled = true;
                }

                row.style.backgroundColor = "#d4edda";
                row.style.color = "#155724";
                row.style.fontWeight = "500";

                row.setAttribute("onmouseover", "this.style.backgroundColor='#c3e6cb'");
                row.setAttribute("onmouseout", "this.style.backgroundColor='#d4edda'");

                cells[termineColIndex].innerHTML =
                    '<span style="display:inline-flex;align-items:center;gap:6px;">' +
                    '<span style="background:#28a745;color:#fff;border-radius:12px;padding:2px 10px;font-size:12px;font-weight:600;">✓ Oui</span>' +
                    "</span>";
            }
        });

        const checkAll = table.querySelector("thead input[type='checkbox']");
        if (checkAll) {
            checkAll.addEventListener("click", function () {
                const allCheckboxes = table.querySelectorAll("tbody input[type='checkbox']");
                allCheckboxes.forEach((cb) => {
                    if (cb.disabled) {
                        cb.checked = true; // keep finished ones always checked
                    }
                });
            });
        }
    });
</script>
<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

