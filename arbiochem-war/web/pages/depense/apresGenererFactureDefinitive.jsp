<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="depense.DepenseDivers" %>
<html>
<% try {
    UserEJB u = (UserEJB) session.getAttribute("u");
    String id = request.getParameter("id");
    DepenseDivers depenseDivers = new DepenseDivers();
    depenseDivers.setId(id);
    depenseDivers.genererFactureDefinitive(u.getUser().getTuppleID(),null);
%>
<script>history.back();</script>
<% } catch (Exception e) {
    e.printStackTrace(); %>
    <script>alert("<%=e.getMessage()%>"); history.back();</script>
<% return; } %>
</html>

