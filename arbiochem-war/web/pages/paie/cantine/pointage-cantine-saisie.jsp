<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="affichage.Champ" %>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.cantine.PointageCantineCpl" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="bean.CGenUtil" %>

<% try{
  UserEJB u = (user.UserEJB) session.getValue("u");
  int taille = 10;

  PointageCantineCpl fille = new PointageCantineCpl();
  fille.setNomTable("POINTAGECANTINE_CPL");

  PageInsertMultiple pi = new PageInsertMultiple(fille, fille, request, taille, u);
  pi.setLien((String) session.getValue("lien"));
  pi.setTitre("Enregistrement des pointages cantine en lot");

  if (request.getParameter("onchanged") != null && request.getParameter("onchanged").equals("true")){
    String iddepartement = request.getParameter("iddepartement");
    if (iddepartement != null) {
      System.out.println("iddepartement : " + iddepartement);
      PointageCantineCpl[] filles = fille.genererPointage(iddepartement);
      System.out.println(filles);
      if (filles != null) {
        pi = new PageInsertMultiple(fille, fille, request, filles.length, u);
        pi.setLien((String) session.getValue("lien"));
        pi.setTitre("Enregistrement des pointages cantine en lot");
        taille = filles.length;
        pi.setDefautFille(filles);
      }
    }
  }

  pi.getFormu().getChamp("daty").setVisible(false);
  pi.getFormu().getChamp("etat").setVisible(false);
  pi.getFormu().getChamp("idPersonnel").setVisible(false);
  pi.getFormu().getChamp("idDepartement").setVisible(false);

  String[] ordre = {
          "idpersonnel",
          "matricule",
          "nomPersonnel",
          "nombre",
          "mois",
          "annee"
  };

  pi.getFormufle().setColOrdre(ordre);

  pi.getFormufle().getChamp("idpersonnel_0").setLibelle("Personnel");
  pi.getFormufle().getChamp("matricule_0").setLibelle("Matricule");
  pi.getFormufle().getChamp("nomPersonnel_0").setLibelle("Nom du Personnel");
  pi.getFormufle().getChamp("nombre_0").setLibelle("Nombre");
  pi.getFormufle().getChamp("annee_0").setLibelle("Année");
  pi.getFormufle().getChamp("annee_0").setVisible(false);
  pi.getFormufle().getChamp("annee_0").setType("INTEGER");
  String selectedDepartement = request.getParameter("iddepartement");

//  affichage.Liste[] liste = new Liste[1];
//  Liste mois = new Liste("mois");
//  String[] valeur = {"1","2","3","4","5","6","7","8","9","10","11","12"};
//  String[] affiche = {"Janvier","Février","Mars","Avril","Mai","Juin", "Juillet","Aout","Septembre","Octobre","Novembre","Décembre"};
//  mois.ajouterValeur(valeur,affiche);
//  liste[0] = mois;
//  pi.getFormufle().changerEnChamp(liste);
  pi.getFormufle().getChamp("mois_0").setLibelle("Mois");
  // Définir les valeurs par défaut pour toutes les lignes
  for(int i = 0; i < taille; i++){
    pi.getFormufle().getChamp("mois_"+i).setDefaut(""+Utilitaire.getMoisEnCours());
    pi.getFormufle().getChamp("annee_"+i).setDefaut(""+Utilitaire.getAneeEnCours());
    pi.getFormufle().getChamp("annee_"+i).setVisible(false);
    pi.getFormufle().getChamp("nombre_"+i).setDefaut("0");
    pi.getFormufle().getChamp("nomPersonnel_"+i).setAutre("readonly");
    pi.getFormufle().getChamp("matricule_"+i).setAutre("readonly");
    // pi.getFormufle().getChamp("idpersonnel_"+i)
    // .setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","matricule","nom");
  }
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idpersonnel").getListeChamp(),"paie.log.LogPersonnel","id","LOG_PERSONNEL_V2","nom;matricule","nomPersonnel;matricule");

  pi.getFormufle().getChampMulitple("id").setVisible(false);
  pi.getFormufle().getChampMulitple("daty").setVisible(false);
  pi.getFormufle().getChampMulitple("etat").setVisible(false);
  pi.getFormufle().getChampMulitple("idDepartement").setVisible(false);
  pi.getFormufle().getChampMulitple("departementLib").setVisible(false);
  pi.getFormufle().getChampMulitple("etatLib").setVisible(false);
  pi.getFormufle().getChampMulitple("moisLib").setVisible(false);

  TypeObjet typeObjet = new TypeObjet();
  typeObjet.setNomTable("DEPARTEMENT");
  TypeObjet[] deps = (TypeObjet[]) CGenUtil.rechercher(typeObjet, null, null, "");


  pi.preparerDataFormu();
  pi.getFormu().makeHtmlInsertTabIndex();
  pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<script>
  function changerDesignation() {
    document.incident.submit();
  }

  document.addEventListener('DOMContentLoaded', function() {
    const valeurs = ["1","2","3","4","5","6","7","8","9","10","11","12"];
    const affichages = ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"];

    const moisInputs = document.querySelectorAll('input[name^="mois_"]');

    moisInputs.forEach(function(input) {
      const select = document.createElement('select');
      select.name = input.name;
      select.id = input.id;
      select.className = input.className;

      const now = new Date();
      const moisActuel = now.getMonth() + 1;

      let currentValue = now.getMonth() + 1;

      for (let i = 0; i < valeurs.length; i++) {
        const option = document.createElement('option');
        option.value = valeurs[i];
        option.textContent = affichages[i];

        if (currentValue === parseInt(valeurs[i], 10)) {
          option.selected = true;
        }

        select.appendChild(option);
      }

      // Replace ONCE
      input.parentNode.replaceChild(select, input);
    });
  });
</script>
<div class="content-wrapper">
  <section class="content-header">
    <h1><%= pi.getTitre() %></h1>

  </section>
  <section class="content">
    <form action="<%=pi.getLien()%>?but=paie/cantine/pointage-cantine-saisie.jsp" method="post" name="incident" id="incident">
      <input name="onchanged" type="hidden" id="onchanged" value="true">
      <%
        out.println(pi.getFormu().getHtmlEnsemble());
      %>
      <div class="row col-md-12 nopadding">
        <div class="col-md-2 nopadding">
          D&eacutepartement :
          <select name="iddepartement" class="champ form-control" id="iddepartement" onchange="changerDesignation()">
            <%
              for( int i = 0; i < deps.length; i++ ){
                String selected = "";
                if(selectedDepartement != null && selectedDepartement.equals(deps[i].getId())){
                  selected = "selected";
                }
              %>
                <option value="<%= deps[i].getId() %>" <%= selected %>> <%= deps[i].getVal() %> </option>
            <% } %>
          </select>
        </div>
      </div>
    </form>
  <form id="formId" class='container' action="<%=pi.getLien()%>?but=paie/cantine/apresMultiple-cantine.jsp" method="post" >
    <%
      out.println(pi.getFormufle().getHtmlTableauInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
    <input name="bute" type="hidden" id="bute" value="paie/cantine/pointage-cantine-liste.jsp">
    <input name="classe" type="hidden" id="classe" value="paie.cantine.PointageCantine">
    <input name="classefille" type="hidden" id="classefille" value="paie.cantine.PointageCantine">
    <input name="nomtable" type="hidden" id="nomtable" value="pointagecantine">
    <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
  </form>
  </section>
</div>

<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>

