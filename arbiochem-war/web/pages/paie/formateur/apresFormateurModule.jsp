<%@ page import="bean.ClassMAPTable" %>
<%@ page import="affichage.PageInsert" %>
<%@ page import="user.UserEJB" %>
<%@ page import="paie.formateur.ModulePrestataire" %><%
    try{
        UserEJB u = (UserEJB) session.getAttribute("u");
        String acte = request.getParameter("acte");
        String lien = (String) session.getValue("lien");
        String classe = request.getParameter("classe");
        ClassMAPTable t = null;
        ModulePrestataire temp = null;
        String bute = request.getParameter("bute");
        String nomtable = request.getParameter("nomtable");
        if (acte.compareToIgnoreCase("insert") == 0) {
            t = (ClassMAPTable) (Class.forName(classe).newInstance());
            PageInsert p = new PageInsert(t, request);
            ClassMAPTable f = p.getObjectAvecValeur();
            f.setNomTable(nomtable);
            ClassMAPTable o = (ClassMAPTable) u.createObject(f);
            temp = (ModulePrestataire) o;
            String idFormateur = temp.getIdformateur();
            bute += "&id=" + idFormateur;
        }
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>")</script>
<%
    } catch (Exception e) {
        e.printStackTrace();
        throw new Exception(e);
    }

%>