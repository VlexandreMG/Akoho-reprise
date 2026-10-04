<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="magasin.MagasinCompte" %>
<%@ page import="affichage.Liste"%>
<%@ page import="magasin.MagasinLib" %>

<% try{
    String req = request.getParameter("val");
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "magasin.MagasinCompte";
    String nomTable = "MAGASIN_COMPTE";
    String apres = "magasin/magasin-compte-fiche.jsp";

    MagasinCompte o = new MagasinCompte();
    o.setNomTable("MAGASIN_COMPTE");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("fsd");

    Liste[] liste = new Liste[1];
    MagasinLib liste0 = new MagasinLib();
    liste0.setNomTable("MAGASIN2");
    liste[0] = new Liste("val",liste0,"val","id");
    if (req != null && !req.isEmpty()){
        liste[0].setDefaut(req);
    }
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("val").setLibelle("Magasin");
    pi.getFormu().getChamp("desce").setLibelle("Compte");
    pi.getFormu().getChamp("desce").setPageAppelComplete("mg.cnaps.compta.ComptaCompte","compte","compta_compte","","");
    String[] ordre = {"val","desce"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("fdsf");
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

