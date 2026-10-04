<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Télécharger le modèle de CV</h1>
    </section>
    <section class="content">
        
    <h3>Veuillez télécharger et remplir ce modèle de CV pour la candidature.</h3>

    <form action="${pageContext.request.contextPath}/downloadCV" method="get">
        <button class="btn btn-secondary" type="submit">📄 Télécharger CV de candidature</button>
    </form>
    </section>
</div>