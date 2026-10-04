
<%
    String lien = (String) session.getValue("lien");
    String id = request.getParameter("idOrigine");
    if(id == null) id = "";

    String but = "";
    if(id.startsWith("VNT")){
        but = "vente/vente-fiche.jsp&id=" + id;
    }else if (id.startsWith("FCF")){
        but = "facturefournisseur/facturefournisseur-fiche.jsp&id=" + id;
    } else if (id.startsWith("BC")) {
        but = "bondecommande/bondecommande-fiche.jsp";
    } else if (id.startsWith("REC")) {
        but = "caisse/report/reportCaisse-fiche.jsp";
    }

    String url = lien + "?but=" + but;
%>
<script>
    window.location.href = "<%=url%>";
</script>