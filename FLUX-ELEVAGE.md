# 🔄 FLUX ÉLEVAGE COMPLET — De la commande à la ration

> Traçabilité réelle : quel écran, quelle classe, quelle table, quelle vue, quel contrôle.

---

## 🗺️ VUE D'ENSEMBLE (10 étapes)

```
 ① BON DE COMMANDE FOURNISSEUR
        │  As_BonDeCommande
        ▼
 ② LIVRAISON (génération + mouvement de stock)
        │  As_BonDeLivraison.genererMvtStockPersist()
        ▼
 ③ RÉCEPTION AVION  ── triage : vivant / mort / (perdus)
        │  ReceptionPoussinAeroport  + checkQteFille()
        ▼
 ④ DIRECTION USINE EN VOITURE (transport + traçabilité)
        │  TransfertPoulet  (véhicule, chauffeur, controleur)
        ▼
 ⑤ TRIAGE SUR PLACE ── mort / perdus / malades
        │  TriageBatimentParquet
        ▼
 ⑥ RÉPARTITION EN COMPARTIMENTS  (A, B, C…)
        │  idbatiment + idparquet
        ▼
 ⑦ GROUPEMENT PAR SEXE (mâles / femelles)
        ▼
 ⑧ ISOLATION DES MALADES  (quarantaine)
        ▼
 ⑨ NOURRITURE JOURNALIÈRE (ration par tête)
        │  DistributionAliment.rationParTete
        ▼
 ⑩ SUIVI QUOTIDIEN (mortalité, eau, température)
           SuiviJournalierDetail
```

---

# ① BON DE COMMANDE FOURNISSEUR

| | |
|---|---|
| 🖥️ **Écran** | `pages/bondecommande/bondecommande-saisie.jsp` |
| 🧠 **Classe mère** | `faturefournisseur.As_BonDeCommande` |
| 📄 **Classe fille** | `As_BonDeCommande_Fille` |
| 🗃️ **Tables** | `AS_BONDECOMMANDE`, `AS_BONDECOMMANDE_FILLE` |
| 👁️ **Vues** | `ST_INGREDIENTSAUTOACHAT_CPL` / `_USD` / `_EUR`, `AS_BC_RESTE_A_FACTURER` |
| 🔑 **Clé** | `BC` + séquence `GETSEQBONCOMMANDE` |
| ✅ **Contrôle** | `annulerVisa()` : impossible de dé-valider un BC validé |

**Affichage utilisé :**
```jsp
PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, 10, u);
Liste[] liste = new Liste[4];
liste[0] = new Liste("idDevise",     dev,      "val",     "id");
liste[1] = new Liste("modepaiement", mp,       "val",     "id");
liste[2] = new Liste("idMagasin",    magasin,  "val",     "id");
liste[3] = new Liste("service",      new Service(), "libelle", "compte");
pi.getFormu().changerEnChamp(liste);

pi.getFormu().getChamp("fournisseur")
           .setPageAppelComplete("faturefournisseur.Fournisseur","id","Fournisseur","taxe","taxe");
pi.getFormu().getChamp("fournisseur")
           .setPageAppelInsert("fournisseur/fournisseur-saisie.jsp",
                               "fournisseur;fournisseurlibelle","id;nom");
pi.getFormu().getChamp("etat").setVisible(false);
```

**Champs :** `fournisseur`, `reference`, `designation`, `daty`, `dateLimite`,
`idDevise`, `idMagasin`, `modepayment`, `service`, `remise`, **`iddmdachat`**, `refproforma`

---

# ② LIVRAISON + MOUVEMENT DE STOCK

| | |
|---|---|
| 🖥️ **Écran** | `bondecommande/apresLivraisonCommande.jsp` → `bondelivraison/bondelivraison-modif.jsp` |
| 🖥️ **Stock** | `bondelivraison/apresMvtStock.jsp` |
| 🧠 **Classe** | `faturefournisseur.As_BonDeLivraison` |
| 📄 **Fille** | `As_BonDeLivraison_Fille` |
| 🗃️ **Tables** | `AS_BONDELIVRAISON`, `AS_BONDELIVRAISON_FILLE` |
| ⚙️ **Action** | `genererMvtStockPersist()` — **entrée en stock automatique** |

