J'ai tout. Voici le cours détaillé sur tes3 sujets.

---

# 📚 COURS 2 : Bon de commande fournisseur + Réceptions & Triage

---

# ══════════════════════════════════════
# SUJET 1 : LE BON DE COMMANDE FOURNISSEUR
# ══════════════════════════════════════

## 1.1 Les fichiers

```
arbiochem-war/web/pages/bondecommande/
├── bondecommande-liste.jsp      ← la liste des BC
├── bondecommande-saisie.jsp     ← ⭐ le formulaire de saisie
├── bondecommande-fiche.jsp      ← le détail d'un BC
├── bondecommande-modif.jsp      ← la modification
├── apresFacturer.jsp            ← ⚡ l'action "Facturer"
├── apresLivraisonCommande.jsp   ← ⚡ l'action "Générer la livraison"
├── facturer-commande-multiple.jsp ← facturer plusieurs BC d'un coup
└── inc/ ← les lignes de détail
```

## 1.2 L'écran de saisie, ligne par ligne

Voici **le cœur du fichier** (`bondecommande-saisie.jsp`), commenté :

```jsp
<%
// ══════ 1. DÉCLARATION DES CLASSES ══════
As_BonDeCommande       mere  = new As_BonDeCommande();       // la MÈRE
As_BonDeCommande_Fille fille = new As_BonDeCommande_Fille();  // la FILLE
fille.setNomTable("AS_BONDECOMMANDE_FILLE_CPL"); // table enrichie

// ══════ 2. GÉNÉRATION DU FORMULAIRE ══════
int nombreLigne = 10;   // ←10 lignes de détail dans le tableau
PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
pi.setLien((String) session.getValue("lien"));

// ══════ 3. LES LISTES DÉROULANTES ══════
Liste[] liste = new Liste[4];
liste[0] = new Liste("idDevise", dev, "val", "id");     // Devise
liste[0].setDefaut("AR");                            // ← par défaut Ariary
liste[1] = new Liste("modepaiement", mp, "val", "id");    // Mode paiement
liste[2] = new Liste("idMagasin", magasin, "val", "id");  // Magasin
liste[3] = new Liste("service", new Service(), "libelle", "compte"); // Département
pi.getFormu().changerEnChamp(liste);

// ══════ 4. LES LIBELLÉS (ce que l'utilisateur voit) ══════
pi.getFormu().getChamp("etat").setLibelle(""); // champ visible mais vide
pi.getFormu().getChamp("reference").setLibelle("Référence");
pi.getFormu().getChamp("designation").setLibelle("Désignation");
pi.getFormu().getChamp("daty").setLibelle("Date");
pi.getFormu().getChamp("dateLimite").setLibelle("Date limite de livraison");
pi.getFormu().getChamp("fournisseur").setLibelle("Fournisseur");
pi.getFormu().getChamp("iddmdachat").setLibelle("Demande d'achat");
pi.getFormu().getChamp("refproforma").setLibelle("Référence proforma");

// ══════ 5. LES LISTES DÉROULANTES ══════
pi.getFormu().getChamp("service").setLibelle("Département");
pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
```

## 1.3 Les 3 types de champs

### Type1 : Liste déroulante (choix among fixe)
```jsp
liste[0] = new Liste("idDevise", dev, "val", "id");
//                    ↑ le nom du champ   ↑la classe   ↑colonne affichée ↑colonne stockée
```
→ Génère un `<select>` avec les valeurs de la table.

### Type 2 : Autocomplétion (chercher une donnée)
```jsp
pi.getFormu().getChamp("fournisseur")
   .setPageAppelComplete(
       "faturefournisseur.Fournisseur",  // la classe Java
       "id",                            // colonne affichée
       "Fournisseur",                   // libellé du champ
       "taxe",                          // colonne de recherche
       "taxe");                         // colonne renvoyée
```
→ Quand tu tapes « Sodipred », une liste te propose les fournisseurs.

