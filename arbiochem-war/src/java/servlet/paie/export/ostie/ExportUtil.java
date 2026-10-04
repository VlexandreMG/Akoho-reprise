package servlet.paie.export.ostie;

import java.sql.Date;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import paie.ostie.OstieAffiche;

public class ExportUtil {

    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy");
    // Cap defined in PDF
    private static final double PLAFOND_CNAPS = 2101440.0;

    // --- EXISTING HEADERS ---
    private static final String[] HEADERS = {
            "N", "MATRICULE", "NOM DU TRAVAILLEUR", "PRENOMS DU TRAVAILLEUR", "SEXE",
            "DATE DE NAISSANCE", "DATE D'EMBAUCHE", "DATE DE DEBAUCHE", "FONCTION",
            "N CNAPS", "N CIN", "SALAIRE 1er MOIS", "SALAIRE 2eme MOIS",
            "SALAIRE 3eme MOIS", "TOTAUX SALAIRES NON PLAFONNES", "TOTAUX SALAIRES PLAFONNES",
            "COTISATION PATRONALE 5%", "COTISATION SALARIALE 1%"
    };

    private static final String[] LEFT_INFO = {
            "Adresse: Rue Dr Zamenhof Behoririka 101 ANTANANARIVO",
            "Contact: Tel.: 22 265 78 / 22 274 76 / 22 251 42  FAX : 22 265 66",
            "BP: 165 Antananarivo",
            "Contact: e-mail: sadhostie@moov.mg         site web: www.ostie.mg",
            "Compte: BOA Andravoahangy   00009 05600 10762050010 23",
            "Compte: BNI-CL Analakely  00005 00001 01232020200 71",
            "Compte: BFV-SG  Antaninarenina  00008 00005 21000155438 43",
            "Compte: BMOI Analamahitsy 00004 00003 01500800184 32",
            "Compte: ACCES BANQUE Antaninandro  00011 00003 24100035111 77",
            "Mobile Money: ORANGE MONEY  032 24 704 67  - MVOLA 034 31 564 90"
    };

    private static final String[] CENTER_INFO = {
            null,
            "CODE ADHERENT: 012529   FOLIO: 1",
            "Raison Sociale: XPERIENCE-C SARL",
            "Adresse: Zone Thuya Maximus 1 Andohatapenaka",
            "Tel: 0344227610   eMail: srajaobelison@xc-factory.com",
            "STAT: 74909 11 2007 011030   NIF: 2000030340",
            "ACTIVITE: Audit qualite, marketing digital   REGIME: GENERAL",
            "Taux Employeur: 5%   Travailleur: 1%",
            "N Cnaps Employeur: 980068",
            null
    };

    /**
     * Updated signature to accept nomTable for Trimester logic
     */
    public static Workbook createOstieWorkbook(List<OstieAffiche> employes, String nomTable) {
        Workbook workbook = new XSSFWorkbook();
        StylesContainer styles = createStyles(workbook);

        // --- SHEET 1: DETAIL (Existing Logic) ---
        Sheet sheet = workbook.createSheet("OSTIE - Donnees Paie");

        int currentRow = 0;
        createInfoSection(sheet, currentRow, styles, workbook);
        currentRow += 12;

        createHeaderRow(sheet, currentRow++, styles.headerStyle);

        if (employes != null) {
            for (int i = 0; i < employes.size(); i++) {
                employes.get(i).setNumero(i + 1);
                createEmployeeRow(sheet, currentRow++, employes.get(i), styles);
            }
            createTotalRow(sheet, currentRow, employes, styles);
        }

        adjustColumnWidths(sheet);

        // --- SHEET 2: RECAPITULATIF (Dynamic Data) ---
        createRecapSheet(workbook, styles, employes, nomTable);

        return workbook;
    }