**Le passage BC → Livraison :**
```java
// aprèsLivraisonCommande.jsp
As_BonDeCommande v = new As_BonDeCommande();
v.setId(request.getParameter("id"));
String id = v.genererLivraison(u.getUser().getTuppleID(), null);
//  → CRÉE le bon de livraison, puis redirige

// aprèsMvtStock.jsp
As_BonDeLivraison bl = new As_BonDeLivraison();
bl.setId(id);
bl.genererMvtStockPersist(u.getUser().getTuppleID());
//  → MOUVEMENT DE STOCK
---

# ③ RÉCEPTION AVION + TRIAGE VIVANT / MORT

| | |
|---|---|
| 🖥️ **Écran** | `pages/ferme/receptionaeroport/receptionaeroport-saisie.jsp` |
| 🧠 **Classe mère** | `ferme.receptionaeroport.ReceptionPoussinAeroport` |
| 📄 **Classe fille** | `ReceptionPoussinAeroportDetail` |
| 🗃️ **Tables** | `receptionPoussinAeroport`, `receptionPoussinAeroportDetail` |
| 🗂️ **Nomenclatures** | `SEXE`, **`QUALITEPOUSSIN`** |
| 🔑 **Clé** | `RPA` / `RPAF` + `GETSEQRECEPTIONPOUSSINAEROPORT` |
| ✅ **Contrôle** | `checkQteFille()` — total détail **identique** au total reçu |

## AFFICHAGE — le triage

```jsp
// EN-TÊTE
pi.getFormu().getChamp("idLot").setLibelle("Lot");
pi.getFormu().getChamp("qteRecus").setLibelle("Quantité reçue");
pi.getFormu().getChamp("nbrCartonMale").setLibelle("Nombre de cartons mâles");
pi.getFormu().getChamp("nbrCartonFemelle").setLibelle("Nombre de cartons femelles");
pi.getFormu().getChamp("heureDepart").setType("time");
pi.getFormu().getChamp("heureArrive").setType("time");
pi.getFormu().getChamp("idLot").setPageAppelComplete("ferme.lot.Lot","id","LOT");

// DÉTAIL : les 2 listes déroulantes du triage
Liste[] listef = new Liste[2];
TypeObjet sexe = new TypeObjet();
sexe.setNomTable("SEXE");                          // ← MÂLE / FEMELLE
listef[0] = new Liste("idSexe", sexe, "val", "id");

QualitePoussin qp = new QualitePoussin();          // ← VIVANT / MORT
listef[1] = new Liste("idQualitePoussin", qp, "val", "id");
pi.getFormufle().changerEnChamp(listef);

// ORDRE DES COLONNES
String[] colOrdre = {"id", "idQualitePoussin", "idsexe", "qte"};
pi.getFormufle().setColOrdre(colOrdre);
```

## MÉTIER — la structure

```java
// EN-TÊTE
private String id, idLot, remarque, heureDepart, heureArrive;
private Date   daty;
private double qteRecus;         // ← TOTAL reçu
private int    nbrCartonMale;    // ← nombre de cartons MÂLES
private int    nbrCartonFemelle; // ← nombre de cartons FEMELLES
private int    etat;

// DÉTAIL : le triage ligne par ligne
private String id, idMere, idQualitePoussin, idSexe;
private double qte;
```

## MÉTIER — le contrôle bloquant

```java
@Override
public ClassMAPTable createObject(String u, Connection c) throws Exception {
    this.checkQteFille();            // ← appelé AVANT l'insertion
    return super.createObject(u, c);
}

public void checkQteFille() throws Exception {
    double qteFille = 0;
    for (ReceptionPoussinAeroportDetail f : fille) {
        qteFille += f.getQte();
    }
    if (this.getQteRecus() != qteFille)
        throw new Exception("La quantité totale en détails : (" + qteFille
            + ") est différente de la quantité reçue : (" + this.getQteRecus() + ")");
}
```

**Exemple concret :**
```
qteRecus (total)               = 1000
──────────────────────────────────────────
Conforme  Mâle       =  450
Conforme  Femelle    =  480
Mort      Mâle       =   40
Mort      Femelle    =   30
                       ────────
              Somme   =  1000   ✅ accepted
