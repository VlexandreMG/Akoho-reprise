<%@page import="caisse.VirementIntraCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>

<% try{
    VirementIntraCaisseCpl t = new VirementIntraCaisseCpl();
    t.setNomTable("VirementIntraCaisseCpl");
    String etat = request.getParameter("etat");
    if(etat == null) etat = "";
    t.setNomTable( t.getNomTable().concat(etat) );
    String listeCrt[] = {"id","designation","daty","idCaisseDepartLib","idCaisseArriveLib","montant"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","designation","daty","idCaisseDepartLib","idCaisseArriveLib","montant", "etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("virements intra-caisse");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/virementIntraCaisse/virementIntraCaisse-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("idCaisseDepartLib").setLibelle("Caisse de d&eacute;part");
    pr.getFormu().getChamp("idCaisseArriveLib").setLibelle("Caisse d'arriv&eacute;e");
    String[] colSomme = {"montant"};
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=caisse/virementIntraCaisse/virementIntraCaisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Definition des libelles � afficher
    String libEnteteAffiche[] = {"id","d&eacute;signation","date","Caisse de D&eacute;part","Caisse d'Arriv&eacute;e","montant", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatAffiche = {"Tous","Cr&eacute;&eacute;(s)","Valid&eacute;(s)","Annul&eacute;(s)"};
    String[] etatPasse = {"","_cree","_valider","_annule"};
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=caisse/virementIntraCaisse/virementIntraCaisse-saisie.jsp&currentMenu=MENUDYN00161\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un virement intra caisse</a>"
    );
    String[] enteteRecap = {"","Nombres","Somme montant"};
    pr.getTableauRecap().setLibeEntete(enteteRecap);
%>


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">

            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>


        </form>

        <div class="row">
            <div class="col-lg-12">
                <form action="<%= pr.getLien() %>?but=<%= pr.getApres() %>" method="post" >
                    <div class="col-md-4 nopadding">
                        <div class="d-flex" style="align-items: end;gap: 8px;">
                            <div class="form-input w-100">
                                <label for="etat" class="input-label">Etat</label>
                                <select name="etat" id="etat" class="form-control" onchange="changerEtat()">
                                    <%
                                        for(int i=0; i<etatAffiche.length; i++){
                                            String selected = "";
                                            if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase(etatPasse[i])==0){
                                                selected = "selected";
                                            }
                                    %>
                                    <option value="<%=etatPasse[i]%>" <%=selected%>><%=etatAffiche[i]%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <input type="submit" value="Consultez" class="btn btn-small btn-primary my-2" />
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 nopadding">
                <%
                    out.println(pr.getTableauRecap().getHtml());
                %>
            </div>
        </div>

        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