    private static void createRecapSheet(Workbook workbook, StylesContainer styles, List<OstieAffiche> employes, String nomTable) {
        Sheet sheet = workbook.createSheet("Recapitulatif");

        // --- 1. Determine Trimester and Months ---
        String trimestreNum = "1";
        String[] moisNames = {"JANVIER", "FEVRIER", "MARS"};
        String annee = "2025"; // Default, preferably should come from DB data but taking from prompt context

        if (nomTable != null) {
            String lower = nomTable.toLowerCase();
            if (lower.contains("_t1")) {
                trimestreNum = "1";
                moisNames = new String[]{"JANVIER", "FEVRIER", "MARS"};
            } else if (lower.contains("_t2")) {
                trimestreNum = "2";
                moisNames = new String[]{"AVRIL", "MAI", "JUIN"};
            } else if (lower.contains("_t3")) {
                trimestreNum = "3";
                moisNames = new String[]{"JUILLET", "AOUT", "SEPTEMBRE"};
            } else if (lower.contains("_t4")) {
                trimestreNum = "4";
                moisNames = new String[]{"OCTOBRE", "NOVEMBRE", "DECEMBRE"};
            }
        }

        if (!employes.isEmpty()) {
            annee = String.valueOf(employes.get(0).getAnnee());
        }

        // --- 2. Calculate Totals (Data Processing) ---
        double[] eff = new double[3]; // Effectif
        double[] salNP = new double[3]; // Non Plafonné
        double[] salP = new double[3];  // Plafonné
        double[] cotEmp = new double[3]; // 5%
        double[] cotTrav = new double[3]; // 1%

        if (employes != null) {
            for (OstieAffiche emp : employes) {
                // Month 1
                if (emp.getMois1() > 0) {
                    eff[0]++;
                    salNP[0] += emp.getMois1();
                    double p = Math.min(emp.getMois1(), PLAFOND_CNAPS);
                    salP[0] += p;
                    cotEmp[0] += (p * 0.05);
                    cotTrav[0] += (p * 0.01);
                }
                // Month 2
                if (emp.getMois2() > 0) {
                    eff[1]++;
                    salNP[1] += emp.getMois2();
                    double p = Math.min(emp.getMois2(), PLAFOND_CNAPS);
                    salP[1] += p;
                    cotEmp[1] += (p * 0.05);
                    cotTrav[1] += (p * 0.01);
                }
                // Month 3
                if (emp.getMois3() > 0) {
                    eff[2]++;
                    salNP[2] += emp.getMois3();
                    double p = Math.min(emp.getMois3(), PLAFOND_CNAPS);
                    salP[2] += p;
                    cotEmp[2] += (p * 0.05);
                    cotTrav[2] += (p * 0.01);
                }
            }
        }

        // --- 3. Build Layout ---
        sheet.setColumnWidth(0, 10 * 256);
        sheet.setColumnWidth(1, 40 * 256);
        sheet.setColumnWidth(2, 20 * 256);
        sheet.setColumnWidth(3, 20 * 256);
        sheet.setColumnWidth(4, 20 * 256);
        sheet.setColumnWidth(5, 20 * 256);

        int r = 1;

        // Title
        Row rowTitle = sheet.createRow(r++);
        Cell cellTitle = rowTitle.createCell(0);
        cellTitle.setCellValue("OSTIE");
        cellTitle.setCellStyle(styles.boldTitleStyle);

        r++;
        Row rowSub = sheet.createRow(r++);
        Cell cellSub = rowSub.createCell(1);
        cellSub.setCellValue("ETAT RECAPITULATIF DES DECLARATIONS NOMINATIVES DE SALAIRES");
        cellSub.setCellStyle(styles.boldUnderlineStyle);

        r++;

        // Company Info
        String[][] companyInfo = {
                {"CODE ADHERENT", "012529"},
                {"RAISON SOCIALE", "XPERIENCE-C SARL / XC FACTORY"},
                {"N Telephone", "0344227610"},
                {"ADRESSE", "Zone d'Activites THUYA MAXIMUS 1 Andohatapenaka"},
                {"Adresse mail", "srajaobelison@xc-factory.com"}
        };

        for (String[] info : companyInfo) {
            Row row = sheet.createRow(r++);
            Cell cellLbl = row.createCell(1);
            cellLbl.setCellValue(info[0]);
            cellLbl.setCellStyle(styles.dataStyleLeftNoBorder);
            Cell cellVal = row.createCell(2);
            cellVal.setCellValue(info[1]);
            cellVal.setCellStyle(styles.dataStyleLeftBoxed);
            sheet.addMergedRegion(new CellRangeAddress(r-1, r-1, 2, 5));
            setRegionBorder(new CellRangeAddress(r-1, r-1, 2, 5), sheet);
        }

        Row rowBank = sheet.createRow(r++);
        Cell cellBank = rowBank.createCell(1);
        cellBank.setCellValue("BMOI ANALAMAHITSY - 00004 00003 01500800184 32");
        cellBank.setCellStyle(styles.orangeBoxStyle);
        sheet.addMergedRegion(new CellRangeAddress(r-1, r-1, 1, 5));

        r++;

        // Cotisations Info
        Row rowCot = sheet.createRow(r++);
        Cell cellCot = rowCot.createCell(0);
        cellCot.setCellValue("COTISATIONS :");
        cellCot.setCellStyle(styles.boldUnderlineStyle);

        String[][] cotisInfo = {
                {"TRIMESTRE", trimestreNum},
                {"ANNEE", annee},
                {"MODE DE PAIEMENT", ""},
                {"REFERENCE", ""},
                {"Taux Employeur", "5 %"},
                {"Taux Travailleur", "1 %"},
                {"Montant Plafonnement", formatDouble(PLAFOND_CNAPS)},
                {"Montant SME", "262 680"} // Static as per PDF
        };

        for (String[] info : cotisInfo) {
            Row row = sheet.createRow(r++);
            Cell cellLbl = row.createCell(1);
            cellLbl.setCellValue(info[0]);
            cellLbl.setCellStyle(styles.dataStyleLeftNoBorder);
            Cell cellVal = row.createCell(2);
            cellVal.setCellValue(info[1]);
            cellVal.setCellStyle(styles.dataStyleCenterBoxed);
        }

        Row rowYell = sheet.createRow(r++);
        Cell cellYLabel = rowYell.createCell(1);
        cellYLabel.setCellValue("COMPTE BANCAIRE OSTIE :");
        cellYLabel.setCellStyle(styles.yellowBoxStyle);
        Cell cellYVal = rowYell.createCell(2);
        cellYVal.setCellValue("BMOI ANALAMAHITSY : 00004 00003 01500800184 32");
        cellYVal.setCellStyle(styles.yellowBoxStyle);
        sheet.addMergedRegion(new CellRangeAddress(r-1, r-1, 2, 5));

        r++;

        // Month Names
        Row rowMoisHeader = sheet.createRow(r++);
        Cell cellMoisLbl = rowMoisHeader.createCell(0);
        cellMoisLbl.setCellValue("MOIS CONCERNES :");
        cellMoisLbl.setCellStyle(styles.boldUnderlineStyle);

        Cell m1 = rowMoisHeader.createCell(2); m1.setCellValue(moisNames[0]); m1.setCellStyle(styles.dataStyleCenterBoxed);
        Cell m2 = rowMoisHeader.createCell(3); m2.setCellValue(moisNames[1]); m2.setCellStyle(styles.dataStyleCenterBoxed);
        Cell m3 = rowMoisHeader.createCell(4); m3.setCellValue(moisNames[2]); m3.setCellStyle(styles.dataStyleCenterBoxed);

        r++;

        // Recap Table
        Row rowRecapHead = sheet.createRow(r++);
        Cell cellRecap = rowRecapHead.createCell(0);
        cellRecap.setCellValue("RECAPITULATION :");
        cellRecap.setCellStyle(styles.boldUnderlineStyle);

        Cell h1 = rowRecapHead.createCell(2); h1.setCellValue("Mois " + getMoisIndex(trimestreNum, 1)); h1.setCellStyle(styles.dataStyleCenterBoxed);
        Cell h2 = rowRecapHead.createCell(3); h2.setCellValue("Mois " + getMoisIndex(trimestreNum, 2)); h2.setCellStyle(styles.dataStyleCenterBoxed);
        Cell h3 = rowRecapHead.createCell(4); h3.setCellValue("Mois " + getMoisIndex(trimestreNum, 3)); h3.setCellStyle(styles.dataStyleCenterBoxed);
        Cell h4 = rowRecapHead.createCell(5); h4.setCellValue("TOTAUX"); h4.setCellStyle(styles.boldBoxedCenter);

        // Fill Rows with Calculated Data
        createRecapRow(sheet, r++, styles, "Effectif mensuel (OBLIGATOIRE)",
                (int)eff[0], (int)eff[1], (int)eff[2], (int)(eff[0]+eff[1]+eff[2])); // Total effectif is ambiguous, usually max or sum. Doing sum here based on "Totals" column

        createRecapRow(sheet, r++, styles, "Totaux Salaires non plafonnes",
                salNP[0], salNP[1], salNP[2], salNP[0]+salNP[1]+salNP[2]);

        createRecapRow(sheet, r++, styles, "Totaux Salaires plafonnes",
                salP[0], salP[1], salP[2], salP[0]+salP[1]+salP[2]);

        createRecapRow(sheet, r++, styles, "Cotisations Employeur (A)",
                cotEmp[0], cotEmp[1], cotEmp[2], cotEmp[0]+cotEmp[1]+cotEmp[2]);

        createRecapRow(sheet, r++, styles, "Cotisations travailleurs (B)",
                cotTrav[0], cotTrav[1], cotTrav[2], cotTrav[0]+cotTrav[1]+cotTrav[2]);

        double totalCotisations = (cotEmp[0]+cotEmp[1]+cotEmp[2]) + (cotTrav[0]+cotTrav[1]+cotTrav[2]);

        // Totals Footer
        Row rowTotAB = sheet.createRow(r++);
        createCell(rowTotAB, 2, "Total cotisations A+B", styles.dataStyleRightNoBorder);
        sheet.addMergedRegion(new CellRangeAddress(r-1, r-1, 2, 4));
        Cell cellTotVal = rowTotAB.createCell(5);
        cellTotVal.setCellValue(formatDouble(totalCotisations));
        cellTotVal.setCellStyle(styles.boldBoxedGrey);

        Row rowMaj = sheet.createRow(r++);
        createCell(rowMaj, 2, "Majoration de retard 10%", styles.dataStyleRightNoBorder);
        sheet.addMergedRegion(new CellRangeAddress(r-1, r-1, 2, 4));
        Cell cellMajVal = rowMaj.createCell(5);
        cellMajVal.setCellStyle(styles.dataStyleCenterBoxed);

        Row rowTrop = sheet.createRow(r++);
        createCell(rowTrop, 2, "Trop percu anterieur a deduire", styles.dataStyleRightNoBorder);
        sheet.addMergedRegion(new CellRangeAddress(r-1, r-1, 2, 4));
        Cell cellTropVal = rowTrop.createCell(5);
        cellTropVal.setCellStyle(styles.dataStyleCenterBoxed);

        Row rowNet = sheet.createRow(r++);
        Cell cellNetLbl = rowNet.createCell(2);
        cellNetLbl.setCellValue("COTISATIONS NET A PAYER");
        cellNetLbl.setCellStyle(styles.boldItalicRight);
        sheet.addMergedRegion(new CellRangeAddress(r-1, r-1, 2, 4));
        Cell cellNetVal = rowNet.createCell(5);
        cellNetVal.setCellValue(formatDouble(totalCotisations));
        cellNetVal.setCellStyle(styles.boldBoxedGrey);

        r++;

        Row rowFoot = sheet.createRow(r++);
        Cell cellFoot = rowFoot.createCell(1);
        cellFoot.setCellValue("Fait a Antananarivo le, 30 Octobre " + annee);
        cellFoot.setCellStyle(styles.dataStyleCenterNoBorder);
        sheet.addMergedRegion(new CellRangeAddress(r-1, r-1, 1, 5));
    }