```

## BD — la nomenclature qui porte « vivant / mort / perdus »

| Table | Contenu |
|---|---|
| `QUALITEPOUSSIN` | La liste des qualités — **modifiable à l'écran** |
| `SEXE` | La liste des sexes |

```java
// ferme/utils/ConstanteFerme.java
qualiteConforme = "QP000001"   // ← VIVANT / SAIN
qualiteMort     = "QP000022"   // ← MORT
IDSEXEMALE      = "1"
IDSEXEFEMELLE   = "0"
```

> 💡 **Pour ajouter « Perdus » ou « Malade »** → écran
> `pages/ferme/configuration/qualitepoussin-saisie.jsp`, saisie d'une ligne.
> **Zéro code.** Elle apparaît automatiquement dans tous les menus déroulants.

---

# ④ DIRECTION USINE EN VOITURE

| | |
|---|---|
| 🖥️ **Écran** | `pages/ferme/transfertpoulet/transfertpoulet-saisie.jsp` |
| 🧠 **Classe mère** | `ferme.transfertpoulet.TransfertPoulet` |
| 📄 **Classe fille** | `TransfertPouletDetail` |
| 🗃️ **Tables** | `TRANSFERTPOULET`, `TransfertPouletDetail` |
| 🔑 **Clé** | `TRSP` / `TRSPF` + `GETSEQTRANSFERTPOULET` |
| 🚗 **Traçabilité** | `idVehicule`, `idChauffeur`, `idControleur` |

## MÉTIER — la fiche de transport

```java
public class TransfertPouletDetail extends ClassFille {

    // ═══ LE TRAJET ═══
    private String idFermeDepart,   idBatimentDepart,   idParquetDepart;   // DÉPART
    private String idFermeArrive,   idBatimentArrive,   idParquetArrive;   // ARRIVÉE

    // ═══ LA TRAÇABILITÉ ═══
    private String idControleur;   // QUI a contrôlé
    private String idChauffeur;    // QUI conduisait
    private String idVehicule;     // QUEL véhicule

    // ═══ LE CARGO ═══
    private String idSexe;
    private double qte;
}
```

**Structure réelle :**
```
  FERME   BÂTIMENT   PARQUET
DÉPART → Bat. A  → Parc. 1     (450 M + 480 F conformes)
   ↓  voiture  TRSP-000042
      idVehicule   = VEH01
      idChauffeur  = PERS007
      idControleur = PERS012
   ↓
ARRIVÉE → Bat. B → Parc. 3     (450 M + 480 F conformes)
```

**Classe mère :**
```java
private String id, idLot, remarque;
private Date   daty;
```
```

> ⚠ Ici on quitte le « normal » : pour des **poussins**, la matière n'est pas un
---

# ⑤ + ⑥ TRIAGE SUR PLACE & RÉPARTITION EN COMPARTIMENTS

**C'est l'étape qui répond à ton exemple : « Compartiment A, masculin, 200, sain »**

| | |
|---|---|
| 🖥️ **Écran** | `pages/ferme/triagebatiment/triagebatimentparquet-saisie.jsp` |
| 🧠 **Classe mère** | `ferme.triageBatiment.TriageBatimentParquet` |
| 📄 **Classe fille** | `TriageBatimentParquetDetail` |
| 🗃️ **Tables** | `TRIAGEBATIMENTPARQUET`, `TRIAGEBATIMENTPARQUETDETAIL` |
| 👁️ **Vues** | **`v_qte_dispo_lot_sexe_qualite`**, `QTE_DISPO_LOT_SEXE_QUALITELIB` |
| 🔑 **Clé** | `TB` / `TBD` + `getseq_triagebatimentparquet` |
| ⚠️ **Contrôle** | **DÉSACTIVÉ** (commenté, voir §Manques) |

## MÉTIER — la structure exacte

```java
// EN-TÊTE
private String id;
private Date   daty;
private String idlot;
private int    dispomale;      // ← MÂLES DISPONIBLES
private int    dispofemelle;   // ← FEMELLES DISPONIBLES
private int    etat;

// DÉTAIL : LE CROISEMENT QUI REPASSE TON EXEMPLE
private String id;                              // id
private String idmere;                          // ← lien vers la mère
private String idbatiment;                      // ← BÂTIMENT
private String idparquet;                       // ← COMPARTIMENT (A, B, C…)
private String idsexe;                          // ← 1=MÂLE / 0=FEMELLE
private String idqualite;                       // ← SAIN / MORT / MALADE
private int    qte;                             // ← 200
```

### 🎯 Ton exemple, ligne par ligne

