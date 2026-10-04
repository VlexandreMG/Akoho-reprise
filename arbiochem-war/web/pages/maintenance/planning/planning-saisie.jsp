<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="maintenance.planning.Planning" %>
<%@ page import="maintenance.configuration.TypeMaintenance" %>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "maintenance.planning.Planning",
                nomtable = "Planning",
                apres = "maintenance/planning/planning-fiche.jsp",
                titre = "Saisie de planning";
        if (request.getParameter("acte")!=null && request.getParameter("acte").equals("update")){
            titre = "Modification de planning";
        }
        Planning categorie = new Planning();
        PageInsert pi = new PageInsert(categorie, request, u);
        pi.setLien((String) session.getValue("lien"));

        Liste[] liste = new Liste[6];
        TypeMaintenance c = new TypeMaintenance();
        liste[0] = new Liste("idTypeMaintenance",c,"val","id");
        liste[1] = new Liste("estPeriodique");
        liste[1].makeListeOuiNon();
        TypeObjet tp = new TypeObjet();
        tp.setNomTable("UNITEMAINTENANCE");
        liste[2] = new Liste("unite",tp,"val","id");
        IngredientMaintenance im= new IngredientMaintenance("AS_INGREDIENT_MACHINE");
        liste[3] = new Liste("idMachine", im, "libelle", "id");
        liste[4] = new Liste("idLigne",   new TypeObjet("ligne"), "val", "id");
        liste[4].setDeroulanteDependante(liste[3],"idligne","onchange");
        liste[5] = new Liste("idSituation",   new TypeObjet("situation"), "val", "id");

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("refObjet").setLibelle("Description");
        pi.getFormu().getChamp("idMachine").setLibelle("&Eacute;l&eacute;ment");
        pi.getFormu().getChamp("idLigne").setLibelle("Ligne");
        pi.getFormu().getChamp("idSituation").setLibelle("Situation");
        pi.getFormu().getChamp("idTypeMaintenance").setLibelle("Type de maintenance");
        pi.getFormu().getChamp("frequence").setLibelle("Fr&eacute;quence");
        pi.getFormu().getChamp("datedebut").setLibelle("Date de d&eacute;but");
        pi.getFormu().getChamp("datefin").setLibelle("Date de fin");
        pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
        pi.getFormu().getChamp("estPeriodique").setLibelle("Est p&eacute;riodique");
        pi.getFormu().getChamp("estPeriodique").setAutre("onChange=\"changeChamp()\"");
        pi.getFormu().getChamp("duree").setLibelle("dur&eacute;e");
        pi.getFormu().getChamp("duree").setType("time");
        pi.getFormu().getChamp("heure").setType("time");
        pi.getFormu().getChamp("duree").setAutre("step=\"1\"");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idSource").setVisible(false);
//        pi.getFormu().getChamp("datefin").setVisible(false);

        pi.getFormu().setOrdre(new String[]{"id","datedebut", "datefin","idTypeMaintenance","idLigne","idMachine", "idSituation","estPeriodique","frequence","unite","heure","duree"});
        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<script>
    function changeChamp(){
        let champPeriodique = document.getElementById("estPeriodique");
        let frequence = document.getElementById("frequence");
        let unite = document.getElementById("unite");

        if (champPeriodique.value === "0"){
            frequence.value = "";
            frequence.disabled = true;
            unite.value = "";
            unite.disabled = true;
        }else {
            frequence.disabled = false;
            unite.disabled = false;
        }
    }
</script>
<script>
    document.addEventListener("DOMContentLoaded", function(){
        const inputContainer = document.querySelector('.input-container');
        const frequenceInput = document.getElementById("frequence");
        const uniteInput = document.getElementById("unite");
        console.log("FREQUENCE INPUT :", frequenceInput);
        const uniteData = {<%
            TypeObjet[] bases = (TypeObjet[]) liste[2].getBase();
            for (int i = 0; i < bases.length; i++) {
                out.print("'" + bases[i].getVal().toLowerCase() + "':'" + bases[i].getId() + "'");
                if (i < bases.length - 1) {
                    out.print(",");
                }
            }
        %>};

        // Créer la div principale (cachée par défaut)
        const divJours = document.createElement('div');
        divJours.className = 'd-flex gap-2 d-none';
        divJours.id = 'jours-container';

        // Liste des jours de la semaine
        const jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi'];

        // Créer un checkbox pour chaque jour
        jours.forEach(jour => {
            // Créer la div form-input
            const formInput = document.createElement('div');
            formInput.className = 'form-input';

            // Créer le checkbox
            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.id = jour.toLowerCase();
            checkbox.name = 'jours';
            checkbox.value = jour;
            checkbox.addEventListener('change', () => {
                updateFrequency();
            });

            // Créer le label
            const label = document.createElement('label');
            label.htmlFor = jour.toLowerCase();
            label.textContent = jour;

            // Ajouter le checkbox et le label dans form-input
            formInput.appendChild(checkbox);
            formInput.appendChild(label);

            // Ajouter form-input dans la div principale
            divJours.appendChild(formInput);
        });

        // Ajouter la div dans le container
        inputContainer.appendChild(divJours);

        function updateFrequency() {
            const count = document.querySelectorAll('input[name="jours"]:checked').length;
            frequenceInput.value = count;
        }

        // Fonction pour gérer l'affichage et la limitation
        function gererJours() {
            const unite = uniteInput.value;


            if (unite === uniteData['semaine']) {
                divJours.classList.remove('d-none');
                frequenceInput.readOnly = true;
            } else {
                divJours.classList.add('d-none');
                frequenceInput.readOnly = false;

                document.querySelectorAll('input[name="jours"]').forEach(cb => cb.checked = false);
                //frequenceInput.value = 0;
            }

            // Limiter le nombre de sélections
            const checkboxes = document.querySelectorAll('input[name="jours"]');
            console.log("CHECKBOXES :", checkboxes);

            <%--checkboxes.forEach(checkbox => {--%>
            <%--    checkbox.addEventListener('change', function(event) {--%>
            <%--        const frequence = parseInt(frequenceInput.value) || 0;--%>
            <%--        const checkedCount = document.querySelectorAll('input[name="jours"]:checked').length;--%>

            <%--        if (checkedCount > frequence) {--%>
            <%--            event.target.checked = false;--%>
            <%--            alert(`Vous ne pouvez sélectionner que ${frequence} jour(s) maximum.`);--%>
            <%--        }--%>
            <%--    });--%>
            <%--});--%>
        }

        // Écouter les changements sur unite et frequence
        uniteInput.addEventListener('change', gererJours);
        frequenceInput.addEventListener('input', gererJours);
        gererJours();
        updateFrequency();
        changeChamp();
    });

    window.addEventListener("pageshow", function () {
        changeChamp();
    });
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>
<% }%>