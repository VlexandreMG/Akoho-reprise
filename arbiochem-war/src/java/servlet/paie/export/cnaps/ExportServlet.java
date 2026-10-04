package servlet.paie.export.cnaps;

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
import paie.cnaps.CnapsAfficheBis;

@WebServlet("/ExportCnaps")
@MultipartConfig
public class ExportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
//            configureResponse(response);

            CnapsAfficheBis tmp = new CnapsAfficheBis();
            String nomTable = request.getAttribute("nomTable") != null ? request.getAttribute("nomTable").toString() : "CNAPS_T1";
            tmp.setNomTable(nomTable);
            CnapsAfficheBis[] data = (CnapsAfficheBis[]) CGenUtil.rechercher(tmp, null, null, " ");

            List<CnapsAfficheBis> processedData = new ArrayList<>();
            if (data != null) {
                Set<String> seenMatricules = new HashSet<>();
                for (CnapsAfficheBis item : data) {
                    if (item.getMatricule() != null && !seenMatricules.contains(item.getMatricule())) {
                        seenMatricules.add(item.getMatricule());
                        processedData.add(item);
                    }
                }

                Collections.sort(processedData, new Comparator<CnapsAfficheBis>() {
                    @Override
                    public int compare(CnapsAfficheBis o1, CnapsAfficheBis o2) {
                        String m1 = o1.getMatricule() == null ? "" : o1.getMatricule();
                        String m2 = o2.getMatricule() == null ? "" : o2.getMatricule();
                        return m1.compareTo(m2);
                    }
                });
            }

            List<List<String>> donneesEmployes = ExportUtil.convertData(processedData);

            Workbook workbook = ExportUtil.createCnapsWorkbook(donneesEmployes);
            sendWorkbook(workbook, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Erreur lors de la génération du fichier Excel CNAPS");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void configureResponse(HttpServletResponse response) {
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=export_cnaps.xlsx");
    }
    
    private void sendWorkbook(Workbook workbook, HttpServletResponse response) throws IOException {
        try (OutputStream outputStream = response.getOutputStream()) {
            workbook.write(outputStream);
        } finally {
            workbook.close();
        }
    }
}