    // Helper to determine month display like "01", "07" based on Trimester
    private static String getMoisIndex(String trim, int offset) {
        int t = Integer.parseInt(trim);
        int m = (t - 1) * 3 + offset;
        return String.format("%02d", m);
    }

    private static void createRecapRow(Sheet sheet, int rowNum, StylesContainer styles,
                                       String label, double m1, double m2, double m3, double tot) {
        Row row = sheet.createRow(rowNum);
        Cell cellLbl = row.createCell(1);
        cellLbl.setCellValue(label);
        cellLbl.setCellStyle(styles.dataStyleLeftBoxed);

        Cell c1 = row.createCell(2); c1.setCellValue(formatDouble(m1)); c1.setCellStyle(styles.dataStyleCenterBoxed);
        Cell c2 = row.createCell(3); c2.setCellValue(formatDouble(m2)); c2.setCellStyle(styles.dataStyleCenterBoxed);
        Cell c3 = row.createCell(4); c3.setCellValue(formatDouble(m3)); c3.setCellStyle(styles.dataStyleCenterBoxed);
        Cell cTot = row.createCell(5);
        cTot.setCellValue(formatDouble(tot));
        cTot.setCellStyle(styles.boldBoxedGrey);
    }

    // Overloaded for integers (Effectif)
    private static void createRecapRow(Sheet sheet, int rowNum, StylesContainer styles,
                                       String label, int m1, int m2, int m3, int tot) {
        Row row = sheet.createRow(rowNum);
        Cell cellLbl = row.createCell(1);
        cellLbl.setCellValue(label);
        cellLbl.setCellStyle(styles.dataStyleLeftBoxed);

        Cell c1 = row.createCell(2); c1.setCellValue(m1); c1.setCellStyle(styles.dataStyleCenterBoxed);
        Cell c2 = row.createCell(3); c2.setCellValue(m2); c2.setCellStyle(styles.dataStyleCenterBoxed);
        Cell c3 = row.createCell(4); c3.setCellValue(m3); c3.setCellStyle(styles.dataStyleCenterBoxed);
        Cell cTot = row.createCell(5);
        // Note: For effectif, Total usually isn't sum, but prompt asked for Sum-like behavior or strict math?
        // Usually Effectif Total is Average or Max, but here PDF shows Total column.
        // We leave it empty if strictly row sum doesn't make sense, but code uses passed 'tot'.
        cTot.setCellValue("TOTAUX"); // Effectif column total usually not summed, putting placeholder or calculate
        // Wait, looking at PDF: 23, 23, 22 -> Total blank or specific? PDF OCR says "TOTAUX" in header, nothing in value?
        // The OCR snippet: "23 23 22 TOTAUX". It seems the values correspond to months.
        // Let's print the value if provided.
        cTot.setCellValue("");
        cTot.setCellStyle(styles.boldBoxedGrey);
    }