### Type 3 : Bouton « + » pour créer en direct
```jsp
pi.getFormu().getChamp("fournisseur")
   .setPageAppelInsert(
       "fournisseur/fournisseur-saisie.jsp",  // la page de création
       "fournisseur;fournisseurlibelle",      // colonnes à renvoyer
       "id;nom");              // colonnes à lire dans la page créée
```
→ Tu peux créer un fournisseur **sans quitter la page du BC** !

## 1.4 Le cas particulier de la demande d'achat

```jsp
if(request.getParameter("iddmdachat") != null) {
    // ← on arrive depuis une demande d'achat
    pi.getFormu().getChamp("iddmdachat").setDefaut(request.getParameter("iddmdachat"));
    pi.getFormu().getChamp("iddmdachat").setAutre("readonly");  // ← verrouillé
} else {
    // ← saisie directe, le champ est libre
    pi.getFormu().getChamp("iddmdachat")
       .setPageAppelComplete("faturefournisseur.DmdAchat","id","DMDACHAT","id","id");
}
```

> 💡 **C'est un mécanisme très courant dans le projet** : un écran peut_forcer un champ si on arrive d'un autre écran.

## 1.5 Le calcul de la remise

```jsp
pi.getFormu().getChamp("remise").setAutre("onchange='calculerMontantV2()'");
```
→ Quand tu changes la remise %, le JavaScript recalcule les montants.

## 1.6 La logique du changement de devise ⚡

C'est le point le plus subtil. Quand tu changes de devise, **la table des prix change** :

```javascript
var mapping = {
    "AR":  { "table": "ST_INGREDIENTSAUTOACHAT_CPL" },
    "USD": { "table": "ST_INGREDIENTSAUTOACHAT_USD" },
    "EUR": { "table": "ST_INGREDIENTSAUTOACHAT_EUR" }
};

function deviseModification() {
    var idDevise = $('#idDevise').val();
    // 1. On détruit l'ancienne autocomplétion
    $("#produit_"+iL+"libelle").autocomplete('destroy');
    // 2. On met à jour le champ caché
    $("#idDevise_"+iL).val(idDevise);
    // 3. On reconstruit avec la NOUVELLE table
    $("#produit_"+iL+"libelle").autocomplete({
        source: function(request, response) {
            fetchAutocomplete(request, response, "null", "id", "null",
                              mapping[idDevise].table,      // ← ICI "produits.IngredientsLib", "true",
                              "pu;taux;compte_achat;compte_achat;libelle");
        },
        select: function(event, ui) {
            // On remplit5 champs d'un coup depuis la réponse
            var champsDependant = ['pu_'+iL,'tauxDeChange_'+iL,'compte_'+iL,
                                   'comptelibelle_'+iL,'produitLib_'+iL];
            for(let i=0;i<champsDependant.length;i++){
                $('#'+champsDependant[i]).val(ui.item.retour.split(';')[i]);
            }
        }
    });
}
```

**Ce que ça veut dire concrètement :**
| Devise | Table interrogée |
|---|---|
| Ariary | `ST_INGREDIENTSAUTOACHAT_CPL` |
| Dollar | `ST_INGREDIENTSAUTOACHAT_USD` |
| Euro | `ST_INGREDIENTSAUTOACHAT_EUR` |

→ Le même produit a **un prix différent** selon la devise.

## 1.7 Le workflow complet

