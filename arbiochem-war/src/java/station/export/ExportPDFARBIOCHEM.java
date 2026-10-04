
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package station.export;

import avoir.AvoirFCFilleLib;
import avoir.AvoirFCLib;
import bean.AdminGen;
import bean.CGenUtil;
import bean.ResultatEtSomme;
import caisse.Caisse;
import client.Client;
import client.ClientLib;
import client.ReleveClient;
import declaration.DeclarationTva;
import declaration.DeclarationTvaLib;
import declaration.ImprimerDeclaration;
import encaissement.EncaissementDetailsLib;
import encaissement.EncaissementFichePdf;
import encaissement.EncaissementLib;
import encaissement.EncaissementReport;
import fabrication.Of;
import fabrication.OfEtatGlobal;
import fabrication.OfFilleCpl;
import fabrication.OffilleEtatGlobal;
import faturefournisseur.As_BonDeCommandeCpl;
import faturefournisseur.As_BonDeCommande_Fille_CPL;
import faturefournisseur.FournisseurCpl;
import net.sf.jasperreports.engine.JRException;
import paie.accident.AccidentPdf;
import paie.edition.FichePaie;
import paie.edition.MappingElementPaie;
import paie.edition.PaieEditionEltpaie;
import produits.IngredientsLib;
import proforma.ProformaDetailsLib;
import proforma.ProformaLib;
import reporting.ReportingCdn;
import societe.Societe;
import stock.EtatStockEngage;
import stock.MvtStockFilleTheorique;
import stock.TransfertStockCpl;
import stock.TransfertStockDetailsCpl;
import user.UserEJB;
import utilisateur.Utilisateur;
import utilitaire.ChiffreLettre;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteAsync;
import utils.ConstanteSocobis;
import utils.ConstanteVente;
import vente.*;
import web.mg.cnaps.servlet.etat.UtilitaireImpression;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ExportPDFARBIOCHEM", urlPatterns = {"/ExportPDFARBIOCHEM"})
public class ExportPDFARBIOCHEM extends HttpServlet {
    String nomJasper = "";
    ReportingCdn.Fonctionnalite fonctionnalite = ReportingCdn.Fonctionnalite.RECETTE;
    
    public String getReportPath() throws IOException {
        return getServletContext().getRealPath(File.separator + "report" + File.separator + getNomJasper() + ".jasper");
    }
    public String getNomJasper() {
        return nomJasper;
    }

