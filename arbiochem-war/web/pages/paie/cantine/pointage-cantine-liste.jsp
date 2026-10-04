<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.cantine.PointageCantineCpl" %>

<% try{ 
    PointageCantineCpl o = new PointageCantineCpl();

    String etat = request.getParameter("etat");
    if(etat == null || etat.isEmpty()) etat = "";

    String mois = request.getParameter("mois");
    if(mois == null) mois = "";

    o.setNomTable("POINTAGECANTINE_CPL");

    String[] listeCrt = {"id","nomPersonnel","annee"};
    String[] listeInt = {};
    String[] libEntete = {"id","matricule","nomPersonnel","nombre","moisLib","annee","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);

    // Filtre état
    if(!etat.isEmpty()){
        pr.setAWhere(" and etat = '"+ etat +"'");
    }

    // Filtre mois
    if(!mois.isEmpty()){
        pr.setAWhere(pr.getAWhere() + " and mois = " + mois);
    }

    pr.setTitre("Liste des pointages cantine");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/cantine/pointage-cantine-liste.jsp");

    boolean etatCree = "1".equalsIgnoreCase(etat);
    String formAction = pr.getLien() + "?but=" + (etatCree ? "paie/cantine/apresPointageCantine.jsp&acte=valider" : pr.getApres());

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("nomPersonnel").setLibelle("Nom du personnel");
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"Id","Matricule","Nom du personnel","Nombre","Mois","Ann&eacute;e","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String[] etatAffiche = { "Tous","Cr&eacute;&eacute;", "Vis&eacute;e" };
    String[] etatPasse = { "","1","11" };
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>

    <section class="content">

        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="formRecherche" id="formRecherche">

            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

            <div class="col-md-12 mb-5 nopadding">
                <div class="row">

                    <!-- FILTRE MOIS -->
                    <div class="col-md-4">
                        Mois :
                        <select name="mois" class="champ form-control" onchange="changerMois()">

                            <option value="">Tous</option>

                            <%
                                String[] moisLib = {"Janvier","Février","Mars","Avril","Mai","Juin",
                                                    "Juillet","Août","Septembre","Octobre","Novembre","Décembre"};

                                for(int i=1;i<=12;i++){
                                    String selected="";
                                    if(mois.equals(String.valueOf(i))){
                                        selected="selected";
                                    }
                            %>

                            <option value="<%=i%>" <%=selected%>><%=moisLib[i-1]%></option>

                            <% } %>

                        </select>
                    </div>

                    <!-- FILTRE ETAT -->
                    <div class="col-md-4">
                        &Eacute;tat :
                        <select name="etat" class="champ form-control" id="etat" onchange="changerEtat()">
                            <%
                                for( int i = 0; i < etatAffiche.length; i++ ){
                                    String selected = "";
                                    if(etat != null && etat.equals(etatPasse[i])){
                                        selected = "selected";
                                    }
                            %>
                                <option value="<%= etatPasse[i] %>" <%= selected %>> <%= etatAffiche[i] %> </option>
                            <%  } %>
                        </select>
                    </div>

                </div>
            </div>

        </form>

        <form action="<%= formAction %>" method="post" name="pointage" id="pointage">

            <input type="hidden" name="lien" value="<%= pr.getLien() %>">
            <input type="hidden" name="searchVal" value="<%= request.getParameter("searchVal") != null ? request.getParameter("searchVal") : "" %>">

            <%
                out.println(pr.getTableauRecap().getHtml());
            %>

            <br>

            <%
                if(etatCree){
                    pr.getTableau().setNameBoutton("Valider");
                    out.println(pr.getTableau().getHtmlWithCheckbox());
                } else {
                    out.println(pr.getTableau().getHtml());
                }

                out.println(pr.getBasPage());
            %>

        </form>

    </section>
</div>

<script>

function changerEtat(){
    document.formRecherche.submit();
}

function changerMois(){
    document.formRecherche.submit();
}

</script>

<% } catch (Exception e) {
  e.printStackTrace();
%>

<script language="JavaScript">
alert('<%=e.getMessage()%>');
history.back();
</script>

<% }%>