```
  DEMANDE D'ACHAT          (facultatif)
       │
       │  ← le champ iddmdachat est rempli automatiquement
       ▼
 ┌─────────────────────────────────────────┐
 │ ① CRÉATION          état = 1 (etatCreer)│
 │    bondecommande-saisie.jsp             │
 └───────────────────┬─────────────────────┘
        │            │
        │ Cliquer "Valider"
        ▼            ▼
 ┌─────────────────┐  ┌──────────────────────────┐
 │ ② VALIDATION    │  │ ③a FACTURER              │
 │    état = 11    │  │    apresFacturer.jsp      │
 └────┬───────┬────┘  └──────────────────────────┘ │       │
      │       └──▶ ③b GÉNÉRER LIVRAISON
      │              apresLivraisonCommande.jsp
      │              v.genererLivraison(...)
      │              → crée le Bon de Livraison automatiquement
      ▼
 ┌──────────────────────────────────────────┐
 │ ④ RÉCEPTION        (cf. Sujet 2)          │
 │    aprèsMvtStock.jsp                      │
 │    → mouvement de stock automatique │
 └──────────────────────────────────────────┘
```

## 1.8 Le code métier du BC

**La garde-fou :**
```java
// As_BonDeCommande.java
@Override
public void annulerVisa(String u, Connection c) throws Exception {
    if (etat == ConstanteEtat.getEtatValider()) {
        throw new Exception("Cette Bon de commande est deja valide");
    }
    super.annulerVisa(u, c);
}
```
→ **Un BC validé ne peut plus être dévalidé.**

**La génération de facture** (dans `As_BonDeCommande`) :
```java
public FactureFournisseurDetails[] getDetailsFactureByIdsBC(String[] idsBCF, Connection c) {
    As_BonDeCommande_Fille_CPL[] blf = CGenUtil.rechercher(..., "AS_BC_RESTE_A_FACTURER");
    // ↑
    //  Vue SQL : "ce qui reste à facturer"

    // ⚠ GARDE-FOU MÉTIER
    if (!fournisseur.equals(blf[j].getFournisseurlib())) {
        throw new Exception("Impossible de générer une facture avec différents fournisseurs.");
    }
}
```
→ **On ne peut pas facturer 2 fournisseurs sur la même facture.**

---

# ══════════════════════════════════════
# SUJET 2 : RÉCEPTION AÉROPORT + TRIAGE
# ══════════════════════════════════════

**Écran :** `pages/ferme/receptionaeroport/receptionaeroport-saisie.jsp`

## 2.1 Le modèle

```
┌──────────────────────────────────────────────────────────────┐
│  RECEPTIONPOUSSINAEROPORT  (l'en-tête)                       │
│  → "Combien de poussins sont arrivés, par avion ?"          │
├──────────────────────────────────────────────────────────────┤
│  ReceptionPoussinAeroportDetail  (les lignes de triage)     │
│  → "Sur ce lot, combien de M / F / morts / malades ?"       │
└──────────────────────────────────────────────────────────────┘
```

## 2.2 L'en-tête — ce que tu saisis

| Champ Java | Libellé affiché | Explication |
|---|---|---|
| `idLot` | Lot | Le lot de poussins concerné |
| `daty` | Date | Date de la réception |
| **`qteRecus`** | **Quantité reçue** | **Total de poussins** |
| **`nbrCartonMale`** | **Nombre de cartons mâles** | Combien de cartons M |
| **`nbrCartonFemelle`** | **Nombre de cartons femelles** | Combien de cartons F |
| `heureDepart` | Heure de départ | heure `hh:mm` |
| `heureArrive` | Heure d'arrivée | heure `hh:mm` |
| `remarque` | Remarque | Observations |
| `etat` | *(caché)* | Géré automatiquement |

**Détail du code :**
```jsp
pi.getFormu().getChamp("heureDepart").setType("time");   // →<input type="time">
pi.getFormu().getChamp("heureArrive").setType("time");
pi.getFormu().getChamp("qteRecus").setLibelle("Quantité reçue");
pi.getFormu().getChamp("nbrCartonMale").setLibelle("Nombre de cartons mâles");
pi.getFormu().getChamp("nbrCartonFemelle").setLibelle("Nombre de cartons femelles");
pi.getFormu().getChamp("etat").setVisible(false);   // ← on cache l'état
```

## 2.3 Le détail — le triage

**Les 2 colonnes du triage** (ce sont des listes déroulantes) :

