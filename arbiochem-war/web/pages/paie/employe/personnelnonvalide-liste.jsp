<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="paie.log.LogPersnonValideComplet" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    LogPersnonValideComplet o = new LogPersnonValideComplet();
    o.setNomTable("LOG_PERS_NON_VALIDE_LIB");

    String nomTable = "LOG_PERS_NON_VALIDE_LIB";
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        nomTable = request.getParameter("etat");
        o.setNomTable(nomTable);
    }

    String[] listeCrt = {"id","matricule","dateapplication","idtypedebauche"};
    String[] listeInt = {"dateapplication"};
    String[] libEntete = {"id","matricule","idlogpers","dateapplication","idtypedebauche","etatLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/employe/personnelnonvalide-liste.jsp");

    Liste[] liste = new Liste[1];
    TypeObjet r = new TypeObjet();
    r.setNomTable("type_depart");
    liste[0] = new Liste("idtypedebauche", r,"val", "val");
    pr.getFormu().changerEnChamp(liste);


    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
//    pr.getFormu().getChamp("idlogpers").setLibelle("Id log personnel");
    pr.getFormu().getChamp("dateapplication1").setLibelle("Date d'application min");
    pr.getFormu().getChamp("dateapplication2").setLibelle("Date d'application max");
    pr.getFormu().getChamp("idtypedebauche").setLibelle("Cause de d&eacute;part");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=paie/employe/personnelnonvalide-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Matricule","Personnel","Date d'application","Cause","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String[] etatVal = {"LOG_PERS_NON_VALIDE_LIB","LOG_PERS_NON_VALIDE_LIB_CREE", "LOG_PERS_NON_VALIDE_LIB_VISE", "LOG_PERS_NON_VALIDE_LIB_STC"};
    String[] etatAff = {"Tous","Cr&eacute;e"," Vis&eacute;e","STC"};

    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=paie/employe/personnelnonvalide-saisie.jsp&currentMenu=ELM000658\">\n" +
                    "                    <i class=\"material-symbols-rounded\">add</i> Saisir un d&eacute;part\n" +
                    "                </a>"
    );
%>
<script>
    function changerDesignation() {
        document.pnv.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="pnv">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <%
                        String selectedEtat = request.getParameter("etat");
                        if (selectedEtat == null) {
                            selectedEtat = etatVal[0]; // default "Tous"
                        }
                    %>

                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            for (int i = 0; i < etatAff.length; i++) {
                        %>
                        <% if (etatVal[i].equalsIgnoreCase(selectedEtat)) { %>
                        <option value="<%= etatVal[i] %>" selected>
                            <%= etatAff[i] %>
                        </option>
                        <% } else { %>
                        <option value="<%= etatVal[i] %>">
                            <%= etatAff[i] %>
                        </option>
                        <% } %>
                        <%
                            }
                        %>
                    </select>
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

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>

