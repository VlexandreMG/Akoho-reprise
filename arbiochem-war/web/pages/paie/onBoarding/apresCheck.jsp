

<%@page import="utils.ConstanteEtatStation"%>
<%@page import="bean.CGenUtil"%>
<%@page import="faturefournisseur.FactureFournisseur"%>
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.UtilDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="paie.onBoarding.CheckListFille" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

    try{
        UserEJB u = (UserEJB)session.getAttribute("u");
        String lien = (String)session.getAttribute("lien");
        String bute = request.getParameter("bute");
        String[] ids = request.getParameterValues("ids");
        String id = request.getParameter("id");

        System.out.println("ids: " + ids);

        if (ids != null && ids.length > 0) {
            CheckListFille checkListFille = new CheckListFille();
            checkListFille.checkListFille(ids, u);
        }

        if (id != null){
            bute += "&id=" +id;
        }
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%
}catch (Exception e) {
    e.printStackTrace();
%>

<script language="JavaScript"> alert("<%=new String(e.getMessage().getBytes(), "UTF-8")%>");
history.back();</script>
<%
        return;
    } %>