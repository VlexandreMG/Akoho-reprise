package servlet;

import charge.ChargePersonnelTemp;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.poi.ss.usermodel.*;
import user.UserEJB;

@WebServlet("/ImportChargePersonnel")
@MultipartConfig
public class ImportChargePersonnelServlet extends HttpServlet {

    private final String[] matriculeKeywords = { "MLLE", "MAT", "MATRIC", "MATRICULE", "N°" };

    private final String[] requiredDataColumns = {
            "HEURE NORMAL", "HEURE NORMALE", "HEURE HN", "HN",
            "HEURE HS", "HEURE FERIE", "HEURE DIM",
            "MN", "IF", "TAUX"
    };

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException,IOException {

        UserEJB u = (UserEJB) request.getSession().getAttribute("u");
        String refUser = String.valueOf(u.getUser().getRefuser());
        String idFab = request.getParameter("idFab");
        Part filePart = request.getPart("excelFile");

        if (filePart == null || filePart.getSize() == 0) {
            redirect(response, request, idFab);
            return;
        }

        try (InputStream is = filePart.getInputStream();
             Workbook workbook = WorkbookFactory.create(is)) {

            Sheet sheet = workbook.getSheetAt(0);

            int headerRow = findHeaderRow(sheet);
            if (headerRow == -1) {
                System.out.println("DEBUG: Header row not found!");
                redirect(response, request, idFab);
                return;
            }

            Map<String, Integer> colIndex = readColumnIndex(sheet.getRow(headerRow));

            // DEBUG: Print found columns
            System.out.println("DEBUG: Columns found in Excel: " + colIndex.keySet());

            String matriculeCol = detectMatriculeColumn(colIndex);
            if (matriculeCol == null) {
                System.out.println("DEBUG: Matricule column not found!");
                redirect(response, request, idFab);
                return;
            }

            cleanAndExpandSheetData(sheet, headerRow, colIndex, matriculeCol);

            ChargePersonnelTemp chargeTemp = new ChargePersonnelTemp();
            chargeTemp.setIdFab(idFab);
            chargeTemp.setSheet(sheet);
            chargeTemp.setColIndex(colIndex);
            chargeTemp.setHeaderRow(headerRow);
            chargeTemp.setMatriculeCol(matriculeCol);

            System.out.println("DEBUG: Starting import logic...");
            ArrayList<String> erreurs = chargeTemp.importerChargePersonnel(refUser, null);
            request.getSession().setAttribute("erreurs", erreurs);
            System.out.println("DEBUG: Import logic finished.");
            redirect(response, request, idFab);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void cleanAndExpandSheetData(Sheet sheet, int headerRow,
                                         Map<String, Integer> colIndex,
                                         String matriculeCol) {

        Integer matriculeIdx = colIndex.get(matriculeCol);
        if (matriculeIdx == null) return;

        Map<String, Integer> dataColIndices = new HashMap<>();
        for (String colName : requiredDataColumns) {
            Integer idx = colIndex.get(colName);
            if (idx != null) {
                dataColIndices.put(colName, idx);
            }
        }

        // Calculate the number of rows at the start to avoid modification during iteration
        int lastRowNum = sheet.getLastRowNum();
        java.util.List<RowDataToAdd> rowsToAdd = new java.util.ArrayList<>();

        for (int i = headerRow + 1; i <= lastRowNum; i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;

            Cell matriculeCell = row.getCell(matriculeIdx);
            String matricule = safe(matriculeCell);

            if (matricule == null || matricule.trim().isEmpty()) {
                clearRow(row, matriculeIdx);
                continue;
            }

            // Split BEFORE cleaning (to preserve the separators)
            String[] matricules = splitMatricules(matricule);

            // Now clean each individual matricule
            java.util.List<String> validMatricules = new java.util.ArrayList<>();
            for (String mat : matricules) {
                String cleaned = sanitizeMatricule(mat);
                if (cleaned != null && !cleaned.trim().isEmpty()) {
                    validMatricules.add(cleaned);
                }
            }

            if (validMatricules.isEmpty()) {
                clearRow(row, matriculeIdx);
                continue;
            }

            matricules = validMatricules.toArray(new String[0]);

            if (matricules.length > 1) {
                // Set the first matricule in the original row
                matriculeCell.setCellValue(matricules[0]);

                System.out.println("DEBUG: Found multiple matricules in row " + i + ": " + java.util.Arrays.toString(matricules));

                // Store data for new rows to be added later (avoid modifying during iteration)
                for (int j = 1; j < matricules.length; j++) {
                    rowsToAdd.add(new RowDataToAdd(row, matriculeIdx, colIndex, matricules[j]));
                    System.out.println("DEBUG: Queued new row for matricule: " + matricules[j]);
                }
            } else {
                matriculeCell.setCellValue(matricules[0]);
            }

            // Check if row has actual data
            matricule = safe(matriculeCell);
            if (matricule != null && !matricule.trim().isEmpty()) {
                boolean hasData = false;
                for (Integer colIdx : dataColIndices.values()) {
                    Cell cell = row.getCell(colIdx);
                    String value = safe(cell);
                    if (value != null && !value.trim().isEmpty()) {
                        hasData = true;
                        break;
                    }
                }

                if (!hasData) {
                    clearRow(row, matriculeIdx);
                }
            }
        }

        // NOW add the new rows after iteration is complete
        for (RowDataToAdd data : rowsToAdd) {
            Row newRow = sheet.createRow(sheet.getLastRowNum() + 1);
            copyRowData(data.sourceRow, newRow, data.colIndex);

            Cell newMatriculeCell = newRow.getCell(data.matriculeIdx);
            if (newMatriculeCell == null) {
                newMatriculeCell = newRow.createCell(data.matriculeIdx);
            }
            newMatriculeCell.setCellValue(data.matricule);
            System.out.println("DEBUG: Created new row " + newRow.getRowNum() + " for matricule: " + data.matricule);
        }

        System.out.println("DEBUG: Total rows after expansion: " + (sheet.getLastRowNum() + 1));
    }

    // Helper class to store row data to add later
    private static class RowDataToAdd {
        Row sourceRow;
        Integer matriculeIdx;
        Map<String, Integer> colIndex;
        String matricule;

        RowDataToAdd(Row sourceRow, Integer matriculeIdx, Map<String, Integer> colIndex, String matricule) {
            this.sourceRow = sourceRow;
            this.matriculeIdx = matriculeIdx;
            this.colIndex = colIndex;
            this.matricule = matricule;
        }
    }

    private String[] splitMatricules(String matricule) {
        if (matricule == null || matricule.trim().isEmpty()) return new String[0];
        String[] parts = matricule.split("\\s*-\\s*");
        if (parts.length == 1) return new String[] { matricule };
        if (parts[parts.length - 1].trim().isEmpty()) return new String[] { matricule };

        boolean allValid = true;
        for (String part : parts) {
            if (part.trim().isEmpty()) {
                allValid = false;
                break;
            }
        }
        if (allValid) {
            String[] result = new String[parts.length];
            for (int i = 0; i < parts.length; i++) {
                result[i] = parts[i].trim();
            }
            return result;
        }
        return new String[] { matricule.trim() };
    }

    private String sanitizeMatricule(String matricule) {
        if (matricule == null) return null;

        // 1. Trim spaces
        String clean = matricule.trim();

        // 1b. Remove leading/trailing dashes
        while (clean.startsWith("-")) {
            clean = clean.substring(1);
        }
        while (clean.endsWith("-")) {
            clean = clean.substring(0, clean.length() - 1);
        }
        clean = clean.trim();

        // 2. Remove all non-alphanumeric characters (keep letters and numbers only)
        // This removes: commas, periods, dashes, underscores, special chars, etc.
        clean = clean.replaceAll("[^A-Za-z0-9]", "");

        // 3. Uppercase everything
        clean = clean.toUpperCase();

        return clean.isEmpty() ? null : clean;
    }


    private void copyRowData(Row sourceRow, Row targetRow, Map<String, Integer> colIndex) {
        for (Integer colIdx : colIndex.values()) {
            Cell sourceCell = sourceRow.getCell(colIdx);
            if (sourceCell == null) continue;
            Cell targetCell = targetRow.createCell(colIdx);
            switch (sourceCell.getCellType()) {
                case Cell.CELL_TYPE_STRING: targetCell.setCellValue(sourceCell.getStringCellValue()); break;
                case Cell.CELL_TYPE_NUMERIC: targetCell.setCellValue(sourceCell.getNumericCellValue()); break;
                case Cell.CELL_TYPE_BOOLEAN: targetCell.setCellValue(sourceCell.getBooleanCellValue()); break;
                case Cell.CELL_TYPE_FORMULA: targetCell.setCellFormula(sourceCell.getCellFormula()); break;
                default: break;
            }
            targetCell.setCellStyle(sourceCell.getCellStyle());
        }
    }

    private void clearRow(Row row, int matriculeIdx) {
        Cell matriculeCell = row.getCell(matriculeIdx);
        if (matriculeCell != null) matriculeCell.setCellValue("");
    }

    private void redirect(HttpServletResponse res, HttpServletRequest req, String idFab) throws ServletException,IOException {
        String url = req.getContextPath() + "/pages/module.jsp?but=fabrication/fabrication-fiche.jsp&id=" + idFab+"&tab=inc/charge-personnel";
        res.sendRedirect(url);
    }

    private String safe(Cell c) {
        if (c == null) return null;
        int type = c.getCellType();
        if (type == Cell.CELL_TYPE_STRING) return c.getStringCellValue().trim();
        if (type == Cell.CELL_TYPE_NUMERIC) {
            double n = c.getNumericCellValue();
            if (n == (long) n) return String.valueOf((long) n);
            return String.valueOf(n);
        }
        if (type == Cell.CELL_TYPE_FORMULA) {
            try { return c.getStringCellValue().trim(); }
            catch (Exception e) { return String.valueOf(c.getNumericCellValue()); }
        }
        if (type == Cell.CELL_TYPE_BOOLEAN) return String.valueOf(c.getBooleanCellValue());
        return null;
    }

    private int findHeaderRow(Sheet sheet) {
        for (int i = 0; i <= sheet.getLastRowNum(); i++) {
            Row r = sheet.getRow(i);
            if (r == null) continue;
            for (int j = 0; j < r.getLastCellNum(); j++) {
                String v = safe(r.getCell(j));
                if (v == null) continue;
                for (String key : matriculeKeywords)
                    if (v.toUpperCase().contains(key)) return i;
            }
        }
        return -1;
    }

    private Map<String, Integer> readColumnIndex(Row header) {
        Map<String, Integer> map = new HashMap<>();
        System.out.println("DEBUG: -------- Reading Header Row " + header.getRowNum() + " --------");

        for (int i = 0; i < header.getLastCellNum(); i++) {
            Cell c = header.getCell(i);
            String rawValue = safe(c);

            // Print exactly what is in the cell, wrapped in brackets to see spaces
            System.out.println("DEBUG: Cell " + i + " contains: [" + rawValue + "]");

            if (rawValue != null) {
                // Normalize: UPPERCASE, remove double spaces, remove invisible chars
                String cleaned = rawValue.trim().toUpperCase()
                        .replace("\u00A0", " ")  // Remove non-breaking space
                        .replace("  ", " ")      // Turn double space to single
                        .trim();

                map.put(cleaned, i);
            }
        }
        System.out.println("DEBUG: -------- End Header Reading --------");
        return map;
    }

    private String detectMatriculeColumn(Map<String, Integer> cols) {
        for (String col : cols.keySet()) {
            for (String key : matriculeKeywords)
                if (col.contains(key)) return col;
        }
        return null;
    }
}