    public void setNomJasper(String nomJasper) {
        this.nomJasper = nomJasper;
    }
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        String action = request.getParameter("action");
        if (estApercu(request)) {
            response.setContentType("application/pdf");
            response.setHeader("X-Content-Type-Options", "nosniff");
            response = new InlineDispositionResponse(response);
        }
        if (action.equalsIgnoreCase("fiche_encaissement")) impressionEncaissement(request, response);
        if (action.equalsIgnoreCase("fiche_encaissement_pompiste")) impressionEncaissementPompist(request, response);
        if (action.equalsIgnoreCase("fiche_vente")) fiche_vente(request, response);
        if (action.equalsIgnoreCase("fiche_bc")) fiche_bc_modif(request, response);
        if (action.equalsIgnoreCase("fiche_bl")) fiche_bl(request, response);
        if (action.equalsIgnoreCase("fiche_ordre_fabrication")) fiche_ordre_fabrication(request, response);
        if (action.equalsIgnoreCase("fiche_vente_nouveau")) fiche_vente_nouveau(request, response);
        if (action.equalsIgnoreCase("fiche_vente_nouveau_bl")) fiche_vente_nouveau_bl(request, response);
        if (action.equalsIgnoreCase("fiche_vente_nouveau_avoir")) fiche_vente_nouveau_avoir(request, response);
        if (action.equalsIgnoreCase("situation_globale")) situation_globale(request, response);
        if (action.equalsIgnoreCase("offille_situation_globale")) offille_situation_globale(request, response);
        if (action.equalsIgnoreCase("vente_liste")) vente_liste(request, response);
        if (action.equalsIgnoreCase("vente_liste_encaisser")) vente_liste_encaisser(request, response);
        if (action.equalsIgnoreCase("vente_liste_mere_fille")) vente_liste_mere_fille(request, response);
        if (action.equalsIgnoreCase("proforma")) proforma(request, response);
        if (action.equalsIgnoreCase("imprimerDeclaration")) imprimerDeclaration(request, response);
        if (action.equalsIgnoreCase("imprimer_bulletin_paie")) imprimer_bulletin_paie(request, response);
        if (action.equalsIgnoreCase("accident")) declaration_accident(request, response);
        if (action.equalsIgnoreCase("bc_client")) bc_client(request, response);
        if (action.equalsIgnoreCase("chiffre_affaire_par_article")) chiffre_affaire_par_article(request, response);
        if (action.equalsIgnoreCase("statistique_vente")) statistique_vente(request, response);
        if (action.equalsIgnoreCase("imprimer_releve_client")) imprimer_releve_client(request, response);
        if (action.equalsIgnoreCase("imprimer_etatstock_engage")) imprimer_etatstock_engage(request, response);
        if(action.equalsIgnoreCase("fiche_transfert_stock")) imprimer_transfert_stock(request,response);
    }

    private void fiche_bc_modif(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        As_BonDeCommandeCpl v = new As_BonDeCommandeCpl();
        v.setNomTable("As_BonDeCommande_MERECPL");
        As_BonDeCommandeCpl[] enc_mere = (As_BonDeCommandeCpl[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");

        FournisseurCpl fournisseurCpl = new FournisseurCpl();
        Societe societe = u.getMaSociete();

        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        if (enc_mere.length > 0) {

            fournisseurCpl = (FournisseurCpl) fournisseurCpl.getById(enc_mere[0].getFournisseur(), "FOURNISSEURCPL", c);

            param.put("adr2", fournisseurCpl.getAdresse());
            param.put("nif2", fournisseurCpl.getNif());
            param.put("stat2", fournisseurCpl.getStat());
            param.put("tel2", fournisseurCpl.getContact());
            param.put("mail", fournisseurCpl.getMail());
            param.put("frns", fournisseurCpl.getNom());

            param.put("daty", enc_mere[0].getDaty());

            param.put("fournisseurlib", enc_mere[0].getFournisseurlib());
            param.put("modepaiementlib", enc_mere[0].getModepaiementlib());
            param.put("dateLimite", enc_mere[0].getDateLimite());
            param.put("id", enc_mere[0].getId());

            param.put("annee", enc_mere[0].getDaty().toLocalDate().getYear());

            param.put("contact", "Mr Ricky: 032 05 749 46 / Mlle Mamitiana 032 03 749 68");
            param.put("signature", "MR WAI RICKY/ MR ANTSA 00/00/2026");
            param.put("img2", societe.getLogo());
        }


        param.put("societe", societe.getNom());
        param.put("adr1", societe.getAdresse());
        param.put("nif1", societe.getNif());
        param.put("stat1", societe.getNumStat());
        param.put("tel1", societe.getTelephone());

        As_BonDeCommande_Fille_CPL vf = new As_BonDeCommande_Fille_CPL();
        vf.setNomTable("AS_BONDECOMMANDE_CPL");
        As_BonDeCommande_Fille_CPL[] v_fille = (As_BonDeCommande_Fille_CPL[]) CGenUtil.rechercher(vf, null, null, null,
                " AND idbc = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        setNomJasper("fiche_bc");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());

    }

    private void imprimer_releve_client(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        String awhere = "";
        String annee = request.getParameter("annee");
        if (annee != null && !annee.trim().isEmpty()) {
                daty1 = "01/01/" + annee;
                daty2 = "31/12/" + annee;
        }
    
        ReleveClient v = new ReleveClient();
        v.setNomTable("RELEVECLIENT");
        
        System.out.println("Paramètres reçus - daty1: " + daty1 + ", daty2: " + daty2 + ", annee: " + annee);
    
        if ((daty1 != null && !daty1.trim().isEmpty()) || (daty2 != null && !daty2.trim().isEmpty())) {
            if (daty1 != null && !daty1.trim().isEmpty()) {
                awhere += " and daty >= to_date('" + daty1 + "', 'dd/mm/yyyy') ";
                param.put("datymin", daty1);
            }
            if (daty2 != null && !daty2.trim().isEmpty()) {
                awhere += " and daty <= to_date('" + daty2 + "', 'dd/mm/yyyy') ";
                param.put("datymax", daty2);
            }
        }
    
        ReleveClient[] enc_mere = (ReleveClient[]) v.relever(Utilitaire.stringDate(daty1), Utilitaire.stringDate(daty2), request.getParameter("idclient"));
        Client cl = new Client();
        Client[] client = (Client[]) CGenUtil.rechercher(cl, null, null, null,
                " AND id = '" + enc_mere[0].getIdclient() + "'");
        double totaldebit =0;
        double totalcredit = 0;
        
        if(enc_mere.length > 0){
            if(client.length > 0){
                Client cli = client[0];
                 param.put("client", enc_mere[0].getIdclient()+" - "+cli.getNom());
                 param.put("adresse", cli.getAdresse());
                 param.put("stat", cli.getStat());
                 param.put("nif", cli.getNif());
                 param.put("cp", cli.getCarte());
                 param.put("dateCarte", cli.getDatecarte());
            }
            param.put("periode", " "+daty1+" et "+daty2);
            for (int i = 0; i < enc_mere.length; i++) {
            totaldebit +=  enc_mere[i].getDebit();
            totalcredit += enc_mere[i].getCredit();
            }
            double solde = totaldebit - totalcredit;
            String valeur = " ";
            if (solde > 0) {
                valeur = "SOLDE DEBITEUR";
            } else {
                valeur = "SOLDE CREDITEUR";
            }
            param.put("solde", valeur);
            param.put("valeurSolde", solde);

            }
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        param.put("nom",societe.getNom());
        dataSource.addAll(Arrays.asList(enc_mere));
        setNomJasper("RELEVE-CLIENTS");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }
    private void fiche_bc(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        As_BonDeCommandeCpl v = new As_BonDeCommandeCpl();
        v.setNomTable("As_BonDeCommande_MERECPL");
        As_BonDeCommandeCpl[] enc_mere = (As_BonDeCommandeCpl[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        if (enc_mere.length > 0) {
          param.put("designation", enc_mere[0].getDesignation());
          param.put("ref", enc_mere[0].getReference());
          param.put("daty", enc_mere[0].getDaty());
          param.put("remarque", enc_mere[0].getRemarque());
          param.put("fournisseur", enc_mere[0].getFournisseurlib());
          param.put("modeP", enc_mere[0].getModepaiementlib());
          param.put("num", id);
          param.put("iddevise", enc_mere[0].getIdDevise());
          param.put("montantHT", enc_mere[0].getMontantHT());
          param.put("montantTVA", enc_mere[0].getMontantTVA());
          param.put("montantTTC", enc_mere[0].getMontantTTC());
          param.put("devise", enc_mere[0].getIdDeviselib());
        }
       
        As_BonDeCommande_Fille_CPL vf = new As_BonDeCommande_Fille_CPL();
        vf.setNomTable("AS_BONDECOMMANDE_CPL");
        As_BonDeCommande_Fille_CPL[] v_fille = (As_BonDeCommande_Fille_CPL[]) CGenUtil.rechercher(vf, null, null, null,
                " AND idbc = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        setNomJasper("BonDeCommande");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }

    private void declaration_accident(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        System.out.println(" dans pdf generation ");
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        AccidentPdf accidentLib = new AccidentPdf();
        accidentLib.setId(id);
        accidentLib.setNomTable("v_accident_pdf");
        AccidentPdf[] accident = (AccidentPdf[]) CGenUtil.rechercher(accidentLib, null, null, "");
        System.out.println(" accident pdf");
        System.out.println(" acc " + accident.length);
        if(accident != null && accident.length>0) {
            param.put("nomPersonnel", accident[0].getId_personnel_lib());
            param.put("dateNaissance", accident[0].getDate_naissance());
            param.put("cin", accident[0].getNumero_cin());
            param.put("dateEmbauche", accident[0].getDateembauche());
            param.put("numCnaps", accident[0].getNumero_cnaps());
            param.put("fonction", accident[0].getFonction());
            param.put("adresse", accident[0].getAdresse());
            param.put("lieu", accident[0].getId_lieu_lib());
            param.put("activite", accident[0].getActivite());
            param.put("materiel", accident[0].getId_machine_lib());
            param.put("lesion", accident[0].getLesions());
            param.put("centre", accident[0].getCentreSoin());
            param.put("temoin1", accident[0].getDetailsTemoin1());
            param.put("temoin2", accident[0].getDetailsTemoin2());
            param.put("raisonSociale", ConstanteSocobis.nomEntreprise);

            param.put("email", ConstanteSocobis.email);
            param.put("telephone", ConstanteSocobis.telephone);
            param.put("adresseEmployeur", ConstanteSocobis.adresse);


        } else {
            throw new Exception("Erreur pendant la generation du PDF");
        }
        setNomJasper("declaration_accident");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());

    }
    
    private void fiche_bl(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        As_BondeLivraisonClient_Cpl v = new As_BondeLivraisonClient_Cpl();
        v.setNomTable("AS_BONDELIVRAISON_CLIENT_CPL");
        As_BondeLivraisonClient_Cpl[] enc_mere = (As_BondeLivraisonClient_Cpl[]) CGenUtil.rechercher(v, null, null, null,
                " AND id = '" + id + "'");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        if (enc_mere.length > 0) {
          param.put("designation", enc_mere[0].getDesignation());
          param.put("daty", enc_mere[0].getDaty());
          param.put("remarque", enc_mere[0].getRemarque());
          param.put("magasin", enc_mere[0].getMagasin());
          param.put("client", enc_mere[0].getIdclientlib());
          param.put("num", id);

        }
        As_BondeLivraisonClientFille_Cpl vf = new As_BondeLivraisonClientFille_Cpl();
        vf.setNomTable("AS_BONLIVRFILLE_CLIENT_CPL");
        As_BondeLivraisonClientFille_Cpl[] v_fille = (As_BondeLivraisonClientFille_Cpl[]) CGenUtil.rechercher(vf, null, null, null,
                " AND numbl = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        setNomJasper("BonDeLivraison");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }
    private void fiche_vente(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        VenteLib v = new VenteLib();
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
          param.put("designation", enc_mere[0].getDesignation());
          param.put("magasin", enc_mere[0].getIdMagasinLib());
          param.put("daty", enc_mere[0].getDaty());
          param.put("remarque", enc_mere[0].getRemarque());
          param.put("devise", enc_mere[0].getIdDevise());
          param.put("numFact", id);
        }
       
        VenteDetailsLib vf = new VenteDetailsLib();
        vf.setNomTable("VENTE_DETAILS_CPL");
        VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, null,
                " AND idVente = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
         String devise = v_fille[0].getIdDevise();
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantHTLocal");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTvaLocal");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantTTCLocal");
        
        param.put("montantHT", montantHT);
        param.put("montantTVA", montantTVA);
        param.put("montantTTC", montantTTC);
        param.put("devise", devise);
        
        setNomJasper("factureclient");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }
    private void impressionEncaissement(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        EncaissementLib eM = new EncaissementLib();
        eM.setNomTable("ENCAISSEMENT_LIB");
        EncaissementLib[] enc_mere = (EncaissementLib[]) CGenUtil.rechercher(eM, null, null, null,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
          param.put("carburants", Utilitaire.formaterAr(enc_mere[0].getVenteCarburant()));
          param.put("lubrifiants", Utilitaire.formaterAr(enc_mere[0].getVenteLubrifiant()));
          param.put("totalrecette", Utilitaire.formaterAr(enc_mere[0].getTotalRecette()));
          param.put("depense", Utilitaire.formaterAr(enc_mere[0].getDepense()));
          param.put("montantecart", Utilitaire.formaterAr(enc_mere[0].getEcart()));
          param.put("versement", Utilitaire.formaterAr(enc_mere[0].getTotalVersement()));
         
        }
        EncaissementDetailsLib eF = new EncaissementDetailsLib();
        eF.setNomTable("Encaissement_Details_Lib");
        EncaissementDetailsLib[] enc_fille = (EncaissementDetailsLib[]) CGenUtil.rechercher(eF, null, null, null,
                " AND idEncaissement = '" + id + "'");
        dataSource.addAll(Arrays.asList(enc_fille));
        setNomJasper("encaissement");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }

    private void imprimer_transfert_stock(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Map param = new HashMap();
            List dataSource = new ArrayList();
            String id = request.getParameter("id");
            String awhere = "";


            TransfertStockCpl transfertStockCpl = (TransfertStockCpl) new TransfertStockCpl().getById(id, "TransfertStockCpl", c);

            TransfertStockDetailsCpl[] transfertStockDetailsCpls = (TransfertStockDetailsCpl[]) CGenUtil.rechercher(new TransfertStockDetailsCpl(), null, null, c, " and IDTRANSFERTSTOCK = '" + transfertStockCpl.getId() + "'");

            dataSource.addAll(Arrays.asList(transfertStockDetailsCpls));

            param.put("id", transfertStockCpl.getId());
            param.put("daty", Utilitaire.datetostring(transfertStockCpl.getDaty()));
            param.put("origine", transfertStockCpl.getIdMagasinDepartLib());
            param.put("destination", transfertStockCpl.getIdMagasinArriveLib());

            UserEJB u = (UserEJB) request.getSession().getAttribute("u");
            Societe societe = u.getMaSociete();

            param.put("logo", societe.getLogo());
            param.put("cf", societe.getCf());
            param.put("tel", societe.getTelephone());
            param.put("capital", societe.getCapital());
            param.put("adresse", societe.getAdresse());
            param.put("fax", societe.getFax());
            param.put("tel1", societe.getFax());
            param.put("email", societe.getEMail());
            param.put("stat", societe.getNumStat());
            param.put("nif", societe.getNif());

            setNomJasper("trsfStock");
            UtilitaireImpression.imprimer(request, response, "Fiche_Transfert_Stock", param, dataSource, getReportPath());
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

     private void impressionEncaissementPompist (HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        EncaissementFichePdf eM = new EncaissementFichePdf();
       
        EncaissementFichePdf[] enc_mere = (EncaissementFichePdf[]) CGenUtil.rechercher(eM, null, null, null,
                " AND ID = '" + id + "'");

      
        EncaissementReport er=new EncaissementReport();
        er.setId(id);
        er.init(c);

        if (enc_mere.length > 0) {
          param.put("date", enc_mere[0].getDaty());
          param.put("nom", enc_mere[0].getIdPompisteLib());
          param.put("ecart", enc_mere[0].getEcart());
          param.put("versement", enc_mere[0].getTotalVersement());
          param.put("espece", enc_mere[0].getTotalEspece());
          param.put("om", enc_mere[0].getTotalOrangeMoney());
        }
       
        dataSource.add(er);


        setNomJasper("encaissementPompiste");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }
    private void fiche_ordre_fabrication(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
       //List dataSource = new ArrayList();
        String id = request.getParameter("id");
        Of t = new Of();
        t.setId(id);
        Of[] of_mere = (Of[]) CGenUtil.rechercher(t, null, null, null,
        " AND ID = '" + id + "'");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        if (of_mere.length > 0) {
          param.put("daty", of_mere[0].getDaty());
          param.put("id", of_mere[0].getId());
        }
      
        MvtStockFilleTheorique mvtst = new MvtStockFilleTheorique();
        HashMap<String, Vector> map = mvtst.getRapprochementParCategorie(id, null, null);
        List dataSource = new ArrayList();
        for (Vector v : map.values()) {
            for (Object obj : v) {
                if (obj instanceof MvtStockFilleTheorique) {
                    dataSource.add((MvtStockFilleTheorique) obj);
                }
            }
        }
        setNomJasper("fiche_ordre_fabrication");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }
    private void fiche_vente_nouveau_avoir(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        AvoirFCLib v = new AvoirFCLib();
        v.setNomTable("AVOIRFCLIB_PDF");
        AvoirFCLib[] enc_mere = (AvoirFCLib[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        Caisse[] caisse = u.getCaissePdf();
        List dataSource1 = new ArrayList();
        if(caisse.length > 0){
            dataSource1.addAll(Arrays.asList(caisse));
            param.put("listeDetails",dataSource1);
        }
        param.put("nom", societe.getNom());
        param.put("logo", societe.getLogo());
        param.put("cf", societe.getCf());
        param.put("tel", societe.getTelephone());
        param.put("capital", societe.getCapital());
        param.put("adresse", societe.getAdresse());
        param.put("fax", societe.getFax());
        param.put("tel1", societe.getFax());
        param.put("email", societe.getEMail());
        param.put("bni_cl", societe.getBanque1());
        param.put("boa", societe.getBanque2());
        param.put("cf", societe.getCf());
        param.put("stat", societe.getNumStat());
        param.put("nif", societe.getNif());
        param.put("datyJour", Utilitaire.dateDuJour());

        AvoirFCFilleLib vf = new AvoirFCFilleLib();
        vf.setNomTable("AVOIRFCFILLELIB_PDF");
        AvoirFCFilleLib[] v_fille = (AvoirFCFilleLib[]) CGenUtil.rechercher(vf, null, null, null,
                " AND IDAVOIRFC = '" + id + "'");

        if (enc_mere.length > 0) {
            ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENT");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdClient(),"CLIENT" , null);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getCodeclient());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("lieuClient",client.getProvinceLib());
                param.put("telClient",client.getTelephone());
                param.put("nifclient",client.getNif());
                param.put("statclient",client.getStat());
                param.put("cp",client.getCarte());
                param.put("quit","");
                param.put("datyclient",client.getDatecarte());
            } 
            param.put("numfact",enc_mere[0].getNumavoir());
            param.put("datyfact",enc_mere[0].getDaty());
            //param.put("numfact",id);
            //param.put("totalcolis",enc_mere[0].getColis());
            //param.put("totalpoids",enc_mere[0].getPoids());
            //param.put("modepaiement",enc_mere[0].getModepaiementlib());
            param.put("reference",enc_mere[0].getNumfact());
            //String modeDeLiv = enc_mere[0].getModelivraisonlib();
            //String livraison = modeDeLiv.replace("<span style=color: green;>", "")
                 //.replace("</span>", "");
            //param.put("livraison",livraison);
            //param.put("transport",enc_mere[0].getFrais());
            if (enc_mere[0].getTypeavoir().equalsIgnoreCase("Avoir")) {
                setNomJasper("facture-vente-avoir");
                for (int i = 0; i < v_fille.length; i++) {
                    v_fille[i].setTva(0);
                }
                param.put("reference","AVOIR FACT "+enc_mere[0].getNumfact());
            } else {
                setNomJasper("facture-vente-ristourne");
                for (int i = 0; i < v_fille.length; i++) {
                    v_fille[i].setQte(v_fille[i].getTaux());
                    //v_fille[i].setContenuelib("180x250");

                    double montantSansTva = enc_mere[0].getPuFacture(v_fille[i].getIdProduit())*((100/v_fille[i].getTva())/((100/v_fille[i].getTva())+1));
                    double pu = montantSansTva/v_fille[i].getTaux();
                    v_fille[i].setTva(((v_fille[i].getPu()/v_fille[i].getTaux())/pu)*100);
                    v_fille[i].setPu(v_fille[i].getPu()/v_fille[i].getTaux());
                    v_fille[i].setPoids(v_fille[i].getCalorie()*v_fille[i].getTaux());
                }
                param.put("reference","RISTOURNE FACT "+enc_mere[0].getNumfact());
            }
        }

        dataSource.addAll(Arrays.asList(v_fille));
        double montant = AdminGen.calculSommeDouble(v_fille,"ptHt");
        double montantHT = AdminGen.calculSommeDouble(v_fille,"ptHt");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTVA");
        double montantTTC = montantHT + montantTVA;
//        double frais = AdminGen.calculSommeDouble(v_fille,"frais");

        //System.out.println("montant = "+Utilitaire.formaterAr(montantTVA));
        
        //String valeurMontantTTC = ChiffreLettre.convertRealToString(montantTTC);
        //valeurMontantTTC= valeurMontantTTC.replace(",", "Ariary");
        String montantNetLettre = ChiffreLettre.convertRealToString(montantTTC);
            if (montantNetLettre.contains(",")) {
                montantNetLettre = montantNetLettre.replace(",", " Ariary ");
            } else {
                montantNetLettre += " Ariary";
            }

        param.put("montantNetLettre", montantNetLettre);
        
        param.put("totalbrut",montant);
        //param.put("participation_transport",frais);
        param.put("totalHt",montantHT);
        param.put("total_taxes",montantTVA);
        param.put("montantttc",montantTTC);
        //param.put("escompte","");
        param.put("net_payer",montantTTC);
       // param.put("net_payer_fmg",montantTTC*5);
        UtilitaireImpression.imprimer(request, response, id, param, dataSource, getReportPath());
    }
    
    private void fiche_vente_nouveau(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
         String id = request.getParameter("id");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");

        String type = request.getParameter("type");
        if(type.compareToIgnoreCase("duplicata")==0){
            param.put("type","DUPLICATA");
        }else{
            ImprimerVente imprimerVente =  new ImprimerVente();
            imprimerVente.setVal(id);
            imprimerVente.setDesce(u.getUser().getIdrole());
            u.createObject(imprimerVente);
        }
        Societe societe = u.getMaSociete();
        Caisse[] caisse = u.getCaissePdf();
        VenteLib v = new VenteLib();
        List dataSource1 = new ArrayList();
        if(caisse.length > 0){
            dataSource1.addAll(Arrays.asList(caisse));
            param.put("listeDetails",dataSource1);
        }
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        param.put("cf", societe.getCf());
        param.put("tel", societe.getTelephone());
        param.put("capital", societe.getCapital());
        param.put("adresse", societe.getAdresse());
        param.put("fax", societe.getFax());
        param.put("tel1", societe.getFax());
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", societe.getEMail());
        param.put("bni_cl", societe.getBanque1());
        param.put("boa", societe.getBanque2());
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", societe.getCf());
        param.put("stat", societe.getNumStat());
        param.put("nif", societe.getNif());
        param.put("datyJour", Utilitaire.dateDuJour());
        if (enc_mere.length > 0) {
            ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENT");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdClient(),"CLIENT" , null);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getCodeclient());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("lieuClient",client.getProvinceLib());
                param.put("telClient",client.getTelephone());
                param.put("nifclient",client.getNif());
                param.put("statclient",client.getStat());
                param.put("cp",client.getCarte());
                param.put("quit","QUIT");
                param.put("datyclient",client.getDatecarte());
            } 
            param.put("numfact",enc_mere[0].getNumerofacture());
            param.put("datyfact",enc_mere[0].getDaty());
            param.put("totalcolis",enc_mere[0].getColis());
            param.put("totalpoids",enc_mere[0].getPoids());
            param.put("modepaiement",enc_mere[0].getModepaiementlib());
            param.put("reference",enc_mere[0].getIdOrigine());
            String modeDeLiv = enc_mere[0].getModelivraisonlib();
            String livraison = modeDeLiv.replace("<span style=color: green;>", "")
                 .replace("</span>", "");
            param.put("livraison",livraison);
            param.put("lieu_livraison",enc_mere[0].getLieuLivraison());
            param.put("transport",enc_mere[0].getFrais());
        }
       
        VenteDetailsLib vf = new VenteDetailsLib();
        vf.setNomTable("VENTE_DETAILS_POIDS_ING");
        VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, null,
                " AND idVente = '" + id + "' order by idproduitlib asc");
        //for (int i = 0; i < v_fille.length; i++) {
            //v_fille[i].setMontant(v_fille[i].getPuRemiseLib()*v_fille[i].getQte());
            //v_fille[i].setUnite("Carton");
        //}
        dataSource.addAll(Arrays.asList(v_fille));
        double montant = AdminGen.calculSommeDouble(v_fille,"montant");
        double montantremise = AdminGen.calculSommeDouble(v_fille,"montantremise");
        double montantremiser = AdminGen.calculSommeDouble(v_fille,"montantremiser");
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantht");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTva");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantttc");
        double frais = AdminGen.calculSommeDouble(v_fille,"frais");

        System.out.println("montant = "+Utilitaire.formaterAr(montantTVA));
        
        String montantNetLettre = ChiffreLettre.convertRealToString(montantTTC);
            if (montantNetLettre.contains(",")) {
                montantNetLettre = montantNetLettre.replace(",", " Ariary ");
            } else {
                montantNetLettre += " Ariary";
            }

        param.put("colpc", "Remise %");
        param.put("colmt", "PU Remis&eacute;");
        param.put("montantNetLettre", montantNetLettre);
        param.put("totalbrut",montant);
        param.put("totalremise",montantremiser);
        param.put("remise",montantremise);
        param.put("participation_transport",frais);
        param.put("totalHt",montantHT);
        param.put("total_taxes",montantTVA);
        param.put("montantttc",montantTTC);
        //param.put("escompte","");
        param.put("net_payer",montantTTC);
        param.put("net_payer_fmg",montantTTC*5);
        param.put("heure",Utilitaire.heureCouranteHMS());
        param.put("user",u.getUser().getNomuser());
        param.put("size",v_fille.length);

        setNomJasper("facture-vente-arbiochem");
        UtilitaireImpression.imprimer(request, response, enc_mere[0].getNumerofacture(), param, dataSource, getReportPath());
    }

    private void fiche_vente_nouveau_bl(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        String nomfichier = "bl-default";
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String idbl = request.getParameter("idbl");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");

        String type = request.getParameter("type");
        if(type.compareToIgnoreCase("duplicata")==0){
            param.put("type","DUPLICATA");
        }else{
            ImprimerVente imprimerVente =  new ImprimerVente();
            imprimerVente.setVal(id);
            imprimerVente.setDesce(u.getUser().getIdrole());
            u.createObject(imprimerVente);
        }
        Societe societe = u.getMaSociete();
        Caisse[] caisse = u.getCaissePdf();
        VenteLib v = new VenteLib();
        List dataSource1 = new ArrayList();
        if(caisse.length > 0){
            dataSource1.addAll(Arrays.asList(caisse));
            param.put("listeDetails",dataSource1);
        }
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        param.put("cf", societe.getCf());
        param.put("tel", societe.getTelephone());
        param.put("capital", societe.getCapital());
        param.put("adresse", societe.getAdresse());
        param.put("fax", societe.getFax());
        param.put("tel1", societe.getFax());
        param.put("tel2", ConstanteVente.tel2);
        param.put("email", societe.getEMail());
        param.put("bni_cl", societe.getBanque1());
        param.put("boa", societe.getBanque2());
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", societe.getCf());
        param.put("stat", societe.getNumStat());
        param.put("nif", societe.getNif());
        param.put("datyJour", Utilitaire.dateDuJour());
        if (enc_mere.length > 0) {
            ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENT");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdClient(),"CLIENT" , null);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getCodeclient());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("lieuClient",client.getProvinceLib());
                param.put("telClient",client.getTelephone());
                param.put("nifclient",client.getNif());
                param.put("statclient",client.getStat());
                param.put("cp",client.getCarte());
                param.put("quit","QUIT");
                param.put("datyclient",client.getDatecarte());
            }
            nomfichier = enc_mere[0].getNumerofacture();
            param.put("numfact",enc_mere[0].getNumerofacture());
            if(idbl!=null){
                param.put("numfact",idbl);
                nomfichier = idbl;
            }

            param.put("datyfact",enc_mere[0].getDaty());
            param.put("totalcolis",enc_mere[0].getColis());
            param.put("totalpoids",enc_mere[0].getPoids());
            param.put("modepaiement",enc_mere[0].getModepaiementlib());
            param.put("reference",enc_mere[0].getIdOrigine());
            String modeDeLiv = enc_mere[0].getModelivraisonlib();
            String livraison = modeDeLiv.replace("<span style=color: green;>", "")
                    .replace("</span>", "");
            param.put("livraison",livraison);
            param.put("lieu_livraison",enc_mere[0].getLieuLivraison());
            param.put("transport",enc_mere[0].getFrais());
        }

        VenteDetailsLib vf = new VenteDetailsLib();
        vf.setNomTable("VENTE_DETAILS_POIDS_ING");
        VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, null,
                " AND idVente = '" + id + "' order by idproduitlib asc");
        //for (int i = 0; i < v_fille.length; i++) {
        //v_fille[i].setMontant(v_fille[i].getPuRemiseLib()*v_fille[i].getQte());
        //v_fille[i].setUnite("Carton");
        //}
        dataSource.addAll(Arrays.asList(v_fille));
        double montant = AdminGen.calculSommeDouble(v_fille,"montant");
        double montantremise = AdminGen.calculSommeDouble(v_fille,"montantremise");
        double montantremiser = AdminGen.calculSommeDouble(v_fille,"montantremiser");
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantht");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTva");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantttc");
        double frais = AdminGen.calculSommeDouble(v_fille,"frais");

        System.out.println("montant = "+Utilitaire.formaterAr(montantTVA));

        String montantNetLettre = ChiffreLettre.convertRealToString(montantTTC);
        if (montantNetLettre.contains(",")) {
            montantNetLettre = montantNetLettre.replace(",", " Ariary ");
        } else {
            montantNetLettre += " Ariary";
        }

        param.put("colpc", "Remise %");
        param.put("colmt", "PU Remis&eacute;");
        param.put("montantNetLettre", montantNetLettre);
        param.put("totalbrut",montant);
        param.put("totalremise",montantremiser);
        param.put("remise",montantremise);
        param.put("participation_transport",frais);
        param.put("totalHt",montantHT);
        param.put("total_taxes",montantTVA);
        param.put("montantttc",montantTTC);
        //param.put("escompte","");
        param.put("net_payer",montantTTC);
        param.put("net_payer_fmg",montantTTC*5);
        param.put("heure",Utilitaire.heureCouranteHMS());
        param.put("user",u.getUser().getNomuser());
        param.put("size",v_fille.length);

        setNomJasper("facture-vente-arbiochem-bl");
        UtilitaireImpression.imprimer(request, response, nomfichier, param, dataSource, getReportPath());
    }

    private void situation_globale(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        String id = request.getParameter("id");
        Of t = new Of();
        t.setId(id);
        Of[] of_mere = (Of[]) CGenUtil.rechercher(t, null, null, null,
        " AND ID = '" + id + "'");
        if (of_mere.length > 0) {
          param.put("daty", of_mere[0].getDaty());
          param.put("id", of_mere[0].getId());
        }

        OfEtatGlobal ofGlobal = new OfEtatGlobal(id);
        Of of = ofGlobal.getOf();
        HashMap<String, Vector> mapRapprochement = ofGlobal.getRapprochement();
        MvtStockFilleTheorique[] rapprochementGlobal = ofGlobal.getRapprochementGlobal();
        OfFilleCpl[] details = ofGlobal.getDetails();

        List<MvtStockFilleTheorique> rapprochement = new ArrayList();
        for (Vector v : mapRapprochement.values()) {
            for (Object obj : v) {
                if (obj instanceof MvtStockFilleTheorique) {
                    rapprochement.add((MvtStockFilleTheorique) obj);
                }
            }
        }

        MvtStockFilleTheorique.calculerPourcentage(rapprochementGlobal);
        List<MvtStockFilleTheorique> listerapproche_globales = new ArrayList<>();
        if (rapprochementGlobal != null) {
            Collections.addAll(listerapproche_globales, rapprochementGlobal);
        }
        
        List<OfFilleCpl> listeDetails = new ArrayList<>();
        if (details != null) {
            Collections.addAll(listeDetails, details);
        }
        System.out.println("details = "+details.length);
        param.put("rapprochement", rapprochement);
        param.put("listeDetails", listeDetails);
        param.put("listerapproche_globales", listerapproche_globales);
        setNomJasper("situation_globale");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }

    private void offille_situation_globale(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");

        OffilleEtatGlobal etatGlobal = new OffilleEtatGlobal(id);
        OfFilleCpl offille = etatGlobal.getOffille();
        String idMere = offille.getIdMere();
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        Of[] of_mere = (Of[]) CGenUtil.rechercher(new Of(), null, null, null,
                " AND ID = '" + idMere + "'");
        if (of_mere.length > 0) {
            param.put("daty", of_mere[0].getDaty());
            param.put("id", of_mere[0].getId());
            param.put("idfille", id);
        }
        String idIngredient = offille.getIdIngredients();
        IngredientsLib ingredients = (IngredientsLib) new IngredientsLib().getById(idIngredient,null,null);
        param.put("article",ingredients.getLibelle());
        param.put("qte", Utilitaire.formaterAr(offille.getQte())+" "+ingredients.getUnite());
        param.put("qteFabrique", Utilitaire.formaterAr(offille.getQteFabrique())+" "+ingredients.getUnite());
        param.put("qteReste", Utilitaire.formaterAr(offille.getQteReste())+" "+ingredients.getUnite());
        param.put("puRevient", Utilitaire.formaterAr(offille.getPuRevient())+" Ar");
        param.put("pv", Utilitaire.formaterAr(offille.getPv())+" Ar");
        param.put("montantRevient", Utilitaire.formaterAr(Utilitaire.enleverExponentielleDouble(offille.getMontantRevient()))+" Ar");
        param.put("montantEntree", Utilitaire.formaterAr(Utilitaire.enleverExponentielleDouble(offille.getMontantentree()))+" Ar");
        param.put("montantSortie", Utilitaire.formaterAr(Utilitaire.enleverExponentielleDouble(offille.getMontantsortie()))+" Ar");
        param.put("tauxRevient", Utilitaire.enleverExponentielleDouble(offille.getTauxRevient())+" %");

        HashMap<String, Vector> mapRapprochement = etatGlobal.getRapprochement();
        MvtStockFilleTheorique[] rapprochementGlobal = etatGlobal.getRapprochementGlobal();

        List<MvtStockFilleTheorique> rapprochement = new ArrayList();
        for (Vector v : mapRapprochement.values()) {
            for (Object obj : v) {
                if (obj instanceof MvtStockFilleTheorique) {
                    rapprochement.add((MvtStockFilleTheorique) obj);
                }
            }
        }

        MvtStockFilleTheorique.calculerPourcentage(rapprochementGlobal);
        List<MvtStockFilleTheorique> listerapproche_globales = new ArrayList<>();
        if (rapprochementGlobal != null) {
            Collections.addAll(listerapproche_globales, rapprochementGlobal);
        }

        param.put("rapprochement", rapprochement);
        param.put("listerapproche_globales", listerapproche_globales);
        setNomJasper("offille_situation_globale");
      
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }
    private void vente_liste(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String designation = request.getParameter("designation");
        String idClientLib = request.getParameter("idClientLib");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        String awhere="";
        VenteLib v = new VenteLib();
        v.setNomTable("VENTE_CPL");
        v.setId(id);
        v.setDesignation(designation);
        v.setIdClientLib(idClientLib);
        if ((daty1 != null && !daty1.trim().isEmpty()) || (daty2 != null && !daty2.trim().isEmpty())) {
            if (daty1 != null && !daty1.trim().isEmpty()) {
                awhere += " and daty >= to_date('" + daty1 + "', 'dd/mm/yyyy') ";
                param.put("datymin", daty1);
            }
            if (daty2 != null && !daty2.trim().isEmpty()) {
                awhere += " and daty <= to_date('" + daty2 + "', 'dd/mm/yyyy') ";
                param.put("datymax", daty2);
            }
        }
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, null,awhere);
        //double montantHT = AdminGen.calculSommeDouble(enc_mere,"montantHT");
        dataSource.addAll(Arrays.asList(enc_mere));
        setNomJasper("facture_vente_mere");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }
     private void vente_liste_encaisser(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        param.put("adresse" , societe.getAdresse());
        param.put("nom" , societe.getNom());
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String designation = request.getParameter("designation");
         String idClientLib = request.getParameter("idClientLib");
         String provincelib = request.getParameter("provincelib");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        String awhere="";
        VenteLib v = new VenteLib();
        v.setNomTable("VENTE_CPL");
        v.setId(id);
        v.setDesignation(designation);
        v.setIdClientLib(idClientLib);
        v.setProvincelib(provincelib);
        if ((daty1 != null && !daty1.trim().isEmpty()) || (daty2 != null && !daty2.trim().isEmpty())) {
            if (daty1 != null && !daty1.trim().isEmpty()) {
                awhere += " and daty >= to_date('" + daty1 + "', 'dd/mm/yyyy') ";
                param.put("datymin", daty1);
            }
            if (daty2 != null && !daty2.trim().isEmpty()) {
                awhere += " and daty <= to_date('" + daty2 + "', 'dd/mm/yyyy') ";
                param.put("datymax", daty2);
            }
        }
        awhere += " order by datelivraison asc";
        v.setNomTable("VENTE_CPL_CL");
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, null,awhere);
        VenteLib vente = enc_mere[0];
         for (int i = 0; i < enc_mere.length; i++) {
             enc_mere[i].setProvincelib(enc_mere[i].getAdresse());
         }
        if(enc_mere.length > 0){
             param.put("province", "ANTANANARIVO");
        }
        
        //double montantHT = AdminGen.calculSommeDouble(enc_mere,"montantHT");
        dataSource.addAll(Arrays.asList(enc_mere));
        setNomJasper("liste-encaissement");
        UtilitaireImpression.imprimer(request, response, "Liste des ancaissements", param, dataSource, getReportPath());
    }
    private void vente_liste_mere_fille(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String designation = request.getParameter("designation");
        String idClientLib = request.getParameter("idClientLib");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        String awhere="";
        VenteLib v = new VenteLib();
        v.setNomTable("VENTE_CPL");
        v.setId(id);
        v.setDesignation(designation);
        v.setIdClientLib(idClientLib);
        if ((daty1 != null && !daty1.trim().isEmpty()) || (daty2 != null && !daty2.trim().isEmpty())) {
            if (daty1 != null && !daty1.trim().isEmpty()) {
                awhere += " and daty >= to_date('" + daty1 + "', 'dd/mm/yyyy') ";
                param.put("datymin", daty1);
            }
            if (daty2 != null && !daty2.trim().isEmpty()) {
                awhere += " and daty <= to_date('" + daty2 + "', 'dd/mm/yyyy') ";
                param.put("datymax", daty2);
            }
        }
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, null, awhere);
        Map<String, List<VenteDetailsLib>> listedetailsMap = new HashMap<>();
        for (VenteLib venteMere : enc_mere) {
            VenteDetailsLib vf = new VenteDetailsLib();
            vf.setNomTable("VENTE_DETAILS_CPL");
            vf.setIdVente(venteMere.getId());
            VenteDetailsLib[] enc_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, null, "");
            if (enc_fille != null) {
                listedetailsMap.put(venteMere.getId(), Arrays.asList(enc_fille));
            } else {
                listedetailsMap.put(venteMere.getId(), new ArrayList<>());
            }
        }
        param.put("listedetails", listedetailsMap);
        List<VenteLib> dataSourceMere = Arrays.asList(enc_mere);
        setNomJasper("facture_vente_mere_fille");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSourceMere, getReportPath());

    }

    private void proforma(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        ProformaLib v = new ProformaLib();
        v.setNomTable("PROFORMA_CPL");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        ProformaLib[] enc_mere = (ProformaLib[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        v = enc_mere[0];
        Societe societe = u.getMaSociete();
        Caisse[] caisse = u.getCaissePdf();
        List dataSource1 = new ArrayList();
        if(caisse.length > 0){
            dataSource1.addAll(Arrays.asList(caisse));
            param.put("listeDetails",dataSource1);
        }
        
       if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        param.put("cf", societe.getCf());
        param.put("tel", societe.getTelephone());
        param.put("capital", societe.getCapital());
        param.put("adresse", societe.getAdresse());
        param.put("fax", "");
        param.put("tel1", societe.getFax());
        param.put("tel2", "");
        param.put("email", societe.getEMail());
        param.put("bni_cl", societe.getBanque1());
        param.put("boa", societe.getBanque2());
        param.put("bmoi", ConstanteVente.bmoi);
        param.put("bfv_sg", ConstanteVente.bfv_sg);
        param.put("cf", societe.getCf());
        param.put("stat", societe.getNumStat());
        param.put("nif", societe.getNif());
        
        param.put("datyJour", Utilitaire.dateDuJour());
        if (enc_mere.length > 0) {
             ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENT");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdClient(),"CLIENT" , null);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getCodeclient());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("lieuClient",client.getProvinceLib());
                param.put("telClient",client.getTelephone());
                param.put("statclient",client.getStat());
                param.put("nifclient",client.getNif());
                param.put("cp",client.getCarte());
                param.put("quit","");
                param.put("datyclient",client.getDatecarte());
            }
            param.put("numfact",enc_mere[0].getNumeroProforma());
            param.put("datyfact",enc_mere[0].getDaty());
            //param.put("totalcolis","");
            //param.put("totalpoids","");
            //param.put("modepaiement",enc_mere[0].get);
            param.put("reference",enc_mere[0].getReference());
            param.put("livraison",enc_mere[0].getModeLivraisonLib());
            param.put("lieu_livraison",enc_mere[0].getLieuLivraison());
            param.put("transport","");
        }

        ProformaDetailsLib vf = new ProformaDetailsLib();
        vf.setNomTable("PROFORMADETAILS_CPL_ING_PDF");
        ProformaDetailsLib[] v_fille = (ProformaDetailsLib[]) CGenUtil.rechercher(vf, null, null, null,
                 " AND idProforma='" + id + "' ORDER BY idproduitlib ASC");
        double restourne = 0;
        for (int i = 0; i < v_fille.length; i++) {
            //v_fille[i].setPuTotal(v_fille[i].getPuRemiseLib()*v_fille[i].getQte());
            //v_fille[i].setUnite(v_fille[i].getContenuelib());
            restourne = restourne + v_fille[i].getRistourne();
        }
        setNomJasper("proforma-arbiochem");
        String nomPDF = "Proforma";
        if(restourne == 0){
            setNomJasper("proforma-remise-arbiochem");
            nomPDF = "Proforma avec remise"; 
        }
        dataSource.addAll(Arrays.asList(v_fille));
        double montantHT = AdminGen.calculSommeDouble(v_fille,"puTotal");
        double fraistransport = AdminGen.calculSommeDouble(v_fille, "fraistransport");
        double montantRistourne = AdminGen.calculSommeDouble(v_fille,"montantristourne");
        double montantNetHt = AdminGen.calculSommeDouble(v_fille,"montanttotal");
        double totalTaxe = AdminGen.calculSommeDouble(v_fille,"montanttva");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantttc");
        double totalColis = AdminGen.calculSommeDouble(v_fille,"qte");
        double totalPoids = AdminGen.calculSommeDouble(v_fille,"poidstotal");
        //double frais = AdminGen.calculSommeDouble(v_fille,"frais");
         String montantNetLettre = ChiffreLettre.convertRealToString(montantTTC);
            if (montantNetLettre.contains(",")) {
                montantNetLettre = montantNetLettre.replace(",", " Ariary ");
            } else {
                montantNetLettre += " Ariary";
            }

        param.put("montantNetLettre", montantNetLettre);
        param.put("total_HT",montantHT);
        param.put("transport",v.getFraislivraison());
        param.put("frais_livraison",fraistransport);
        param.put("total_ristourne",montantRistourne);
        param.put("total_net_HT",montantNetHt);
        param.put("total_taxe",totalTaxe);
        param.put("net_payer",montantTTC);
        param.put("totalcolis",totalColis);
        param.put("totalpoids",totalPoids);
        param.put("heure",Utilitaire.heureCouranteHMS());
        param.put("user",u.getUser().getNomuser());
        param.put("size",v_fille.length);
        getNomJasper();
        UtilitaireImpression.imprimer(request, response, nomPDF+"-"+id, param, dataSource, getReportPath());
    }

    private void imprimerDeclaration(HttpServletRequest request, HttpServletResponse response) throws Exception{

        String id = request.getParameter("id");

        DeclarationTvaLib declib = new DeclarationTvaLib();

        DeclarationTvaLib[] decls = (DeclarationTvaLib[]) CGenUtil.rechercher(declib, null, null, null," AND ID='"+id+"'");
        if(decls.length <1){
            throw new Exception("Pas de declaration pour : "+id);
        }


        Map param = new HashMap();
        List dataSource = new ArrayList();
        ImprimerDeclaration[] enc_mere = (ImprimerDeclaration[]) CGenUtil.rechercher(new ImprimerDeclaration(), null, null, null,"");

        DeclarationTva dec = new DeclarationTva(decls[0].getDatydebut(),decls[0].getDatyfin());
        HashMap<String, ImprimerDeclaration> res = dec.getDonnees();
        for (int j = 0; j < enc_mere.length; j++) {
            if(enc_mere[j].getId().compareToIgnoreCase(res.get(enc_mere[j].getId()).getId())==0){
                //enc_mere[j].setMontant(res.get(enc_mere[j].getId()).getMontant()*(res.get(enc_mere[j].getId()).getTaux()/100));
                enc_mere[j].setMontant(res.get(enc_mere[j].getId()).getMontant());
                //enc_mere[j].setMontantadeclarer(calcule.getMontant()*(calcule.getTaux()/100));
                System.out.println(enc_mere[j].getNumero()+"====="+enc_mere[j].getMontant());
            }
        }
        param.put("nif", ConstanteVente.nif);
        param.put("raisonSocial", ConstanteVente.RAISON_SOCIAL);
        param.put("adresse", ConstanteVente.ADRESSE);
        param.put("adresseCentre", ConstanteVente.ADRESSE_CENTRE);
        param.put("centre", ConstanteVente.CENTRE_FISCAL);
        dataSource.addAll(Arrays.asList(enc_mere));
        setNomJasper("hetra");
        UtilitaireImpression.imprimer(request, response, "imprime-declaration", param, dataSource, getReportPath());
    }
    private void imprimer_bulletin_paie(HttpServletRequest request, HttpServletResponse response) throws Exception{
        String id = request.getParameter("id");  
        FichePaie fp = new FichePaie();
        List<FichePaie> allFichePaies = fp.getListFichePaieEdition(id);
        List<PaieEditionEltpaie> empElements = new ArrayList();
        MappingElementPaie mapEmp = null;
         for (int i = 0; i < allFichePaies.size(); i++) {
            FichePaie empFiche = allFichePaies.get(i);
            empElements = empFiche.getListeElementPaie();
            mapEmp = MappingElementPaie.getValeurElementDePaie(empElements);
            empFiche.setMapEmp(Collections.singletonList(mapEmp));
        }
        List dataSource = new ArrayList();
        Map param = new HashMap();
        param.put("listeDetails",allFichePaies);
        setNomJasper("fiche_de_paie");
        UtilitaireImpression.imprimer(request, response, "fiche_de_paie", param, dataSource, getReportPath());
    }

    private void bc_client(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        BonDeCommandeCpl v = new BonDeCommandeCpl();
        v.setNomTable("BONDECOMMANDE_CLIENT_CPL");
        BonDeCommandeCpl[] enc_mere = (BonDeCommandeCpl[]) CGenUtil.rechercher(v, null, null, null,
            " AND ID = '" + id + "'");
        v = enc_mere[0];

        Societe societe = u.getMaSociete();
        Caisse[] caisse = u.getCaissePdf();
        List dataSource1 = new ArrayList();
        if(caisse.length > 0){
            dataSource1.addAll(Arrays.asList(caisse));
            param.put("listeDetails",dataSource1);
        }

        if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }

        param.put("tel", societe.getTelephone());
        param.put("capital", societe.getCapital());
        param.put("adresse", societe.getAdresse());
        param.put("fax", societe.getFax());
        param.put("tel1", societe.getFax());
        param.put("cf", societe.getCf());
        param.put("stat", societe.getNumStat());
        param.put("nif", societe.getNif());
        param.put("email", societe.getEMail());
        param.put("datyJour", Utilitaire.dateDuJour());

        if (enc_mere.length > 0) {
            ClientLib cl = new ClientLib();
            cl.setNomTable("CLIENT");
            ClientLib client = (ClientLib) cl.getById(enc_mere[0].getIdClient(),"CLIENT" , null);
            if (enc_mere.length > 0) {
                param.put("idclient",client.getCodeclient());
                param.put("nomClient",client.getNom());
                param.put("adresseClient",client.getAdresse());
                param.put("lieuClient",client.getProvinceLib());
                param.put("telClient",client.getTelephone());
                param.put("statclient",client.getStat());
                param.put("nifclient",client.getNif());
                param.put("cp",client.getCarte());
                param.put("quit","");
                param.put("datyclient",client.getDatecarte());
            }
            param.put("numfact",enc_mere[0].getNumeroBc());
            param.put("datyfact",enc_mere[0].getDaty());
            //param.put("totalcolis","");
            //param.put("totalpoids","");
            param.put("modepaiement",enc_mere[0].getModepaiementlib());
            param.put("reference",enc_mere[0].getReference());
            param.put("livraison",enc_mere[0].getModelivraisonlib());
            param.put("lieu_livraison",enc_mere[0].getLieuLivraison());
            param.put("transport",enc_mere[0].getFraislivraison());

        }

        BonDeCommandeFIlleCpl vf = new BonDeCommandeFIlleCpl();
        vf.setNomTable("BC_CLIENT_FILLE_CPL_LIB_PDF");
        BonDeCommandeFIlleCpl[] v_fille = (BonDeCommandeFIlleCpl[]) CGenUtil.rechercher(vf, null, null, null,
            " and idbc='" + id + "' order by produitlib asc");
        dataSource.addAll(Arrays.asList(v_fille));
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montanttotal");
        double fraistransport = AdminGen.calculSommeDouble(v_fille, "fraistransport");
        double montantRistourne = AdminGen.calculSommeDouble(v_fille,"montantristourne");
        double montantNetHt = AdminGen.calculSommeDouble(v_fille,"montanttotal");
        double totalTaxe = AdminGen.calculSommeDouble(v_fille,"montanttva");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantttc");
        double totalColis = AdminGen.calculSommeDouble(v_fille,"quantite");
        double totalPoids = AdminGen.calculSommeDouble(v_fille,"poidstotal");
        //double frais = AdminGen.calculSommeDouble(v_fille,"frais");
         String montantNetLettre = ChiffreLettre.convertRealToString(montantTTC);
            if (montantNetLettre.contains(",")) {
                montantNetLettre = montantNetLettre.replace(",", " Ariary ");
            } else {
                montantNetLettre += " Ariary";
            }

        /*
        //ETO
        param.put("transport",fraistransport);

        double totalBrut = AdminGen.calculSommeDouble(v_fille,"montantremise");
        param.put("totalbrut", totalBrut);

        double remise = AdminGen.calculSommeDouble(v_fille,"montantremise");
        param.put("totalremise", remise);

        double totalremise = totalBrut - remise;
        param.put("remise", totalremise);

        param.put("participation_transport", fraistransport);
        param.put("totalHt", remise-fraistransport);
        param.put("total_taxes", totalTaxe);
        param.put("montantttc", montantTTC);
        param.put("escompte", 0.0);
            //
        param.put("montantNetLettre", montantNetLettre);
        param.put("total_HT",montantHT);
        param.put("transport",v.getFraislivraison());
        param.put("frais_livraison",fraistransport);
        param.put("total_ristourne",montantRistourne);
        param.put("total_net_HT",montantNetHt);
        param.put("total_taxe",totalTaxe);
        param.put("net_payer",montantTTC);
         */
        param.put("ristourne", 10.0);

        param.put("montantNetLettre", montantNetLettre);

        double totalBrut = AdminGen.calculSommeDouble(v_fille,"montanttotal");
        param.put("totalbrut", totalBrut);

        double remise = AdminGen.calculSommeDouble(v_fille,"montantdelaremise");
        param.put("remise", remise);

        double totalremise = AdminGen.calculSommeDouble(v_fille,"montantremise");
        param.put("totalremise", totalremise);

        param.put("participation_transport", fraistransport);
        param.put("totalHt", totalremise-fraistransport);
        param.put("total_taxes", totalTaxe);
        param.put("montantttc", montantTTC);
        param.put("ristourne",montantRistourne);
        param.put("net_payer",montantTTC);
        param.put("escompte", 0.0);

        param.put("totalcolis",totalColis);
        param.put("totalpoids",totalPoids);
        param.put("heure",Utilitaire.heureCouranteHMS());
        param.put("user",u.getUser().getNomuser());
        param.put("size",v_fille.length);
        param.put("colpc", "Remise %");
        param.put("colmt", "PU Remis&eacute;");
        setNomJasper("bc-vente-arbiochem");
        UtilitaireImpression.imprimer(request, response, getNomJasper()+"-"+id, param, dataSource, getReportPath());
    }
     private void chiffre_affaire_par_article(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        param.put("adresse" , societe.getAdresse());
        param.put("nom",societe.getNom());
        param.put("capital" , societe.getCapital());
        String awhere="";
        StatFille stf = new StatFille();
        String [] colInt = {"daty"};
        String [] valInt = {daty1, daty2};
        int numPage = 1;
        String apresWhere = " ";
        String [] nomColSomme = {"montant"};
        int npp=1000;
        ResultatEtSomme rs =stf.rechercherPage(colInt, valInt, numPage, apresWhere, nomColSomme, null,npp);
        StatFille[] enc_mere = (StatFille[]) rs.getResultat();
        param.put("daty", Utilitaire.dateDuJour());
        param.put("datydebut", daty1);
        param.put("datyfin", daty2);
        if (enc_mere.length > 0) {
            /*param.put("totalbrut","");
            param.put("remiseglobale","");
            param.put("totalca","");
            param.put("totalfmg","");
            param.put("montantventes","");
            param.put("notecredit","");
            param.put("remise","");
            param.put("reste","");
             param.put("totalfmg2","");*/
        }

        dataSource.addAll(Arrays.asList(enc_mere));


        setNomJasper("chiffre_affaire_par_article");
        UtilitaireImpression.imprimer(request, response, getNomJasper()+"-"+id, param, dataSource, getReportPath());
    }
     private void statistique_vente(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        String idclient = request.getParameter("idclient");
        String famille = request.getParameter("famille");
        if(daty1==null || daty1.trim().isEmpty()  || daty2==null || daty2.trim().isEmpty()){
            daty1 = Utilitaire.dateDuJour();
            daty2 = Utilitaire.dateDuJour();
        }
        String awhere="";
        StatFille stf = new StatFille();
         stf.setIdclient(idclient);
         stf.setFamille(famille);
        String [] colInt = {"daty"};
        String [] valInt = {daty1, daty2};
        int numPage = 1;
        String apresWhere = "";
       /*  if(idclient!=null && !idclient.trim().isEmpty()){
            apresWhere += " and idClient='"+idclient+"'";
        }*/
        String [] nomColSomme = {"montant"};
        int npp=1000;
        ResultatEtSomme rs =stf.rechercherPage(colInt, valInt, numPage, apresWhere, nomColSomme, null,npp);
        StatFille[] enc_mere = (StatFille[]) rs.getResultat();
        param.put("daty", Utilitaire.dateDuJour());
        param.put("datydebut", daty1);
        param.put("datyfin", daty2);
         System.err.println("================="+idclient);
        ClientLib client = (ClientLib) new ClientLib().getById(idclient,"CLIENTLIB",null);
        if (enc_mere.length > 0) {
            param.put("province",client.getProvinceLib());
            param.put("client",client.getCodeclient() +" "+client.getNom());
            param.put("adresseclient",client.getAdresse());
            /*param.put("totalbrut","");
            param.put("remiseglobale","");
            param.put("totalca","");
            param.put("totalfmg","");
            param.put("montantventes","");
            param.put("notecredit","");
            param.put("remise","");
            param.put("reste","");
             */
            param.put("remiseglobale",AdminGen.calculSommeDouble(enc_mere, "remise"));
            param.put("totalbrut",AdminGen.calculSommeDouble(enc_mere, "montant"));
            param.put("montantventes",(AdminGen.calculSommeDouble(enc_mere, "montant")-AdminGen.calculSommeDouble(enc_mere, "remise")));
            param.put("totalfmg",AdminGen.calculSommeDouble(enc_mere, "montant"));
        }

        dataSource.addAll(Arrays.asList(enc_mere));
        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        param.put("nom",societe.getNom());
        param.put("capital" , societe.getCapital());
        setNomJasper("statistique_vente");
        UtilitaireImpression.imprimer(request, response, getNomJasper()+"-"+client.getNom()+"-"+daty1+"_"+daty2, param, dataSource, getReportPath());
    }
    private void imprimer_etatstock_engage(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
          boolean canClose=false;
        try{
            if(c==null){
                c=new UtilDB().GetConn();
                canClose=true;
            }
            System.err.println("========================MIDITRA ATO=");
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String idProduitLib = request.getParameter("idProduitLib");
        String idMagasin = request.getParameter("idMagasin");

        param.put("daty", Utilitaire.dateDuJourSql());
        param.put("magasin", idMagasin);
        param.put("prixlib", "");
        param.put("unite", "");
        String awhere="";
        EtatStockEngage stf = new EtatStockEngage();
        stf.setNomTable("V_ETATSTOCK_ING_VENTE");
        String [] colInt = {};
        String [] valInt = {};
        int numPage = 1;
        String apresWhere = "";
       /*  if(idclient!=null && !idclient.trim().isEmpty()){
            apresWhere += " and idClient='"+idclient+"'";
        }*/
        String[] nomColSomme = {"physique","engage","afacturer"};
        int npp=1000;

        if(idMagasin!=null){
            apresWhere+=" AND IDMAGASIN='"+idMagasin+"'";
        }

        System.err.println(apresWhere);
        ResultatEtSomme rs =stf.rechercherPage(colInt, valInt, numPage, apresWhere, nomColSomme, c,npp);
        EtatStockEngage[] enc_mere = (EtatStockEngage[]) rs.getResultat();
        if (enc_mere.length > 0) {
        }

        dataSource.addAll(Arrays.asList(enc_mere));

        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        Societe societe = u.getMaSociete();
        param.put("nom",societe.getNom());
        param.put("adresse",societe.getAdresse());
        
        setNomJasper("etatstock_engage_vf");
        System.out.println("getNomJasper = "+getNomJasper());
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
         } catch(Exception e){
            throw e;
        } finally {
            if(canClose){
                c.close();
            }
        }
    }


    private void imprimer_ticket_caisse(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception{
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        VenteLib v = new VenteLib();
        VenteLib[] enc_mere = (VenteLib[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        Vente vt = new Vente();
        Vente[] vente = (Vente[]) CGenUtil.rechercher(vt, null, null, null,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
           
            param.put("montantPaye", enc_mere[0].getMontantpaye());
            param.put("montantretour", enc_mere[0].getMontantRetourner());
            param.put("heure", Utilitaire.heureCouranteHMS());
            param.put("designation", enc_mere[0].getDesignation());
            param.put("MAGASINCONSIDERER", enc_mere[0].getIdMagasinLib());
            param.put("daty", enc_mere[0].getDaty());
            param.put("remarque", enc_mere[0].getRemarque());
            // param.put("montanttotal", enc_mere[0].getMontanttotal());
            param.put("devise", enc_mere[0].getIdDevise());
            param.put("numFact", id);
            param.put("num" , id);

            param.put("daty" , enc_mere[0].getDaty());
            param.put("modeDePaie" , enc_mere[0].getIdModePaiementLib());
            //param.put("datyEcheance" , enc_mere[0].ge());
            param.put("montantApayer" , enc_mere[0].getMontantpaye());
            param.put("montantReste" , enc_mere[0].getMontantreste());
            //param.put("reduction" , enc_mere[0].getMonta());
            //param.put("contact" , tiers[0].getContact());
            param.put("nom" , enc_mere[0].getIdClientLib());
            param.put("montantAvoir" , enc_mere[0].getMontantreste() < 0 ? enc_mere[0].getMontantreste() : 0);
            param.put("montantDonne", enc_mere[0].getMontantDonne());
           if(vente.length > 0) {
               if(vente[0].getIdResponsable()!= null){
                Utilisateur ut = new Utilisateur();
                Utilisateur[] utilisateur = (Utilisateur[]) CGenUtil.rechercher(ut, null, null, null,
                " AND refuser = '" + vente[0].getIdResponsable() + "'");
                if(utilisateur.length > 0){
                    param.put("responsable", utilisateur[0].getNomuser());
                }
            }
           }
            
        }
        param.put("lieu" , ConstanteAsync.lieuMagasin);

        param.put("MAGASINCONSIDERER" , "ASYNC");
        param.put("tel" , ConstanteAsync.tel);
        param.put("tel1" , ConstanteAsync.tel1);
        param.put("tel2" , ConstanteAsync.tel2);

        param.put("nif" , ConstanteAsync.nif);
        param.put("stat" , ConstanteAsync.stat);

        VenteDetailsLib vf = new VenteDetailsLib();
        vf.setNomTable("VENTE_DETAILS_TICKET");
        VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, null,
                " AND idVente = '" + id + "'");
        for (VenteDetailsLib vd : v_fille) {
            if (!"APP".equals(vd.getIdProduit())) {
                dataSource.add(vd);
            }
        }
        //dataSource.addAll(Arrays.asList(v_fille));
        String devise = v_fille[0].getIdDevise();
        double montantHT = AdminGen.calculSommeDouble(v_fille,"montantHTLocal");
        double montantTVA = AdminGen.calculSommeDouble(v_fille,"montantTvaLocal");
        double montantTTC = AdminGen.calculSommeDouble(v_fille,"montantTTCLocal");

        param.put("niflib" , "Nif");
        param.put("totallib" , "TOTAL");
        param.put("montantavoirlib" , "Montant Avoir");
        param.put("montantaplib" , "Net a Payer");
        param.put("montantpayelib" , "Montant Paye");
        param.put("resteapayelib" , "Reste a Payer");
        param.put("statlib" , "Stat");
        param.put("date" , "Date");
        param.put("client" , "Client");


        param.put("montantHT", montantHT);
        param.put("montantTVA", montantTVA);
        param.put("montantTTC", montantTTC);
        param.put("devise", devise);
        param.put("mail", ConstanteAsync.mail);
         UserEJB u = (UserEJB) request.getSession().getAttribute("u");
         Societe societe = u.getMaSociete();
         if (societe.getLogo() != null && !societe.getLogo().trim().isEmpty()&& !"-".equals(societe.getLogo().trim())) {
            param.put("logo", societe.getLogo());
        }
        param.put("disponibilite1", societe.getDisponnibilite());
        param.put("disponibilite2", ConstanteAsync.disponibilite2);
        param.put("tel", ConstanteAsync.tel);
        int nbLignes = (v_fille != null) ? v_fille.length : 0;
        param.put("nbArticles", nbLignes);


        ArrayList<VenteDetailsLib> arrList = new ArrayList<VenteDetailsLib>();

        param.put("netapayer" , enc_mere[0].getMontantttc());
//        param.put("list_table",arrList);
        param.put("montanttotal",enc_mere[0].getMontantttc());
        param.put("idmodepaiementlib",enc_mere[0].getIdModePaiementLib());
        double reste = enc_mere[0].getMontantDonne()-enc_mere[0].getMontantttc();
        param.put("reste",reste);
        List<Map<String, Object>> modesPaiement = new ArrayList<>();

        Map<String, Object> m1 = new HashMap<>();
        m1.put("libelle", "Especes");
        m1.put("montant", enc_mere[0].getMontantDonne()); // exemple : montant total payé
        modesPaiement.add(m1);

        Map<String, Object> m2 = new HashMap<>();
        m2.put("libelle", "Cheque");
        m2.put("montant", 0.0);
        modesPaiement.add(m2);

        Map<String, Object> m3 = new HashMap<>();
        m3.put("libelle", "Carte");
        m3.put("montant", 0.0);
        modesPaiement.add(m3);

        // On passe la liste dans les paramètres Jasper
        param.put("LISTE_MODE_PAIEMENT", modesPaiement);
        // setNomJasper("FC");

        setNomJasper("ticket_caisse");
        String filename = "Ticket n°" + id;
        UtilitaireImpression.imprimer(request, response, filename, param, dataSource, getReportPath());
    }
    
    /** Echappement minimal : le message d'exception peut contenir du SQL et des parametres reflechis. */
    private static String htmlEscape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    /**
     * Rend l'erreur DANS l'iframe d'apercu : une redirection y reafficherait
     * l'application entiere imbriquee dans le modal.
     * Entites HTML plutot que des accents litteraux : les sources sont en UTF-8 mais Ant
     * compile en iso-8859-1, un accent litteral sortirait double-encode dans le navigateur.
     */
    private static void rendreErreurApercu(HttpServletResponse response, String error) throws IOException {
        try {
            response.reset();
        } catch (IllegalStateException dejaCommittee) {
            // PDF deja partiellement ecrit : plus rien a reinitialiser, on laisse le flux tel quel.
            return;
        }
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<html><body style=\"font-family:sans-serif;padding:24px;color:#a94442;background:#fff\">");
        out.println("<h3>Impossible de g&eacute;n&eacute;rer le PDF</h3>");
        out.println("<p>" + htmlEscape(error) + "</p>");
        out.println("</body></html>");
        out.flush();
    }

    private static boolean estApercu(HttpServletRequest request) {
        return "1".equals(request.getParameter("inline"));
    }

    /**
     * Reecrit "Content-disposition: attachment; filename=X" en "inline; filename=\"X\"".
     * Necessaire parce que web.mg.cnaps.servlet.etat.UtilitaireImpression (apj-core2.jar,
     * sans source) code la disposition en dur et utilise addHeader : on ne peut ni la
     * parametrer, ni la surcharger apres coup sans obtenir deux en-tetes.
     */
    private static class InlineDispositionResponse extends HttpServletResponseWrapper {

        InlineDispositionResponse(HttpServletResponse response) {
            super(response);
        }

        @Override
        public void addHeader(String name, String value) {
            if ("Content-disposition".equalsIgnoreCase(name)) {
                setHeader(name, value);
                return;
            }
            super.addHeader(name, value);
        }

        @Override
        public void setHeader(String name, String value) {
            if ("Content-disposition".equalsIgnoreCase(name)) {
                super.setHeader("Content-Disposition", toInline(value));
                return;
            }
            super.setHeader(name, value);
        }

        private static String toInline(String value) {
            String fn = "";
            if (value != null) {
                int i = value.toLowerCase().indexOf("filename=");
                if (i >= 0) {
                    fn = value.substring(i + "filename=".length())
                            .replace("\"", "").replace("\r", "").replace("\n", "").trim();
                }
            }
            return fn.isEmpty() ? "inline" : "inline; filename=\"" + fn + "\"";
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
     @Override
     protected void doGet(HttpServletRequest request, HttpServletResponse response)
             throws ServletException, IOException {
         try {
             processRequest(request, response);
         } catch (Exception ex) {
             Logger.getLogger(ExportPDFARBIOCHEM.class.getName()).log(Level.SEVERE, null, ex);
             // Rediriger vers la page précédente avec le message d'erreur
             String error = ex.getMessage() != null ? ex.getMessage() : "Erreur lors de la génération du PDF";
             if (estApercu(request)) {
                 rendreErreurApercu(response, error);
                 return;
             }
             request.getSession().setAttribute("erreur", error);
             String referer = request.getHeader("Referer");
             if (referer != null && !referer.isEmpty()) {
                 response.sendRedirect(referer);
             } else {
                 response.sendRedirect(request.getContextPath() + "/index.jsp");
             }
         }
     }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
     @Override
     protected void doPost(HttpServletRequest request, HttpServletResponse response)
             throws ServletException, IOException {
         try {
             processRequest(request, response);
         } catch (Exception ex) {
             Logger.getLogger(ExportPDFARBIOCHEM.class.getName()).log(Level.SEVERE, null, ex);
             // Rediriger vers la page précédente avec le message d'erreur
             String error = ex.getMessage() != null ? ex.getMessage() : "Erreur lors de la génération du PDF";
             if (estApercu(request)) {
                 rendreErreurApercu(response, error);
                 return;
             }
             request.getSession().setAttribute("erreur", error);
             String referer = request.getHeader("Referer");
             if (referer != null && !referer.isEmpty()) {
                 response.sendRedirect(referer);
             } else {
                 response.sendRedirect(request.getContextPath() + "/index.jsp");
             }
         }
     }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    
}
