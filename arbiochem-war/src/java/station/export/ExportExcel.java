/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package station.export;


import net.sf.jasperreports.engine.JRException;
import caisse.Caisse;
import client.ReleveClient;
import net.sf.jasperreports.engine.JRException;
import oracle.net.aso.d;
import rapprochement.ReleverDetailCpl;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import stock.EtatStockParEntree;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;
import vente.*;
import java.util.*;
import bean.*;


import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import mg.cnaps.compta.ComptaEtatGrandLivreGenerator;
import mg.cnaps.compta.ComptaCompte;
import mg.cnaps.compta.ComptaSousEcriture;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

@WebServlet(name = "ExportExcel", urlPatterns = {"/ExportExcel"})
public class ExportExcel extends HttpServlet {

  

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, Exception, IOException, JRException {
        String action = request.getParameter("action");
         if(action.equalsIgnoreCase("vente_liste")){
            vente_liste(request, response);
         }
        if(action.equalsIgnoreCase("grand_livre")){
            grand_livre(request, response);
        }
        if(action.equalsIgnoreCase("etat_stock")){
            etat_stock(request, response);
        }
        if(action.equalsIgnoreCase("rapprochement")){
            rapprochement(request, response);
        }
        if(action.equalsIgnoreCase("RELEVE_CLIENT")){
            releve_client(request, response);
        }   
      
    }