```jsp
// Colonne 1 : le SEXE
TypeObjet sexe = new TypeObjet();
sexe.setNomTable("SEXE");
listef[0] = new Liste("idSexe", sexe, "val", "id");

// Colonne 2 : la QUALITÉ
QualitePoussin qp = new QualitePoussin();
listef[1] = new Liste("idQualitePoussin", qp, "val", "id");

pi.getFormufle().changerEnChamp(listef);
```

**L'ordre des colonnes** dans le tableau :
```jsp
String[] colOrdre = {"id", "idQualitePoussin", "idsexe", "qte"};
pi.getFormufle().setColOrdre(colOrdre);
// ↑ ↑               ↑     ↑
// (masqué)     QUALITÉ           SEXE  QUANTITÉ
```

## 2.4 🎯 Le triage VIVANT / MORT / PERDUS

### Ce qui existe déjà

| Ce que tu veux | Comment c'est fait | Etat |
|---|---|---|
| **VIVANT** | Qualité = `qualiteConforme` (`QP000001`) | ✅ |
| **MORT** | Qualité = `qualiteMort` (`QP000022`) | ✅ |
| **MALADE** | Une qualité dans `QUALITEPOUSSIN` | ✅ |
| **PERDUS** | ❌ **N'EXISTE PAS** | ❌ |

### Comment ça marche : la table `QUALITEPOUSSIN`

**C'est une nomenclature = une liste modifiable par l'utilisateur.**

```
QUALITEPOUSSIN
┌──────────┬──────────────┬────────────┐
│ ID       │ VAL          │ DESCE      │
├──────────┼──────────────┼────────────┤
│ QP000001 │ Conforme │ Poussin OK │
│ QP000022 │ Mort         │ Mort au... │
│ QP000015 │ Malade       │ ... │
│ QP000030 │ Faible       │ ...        │
└──────────┴──────────────┴────────────┘
```

> 💡 **Pour ajouter « Perdus », tu n'as RIEN à coder !**
> Tu vas dans l'écran **`ferme/configuration/qualitepoussin-saisie.jsp`** et tu saisis une nouvelle ligne.
> Elle apparaîtra **automatiquement** dans tous les menus déroulants de qualité.

### ⚠ Limite importante à connaître

Si « Perdus » est juste une **qualité**, alors :
- ✅ Tu peux le saisir à l'aérogare
- ❌ Mais **il ne sera pas soustrait du stock disponible** automatiquement

Pourquoi ? Voici la vue qui calcule le disponible :
```java
public double getDisponnible(String idLot, String idSexe, Connection c) {
    t.setIdQualite(ConstanteFerme.qualiteConforme);   // ← QUALITÉ CONFORME SEULE
    return CGenUtil.rechercher(t, ...)[0].getQte();
    //  ↑
    //  Vue v_qte_dispo_lot_sexe_qualite
}
```
→ La vue ne regarde **que** la qualité `QP000001` (conforme). Donc les morts et les « perdus » restent dans le disponible. ⚠

> **C'est un point à valider avec l'utilisateur métier.**

## 2.5 Le contrôle automatique du total

```java
@Override
public ClassMAPTable createObject(String u, Connection c) throws Exception {
    this.checkQteFille();    // ← appelé AVANT l'insertion
    return super.createObject(u, c);
}

public void checkQteFille() throws Exception {
    double qteFille = 0;
    for (ReceptionPoussinAeroportDetail f : fille) {
        qteFille += f.getQte();          // somme des lignes de triage
    }
    if (this.getQteRecus() != qteFille)
        throw new Exception("La quantité totale en détails : (" + qteFille
            + ") est différente de la quantité reçue : (" + this.getQteRecus() + ")");
}
```