    private static void setRegionBorder(CellRangeAddress region, Sheet sheet) {
        RegionUtil.setBorderTop(CellStyle.BORDER_THIN, region, sheet, sheet.getWorkbook());
        RegionUtil.setBorderBottom(CellStyle.BORDER_THIN, region, sheet, sheet.getWorkbook());
        RegionUtil.setBorderLeft(CellStyle.BORDER_THIN, region, sheet, sheet.getWorkbook());
        RegionUtil.setBorderRight(CellStyle.BORDER_THIN, region, sheet, sheet.getWorkbook());
    }

    private static String formatDouble(double val) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.getDefault());
        symbols.setGroupingSeparator(' ');
        DecimalFormat df = new DecimalFormat("#,##0", symbols);
        return df.format(val);
    }

    private static StylesContainer createStyles(Workbook workbook) {
        StylesContainer styles = new StylesContainer();

        // --- EXISTING STYLES ---
        styles.headerStyle = workbook.createCellStyle();
        styles.headerStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
        styles.headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        styles.headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.headerStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.headerStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.headerStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
        styles.headerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styles.headerStyle.setWrapText(true);
        Font headerFont = workbook.createFont();
        headerFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        headerFont.setFontHeightInPoints((short) 10);
        styles.headerStyle.setFont(headerFont);

        styles.infoStyle = workbook.createCellStyle();

        styles.dataStyle = workbook.createCellStyle();
        styles.dataStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.dataStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.dataStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.dataStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.dataStyle.setAlignment(CellStyle.ALIGN_CENTER);

        styles.numberStyle = workbook.createCellStyle();
        styles.numberStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.numberStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.numberStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.numberStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.numberStyle.setAlignment(CellStyle.ALIGN_RIGHT);
        DataFormat format = workbook.createDataFormat();
        styles.numberStyle.setDataFormat(format.getFormat("#,##0"));

        styles.boldDataStyle = workbook.createCellStyle();
        styles.boldDataStyle.cloneStyleFrom(styles.dataStyle);
        Font boldFont = workbook.createFont();
        boldFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        styles.boldDataStyle.setFont(boldFont);

        styles.boldNumberStyle = workbook.createCellStyle();
        styles.boldNumberStyle.cloneStyleFrom(styles.numberStyle);
        styles.boldNumberStyle.setFont(boldFont);

        // --- NEW STYLES FOR RECAP SHEET ---
        styles.boldTitleStyle = workbook.createCellStyle();
        Font titleFont = workbook.createFont();
        titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        titleFont.setFontHeightInPoints((short) 14);
        styles.boldTitleStyle.setFont(titleFont);

        styles.boldUnderlineStyle = workbook.createCellStyle();
        Font undFont = workbook.createFont();
        undFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        undFont.setUnderline(Font.U_SINGLE);
        styles.boldUnderlineStyle.setFont(undFont);

        styles.dataStyleLeftNoBorder = workbook.createCellStyle();
        styles.dataStyleLeftNoBorder.setAlignment(CellStyle.ALIGN_LEFT);

        styles.dataStyleLeftBoxed = workbook.createCellStyle();
        styles.dataStyleLeftBoxed.setBorderBottom(CellStyle.BORDER_THIN);
        styles.dataStyleLeftBoxed.setBorderTop(CellStyle.BORDER_THIN);
        styles.dataStyleLeftBoxed.setBorderRight(CellStyle.BORDER_THIN);
        styles.dataStyleLeftBoxed.setBorderLeft(CellStyle.BORDER_THIN);
        styles.dataStyleLeftBoxed.setAlignment(CellStyle.ALIGN_LEFT);

        styles.dataStyleCenterBoxed = workbook.createCellStyle();
        styles.dataStyleCenterBoxed.setBorderBottom(CellStyle.BORDER_THIN);
        styles.dataStyleCenterBoxed.setBorderTop(CellStyle.BORDER_THIN);
        styles.dataStyleCenterBoxed.setBorderRight(CellStyle.BORDER_THIN);
        styles.dataStyleCenterBoxed.setBorderLeft(CellStyle.BORDER_THIN);
        styles.dataStyleCenterBoxed.setAlignment(CellStyle.ALIGN_CENTER);

        styles.dataStyleCenterNoBorder = workbook.createCellStyle();
        styles.dataStyleCenterNoBorder.setAlignment(CellStyle.ALIGN_CENTER);

        styles.orangeBoxStyle = workbook.createCellStyle();
        styles.orangeBoxStyle.setFillForegroundColor(IndexedColors.TAN.getIndex());
        styles.orangeBoxStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        styles.orangeBoxStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.orangeBoxStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.orangeBoxStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.orangeBoxStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.orangeBoxStyle.setAlignment(CellStyle.ALIGN_CENTER);
        styles.orangeBoxStyle.setFont(boldFont);

        styles.yellowBoxStyle = workbook.createCellStyle();
        styles.yellowBoxStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
        styles.yellowBoxStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        styles.yellowBoxStyle.setBorderBottom(CellStyle.BORDER_THIN);
        styles.yellowBoxStyle.setBorderTop(CellStyle.BORDER_THIN);
        styles.yellowBoxStyle.setBorderRight(CellStyle.BORDER_THIN);
        styles.yellowBoxStyle.setBorderLeft(CellStyle.BORDER_THIN);
        styles.yellowBoxStyle.setAlignment(CellStyle.ALIGN_LEFT);
        styles.yellowBoxStyle.setFont(boldFont);

        styles.boldBoxedCenter = workbook.createCellStyle();
        styles.boldBoxedCenter.cloneStyleFrom(styles.dataStyleCenterBoxed);
        styles.boldBoxedCenter.setFont(boldFont);

        styles.boldBoxedGrey = workbook.createCellStyle();
        styles.boldBoxedGrey.cloneStyleFrom(styles.dataStyleCenterBoxed);
        styles.boldBoxedGrey.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        styles.boldBoxedGrey.setFillPattern(CellStyle.SOLID_FOREGROUND);
        styles.boldBoxedGrey.setFont(boldFont);
        styles.boldBoxedGrey.setAlignment(CellStyle.ALIGN_RIGHT); // Align numbers right

        styles.dataStyleRightNoBorder = workbook.createCellStyle();
        styles.dataStyleRightNoBorder.setAlignment(CellStyle.ALIGN_RIGHT);

        styles.boldItalicRight = workbook.createCellStyle();
        styles.boldItalicRight.setAlignment(CellStyle.ALIGN_RIGHT);
        Font biFont = workbook.createFont();
        biFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        biFont.setItalic(true);
        styles.boldItalicRight.setFont(biFont);

        return styles;
    }

    private static void createInfoSection(Sheet sheet, int startRow, StylesContainer styles, Workbook workbook) {
        CellStyle headerInfoStyle = workbook.createCellStyle();
        headerInfoStyle.cloneStyleFrom(styles.infoStyle);

        CellStyle centerInfoStyle = workbook.createCellStyle();
        centerInfoStyle.cloneStyleFrom(styles.infoStyle);
        centerInfoStyle.setAlignment(CellStyle.ALIGN_CENTER);

        for (int i = 0; i < LEFT_INFO.length; i++) {
            Row row = sheet.createRow(startRow + i);

            if (LEFT_INFO[i] != null) {
                Cell leftCell = row.createCell(0);
                leftCell.setCellValue(LEFT_INFO[i]);
                leftCell.setCellStyle(headerInfoStyle);
            }

            if (CENTER_INFO[i] != null) {
                sheet.addMergedRegion(new CellRangeAddress(startRow + i, startRow + i, 5, 12));
                Cell centerCell = row.createCell(5);
                centerCell.setCellValue(CENTER_INFO[i]);
                centerCell.setCellStyle(centerInfoStyle);
            }
        }
    }

    private static void createHeaderRow(Sheet sheet, int rowNum, CellStyle headerStyle) {
        Row headerRow = sheet.createRow(rowNum);
        headerRow.setHeightInPoints(40);

        for (int i = 0; i < HEADERS.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(HEADERS[i]);
            cell.setCellStyle(headerStyle);
        }
    }

    private static void adjustColumnWidths(Sheet sheet) {
        for (int i = 0; i < HEADERS.length; i++) {
            sheet.setColumnWidth(i, (HEADERS[i].length() + 5) * 256);
        }
        sheet.setColumnWidth(2, 6000);
        sheet.setColumnWidth(3, 6000);
    }

    private static void createEmployeeRow(Sheet sheet, int rowNum, OstieAffiche emp, StylesContainer styles) {
        Row dataRow = sheet.createRow(rowNum);

        createCell(dataRow, 0, String.valueOf(emp.getNumero()), styles.dataStyle);
        createCell(dataRow, 1, emp.getMatricule(), styles.dataStyle);
        createCell(dataRow, 2, emp.getNom(), styles.dataStyle);
        createCell(dataRow, 3, emp.getPrenoms(), styles.dataStyle);
        createCell(dataRow, 4, emp.getSexe(), styles.dataStyle);
        createCell(dataRow, 5, formatDate(emp.getDate_naissance()), styles.dataStyle);
        createCell(dataRow, 6, formatDate(emp.getDateembauche()), styles.dataStyle);
        createCell(dataRow, 7, formatDate(emp.getDate_depart()), styles.dataStyle);
        createCell(dataRow, 8, emp.getFonction(), styles.dataStyle);
        createCell(dataRow, 9, emp.getCnaps(), styles.dataStyle);
        createCell(dataRow, 10, emp.getCin(), styles.dataStyle);

        createCellNumber(dataRow, 11, emp.getMois1(), styles.numberStyle);
        createCellNumber(dataRow, 12, emp.getMois2(), styles.numberStyle);
        createCellNumber(dataRow, 13, emp.getMois3(), styles.numberStyle);
        createCellNumber(dataRow, 14, emp.getSalaires_non_plafonnes(), styles.numberStyle);
        createCellNumber(dataRow, 15, emp.getSalaires_plafonnes(), styles.numberStyle);
        createCellNumber(dataRow, 16, emp.getEmployeur(), styles.numberStyle);
        createCellNumber(dataRow, 17, emp.getTravailleur(), styles.numberStyle);
    }

    private static void createTotalRow(Sheet sheet, int rowNum, List<OstieAffiche> employes, StylesContainer styles) {
        Row totalRow = sheet.createRow(rowNum);

        for (int i = 0; i < 9; i++) {
            createCell(totalRow, i, "", styles.dataStyle);
        }

        createCell(totalRow, 9, "TOTAUX", styles.boldDataStyle);
        sheet.addMergedRegion(new CellRangeAddress(rowNum, rowNum, 9, 10));

        createCellNumber(totalRow, 11, employes.stream().mapToDouble(OstieAffiche::getMois1).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 12, employes.stream().mapToDouble(OstieAffiche::getMois2).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 13, employes.stream().mapToDouble(OstieAffiche::getMois3).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 14, employes.stream().mapToDouble(OstieAffiche::getSalaires_non_plafonnes).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 15, employes.stream().mapToDouble(OstieAffiche::getSalaires_plafonnes).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 16, employes.stream().mapToDouble(OstieAffiche::getEmployeur).sum(), styles.boldNumberStyle);
        createCellNumber(totalRow, 17, employes.stream().mapToDouble(OstieAffiche::getTravailleur).sum(), styles.boldNumberStyle);
    }

    private static void createCell(Row row, int column, String value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value != null ? value : "");
        cell.setCellStyle(style);
    }

    private static void createCellNumber(Row row, int column, double value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }

    private static String formatDate(Date date) {
        if (date == null) return "";
        return DATE_FORMAT.format(date);
    }

    private static class StylesContainer {
        CellStyle headerStyle;
        CellStyle infoStyle;
        CellStyle dataStyle;
        CellStyle numberStyle;
        CellStyle boldDataStyle;
        CellStyle boldNumberStyle;

        CellStyle boldTitleStyle;
        CellStyle boldUnderlineStyle;
        CellStyle dataStyleLeftNoBorder;
        CellStyle dataStyleLeftBoxed;
        CellStyle dataStyleCenterBoxed;
        CellStyle dataStyleCenterNoBorder;
        CellStyle orangeBoxStyle;
        CellStyle yellowBoxStyle;
        CellStyle boldBoxedCenter;
        CellStyle boldBoxedGrey;
        CellStyle dataStyleRightNoBorder;
        CellStyle boldItalicRight;
    }
}