```
Compartiment A, masculin, 200, sain
─────────────────────────────────
idbatiment = BAT01        (Bâtiment 1)
idparquet  = PRQ001       (Compartiment A)
idsexe     = "1"          (ConstanteFerme.IDSEXEMALE)
idqualite  = "QP000001"   (ConstanteFerme.qualiteConforme)
qte        = 200
```

## AFFICHAGE — le filtrage Bâtiment → Compartiment

**C'est la mécanique clé de la répartition :**
```jsp
Liste[] liste = new Liste[4];

// 1) BÂTIMENT
liste[1] = new Liste("idbatiment", new Batiment(), "nomBatiment", "id");

// 2) COMPARTIMENT — filtré par le BÂTIMENT
ParquetBatiment parquet = new ParquetBatiment();
liste[2] = new Liste("idparquet", parquet, "val", "id");

// ⭐ LA LIGNE MAGIQUE : le compartiment ne propose
//    que ceux du bâtiment sélectionné
liste[1].setDeroulanteDependante(liste[2], "idbatiment", "onchange");
```

**Ce que ça produit à l'écran :**
```
┌────────────┐┌────────────┐┌─────────┐┌──────────┐┌──────────┐
│ Bâtiment   ││ Compartim. ││ Sexe    ││ Qualité  ││ Quantité │
├────────────┼┼────────────┼┼─────────┼──────────┼──────────┤
│ Bât. A  ▼  ││            ││         ││          ││          │
└────────────┴┴────────────┴┴─────────┴──────────┴──────────┘
                   ↑ vide au départ
        (quand tu choisis "Bât. A", la liste ne montre
         que les compartiments du Bât. A)
```

**Ordre des colonnes + libellés :**
```jsp
String[] colOrdre = {"idbatiment","idparquet","idsexe","idqualite","qte"};
pi.getFormufle().setColOrdre(colOrdre);

pi.getFormufle().getChamp("idbatiment_0").setLibelle("Bâtiment");
pi.getFormufle().getChamp("idparquet_0").setLibelle("Parquet");
pi.getFormufle().getChamp("idsexe_0").setLibelle("Sexe");
pi.getFormufle().getChamp("idqualite_0").setLibelle("Qualité");
pi.getFormufle().getChamp("qte_0").setLibelle("Quantité");

Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(), false);
```

## AFFICHAGE — le disponible calculé automatiquement

```jsp
if (idLot != null && !idLot.isEmpty()) {
    pi.getFormu().getChamp("idlot").setDefaut(idLot);
    pi.getFormu().getChamp("idlot").setAutre("readonly");

    // Interrogation de la VUE pour chaque sexe
    double femelleDispo = mere.getDisponnibleLib(idLot,
                                ConstanteFerme.IDSEXEFEMELLE,
                                ConstanteFerme.qualiteConforme, null);
    double maleDispo = mere.getDisponnibleLib(idLot,
                                ConstanteFerme.IDSEXEMALE,
                                ConstanteFerme.qualiteConforme, null);

    // Pré-remplissage en LECTURE SEULE
    pi.getFormu().getChamp("dispomale").setDefaut(Double.toString(maleDispo));
    pi.getFormu().getChamp("dispofemelle").setDefaut(Double.toString(femelleDispo));
    pi.getFormu().getChamp("dispomale").setAutre("readonly");
    pi.getFormu().getChamp("dispofemelle").setAutre("readonly");
}
```

## BD — les 2 vues qui portent le « disponible »

| Vue | Utilisée par | Rôle |
|---|---|---|
| **`v_qte_dispo_lot_sexe_qualite`** | `TriageLotSexeQualite` | Disponible brut (lot × sexe × qualité) |
| `QTE_DISPO_LOT_SEXE_QUALITELIB` | `TriageLotSexeQualiteLib` | Idem avec libellés lisibles |

```java
// ferme/triageBatiment/TriageLotSexeQualite.java
public class TriageLotSexeQualite extends TriageBatimentParquetDetail {
    private String idLot;
    public TriageLotSexeQualite() throws Exception {
        this.setNomTable("v_qte_dispo_lot_sexe_qualite");
    }
}

// ferme/triageBatiment/TriageBatimentParquet.java
public double getDisponnibleLib(String idLot, String idSexe,
                                String idQualite, Connection c) {
    TriageLotSexeQualiteLib t = new TriageLotSexeQualiteLib();
    t.setIdLot(idLot);
    t.setIdSexe(idSexe);
    t.setIdQualite(idQualite);
    return CGenUtil.rechercher(t, null, null, c, "")[0].getQte();
}
```

