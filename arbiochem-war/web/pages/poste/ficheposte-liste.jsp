<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="poste.FichePosteLib" %>
<%@ page import="paie.annexe.BusinessUnit" %>
<%@ page import="affichage.Liste" %>
<% try{ 
    FichePosteLib o = new FichePosteLib();
    o.setNomTable("FICHE_POSTE_LIB");
    String[] listeCrt = {"id","reference","idBu","titre"};
    String[] listeInt = {};
    String[] libEntete = {"id","reference","idTypeContratLib","titre","idFonctionlib","idBuLib","idCategoriePaieLib","idQualificationPaieLib","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);

    String etatParam = request.getParameter("etat");
    if(etatParam != null && !etatParam.equals("%")){
        pr.setAWhere("and etat = '"+etatParam+"'");
    }
    String[] etatAff = {"Tous", "Cr&eacute;e","Valid&eacute;","Annul&eacute;"};
    String[] etatVal = {"%", "1", "11", "0"};

    Liste[] liste = new Liste[1];
    BusinessUnit nu = new BusinessUnit();
    liste[0] = new Liste("idBu",nu,"val","id");
    pr.getFormu().changerEnChamp(liste);
    pr.setTitre("Liste des fiche de poste");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("poste/ficheposte-liste.jsp");
    //pr.getFormu().getChamp("idDepartementLib").setLibelle("D&eacute;partement");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("idBu").setLibelle("BU");
    //pr.getFormu().getChamp("salairemin1").setLibelle("Salaire min");
    //pr.getFormu().getChamp("salairemin2").setLibelle("Salaire max");
    //pr.getFormu().getChamp("daty1").setLibelle("Date min");
    //pr.getFormu().getChamp("daty2").setLibelle("Date max");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=poste/ficheposte-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche =  {"ID","R&eacute;f&eacute;rence","Type de contrat","Titre","Fonction","Bu","Cat&eacute;gorie de paie","Qualification de paie","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=poste/ficheposte-saisie.jsp\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir une fiche de poste\n" +
                    "                </a>"
    );
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form id="rechercheForm" action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-12 nopadding">
                    <div class="row">
                        <div class="col-md-2 nopadding">
                            <label>&Eacute;tat :</label>
                            <select name="etat" class="champ form-control" id="etat" onchange="submitEtat()">
                                <%for(int i=0; i<etatVal.length; i++){
                                    String selected = (etatParam != null && etatParam.equals(etatVal[i])) ? "selected=\"selected\"" : "";
                                %>
                                <option value="<%=etatVal[i]%>" <%=selected%>><%=etatAff[i]%></option>
                                <%}%>
                            </select>
                        </div>
                        <div class="col-md-2"></div>
                    </div>
                </div>
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
<script type="text/javascript">
    function submitEtat() {
        var form = document.getElementById('rechercheForm');
        if (form) {
            form.submit();
        }
    }
</script>
<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