    private void releve_client(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception {
        try {
            
        
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
    
        // Récupération des paramètres
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

        String[] libEntete = {"DATE", "REFERENCE", "LIBELLE", "DEBIT", "CREDIT"};

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Relevé Client");
    

        CellStyle headerStyle = workbook.createCellStyle();
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        headerStyle.setFont(boldFont);
        headerStyle.setBorderTop(CellStyle.BORDER_THIN);
        headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
        headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
        headerStyle.setBorderRight(CellStyle.BORDER_THIN);
    
  
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderTop(CellStyle.BORDER_THIN);
        dataStyle.setBorderBottom(CellStyle.BORDER_THIN);
        dataStyle.setBorderLeft(CellStyle.BORDER_THIN);
        dataStyle.setBorderRight(CellStyle.BORDER_THIN);
    
 
        CellStyle totalStyle = workbook.createCellStyle();
        totalStyle.setFont(boldFont);
        totalStyle.setBorderTop(CellStyle.BORDER_THIN);
        totalStyle.setBorderBottom(CellStyle.BORDER_THIN);
        totalStyle.setBorderLeft(CellStyle.BORDER_THIN);
        totalStyle.setBorderRight(CellStyle.BORDER_THIN);
    
        totalStyle.setFillForegroundColor(IndexedColors.BLUE_GREY.getIndex());

        CellStyle titleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short)14);
        titleStyle.setFont(titleFont);
        // Ligne 1: Titre
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("RELEVE CLIENT");
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 4));
        
        // Ligne 2: Client
        Row clientRow = sheet.createRow(1);
        Cell clientCell = clientRow.createCell(0);
        clientCell.setCellValue("CLIENT ID: "+enc_mere[1].getIdclient()+" - "+enc_mere[1].getClientlib());
        clientCell.setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(1, 1, 0, 4));
        
        // Ligne 3: Période
        Row periodRow = sheet.createRow(2);
        Cell periodCell = periodRow.createCell(0);
        periodCell.setCellValue("PERIODE DU "+daty1+" AU "+daty2);
        periodCell.setCellStyle(headerStyle);
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, 4));

        // Ligne 4: Vide
        sheet.createRow(3);

        Row headerRow = sheet.createRow(4);
        for (int i = 0; i < libEntete.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(libEntete[i]);
            cell.setCellStyle(headerStyle);
        }
    
     
        int rowNum = 5;
        for (ReleveClient vente : enc_mere) {
            Row row = sheet.createRow(rowNum++);
    
            Cell c0 = row.createCell(0); c0.setCellValue(vente.getDaty() != null ? new SimpleDateFormat("dd/MM/yyyy").format(vente.getDaty()) : ""); c0.setCellStyle(dataStyle);
            Cell c1 = row.createCell(1); c1.setCellValue(vente.getReference()); c1.setCellStyle(dataStyle);
            Cell c2 = row.createCell(2); c2.setCellValue(vente.getLibelle()); c2.setCellStyle(dataStyle);
            Cell c3 = row.createCell(3); c3.setCellValue(vente.getDebit()); c3.setCellStyle(dataStyle);
            Cell c4 = row.createCell(4); c4.setCellValue(vente.getCredit()); c4.setCellStyle(dataStyle);
        }
    

        double totaldebit =0;
        double totalcredit = 0;

        for (int i = 0; i < enc_mere.length; i++) {
            totaldebit +=  enc_mere[i].getDebit();
            totalcredit += enc_mere[i].getCredit();
        }
    
        // Ligne Total
        Row totalRow = sheet.createRow(rowNum++);
        Cell totalLabelCell = totalRow.createCell(2);
        totalLabelCell.setCellValue("Total Mouvement");
        totalLabelCell.setCellStyle(totalStyle);
    
        Cell totalTTC = totalRow.createCell(3);
        totalTTC.setCellValue(totaldebit);
        totalTTC.setCellStyle(totalStyle);
    
        Cell totalRevient = totalRow.createCell(4);
        totalRevient.setCellValue(totalcredit);
        totalRevient.setCellStyle(totalStyle);

        double solde = totaldebit - totalcredit;

        Row soldeRow = sheet.createRow(rowNum++);
        soldeRow.setHeightInPoints(20);

        Cell soldeLabelCell = soldeRow.createCell(2);

        java.util.Date dateMaxPlusUn = Utilitaire.stringDate(daty2);
        if (dateMaxPlusUn != null) {
            dateMaxPlusUn = new java.util.Date(dateMaxPlusUn.getTime() + (24 * 60 * 60 * 1000));
        }

        if (solde > 0) {
            String dateStr = Utilitaire.datetostring(dateMaxPlusUn);
            soldeLabelCell.setCellValue("SOLDE DEBITEUR " + dateStr);
        } else {
            String dateStr = Utilitaire.datetostring(dateMaxPlusUn);
            soldeLabelCell.setCellValue("SOLDE CREDITEUR " + dateStr);
        }
        soldeLabelCell.setCellStyle(totalStyle);

        Cell soldeValueCell = soldeRow.createCell(3);
        soldeValueCell.setCellValue(Math.abs(solde));
        soldeValueCell.setCellStyle(totalStyle);


        for (int i = 0; i < libEntete.length; i++) {
            sheet.autoSizeColumn(i);
        }

        String fileName = "releve-client.xlsx";
    

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
    

        ServletOutputStream out = response.getOutputStream();
        workbook.write(out);
        workbook.close();
        out.flush();
        out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

  
    private void vente_liste(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception {
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
    
        // Récupération des paramètres
        String id = request.getParameter("id");
        String designation = request.getParameter("designation");
        String idClientLib = request.getParameter("idClientLib");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        String awhere = "";
    
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

        String[] libEntete = {
            "ID", "DESIGNATION", "CLIENT", "DEVISE", "DATE",
            "MONTANT TTC", "MONTANT REVIENT", "MARGE BRUTE",
            "MONTANT PAYE", "MONTANT RESTE", "ETAT"
        };
    

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Ventes");
    

        CellStyle headerStyle = workbook.createCellStyle();
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        headerStyle.setFont(boldFont);
        headerStyle.setBorderTop(CellStyle.BORDER_THIN);
        headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
        headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
        headerStyle.setBorderRight(CellStyle.BORDER_THIN);
    
  
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderTop(CellStyle.BORDER_THIN);
        dataStyle.setBorderBottom(CellStyle.BORDER_THIN);
        dataStyle.setBorderLeft(CellStyle.BORDER_THIN);
        dataStyle.setBorderRight(CellStyle.BORDER_THIN);
    
 
        CellStyle totalStyle = workbook.createCellStyle();
        totalStyle.setFont(boldFont);
        totalStyle.setBorderTop(CellStyle.BORDER_THIN);
        totalStyle.setBorderBottom(CellStyle.BORDER_THIN);
        totalStyle.setBorderLeft(CellStyle.BORDER_THIN);
        totalStyle.setBorderRight(CellStyle.BORDER_THIN);
    
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < libEntete.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(libEntete[i]);
            cell.setCellStyle(headerStyle);
        }
    
     
        int rowNum = 1;
        for (VenteLib vente : enc_mere) {
            Row row = sheet.createRow(rowNum++);
    
            Cell c0 = row.createCell(0); c0.setCellValue(vente.getId()); c0.setCellStyle(dataStyle);
            Cell c1 = row.createCell(1); c1.setCellValue(vente.getDesignation()); c1.setCellStyle(dataStyle);
            Cell c2 = row.createCell(2); c2.setCellValue(vente.getIdClientLib()); c2.setCellStyle(dataStyle);
            Cell c3 = row.createCell(3); c3.setCellValue(vente.getIdDevise()); c3.setCellStyle(dataStyle);
            Cell c4 = row.createCell(4); c4.setCellValue(vente.getDaty() != null ? vente.getDaty().toString() : ""); c4.setCellStyle(dataStyle);
            Cell c5 = row.createCell(5); c5.setCellValue(vente.getMontantttc()); c5.setCellStyle(dataStyle);
            Cell c6 = row.createCell(6); c6.setCellValue(vente.getMontantRevient()); c6.setCellStyle(dataStyle);
            Cell c7 = row.createCell(7); c7.setCellValue(vente.getMargeBrute()); c7.setCellStyle(dataStyle);
            Cell c8 = row.createCell(8); c8.setCellValue(vente.getMontantpaye()); c8.setCellStyle(dataStyle);
            Cell c9 = row.createCell(9); c9.setCellValue(vente.getMontantreste()); c9.setCellStyle(dataStyle);
            Cell c10 = row.createCell(10); c10.setCellValue(vente.getEtatLib()); c10.setCellStyle(dataStyle);
        }
    

        double totalmontantttc = AdminGen.calculSommeDouble(enc_mere, "montantttc");
        double totalmontantRevient = AdminGen.calculSommeDouble(enc_mere, "montantRevient");
        double totalmargeBrute = AdminGen.calculSommeDouble(enc_mere, "margeBrute");
        double totalmontantpaye = AdminGen.calculSommeDouble(enc_mere, "montantpaye");
        double totalmontantreste = AdminGen.calculSommeDouble(enc_mere, "montantreste");
    
        // Ligne Total
        Row totalRow = sheet.createRow(rowNum++);
        Cell totalLabelCell = totalRow.createCell(4);
        totalLabelCell.setCellValue("Total");
        totalLabelCell.setCellStyle(totalStyle);
    
        Cell totalTTC = totalRow.createCell(5);
        totalTTC.setCellValue(totalmontantttc);
        totalTTC.setCellStyle(totalStyle);
    
        Cell totalRevient = totalRow.createCell(6);
        totalRevient.setCellValue(totalmontantRevient);
        totalRevient.setCellStyle(totalStyle);
    
        Cell totalMarge = totalRow.createCell(7);
        totalMarge.setCellValue(totalmargeBrute);
        totalMarge.setCellStyle(totalStyle);
    
        Cell totalPaye = totalRow.createCell(8);
        totalPaye.setCellValue(totalmontantpaye);
        totalPaye.setCellStyle(totalStyle);
    
        Cell totalReste = totalRow.createCell(9);
        totalReste.setCellValue(totalmontantreste);
        totalReste.setCellStyle(totalStyle);
    

        for (int i = 0; i < libEntete.length; i++) {
            sheet.autoSizeColumn(i);
        }
    

        String fileName = "liste_ventes.xlsx";
    

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
    

        ServletOutputStream out = response.getOutputStream();
        workbook.write(out);
        workbook.close();
        out.flush();
        out.close();
    }


    private void grand_livre(HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {

        String date1 = request.getParameter("date1");
        String date2 = request.getParameter("date2");
        String plage1     = request.getParameter("plage1");
        String plage2     = request.getParameter("plage2");
        String typecompte = request.getParameter("typecompte");
        String exercice   = request.getParameter("exercice");
        String etat       = request.getParameter("etat");


        ComptaEtatGrandLivreGenerator grandLivre = new ComptaEtatGrandLivreGenerator();
        if (exercice != null && exercice.matches("\\d+")) {
            grandLivre.setExercice(Integer.parseInt(exercice));
        }
        grandLivre.setTypeCompte(typecompte);
        grandLivre.setDateDebut(date1);
        grandLivre.setDateFin(date2);
        grandLivre.setCompteDebut(plage1);
        grandLivre.setCompteFin(plage2);
        grandLivre.fillComptesWithMouvementAndReport(null);

        String[] libEntete = {
            "Compte", "Id Mvt", "Date", "Jrn/Folio",
            "Contrep.", "Libelle oper.", "Debit", "Credit",
            "Lettre", "Compte analytique/Générale", "Etat"
        };
        final int lastCol = libEntete.length - 1;


        SXSSFWorkbook workbook = new SXSSFWorkbook(100); 
        Sheet sheet = workbook.createSheet("Grand Livre");


        CellStyle headerStyle = workbook.createCellStyle();
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        headerStyle.setFont(boldFont);
        headerStyle.setBorderTop(CellStyle.BORDER_THIN);
        headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
        headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
        headerStyle.setBorderRight(CellStyle.BORDER_THIN);

        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderTop(CellStyle.BORDER_THIN);
        dataStyle.setBorderBottom(CellStyle.BORDER_THIN);
        dataStyle.setBorderLeft(CellStyle.BORDER_THIN);
        dataStyle.setBorderRight(CellStyle.BORDER_THIN);


        CellStyle boldStyle = workbook.createCellStyle();
        boldStyle.cloneStyleFrom(dataStyle);
        Font boldDataFont = workbook.createFont();
        boldDataFont.setBold(true);
        boldStyle.setFont(boldDataFont);


        Row titreRow = sheet.createRow(0);
        Cell titreCell = titreRow.createCell(0);
        titreCell.setCellValue(
            "Grand livre du compte " + (grandLivre.getCompteDebut() == null ? "" : grandLivre.getCompteDebut())
            + " au " + (grandLivre.getCompteFin() == null ? "" : grandLivre.getCompteFin())
            + " | Période: " + (grandLivre.getDateDebut() == null ? "" : grandLivre.getDateDebut())
            + " → " + (grandLivre.getDateFin() == null ? "" : grandLivre.getDateFin())
        );
        titreCell.setCellStyle(headerStyle);
        sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(0, 0, 0, lastCol));


        Row headerRow = sheet.createRow(1);
        for (int i = 0; i < libEntete.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(libEntete[i]);
            cell.setCellStyle(headerStyle);
        }

        int rowNum = 2;

        for (Map.Entry<String, ComptaCompte> entry : grandLivre.getComptes().entrySet()) {
            ComptaCompte cc = entry.getValue();
            java.util.List<ComptaSousEcriture> mouvements = cc.getMouvements();

            if (cc.getReportDebit() != 0 || cc.getReportCredit() != 0
                || (mouvements != null && !mouvements.isEmpty())) {

                // Bandeau COMPTE :
                Row compteRow = sheet.createRow(rowNum++);
                Cell compteCell = compteRow.createCell(0);
                compteCell.setCellValue("COMPTE : " + (cc.getCompte() == null ? "" : cc.getCompte()));
                compteCell.setCellStyle(headerStyle);
                sheet.addMergedRegion(new org.apache.poi.ss.util.CellRangeAddress(rowNum - 1, rowNum - 1, 0, lastCol));


                Row cumulAvantRow = sheet.createRow(rowNum++);

                Cell cumulAvantLabel = cumulAvantRow.createCell(5);
                cumulAvantLabel.setCellValue("ANCIEN CUMUL...");
                cumulAvantLabel.setCellStyle(boldStyle);

                Cell cumulAvantDebit = cumulAvantRow.createCell(6);
                cumulAvantDebit.setCellValue(Utilitaire.formaterAr(cc.getReportDebit()));
                cumulAvantDebit.setCellStyle(boldStyle);
                Cell cumulAvantCredit = cumulAvantRow.createCell(7);
                cumulAvantCredit.setCellValue(Utilitaire.formaterAr(cc.getReportCredit()));
                cumulAvantCredit.setCellStyle(boldStyle);

                for (int c = 0; c <= 4; c++) {
                    Cell empty = cumulAvantRow.createCell(c);
                    empty.setCellStyle(boldStyle);
                }

                for (int c = 8; c <= lastCol; c++) {
                    Cell empty = cumulAvantRow.createCell(c);
                    empty.setCellStyle(boldStyle);
                }


                if (mouvements != null) {
                    for (ComptaSousEcriture mvt : mouvements) {
                        Row row = sheet.createRow(rowNum++);

                        Cell c0 = row.createCell(0); c0.setCellValue(nullSafe(cc.getCompte()));                    c0.setCellStyle(dataStyle);
                        Cell c1 = row.createCell(1); c1.setCellValue(nullSafe(mvt.getIdMere()));                   c1.setCellStyle(dataStyle);
                        Cell c2 = row.createCell(2); c2.setCellValue(Utilitaire.datetostring(mvt.getDaty()));      c2.setCellStyle(dataStyle);
                        Cell c3 = row.createCell(3); c3.setCellValue(nullSafe(mvt.getJournal()) + "/" + nullSafe(mvt.getFolio())); c3.setCellStyle(dataStyle);
                        Cell c4 = row.createCell(4); c4.setCellValue("");                                          c4.setCellStyle(dataStyle); 
                        Cell c5 = row.createCell(5); c5.setCellValue(nullSafe(mvt.getRemarque()));                c5.setCellStyle(dataStyle);
                        Cell c6 = row.createCell(6); c6.setCellValue(Utilitaire.formaterAr(mvt.getDebit()));                             c6.setCellStyle(dataStyle);
                        Cell c7 = row.createCell(7); c7.setCellValue(Utilitaire.formaterAr(mvt.getCredit()));                            c7.setCellStyle(dataStyle);
                        Cell c8 = row.createCell(8); c8.setCellValue(nullSafe(mvt.getLettrage()));                c8.setCellStyle(dataStyle);
                        Cell c9 = row.createCell(9); c9.setCellValue(nullSafe(mvt.getReference_engagement()));    c9.setCellStyle(dataStyle);
                        Cell c10= row.createCell(10);c10.setCellValue(mvt.getEtat());                             c10.setCellStyle(dataStyle);
                    }
                }

                Row totalRow = sheet.createRow(rowNum++);
                for (int c = 0; c <= 4; c++) {
                    Cell empty = totalRow.createCell(c);
                    empty.setCellStyle(boldStyle);
                }
                Cell totalLabel = totalRow.createCell(5);
                totalLabel.setCellValue("TOTAL");
                totalLabel.setCellStyle(boldStyle);

                Cell totalDebit = totalRow.createCell(6);
                totalDebit.setCellValue(Utilitaire.formaterAr(cc.getTotalDebit()));
                totalDebit.setCellStyle(boldStyle);

                Cell totalCredit = totalRow.createCell(7);
                totalCredit.setCellValue(Utilitaire.formaterAr(cc.getTotalCredit()));
                totalCredit.setCellStyle(boldStyle);

                for (int c = 8; c <= lastCol; c++) {
                    Cell empty = totalRow.createCell(c);
                    empty.setCellStyle(boldStyle);
                }


                Row cumulApresRow = sheet.createRow(rowNum++);
                for (int c = 0; c <= 4; c++) {
                    Cell empty = cumulApresRow.createCell(c);
                    empty.setCellStyle(boldStyle);
                }
                Cell cumulLabel = cumulApresRow.createCell(5);
                cumulLabel.setCellValue("CUMUL");
                cumulLabel.setCellStyle(boldStyle);

                Cell cumulDebit = cumulApresRow.createCell(6);
                cumulDebit.setCellValue(Utilitaire.formaterAr(cc.getReportDebit()));
                cumulDebit.setCellStyle(boldStyle);

                Cell cumulCredit = cumulApresRow.createCell(7);
                cumulCredit.setCellValue(Utilitaire.formaterAr(cc.getReportCredit()));
                cumulCredit.setCellStyle(boldStyle);

                for (int c = 8; c <= lastCol; c++) {
                    Cell empty = cumulApresRow.createCell(c);
                    empty.setCellStyle(boldStyle);
                }


                Row soldeRow = sheet.createRow(rowNum++);
                for (int c = 0; c <= 4; c++) {
                    Cell empty = soldeRow.createCell(c);
                    empty.setCellStyle(boldStyle);
                }
                Cell soldeLabel = soldeRow.createCell(5);
                soldeLabel.setCellValue("SOLDE");
                soldeLabel.setCellStyle(boldStyle);

                Cell soldeDebit = soldeRow.createCell(6);
                soldeDebit.setCellValue(Utilitaire.formaterAr(cc.getSoldeDebit()));
                soldeDebit.setCellStyle(boldStyle);

                Cell soldeCredit = soldeRow.createCell(7);
                soldeCredit.setCellValue(Utilitaire.formaterAr(cc.getSoldeCredit()));
                soldeCredit.setCellStyle(boldStyle);

                for (int c = 8; c <= lastCol; c++) {
                    Cell empty = soldeRow.createCell(c);
                    empty.setCellStyle(boldStyle);
                }
            }
        }

        Row totalGeneralRow = sheet.createRow(rowNum++);
        for (int c = 0; c <= 4; c++) {
            Cell empty = totalGeneralRow.createCell(c);
            empty.setCellStyle(boldStyle);
        }
        Cell totalGeneralLabel = totalGeneralRow.createCell(5);
        totalGeneralLabel.setCellValue("TOTAL");
        totalGeneralLabel.setCellStyle(boldStyle);

        Cell totalGeneralCredit = totalGeneralRow.createCell(6);
        totalGeneralCredit.setCellValue(Utilitaire.formaterAr(grandLivre.getTotalCredit()));
        totalGeneralCredit.setCellStyle(boldStyle);

        Cell totalGeneralDebit = totalGeneralRow.createCell(7);
        totalGeneralDebit.setCellValue(Utilitaire.formaterAr(grandLivre.getTotalDebit()));
        totalGeneralDebit.setCellStyle(boldStyle);

        for (int c = 8; c <= lastCol; c++) {
            Cell empty = totalGeneralRow.createCell(c);
            empty.setCellStyle(boldStyle);
        }



        int[] widths = {5000, 4200, 4200, 5200, 3200, 12000, 4200, 4200, 4200, 5200, 3200};
        for (int i = 0; i < libEntete.length; i++) {
            sheet.setColumnWidth(i, widths[i]);
        }


        String fileName = "grand_livre.xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");

        response.setHeader("Content-Disposition",
            "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + encodedFileName);
        
        try (ServletOutputStream out = response.getOutputStream();
            BufferedOutputStream bos = new BufferedOutputStream(out)) {
            workbook.write(bos);
            bos.flush();
        }
        workbook.dispose();
    }


    private void etat_stock(HttpServletRequest request, HttpServletResponse response) throws IOException, JRException, Exception {
        String id = request.getParameter("id");
        String idProduit = request.getParameter("idProduit");
        String idProduitLib = request.getParameter("idProduitLib");
        String idMagasin = request.getParameter("idMagasin");
        String idMagasinLib = request.getParameter("idMagasinLib");
        String idTypeProduitLib = request.getParameter("idTypeProduitLib");
        String daty1 = request.getParameter("daty1");
        String daty2 = request.getParameter("daty2");
        String awhere = "";
        String endawhere = request.getParameter("awhere");

        EtatStockParEntree o = new EtatStockParEntree();
        o.setId(id);
        o.setIdProduit(idProduit);
        o.setIdProduitLib(idProduitLib);
        o.setIdMagasin(idMagasin);
        o.setIdTypeProduitLib(idTypeProduitLib);

        if ((daty1 != null && !daty1.trim().isEmpty()) || (daty2 != null && !daty2.trim().isEmpty())) {
            if (daty1 != null && !daty1.trim().isEmpty()) {
                awhere += " and daty >= to_date('" + daty1 + "', 'dd/mm/yyyy') ";
            }
            if (daty2 != null && !daty2.trim().isEmpty()) {
                awhere += " and daty <= to_date('" + daty2 + "', 'dd/mm/yyyy') ";
            }
        }
        if (endawhere != null && !endawhere.trim().isEmpty()) {
            awhere += " " + endawhere;
        }

        EtatStockParEntree[] enc_mere = (EtatStockParEntree[]) CGenUtil.rechercher(o, null, null, null, awhere);

//        String[] libEntete = {"IDINGREDIENT","PRODUIT", "QTE","QTE EN STOCK", "PU", "EXPLICATION"};
        String[] libEntete = {"idProduit","pu", "quantite","explication"};

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Etat_stock_entree");

        CellStyle headerStyle = workbook.createCellStyle();
        Font boldFont = workbook.createFont();
        boldFont.setBold(true);
        headerStyle.setFont(boldFont);
        headerStyle.setBorderTop(CellStyle.BORDER_THIN);
        headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
        headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
        headerStyle.setBorderRight(CellStyle.BORDER_THIN);

        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderTop(CellStyle.BORDER_THIN);
        dataStyle.setBorderBottom(CellStyle.BORDER_THIN);
        dataStyle.setBorderLeft(CellStyle.BORDER_THIN);
        dataStyle.setBorderRight(CellStyle.BORDER_THIN);

        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < libEntete.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(libEntete[i]);
            cell.setCellStyle(headerStyle);
        }

        int rowNum = 1;
        for (EtatStockParEntree detail : enc_mere) {
            Row row = sheet.createRow(rowNum++);
//            Cell c0 = row.createCell(0); c0.setCellValue(detail.getIdProduit()); c0.setCellStyle(dataStyle);
//            Cell c1 = row.createCell(1); c1.setCellValue(detail.getIdProduitLib()); c0.setCellStyle(dataStyle);
//            Cell c2 = row.createCell(2); c2.setCellValue(0); c2.setCellStyle(dataStyle);
//            Cell c3 = row.createCell(3); c3.setCellValue(detail.getQuantite()); c3.setCellStyle(dataStyle);
//            Cell c4 = row.createCell(4); c4.setCellValue(detail.getPu()); c4.setCellStyle(dataStyle);
//            Cell c5 = row.createCell(5); c5.setCellValue(""); c5.setCellStyle(dataStyle);
            Cell c0 = row.createCell(0); c0.setCellValue(detail.getIdProduit()); c0.setCellStyle(dataStyle);
            Cell c1 = row.createCell(1); c1.setCellValue(detail.getPu()); c1.setCellStyle(dataStyle);
            Cell c2 = row.createCell(2); c2.setCellValue(detail.getQuantite()); c2.setCellStyle(dataStyle);
            Cell c3 = row.createCell(3); c3.setCellValue(detail.getIdProduitLib()); c3.setCellStyle(dataStyle);
        }

        for (int i = 0; i < libEntete.length; i++) {
            sheet.autoSizeColumn(i);
        }
        String fileName = "etat_stock_entree_"+idMagasinLib+".xls";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        ServletOutputStream out = response.getOutputStream();
        workbook.write(out);
        workbook.close();
        out.flush();
        out.close();
    }

    private void applyRowStyle(Row row, int nbCol, CellStyle style) {
        for (int i = 0; i <= nbCol; i++) {
            Cell cell = row.getCell(i);
            if (cell == null) {
                cell = row.createCell(i);
            }
            cell.setCellStyle(style);
        }
    }

    private void rapprochement(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Connection c = new UtilDB().GetConn();
        String idCaisseBanque = request.getParameter("idCaisseBanque");
        String dateMin = request.getParameter("dateMin");
        String dateMax = request.getParameter("dateMax");

        Caisse caisse = (Caisse) new Caisse().getById(idCaisseBanque,"",c);

        TypeObjet compte = (TypeObjet) new TypeObjet().getById(idCaisseBanque,"BANQUE_COMPTA",c);
        String awhereSE = "";
        String awhereRE = "";
        if ((dateMin != null && !dateMin.trim().isEmpty()) || (dateMax != null && !dateMax.trim().isEmpty())) {
            if (dateMin != null && !dateMin.trim().isEmpty()) {
                awhereSE += " and daty >= to_date('" + dateMin + "', 'dd/mm/yyyy') ";
                awhereRE += " and datyvaleur >= to_date('" + dateMin + "', 'dd/mm/yyyy') ";
            }
            if (dateMax != null && !dateMax.trim().isEmpty()) {
                awhereSE += " and daty <= to_date('" + dateMax + "', 'dd/mm/yyyy') ";
                awhereRE += " and datyvaleur <= to_date('" + dateMax + "', 'dd/mm/yyyy') ";
            }
        }

        ComptaSousEcriture se = new ComptaSousEcriture();
        se.setNomTable("SOUSECRITURENRMVT");
        se.setCompte(compte.getDesce());
        ComptaSousEcriture[] sousEcritures = (ComptaSousEcriture[])CGenUtil.rechercher(se,null,null,c,awhereSE);

        ReleverDetailCpl re = new ReleverDetailCpl();
        re.setNomTable("RELEVERDETAILNRMVT");
        re.setCompte(compte.getDesce());
        ReleverDetailCpl[] releverDetailCpls = (ReleverDetailCpl[])CGenUtil.rechercher(re,null,null,c,awhereRE);


        boolean maxIsSousEcritures = true;
        int dataLength = sousEcritures.length;
        if (releverDetailCpls.length > sousEcritures.length) {
            maxIsSousEcritures = false;
            dataLength = releverDetailCpls.length;
        }

        ComptaSousEcriture seDecl = new ComptaSousEcriture();
        seDecl.setNomTable("SOUSECRITURERMVT");
        seDecl.setCompte(compte.getDesce());
        ComptaSousEcriture[] sousEcrituresDecl = (ComptaSousEcriture[])CGenUtil.rechercher(seDecl,null,null,c,awhereSE);

        ReleverDetailCpl reDecl = new ReleverDetailCpl();
        reDecl.setNomTable("RELEVERDETAILRMVT");
        reDecl.setCompte(compte.getDesce());
        ReleverDetailCpl[] releverDetailCplsDecl = (ReleverDetailCpl[])CGenUtil.rechercher(reDecl,null,null,c,awhereRE);

        double sommeDebitEcriture = AdminGen.calculSommeDouble(sousEcrituresDecl,"debit");
        double sommeCreditEcriture = AdminGen.calculSommeDouble(sousEcrituresDecl,"credit");
        double sommeDebitRelever = AdminGen.calculSommeDouble(releverDetailCplsDecl,"debit");
        double sommeCreditRelever = AdminGen.calculSommeDouble(releverDetailCplsDecl,"credit");

        String[] libEntete = {"DATE","D&Eacute;BIT", "LIBELL&Eacute;","CR&Eacute;DIT","D&Eacute;BIT","LIBELL&Eacute;", "CR&Eacute;DIT","DATE"};
        Workbook workbook = new XSSFWorkbook();

        Sheet sheet = workbook.createSheet("etat-rapprochement");
        CellStyle titleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleFont.setFontHeightInPoints((short)10);
        titleStyle.setFont(titleFont);

        // centrage et bordures
        titleStyle.setAlignment(CellStyle.ALIGN_CENTER);
        titleStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        titleStyle.setBorderTop(CellStyle.BORDER_THIN);
        titleStyle.setBorderBottom(CellStyle.BORDER_THIN);
        titleStyle.setBorderLeft(CellStyle.BORDER_THIN);
        titleStyle.setBorderRight(CellStyle.BORDER_THIN);

        // --- Ligne principale fusionnée ---
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        String titre = "RAPPROCHEMENT BANCAIRE "+caisse.getVal()+" DU "+dateMin+" AU "+dateMax;
        titleCell.setCellValue(titre);
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 1, 0, 7)); // fusion sur 2 lignes et 8 colonnes

        sheet.createRow(1); // ligne vide, nécessaire pour la fusion
        // --- Ligne des sous-titres ---
        Row petitTitreRow = sheet.createRow(2);
        Cell titleLeft = petitTitreRow.createCell(0);
        Cell titleRight = petitTitreRow.createCell(4);

        titleLeft.setCellValue(caisse.getVal()+" TENU PAR LA SOCOBIS");
        titleLeft.setCellStyle(titleStyle);
        titleRight.setCellValue("SOCOBIS TENU PAR LA "+caisse.getVal());
        titleRight.setCellStyle(titleStyle);

        // fusion des colonnes pour chaque titre
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, 3));
        sheet.addMergedRegion(new CellRangeAddress(2, 2, 4, 7));

        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderTop(CellStyle.BORDER_THIN);
        dataStyle.setBorderBottom(CellStyle.BORDER_THIN);
        dataStyle.setBorderLeft(CellStyle.BORDER_THIN);
        dataStyle.setBorderRight(CellStyle.BORDER_THIN);

        DataFormat format = workbook.createDataFormat();
        CellStyle amountStyle = workbook.createCellStyle();
        amountStyle.cloneStyleFrom(dataStyle);
        amountStyle.setDataFormat(format.getFormat("#,##0.00"));

        Row headerRow = sheet.createRow(3);
        for (int i = 0; i < libEntete.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(StringEscapeUtils.unescapeHtml4(libEntete[i]));
            cell.setCellStyle(dataStyle);
        }
        int rowNum = 4;
        Row row3 = sheet.createRow(rowNum++);
        Cell cHead0 = row3.createCell(0);
        Cell cHead1 = row3.createCell(1); cHead1.setCellValue(sommeDebitEcriture);
        Cell cHead2 = row3.createCell(2); cHead2.setCellValue("SOLDE");
        Cell cHead3 = row3.createCell(3); cHead3.setCellValue(sommeCreditEcriture);
        Cell cHead4 = row3.createCell(4); cHead4.setCellValue(sommeDebitRelever);
        Cell cHead5 = row3.createCell(5); cHead5.setCellValue("SOLDE");
        Cell cHead6 = row3.createCell(6); cHead6.setCellValue(sommeCreditRelever);
        Cell cHead7 = row3.createCell(7);
        this.applyRowStyle(row3,7,dataStyle);
        Row row4 = sheet.createRow(rowNum++);
        this.applyRowStyle(row4,7,dataStyle);

        for (int i = 0; i < dataLength; i++) {
            Row row = sheet.createRow(rowNum++);
            if (maxIsSousEcritures) {
                Cell c0 = row.createCell(0); c0.setCellValue(sousEcritures[i].getDaty().toString());
                Cell c1 = row.createCell(1); c1.setCellValue(sousEcritures[i].getDebit());
                Cell c2 = row.createCell(2); c2.setCellValue(sousEcritures[i].getLibellePiece());
                Cell c3 = row.createCell(3); c3.setCellValue(sousEcritures[i].getCredit());
                if (i < releverDetailCpls.length) {
                    Cell c4 = row.createCell(4); c4.setCellValue(releverDetailCpls[i].getDebit());
                    Cell c5 = row.createCell(5); c5.setCellValue(releverDetailCpls[i].getDesignation());
                    Cell c6 = row.createCell(6); c6.setCellValue(releverDetailCpls[i].getCredit());
                    Cell c7 = row.createCell(7); c7.setCellValue(releverDetailCpls[i].getDatyvaleur().toString());
                }
            } else {
                if (i < sousEcritures.length) {
                    Cell c0 = row.createCell(0); c0.setCellValue(sousEcritures[i].getDaty().toString());
                    Cell c1 = row.createCell(1); c1.setCellValue(sousEcritures[i].getDebit());
                    Cell c2 = row.createCell(2); c2.setCellValue(sousEcritures[i].getLibellePiece());
                    Cell c3 = row.createCell(3); c3.setCellValue(sousEcritures[i].getCredit());
                }
                Cell c4 = row.createCell(4); c4.setCellValue(releverDetailCpls[i].getDebit());
                Cell c5 = row.createCell(5); c5.setCellValue(releverDetailCpls[i].getDesignation());
                Cell c6 = row.createCell(6); c6.setCellValue(releverDetailCpls[i].getCredit());
                Cell c7 = row.createCell(7); c7.setCellValue(releverDetailCpls[i].getDatyvaleur().toString());
            }
            this.applyRowStyle(row,7,dataStyle);
        }
        // ---- LIGNE TOTAL ----
        Row totalRow = sheet.createRow(rowNum++);int first = 5;  // première ligne de données (index 0)
        int last = rowNum - 2; // dernière ligne de données (car on vient de créer totalRow)

        // convertir en numéros Excel ( +1 )
        int excelFirst = first + 1;
        int excelLast = last + 1;

        Cell totalEcritures = totalRow.createCell(2);        // Libellé TOTAL
        totalEcritures.setCellValue("TOTAL");
        Cell totalDebitEcriture = totalRow.createCell(1);        // Débit écriture (col B)
        totalDebitEcriture.setCellFormula("SUM(B" + excelFirst + ":B" + excelLast + ")");
        Cell totalCreditEcriture = totalRow.createCell(3);        // Crédit écriture (col D)
        totalCreditEcriture.setCellFormula("SUM(D" + excelFirst + ":D" + excelLast + ")");
        Cell totalDebitReleve = totalRow.createCell(4);         // Débit relevé (col E)
        totalDebitReleve.setCellFormula("SUM(E" + excelFirst + ":E" + excelLast + ")");
        Cell totalRelever = totalRow.createCell(5);        // Libellé TOTAL
        totalRelever.setCellValue("TOTAL");
        Cell totalCreditReleve = totalRow.createCell(6);         // Crédit relevé (col G)
        totalCreditReleve.setCellFormula("SUM(G" + excelFirst + ":G" + excelLast + ")");
        this.applyRowStyle(totalRow,7,dataStyle);

        Row lastRowVide = sheet.createRow(rowNum++);
        this.applyRowStyle(lastRowVide,7,dataStyle);

        int totalExcelRow = totalRow.getRowNum() + 1;

        Row totalSoldeRow = sheet.createRow(rowNum++);
        Cell soldeCrediteurLabel = totalSoldeRow.createCell(2);
        soldeCrediteurLabel.setCellValue(StringEscapeUtils.unescapeHtml4("SOLDE CR&Eacute;DITEUR"));

        Cell soldeCrediteurCell = totalSoldeRow.createCell(3);
        soldeCrediteurCell.setCellFormula("D" + totalExcelRow + "-B" + totalExcelRow);
        soldeCrediteurCell.setCellStyle(amountStyle);

        Cell soldeDebiteurCell = totalSoldeRow.createCell(4);
        soldeDebiteurCell.setCellFormula("E" + totalExcelRow + "-G" + totalExcelRow);
        soldeDebiteurCell.setCellStyle(amountStyle);

        Cell soldeDebiteurLabel = totalSoldeRow.createCell(5);
        soldeDebiteurLabel.setCellValue(StringEscapeUtils.unescapeHtml4("SOLDE D&Eacute;BITEUR"));

        this.applyRowStyle(totalSoldeRow,7,dataStyle);
        for (int i = 0; i < libEntete.length; i++) {
            sheet.autoSizeColumn(i);
        }

        for (int i = 0; i < libEntete.length; i++) {
            int currentWidth = sheet.getColumnWidth(i);
            sheet.setColumnWidth(i, currentWidth + 3000);
        }

        String fileName = "etat-rapprochement"+idCaisseBanque+".xls";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        ServletOutputStream out = response.getOutputStream();
        FormulaEvaluator evaluator = workbook.getCreationHelper().createFormulaEvaluator();
        evaluator.evaluateAll();
        workbook.write(out);
        workbook.close();
        out.flush();
        out.close();
    }

    private String nullSafe(Object o) {
        return (o == null) ? "" : String.valueOf(o);
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
            Logger.getLogger(ExportExcel.class.getName()).log(Level.SEVERE, null, ex);
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
            Logger.getLogger(ExportExcel.class.getName()).log(Level.SEVERE, null, ex);
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
    }
   
   
     


    
   
}
