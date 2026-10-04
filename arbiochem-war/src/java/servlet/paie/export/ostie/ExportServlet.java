package servlet.paie.export.ostie;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import bean.CGenUtil;
import org.apache.poi.ss.usermodel.Workbook;

import paie.ostie.OstieAffiche;

@WebServlet("/ExportOstie")
@MultipartConfig
public class ExportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            configureResponse(response);

            // 1. Prepare criteria
            String nomTable = (String) request.getAttribute("nomTable");
            // Default fallback if null
            if (nomTable == null || nomTable.isEmpty()) {
                nomTable = "v1_ostie_affiche_t1";
            }

            OstieAffiche tmp = new OstieAffiche();
            tmp.setNomTable(nomTable);

            // 2. Fetch data from DB
            OstieAffiche[] dataArr = (OstieAffiche[]) CGenUtil.rechercher(tmp, null, null, " ");

            // 3. Process Data: Remove duplicates and Sort by Matricule
            List<OstieAffiche> processedList = new ArrayList<>();
            if (dataArr != null) {
                Set<String> seenMatricules = new HashSet<>();
                for (OstieAffiche item : dataArr) {
                    if (item.getMatricule() != null && !seenMatricules.contains(item.getMatricule())) {
                        seenMatricules.add(item.getMatricule());
                        processedList.add(item);
                    }
                }

                // Sort by Matricule ASC
                Collections.sort(processedList, new Comparator<OstieAffiche>() {
                    @Override
                    public int compare(OstieAffiche o1, OstieAffiche o2) {
                        String m1 = o1.getMatricule() == null ? "" : o1.getMatricule();
                        String m2 = o2.getMatricule() == null ? "" : o2.getMatricule();
                        return m1.compareTo(m2);
                    }
                });
            }

            // 4. Generate Workbook (Pass nomTable to determine Semester/Months)
            Workbook workbook = ExportUtil.createOstieWorkbook(processedList, nomTable);
            sendWorkbook(workbook, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Erreur lors de la generation du fichier Excel Ostie: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void configureResponse(HttpServletResponse response) {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=export_paie_ostie.xlsx");
    }

    private void sendWorkbook(Workbook workbook, HttpServletResponse response) throws IOException {
        try (OutputStream outputStream = response.getOutputStream()) {
            workbook.write(outputStream);
        } finally {
            workbook.close();
        }
    }
}