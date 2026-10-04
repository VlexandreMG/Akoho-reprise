<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Importation et Analyse de CV (IA)</h1>
    </section>

    <section class="content">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Sélection des fichiers (PDF ou Images)</h3>
            </div>

            <div class="box-body">
                <form id="formImportCV" action="${pageContext.request.contextPath}/extraire-cv" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="file">Sélectionnez un ou plusieurs CV :</label>
                        <input type="file" id="file" name="file" class="form-control" accept="application/pdf, image/jpeg, image/png, image/webp" multiple required>
                    </div>

                    <div class="form-group" style="margin-top: 20px;">
                        <button type="submit" id="btnSubmit" class="btn btn-primary">
                            <i class="material-symbols-rounded">upload</i> Analyser les CV
                        </button>
                    </div>
                </form>

                <div id="zoneChargement" style="display: none; margin-top: 20px; color: #3c8dbc; font-weight: bold;">
                    <i class="material-symbols-rounded" style="animation: spin 2s linear infinite;">sync</i>
                    Analyse en cours par l'IA Gemini, veuillez patienter...
                </div>

                <div id="zoneResultat" style="display: none; margin-top: 20px;">
                    <h4>Résultat de l'extraction (Format JSON ATS) :</h4>
                    <pre id="jsonAffiche" style="background: #f4f4f4; padding: 15px; border-radius: 5px; max-height: 500px; overflow-y: auto;"></pre>
                </div>
            </div>
        </div>
    </section>
</div>

<style>
    @keyframes spin { 100% { transform: rotate(360deg); } }
</style>

<script>
    document.getElementById('formImportCV').addEventListener('submit', function(e) {
        e.preventDefault();

        var form = this;
        var btnSubmit = document.getElementById('btnSubmit');
        var zoneChargement = document.getElementById('zoneChargement');
        var zoneResultat = document.getElementById('zoneResultat');
        var jsonAffiche = document.getElementById('jsonAffiche');

        var formData = new FormData(form);

        btnSubmit.disabled = true;
        zoneChargement.style.display = 'block';
        zoneResultat.style.display = 'none';
        jsonAffiche.innerHTML = '';

        fetch(form.action, {
            method: 'POST',
            body: formData
        })
            .then(response => {
                // Si le serveur renvoie une erreur (ex: 500), on extrait le vrai message JSON
                if (!response.ok) {
                    return response.json().then(errData => {
                        throw new Error(errData.error || "Erreur serveur inconnue.");
                    });
                }
                return response.json();
            })
            .then(data => {
                jsonAffiche.textContent = JSON.stringify(data, null, 4);
                zoneResultat.style.display = 'block';
            })
            .catch(error => {
                // Affiche la VRAIE erreur sur l'écran
                jsonAffiche.textContent = "Détail de l'erreur : " + error.message;
                jsonAffiche.style.color = "red";
                zoneResultat.style.display = 'block';
            })
            .finally(() => {
                btnSubmit.disabled = false;
                zoneChargement.style.display = 'none';
                form.reset();
            });
    });
</script>