**Exemple concret :**
```
Quantité reçue (en-tête)  =  1000

Lignes de triage :
  Conforme  Mâle    =  450
  Conforme  Femelle =  480
  Mort      Mâle    =   40
  Mort      Femelle =   30
  ──────────────────────────────
  Somme = 1000   ✅ OK  Mais si total = 995 → ❌ ERREUR BLOQUANTE
```

**⚠ Attention** : c'est une comparaison de `double` avec `!=`. Pour des nombres non entiers (1000.0 vs 1000.000001), ça peut créer un faux positif. À surveiller si tu utilises des décimales.

## 2.6 La réception depuis un autre écran

```jsp
String idLot = request.getParameter("idLot");

if (idLot != null && !idLot.isEmpty()){
    pi.getFormu().getChamp("idLot").setDefaut(idLot);
    pi.getFormu().getChamp("idLot").setAutre("readonly");  // ← verrouillé
}
```
→ Tu peux arriver depuis l'écran d'un Lot avec le lot déjà rempli. Very useful.

---

# ══════════════════════════════════════
# SUJET 3 : RÉCEPTION EN COURS + TRIAGE PAR COMPARTIMENT
# ══════════════════════════════════════

**Écran :** `pages/ferme/triagebatiment/triagebatimentparquet-saisie.jsp`

> ⚠ **Point important** : il n'existe **pas** de module appelé « cours ».
> Le module qui fait ce que tu décris s'appelle **`triagebatiment`** (triage bâtiment/parquet).
> C'est très probablement ce que tu appelles « la réception en cours ».

## 3.1 Le modèle

```
TRIAGEBATIMENTPARQUET              (l'en-tête)
├── idlot quel lot
├── dispomale                        disponibles mâles
├── dispofemelle                disponibles femelles
│
└── TRIAGEBATIMENTPARQUETDETAIL    (les lignes — LE TRIAGE)
    ├── idbatiment                   BATIMENT
  ├── idparquet           PARQUET (= COMPARTIMENT)
    ├── idsexe             MÂLE ou FEMELLE
    ├── idqualite      QUALITÉ (conforme/mort/malade...)
    └── qte                       QUANTITÉ
```

## 3.2 L'en-tête

```jsp
pi.getFormu().getChamp("daty").setLibelle("Date");
pi.getFormu().getChamp("idlot").setLibelle("Lot");
pi.getFormu().getChamp("dispomale").setLibelle("Mâles disponibles");
pi.getFormu().getChamp("dispofemelle").setLibelle("Femelles disponibles");
pi.getFormu().getChamp("etat").setVisible(false);
```

### ⚡ Le calcul automatique des disponibles

```jsp
if(idLot != null && !idLot.isEmpty()){
    pi.getFormu().getChamp("idlot").setDefaut(idLot);
    pi.getFormu().getChamp("idlot").setAutre("readonly");   // ← verrouillé

    //1. On interroge la vue pour le nombre de femelles disponibles
    double femelleDispo = mere.getDisponnibleLib(idLot,
                                    ConstanteFerme.IDSEXEFEMELLE,   // "0"
                                    ConstanteFerme.qualiteConforme,// "QP000001"
                                    null);
    // 2. Puis pour les mâles
    double maleDispo = mere.getDisponnibleLib(idLot,
                                    ConstanteFerme.IDSEXEMALE,     // "1"
                                    ConstanteFerme.qualiteConforme,// "QP000001"
                                    null);

    // 3. On pré-remplit les champs en lecture seule
    pi.getFormu().getChamp("dispomale").setDefaut(Double.toString(maleDispo));
    pi.getFormu().getChamp("dispofemelle").setDefaut(Double.toString(femelleDispo));
    pi.getFormu().getChamp("dispomale").setAutre("readonly");
    pi.getFormu().getChamp("dispofemelle").setAutre("readonly");
}
```

> 💡 **Le disponible est calculé automatiquement** quand tu arrives avec un lot déjà sélectionné. Tu n'as rien à saisir.

**Ce que ça fait :** l'utilisateur voit immédiatement combien de mâles et de femelles sont en stock pour ce lot, et le système **lit seul** (ne peut pas modifier).

