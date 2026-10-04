<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.recrutement.OffreEmploi" %>
<%@ page import="affichage.Liste"%>
<%@ page import="bean.TypeObjet" %>
<%@ page import="poste.FichePoste" %>

<% try{ 
    String idficheposte=request.getParameter("idficheposte");
    
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "paie.recrutement.OffreEmploi";
    String nomTable = "OFFRE_EMPLOI";
    String apres = "paie/recrutement/offreemploi-fiche.jsp";

    OffreEmploi o = new OffreEmploi();
    o.setNomTable("OFFRE_EMPLOI");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un offre d'emploi");

    Liste[] liste = new Liste[1];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("TYPE_CONTRAT");
    liste[0] = new Liste("idtypecontrat",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);
    if (idficheposte != null){
        o.setIdficheposte(idficheposte);
        FichePoste fichePoste = o.getFromeFichePoste();
        pi.getFormu().setDefaut(fichePoste);
        pi.getFormu().getChamp("idficheposte").setDefaut(idficheposte);
        pi.getFormu().getChamp("idficheposte").setAutre("readonly");
        pi.getFormu().getChamp("mission").setDefaut(fichePoste.getMissions());
    }
    
    pi.getFormu().getChamp("idficheposte").setLibelle("Fiche du poste");
    pi.getFormu().getChamp("titre").setLibelle("Titre");
    pi.getFormu().getChamp("description").setLibelle("Description");
    pi.getFormu().getChamp("description").setType("textarea");
    pi.getFormu().getChamp("mission").setLibelle("Missions");
    pi.getFormu().getChamp("mission").setType("textarea");
    pi.getFormu().getChamp("exigenceposte").setLibelle("Exigences poste");
    pi.getFormu().getChamp("exigenceposte").setType("textarea");
    pi.getFormu().getChamp("idtypecontrat").setLibelle("Type de contrat");
    pi.getFormu().getChamp("salairemin").setLibelle("Salaire");
    pi.getFormu().getChamp("salairemin").setVisible(false);
    pi.getFormu().getChamp("salairemax").setLibelle("Salaire maximum");
    pi.getFormu().getChamp("datepublication").setLibelle("Date de publication");
    pi.getFormu().getChamp("datefermeture").setLibelle("Date de fermeture");
     pi.getFormu().getChamp("salairemax").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idficheposte").setPageAppelComplete("poste.FichePoste","id","FICHE_POSTE","id","id");
 
    String[] ordre = {"idficheposte","titre","description","mission","exigenceposte","idtypecontrat","salairemin","salairemax","datepublication","datefermeture"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un offre d'emploi");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

