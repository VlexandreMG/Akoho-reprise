<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
    String lien = request.getParameter("lien");
    System.out.println("TYYY + " + lien);
    if (lien != null && !lien.isEmpty()) {
        RequestDispatcher dispatcher = request.getRequestDispatcher(lien);
        dispatcher.include(request, response);
    }
%>