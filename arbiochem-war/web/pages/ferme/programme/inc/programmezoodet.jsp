<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="ferme.programme.ProgrammeZootechniqueDetailsLib" %>

<% try{ 
    ProgrammeZootechniqueDetailsLib o = new ProgrammeZootechniqueDetailsLib();
    o.setNomTable("PROGRAMMEZOOTECHNIQUEDT_LIB");
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"age","idSexeLib","aliment","poids","mortalite","pontehebdomadaire","pontecumulee","oeufcumule","oacpourcentage","oachh","poidsoeuf","tauxeclosion","poussins","consoalimentfemelle","consoalimentmale","femellebw","malebw","ratioproduction","fertilite","consommationEau","temperatureMin","temperatureMax","humiditeMin","humiditeMax","dureeEclairage","uniformiteCible","cvMax"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idmere = '"+request.getParameter("id")+"' ");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] libEnteteAffiche = {"&Acirc;ge","Sexe","Aliment (t&ecirc;te/g/j)","Poids (g)","Mortalit&eacute; (%)","Ponte Hebdomadaire (%)","Ponte cumul&eacute;e","Œuf cumul&eacute;","OAC (%)","OAC / HH","Poids œuf","Taux d'&eacute;closion","Poussins / HH","Consommation d’aliment Femelle (g)","Consommation d’aliment M&acirc;le (g)","Femelle BW (g)","M&acirc;le BW (g)","Ratio de production","Fertilit&eacute;","Consommation Eau","Temp&eacute;rature Min","Temp&eacute;rature xax","Humidit&eacute; min","humidit&eacute; max","Dur&eacute;e &Eacute;clairage","Uniformit&eacute; cible","CV Max"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
    <%  if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        } else{ %>
            <center><h4>Aucune donn&eacute;e trouv&eacute;e</h4></center>
    <%  } %>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