## 3.3 🎯 La répartition par compartiment

**C'est exactement les colonnes `idbatiment` + `idparquet`.**

```jsp
// Colonne 1 : le BÂTIMENT
liste[1] = new Liste("idbatiment", new Batiment(), "nomBatiment", "id");
// ↑ affiche le nom  ↑ stocke l'id

// Colonne 2 : le PARQUET (= compartiment), DÉPENDANT du bâtiment
ParquetBatiment parquet = new ParquetBatiment();
liste[2] = new Liste("idparquet", parquet, "val", "id");

// ⚡ LA LIGNE MAGIQUE : le parquet dépend du bâtiment
liste[1].setDeroulanteDependante(liste[2], "idbatiment", "onchange");
```

### 🌟 `setDeroulanteDependante` — c'est une fonction géniale d'APJ

```jsp
liste[1].setDeroulanteDependante(liste[2], "idbatiment", "onchange");
// liste bâtiment liste parquet   ↑ colonne de liaison  ↑ événement
```

**Ce que ça produit à l'écran :**

```
┌────────────────┐┌────────────────┐┌───────────┐┌──────────┐┌─────────┐
│ Bâtiment ││ Parquet        ││ Sexe      ││ Qualité  ││ Quantité │
├────────────────┼┼────────────────┼┼───────────┼──────────┼─────────┤
│ Bâtiment A ▼ ││                ││ Mâle    ▼ ││        ▼ ││         │
└────────────────┴────────────────┴───────────┴──────────┴─────────┘
                    ↑ Vide au départ !
                (quand tu choisis "Bâtiment A", les parquets
                 se filtrent automatiquement sur ceux du Bâtiment A)
```

**Concrètement** : si le Bâtiment A a 8 parquets et le Bâtiment B en a 12, quand tu sélectionnes Bâtiment B, la liste déroulante des parquets ne propose que les 12 de B. **Tu ne peux pas mettre un poulet dans un parquet d'un autre bâtiment.**

## 3.4 Le tableau de saisie

```jsp
String[] colOrdre = {"idbatiment", "idparquet", "idsexe", "idqualite", "qte"};
pi.getFormufle().setColOrdre(colOrdre);

pi.getFormufle().getChamp("idbatiment_0").setLibelle("Bâtiment");
pi.getFormufle().getChamp("idparquet_0").setLibelle("Parquet");
pi.getFormufle().getChamp("idsexe_0").setLibelle("Sexe");
pi.getFormufle().getChamp("idqualite_0").setLibelle("Qualité");
pi.getFormufle().getChamp("qte_0").setLibelle("Quantité");

// On cache les liens techniques (remplis automatiquement)
Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(), false);
```

**Résultat visuel (10 lignes) :**

```
┌────────────┬──────────┬─────────┬────────────┬──────────┐
│ Bâtiment   │ Parquet  │ Sexe    │ Qualité    │ Quantité │
├────────────┼──────────┼─────────┼────────────┼──────────┤
│ Bât. A     │ Parc. 1  │ Mâle    │ Conforme   │      120 │
│ Bât. A     │ Parc. 1  │ Femelle │ Conforme   │      118 │
│ Bât. A     │ Parc. 1  │ Mâle    │ Mort       │        2 │
│ Bât. A     │ Parc. 2  │ Mâle    │ Conforme   │      125 │
│ Bât. A     │ Parc. 2  │ Femelle │ Malade     │        3 │
│ Bât. B     │ Parc. 1  │ Mâle    │ Conforme   │       95 │
│  ...       │   ...    │  ...    │    ...     │    ...   │
└────────────┴──────────┴─────────┴────────────┴──────────┘
```

## 3.5 Les classes utilisées

```java
// Bâtiment
liste[1] = new Liste("idbatiment", new Batiment(), "nomBatiment", "id");

// Parquet — il y a DEUX classes !
Parquet  → table "PARQUET"       (le compartiment seul)
ParquetBatiment →  la liaison bâtiment↔parquet
```

