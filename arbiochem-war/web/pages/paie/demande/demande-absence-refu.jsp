<%@page import="java.lang.String"%>
<%@page import="paie.log.LogPersonnelFin"%>
<%@page import="paie.demande.EmployeComplet"%>
<%@page import="historique.MapUtilisateur"%>
<%@page import="paie.demande.DemandeJustifications"%>
<%@page import="paie.conge.MouvementAbsence"%>
<%@page import="paie.conge.Conge"%>
<%@page import="paie.permission.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="utils.ConstantePaie" %>


<style>
    textarea {
        height: 50;
    }
</style>

<%
    try{

        UserEJB ue = (UserEJB) session.getValue("u");
        MapUtilisateur u = ue.getUser();
        String receiver = u.getTeluser();
        MapUtilisateur map = ue.getUser();
        EmployeComplet pers = new EmployeComplet();
        EmployeComplet e = pers.getEmployeByRefUser(map.getTuppleID());
        String titre="Refu d'une demande d'absence ";
        DemandeJustifications a = new DemandeJustifications();
        a.setNomTable("demande");
        String acte = "refuser";

        LogPersonnelFin dr = new LogPersonnelFin();
        dr.setNomTable("log_personnel_fin");

        Permission p = new Permission();
        p.setDaty(Utilitaire.stringDate(Utilitaire.dateDuJour()));

        MouvementAbsence mouvementAbsence = new MouvementAbsence();
        mouvementAbsence.setIdPersonnel(e.getId());

//        String soldeConge = String.valueOf(mouvementAbsence.getSoldeCongePers());
//        String soldePermission = String.valueOf(mouvementAbsence.getSoldePermissionPers());

        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("idremplacents").setLibelle("Le/La rempla&ccedil;ant(e)");
        pi.getFormu().getChamp("idremplacents").setPageAppelComplete("paie.log.LogPersonnel", "id", "LOG_PERSONNEL_V2");

        String id = request.getParameter("id");
        if(id != null && id.compareToIgnoreCase("")!=0) {
            System.out.println(" dans id != null");
            DemandeJustifications demandeJustifications = DemandeJustifications.getDemandeById(id);
            pi.getFormu().getChamp("idPersonnel").setDefaut(demandeJustifications.getIdpersonnel());
            pi.getFormu().getChamp("motif").setDefaut(demandeJustifications.getMotif());
            pi.getFormu().getChamp("remarque").setDefaut(demandeJustifications.getRemarque());

            pi.getFormu().getChamp("dateDepart").setDefaut(demandeJustifications.getDatedepart().toString());
            pi.getFormu().getChamp("idtypeabsence").setDefaut(demandeJustifications.getIdtypeabsence());
            pi.getFormu().getChamp("duree").setDefaut(String.valueOf(demandeJustifications.getDuree()));
            pi.getFormu().getChamp("idremplacents").setDefaut(demandeJustifications.getIdremplacents());
        }

        pi.getFormu().getChamp("dateDepart").setAutre("readonly");
        pi.getFormu().getChamp("idtypeabsence").setAutre("readonly");
        pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
        pi.getFormu().getChamp("motif").setAutre("readonly");
        pi.getFormu().getChamp("duree").setAutre("readonly");
        pi.getFormu().getChamp("idremplacents").setAutre("readonly");

        pi.getFormu().getChamp("motifRefu").setLibelle("Motif de refus");
        pi.getFormu().getChamp("weekendDecompte").setLibelle("Week-end d&eacute;compt&eacute;");

        // personnel concerne
//    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel", "id", "log_personnel");
//    pi.getFormu().getChamp("idPersonnel").setAutre("onChange='getSolde()'");
        pi.getFormu().getChamp("idPersonnel").setLibelle("Personnel concern&eacute;");
        pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnel","id","LOG_PERSONNEL_V2");
//    pi.getFormu().getChamp("idPersonnel").setAutre("readonly");
//        pi.getFormu().getChamp("idPersonnel").setDefaut(e.getId());


        pi.getFormu().getChamp("reste_conge").setLibelle("Cong&eacute; restant");
        pi.getFormu().getChamp("reste_conge").setAutre("readonly");
        pi.getFormu().getChamp("reste_permission").setLibelle("Permission restante");
        pi.getFormu().getChamp("reste_permission").setAutre("readonly");
//    pi.getFormu().getChamp("reste_permission").setDefaut(soldePermission);
//    pi.getFormu().getChamp("reste_conge").setDefaut(soldeConge);
        pi.getFormu().getChamp("heuredepart").setVisible(false);
        pi.getFormu().getChamp("heurearrive").setVisible(false);
        pi.getFormu().getChamp("numero").setVisible(false);
        pi.getFormu().getChamp("desce").setVisible(false);
        pi.getFormu().getChamp("observation").setVisible(false);
        pi.getFormu().getChamp("titre").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idtypedemande").setVisible(false);
        pi.getFormu().getChamp("datedepart").setLibelle("Date de d&eacute;but");
        pi.getFormu().getChamp("datefin").setVisible(false);
        pi.getFormu().getChamp("dateretour").setVisible(false);
        pi.getFormu().getChamp("duree").setLibelle("Dur&eacute;e en Jour (*)");
        pi.getFormu().getChamp("daty").setLibelle("Date de demande");
//    pi.getFormu().getChamp("MOTIFREFU").setLibelle("Motif de Refus");
        pi.getFormu().getChamp("horairenormal").setVisible(false);
//    pi.getFormu().getChamp("idpersonnel").setVisible(false);
//    pi.getFormu().getChamp("idpersonnel").setDefaut(e.getId());
        pi.getFormu().getChamp("idtypedemande").setDefaut(ConstantePaie.idDemandeAbsence);

        //pi.getFormu().getChamp("remarque").setType("textarea");
//    pi.getFormu().getChamp("motif").setType("textarea");
        pi.getFormu().getChamp("motif").setLibelle("Motif(*)");
//    pi.getFormu().getChamp("motif").setVisible(false);

//        pi.getFormu().getChamp("datedepart").setDefaut(Utilitaire.dateDuJour());
//        pi.getFormu().getChamp("datefin").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("datefin").setAutre("readonly");
//        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("daty").setAutre("readonly");
        pi.getFormu().getChamp("avenant").setVisible(false);

//        String id = request.getParameter("id");
//        if (id != null && !id.isEmpty()) {
//            pi.getFormu().getChamp("idPersonnel").setDefaut(id);
//        }
        String[] ordre={"daty","datedepart"};
        pi.getFormu().setOrdre(ordre);

        affichage.Champ[] liste = new affichage.Champ[1];
        TypeObjet tpm = new TypeObjet();
        tpm.setNomTable("typeabsence");
        liste[0] = new Liste("idtypeabsence", tpm, "desce", "id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idtypeabsence").setLibelle("Type d'absence ");
        String classe = "paie.demande.DemandeJustifications";
        String butApresPost = "paie/demande/demande-absence-fiche.jsp";
        String nomTable = "Demande";

        pi.getFormu().getChamp("reste_conge").setVisible(false);
        pi.getFormu().getChamp("reste_permission").setVisible(false);


        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center"><%=titre%></h1>
    <form action="<%=pi.getLien()%>?but=paie/demande/apresRefu.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="idtypedemande" type="hidden" id="nature" value="<%=ConstantePaie.idDemandeAbsence%>">
        <input name="idDemande" type="hidden" id="nature" value=<%=id%>>
        <input name="acte" type="hidden" id="nature" value=<%=acte%>>
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <%--        <input name="idpersonnel" type="hidden" id="idpersonnel" value="<%= e.getId() %>">--%>
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>


<script>

    document.addEventListener('DOMContentLoaded', function() {
        // R�cup�rer l'�l�ment avec l'ID idremplacentslibelle
        var inputElement = document.getElementById('idremplacentslibelle');

        // Changer le type de l'�l�ment en textarea
        inputElement.type = 'textarea';
    });


    document.addEventListener("DOMContentLoaded", function() {
        function formatDate(date) {
            var day = date.getDate();
            var month = date.getMonth() + 1;
            var year = date.getFullYear();

            return ('0' + day).slice(-2) + '/' + ('0' + month).slice(-2) + '/' + year;
        }

        function calculerDateFin() {
            var duree = parseInt(document.getElementById('duree').value);
            var dateDepartString = document.getElementById('datedepart').value;
            if (isNaN(duree)) {
                duree = 0;
            }

            var dateDepartParts = dateDepartString.split('/');
            var day = parseInt(dateDepartParts[0]);
            var month = parseInt(dateDepartParts[1]) - 1;
            var year = parseInt(dateDepartParts[2]);
            var dateDepart = new Date(year, month, day);

            if (!isNaN(dateDepart.getTime())) {
                var datefin = new Date(dateDepart);
                if(duree>=1){
                    datefin.setDate(dateDepart.getDate() + duree -1 );
                }else{
                    datefin.setDate(dateDepart.getDate());
                }


                console.log("Date fin", formatDate(datefin));
                document.getElementById('datefin').value = formatDate(datefin);
            }
        }

        var dureeInput = document.getElementById('duree');
        var dateDepartInput = document.getElementById('datedepart');

        dureeInput.addEventListener('change', function(event) {
            event.preventDefault();
            calculerDateFin();
        });

        dateDepartInput.addEventListener('focus', function(event) {
            event.preventDefault();
            calculerDateFin();
        });

    });

    function getSolde() {
        const idPersonnel = document.getElementById("idpersonnel")?.value;
        if (!idPersonnel) {
            console.error("Personnel field not found or empty");
            return;
        }
        var path = '${pageContext.request.contextPath}';
        fetch(path + '/soldeCongePermission?idPersonnel=' + idPersonnel)
            .then(response => response.json())
            .then(data => {
                document.getElementsByName("reste_conge")[0].value = data.resteConge;
                document.getElementsByName("reste_permission")[0].value = data.restePermission;
            })
            .catch(err => console.error("Erreur AJAX:", err));
    }

</script>


<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