> ⚠ **ATTENTION** : ces vues ne filtrent que sur `qualiteConforme` dans l'appel
> par défaut. Les **morts** et les **malades** restent donc dans le disponible
> affiché. → à valider avec le métier.

## BD — les 2 tables de compartiment

| Classe | Table | Rôle |
|---|---|---|
| `Parquet` | `PARQUET` | Référentiel des compartiments |
| **`ParquetBatiment`** | table de liaison | **Utilisée dans la liste déroulante** |

`ParquetBatiment` est utilisée (et non `Parquet`) car **un compartiment appartient
à un bâtiment**. C'est la table de liaison qui permet le filtrage
`setDeroulanteDependante`.
---

# ⑦ + ⑧ GROUPEMENT PAR SEXE ET ISOLATION DES MALADES

## Groupement par sexe

Le groupement **n'est pas une table** : c'est le **croisement de 4 attributs**
dans la table fille :

```
idlot        +  idsexe     +  idqualite   +  idbatiment/idparquet
  ↓              ↓              ↓                ↓
QUEL LOT   QUEL SEXE   QUELLE QUALITÉ   OÙ EXACTEMENT
```

**Pour « grouper les mâles » :**
```sql
SELECT idbatiment, idparquet, idsexe, SUM(qte) AS total
FROM TRIAGEBATIMENTPARQUETDETAIL
WHERE idmere = :TRIAGE_ID
GROUP BY idbatiment, idparquet, idsexe
ORDER BY idbatiment, idparquet, idsexe;
```

**Pour compter mâles / femelles / morts d'un lot :**
```sql
SELECT d.idsexe, d.idqualite, SUM(d.qte)
FROM TRIAGEBATIMENTPARQUETDETAIL d
JOIN TRIAGEBATIMENTPARQUET m ON d.idmere = m.id
WHERE m.idlot = :LOT_ID
GROUP BY d.idsexe, d.idqualite;
```

## Isolation des malades

**Il n'existe pas de « module quarantaine ».** Mais le modèle le permet
**sans modifier le code**, en utilisant la nomenclature :

> 💡 **La méthode :** tu crées un **parquet dédié « Quarantaine »**
> dans un bâtiment, et tu saisis les malades dedans.

```
idbatiment = BAT01
idparquet  = PRQ_QUAR   (le compartiment « Quarantaine »)
idsexe     = 1
idqualite  = QP000015   (nouvelle qualité « Malade »)
qte        = 12
```