**La différence est importante :**
| Classe | Table | Usage |
|---|---|---|
| `Parquet` | `PARQUET` | Référentiel des compartiments |
| **`ParquetBatiment`** | la table de liaison | **Utilisée pour la liste déroulante** |

> Pourquoi ? Parce qu'un **parquet appartient à un bâtiment**. La table `PARQUET` liste tous les parquets, mais la table de liaison dit **à quel bâtiment appartient chaque parquet**. C'est pour ça que `ParquetBatiment` est utilisée dans la liste déroulante : elle permet de filtrer.

## 3.6 ⚠ Un bug à connaître

```java
// TriageBatimentParquet.java
@Override
public String getNomClasseFille() {
    return "ferme.tirageBatiment.TriageBatimentParquet";   // ← "tirageBatiment" !
}
//                                 ^^^^^^^^^^^^^ TYPO
```

Le vrai package c'est `ferme.triageBatiment` (avec un **g**). Cette typo vient d'un ancien nom de package.

**Conséquence :** ce `getNomClasseFille()` est **override** (il y en a un autre identique et correct dans le constructeur), donc ça fonctionne. Mais si tu touches au code, **fais attention à ne pas utiliser la mauvaise version**.

## 3.7 ⚠ Le contrôle désactivé

Dans `TriageBatimentParquet.java`, lignes 92 à 123, tout est **commenté** :

```java
@Override
public ClassMAPTable createObject(String u, Connection c) throws Exception {
// TriageBatimentParquetDetail[] details = (TriageBatimentParquetDetail[]) this.getFille();
//      double sommeMale = 0;
//      double sommeFemelle = 0;
//
//      for (int i = 0; i < details.length; i++) {
//          String idsexe = details[i].getIdsexe();
//          double qte = details[i].getQte();
//
//          if (ConstanteFerme.IDSEXEMALE.equals(idsexe)) {
//              sommeMale += qte;
//          } else if (ConstanteFerme.IDSEXEFEMELLE.equals(idsexe)) {
//              sommeFemelle += qte;
//          } else {
//              throw new Exception("Sexe non reconnu pour la ligne de détail: " + idsexe);
//          }
//      }
//
//      if (sommeMale != quantiteMale) {
//          throw new Exception("La quantité totale des mâles triés ... ne correspond pas");
//      }
//      ... idem pour les femelles ...

    return super.createObject(u, c);
}
```

**Conséquence :** on peut **répartir plus d'animaux qu'il n'y en a disponible**, et rien ne le bloque.

---

# ══════════════════════════════════════
# SUJET 4 : LA NOURRITURE
# ══════════════════════════════════════

**Écran :** `pages/ferme/aliment/distributionaliment-saisie.jsp`

## 4.1 Le modèle

```
distributionAliment              (l'en-tête)
├── idFerme                      la ferme
├── idLot                        le lot
├── daty                         la date
│
└── distributionAlimentDetail    (les lignes)
    ├── idBatiment              dans quel bâtiment
    ├── idParquet       dans quel compartiment
    ├── idAliment        quel aliment
    ├── idLotStock quel lot de stock d'aliment
    ├── qte                     QUANTITÉ TOTALE
    └── rationParTete           ⚡ RATION PAR TÊTE
```

## 4.2 Le champ clé : `rationParTete`

```java
private double qte, rationParTete;
```

**C'est la fonctionnalité clé de la nutrition :**

> Tu saisis combien de têtes et la ration par tête, et le système calcule le total.

```
Si rationParTete = 0.120 kg et que le parquet contient 1000 poulets :
qte = 1000 × 0.120 = 120 kg de distribué
```

