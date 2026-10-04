<%@ page import="user.*" %>
<%@ page import="paie.cantine.PointageCantine" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String redirectUrl = "";
    String[] ids = null;
    String idConcatene = "";
    String searchVal = "";

    try {
        u = (UserEJB) session.getAttribute("u");
        lien = (String) session.getValue("lien");
        acte = request.getParameter("acte");
        ids = request.getParameterValues("ids");
        searchVal = request.getParameter("searchVal");
        if(searchVal == null) searchVal = "";

        redirectUrl = lien + "?";

        if("valider".equalsIgnoreCase(acte)) {
            if (ids != null && ids.length > 0) {
                idConcatene = String.join(";", ids);
                System.out.println("IDs concatenes : " + idConcatene);
                for (int i = 0; i < ids.length; i++) {
                    String id = ids[i];
                    if(id != null && !id.isEmpty()) {
                        PointageCantine cantine = new PointageCantine();
                        cantine.setId(id);
                        u.validerObject(cantine);
                    }
                }
            } else {
                System.out.println("Aucun pointage sélectionné pour validation");
            }
            redirectUrl += "but=paie/cantine/pointage-cantine-liste.jsp&etat=1";
            if (!searchVal.equals("")) {
                redirectUrl += "&searchVal=" + java.net.URLEncoder.encode(searchVal, "UTF-8");
            }
        }
%>
<script language="JavaScript">
    document.location.replace("<%=redirectUrl%>");
</script>
<%
    } catch (Exception ex) {
        ex.printStackTrace();
%>
<script type="text/javascript">
    alert("<%=ex.getMessage()%>");
    history.back();
</script>
<%
        return;
    }
%>
</html>