**Ordre de création (tout se fait par l'écran, sans code) :**

| Étape | Écran |
|---|---|
| 1. Créer la qualité « Malade » | `ferme/configuration/qualitepoussin-saisie.jsp` |
| 2. Créer le compartiment « Quarantaine » | `ferme/configuration/parquet-saisie.jsp` |
| 3. Le rattacher au bâtiment | `ferme/configuration/batiment-saisie.jsp` |
| 4. Trier vers ce compartiment | `ferme/triagebatiment/triagebatimentparquet-saisie.jsp` |

---

# ⑨ NOURRITURE JOURNALIÈRE

| | |
|---|---|
| 🖥️ **Écran** | `pages/ferme/aliment/distributionaliment-saisie.jsp` |
| 🧠 **Classe mère** | `ferme.aliment.DistributionAliment` |
| 📄 **Classe fille** | `DistributionAlimentDetail` |
| 🗃️ **Tables** | `distributionAliment`, `distributionAlimentDetail` |
| 🗂️ **Nomenclature** | `AlimentPoussin`, lot de stock (`idLotStock`) |
| 🔑 **Clé** | `DSTA` / `DSTAF` + `GETSEQDISTRIBUTIONALIMENT` |

## MÉTIER — la structure

```java
// EN-TÊTE
private String id, idFerme, idLot;
private Date   daty;

// DÉTAIL
private String id, idMere;
private String idBatiment;    // ← dans quel bâtiment
private String idParquet;     // ← dans quel COMPARTIMENT
private String idAliment;     // ← quel TYPE d'aliment (démarrage/croissance…)
private String idLotStock;    // ← quel LOT PHYSIQUE (traçabilité)
private double qte;           // ← quantité totale distribuée
private double rationParTete; // ← ⚡ LA RATION PAR TÊTE
```

## 🎯 La fonctionnalité clé : `rationParTete`

```
Si rationParTete = 0.120 kg et le compartiment contient 200 têtes :
qte = 200 × 0.120 = 24 kg distribués
```

**Pourquoi `idAliment` ET `idLotStock` ?**

| Champ | Signification |
|---|---|
| `idAliment` | Le **type** (« aliment de démarrage ») |
| `idLotStock` | Le **lot physique** précis (« AL-2024-015, périmé 03/2025 ») |

→ Traçabilité complète : tu sais quel lot physique a été distribué où.

## Comparaison de granularité des 3 réceptions

| Étape | Granularité | Comment |
|---|---|---|
| ③ Aéroport | **1 ligne = tout le lot** | `qte` globale |
| ⑤⑥ Terrain | **1 ligne = 1 compartiment** | `idbatiment` + `idparquet` |
| ⑨ Nourriture | **1 ligne = 1 compartiment + ration** | `+ rationParTete` |

---

# ⑩ SUIVI QUOTIDIEN

| | |
|---|---|
| 🖥️ **Écran** | `pages/ferme/suiviJournalier/suivijournalier-saisie.jsp` |
| 🧠 **Classe mère** | `ferme.suiviJournalier.SuiviJournalier` |
| 📄 **Classe fille** | `SuiviJournalierDetail` |
| 🗃️ **Tables** | `SUIVIJOURNALIER`, `SUIVIJOURNALIERDETAIL` |
| 🔑 **Clé** | `SJ` / `SJD` + `getseq_suivijournalier` |

```java
private String idbatiment, idparquet;
private double agejour;            // ← Âge en jours
private double entree;             // ← Entrées
private double tri;                // ← Tri
private double mortalite;          // ← ⚠ MORTS
private double culls;              // ← ⚠ ÉLIMINATIONS
private double consignesuraliment; // ← Nourriture prévue
private double eau;                // ← Eau
private double temperaturemin;     // ← Température min
private double temperaturemax;     // ← Température max
```

**Complémentarité des 2 écrans :**

| Écran | Rôle |
|---|---|
| `distributionaliment` | Ce que tu **distributes** aujourd'hui |
| `suivijournalier` | Le **relevé** du jour |

> ⚠ Il n'existe **pas** de lien automatique entre les deux pour vérifier si la
> consoommation respecte la ration. C'est une comparaison manuelle aujourd'hui.
---

# 📊 RÉCAPITULATIF COMPLET DU FLUX

| # | Étape | Écran | Classe | Table(s) | Vue(s) | Contrôle |
|---|---|---|---|---|---|---|
| ① | BC fournisseur | `bondecommande-saisie.jsp` | `As_BonDeCommande` | `AS_BONDECOMMANDE`(+FILLE) | `ST_INGREDIENTSAUTOACHAT_*`, `AS_BC_RESTE_A_FACTURER` | `annulerVisa` |
| ② | Livraison + stock | `apresLivraisonCommande.jsp`, `apresMvtStock.jsp` | `As_BonDeLivraison` | `AS_BONDELIVRAISON`(+FILLE) | — | `genererMvtStockPersist` |
| ③ | Réception avion + triage | `receptionaeroport-saisie.jsp` | `ReceptionPoussinAeroport` | `receptionPoussinAeroport`(+Detail) | — | **`checkQteFille`** |
| ④ | Transport voiture | `transfertpoulet-saisie.jsp` | `TransfertPoulet` | `TRANSFERTPOULET`(+Detail) | — | — |
| ⑤⑥ | Triage + compartiments | `triagebatimentparquet-saisie.jsp` | `TriageBatimentParquet` | `TRIAGEBATIMENTPARQUET`(+DETAIL) | **`v_qte_dispo_lot_sexe_qualite`**, `QTE_DISPO_LOT_SEXE_QUALITELIB` | ⚠ désactivé |
| ⑦⑧ | Groupement sexe + quarantaine | idem | idem | idem | idem | via nomenclature |
| ⑨ | Nourriture | `distributionaliment-saisie.jsp` | `DistributionAliment` | `distributionAliment`(+Detail) | — | — |
| ⑩ | Suivi quotidien | `suivijournalier-saisie.jsp` | `SuiviJournalier` | `SUIVIJOURNALIER`(+DETAIL) | — | — |

## Les 5 tables de configuration (à créer en premier)

| Table | Classe | Contenu |
|---|---|---|
| `LOT` | `ferme.lot.Lot` | Les lots d'animaux |
| `BATIMENT` | `ferme.configuration.Batiment` | Les bâtiments |
| `PARQUET` | `ferme.configuration.Parquet` | Les compartiments |
| `PARQUETBATIMENT` | `ferme.configuration.ParquetBatiment` | La liaison Bât.↔Parquet |
| `QUALITEPOUSSIN` | `ferme.configuration.QualitePoussin` | Sain / Mort / Malade / **Perdus** |
| `SEXE` | `bean.TypeObjet` | Mâle / Femelle |

## Les 2 vues du module (les seules)

| Vue | Porteur |
|---|---|
| `v_qte_dispo_lot_sexe_qualite` | Le **disponible** par lot × sexe × qualité |
| `QTE_DISPO_LOT_SEXE_QUALITELIB` | Le même, avec libellés |

---

# ⚠️ CE QUI MANQUE / CE QUI EST DÉSACTIVÉ

## 1. « PERDUS » — n'existe nulle part

Recherche exhaustive sur tout le package `ferme` :
```
"perdu"   → 0 résultat
"disparu" → 0 résultat
```

**3 solutions possibles :**

| Solution | Effort | Impact |
|---|---|---|
| **A — Comme qualité** | ✅ **Zéro code** | Saisissable, mais **pas soustrait du disponible** |
| **B — Champ `disparus`** | ALTER + champ Java + JSP | Sur le suivi journalier uniquement |
| **C — Nouvelle table de pertes** | Nouveau module | Le plus propre, mais le plus lourd |

> 💡 **Si tu choisis A** : va dans `ferme/configuration/qualitepoussin-saisie.jsp`
> et crée une qualité « Perdus ». Elle apparaîtra aussitôt dans les listes
> déroulantes de la réception aéroport ET du triage terrain.

## 2. Le contrôle du triage terrain est DÉSACTIVÉ

`TriageBatimentParquet.java` lignes 92-123 : tout est commenté.

```java
// Ce qui_exists mais ne s'exécute PAS :
if (sommeMale != quantiteMale) {
    throw new Exception("La quantité totale des mâles triés (" + sommeMale
        + ") ne correspond pas à la quantité disponible male (" + quantiteMale + ")");
}
```

**Impact :** on peut mettre dans les compartiments plus d'animaux que le
disponible ne le permet. Le stock devient faux silencieusement.

## 3. Le disponible ignore les morts et les malades

`getDisponnible()` filtre sur `qualiteConforme` uniquement. Donc :
- ✅ conformes = comptés
- ❌ morts, malades, perdus = **encore comptés comme disponibles**

## 4. Pas de lien entre distribution et suivi

`distributionAliment.rationParTete` et
`suivijournalierdetail.consignesuraliment` sont **deux saisies manuelles
indépendantes**. Rien ne vérifie la conformité.

---

# 💡 RECOMMANDATION

**Ne crée aucun nouveau module.** Voici pourquoi :

1. `v_qte_dispo_lot_sexe_qualite` et `QTE_DISPO_LOT_SEXE_QUALITELIB` sont
   des **vues SQL**. Si tu crées de nouvelles tables, **elles ne verront pas
   tes données** → tous les disponibles affichés seront faux.

2. Tout le vocabulaire métier (femme/mâle, sain/mort/malade, bâtiment,
   compartiment) est **déjà dans des nomenclatures** modifiables par l'écran.

**Le chemin le plus rapide et le plus sûr :**

| Priorité | Action | Effort |
|---|---|---|
| 1 | Créer les qualités manquantes dans `QUALITEPOUSSIN` | **Écran seul** |
| 2 | Créer un compartiment « Quarantaine » | **Écran seul** |
| 3 | Réactiver le contrôle du triage terrain | ~30 lignes |
| 4 | Faire valider par le métier ce que « perdus » signifie | Discussion |

> 🎯 **Le point 3 est le plus important** : c'est une vraie faille de cohérence.
> Sans lui, le système peut attribuer plus de poulets qu'il n'en existe.

---

**Créé à partir du code réel du projet ARBIOCHEM.**
**Toutes les classes, tables et vues citées ont été lues dans les sources
`arbiochem-ejb/src/java/ferme/` et vérifiées.**
> produit stockable classique. Le flux réel des animaux passe par le module `ferme/`.