**Différence avec l'aérogare :**
| Module | Granularité | Usage |
|---|---|---|
| Aéroport | **1 ligne = tout le lot** | Réception globale |
| Bâtiment | **1 ligne = 1 compartiment** | Répartition fine |
| Aliment | **1 ligne = 1 compartiment + ration** | Nutrition精细 |

## 4.3 Le lien avec `AlimentPoussin`

Il existe aussi `produits/AlimentPoussin.java` → c'est la **nomenclature des aliments** (type, âge cible...).

```
Le flux complet :

  ALIMENTPOUSSIN (nomenclature)
    ├─ aliment de démarrage
    ├─ aliment de croissance
    └─ aliment de finition │
     ↓
  distributionAlimentDetail.idAliment  (quel aliment)
         │
     ↓
  idLotStock  (quel lot de stock precis)
         │
         ↓
  qte + rationParTete  (combien distribuer)
```

**Pourquoi `idAliment` ET `idLotStock` ?**
- `idAliment` = **le type** d'aliment (« démarrage »)
- `idLotStock` = **le lot physique** précis (« lot AL-2024-015, périmé le 03/2025 »)

Ça permet la **traçabilité complète** : tu sais quel lot physique a été distribué dans quel parquet.

## 4.4 Le suivi de la consoommation

Tu as aussi `SuiviJournalierDetail` qui contient :
```java
private double consignesuraliment;   // ← la consigne du jour
private double eau;                  // ← l'eau
```

**Les deux objets se complètent :**
| Écran | Rôle |
|---|---|
| `distributionaliment` | Ce que tu **distribues** aujourd'hui |
| `suivijournalier` | Le **relevé** du jour (age, entrées, tri, mortalité) |

**Ce qu'il manque :** un lien entre les deux pour **calculer automatiquement** si la consoommation est conforme à la ration.

---

# 📊 SYNTHÈSE : ce qui existe, ce qui manque

| Ton besoin | Module existant | Statut |
|---|---|---|
| **BC fournisseur** | `bondecommande` | ✅ Complet |
| **BC → livraison auto** | `genererLivraison()` | ✅ |
| **Mouvement stock réception** | `genererMvtStockPersist()` | ✅ |
| **Réception aéroport** | `receptionaeroport` | ✅ |
| **Triage aéroport : vivant** | Qualité `QP000001` | ✅ |
| **Triage aéroport : mort** | Qualité `QP000022` | ✅ |
| **Triage aéroport : malade** | Qualité à créer | ✅ |
| **Triage aéroport : perdus** | Qualité à créer | 🟡 Partiel |
| **Contrôle total réception** | `checkQteFille()` | ✅ |
| **Réception en cours** | `triagebatiment` | ✅ |
| **Triage par compartiment** | `idparquet` | ✅ |
| **Parquet lié au bâtiment** | `setDeroulanteDependante()` | ✅ |
| **Répartition mâle/femelle** | `idsexe` | ✅ |
| **Nourriture** | `distributionaliment` | ✅ |
| **Ration par tête** | `rationParTete` | ✅ |
| **Traçabilité aliment** | `idLotStock` | ✅ |
| ~~Morts en cours d'élevage~~ | `suivijournalier.mortalite` | ✅ |
| **PERDUS** | — | ❌ **ABSENT** |
| **Contrôle du triage terrain** | Commenté | ⚠ **Désactivé** |

---

# 🎯 Pour aller plus loin, dis-moi ce qui t'intéresse

**Sur les 3 sujets, voici lessuite logique :**

| Choix | Ce que je fais |
|---|---|
| **A** | Ajouter **`perdus`** (champ + table + JSP) |
| **B** | **Réactiver le contrôle** du triage terrain (commenté) |
| **C** | Détail **complet ligne par ligne** d'un de ces écrans |
| **D** | La liste complète des tables à requérir pour comprendre l'aliment |
| **E** | Créer une **liste SQL** pour extraire l'état de la ferme (combien de mâles, femelles, morts par lot) |

**Dis-moi celui qui t'intéresse et j'y vais en détail.**