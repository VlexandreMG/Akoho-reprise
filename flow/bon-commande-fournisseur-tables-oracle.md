# Bon de commande fournisseur : tables Oracle et requêtes pour les retrouver

> Source : lecture du dump `arbiochemstandard_20261002_160451.dmp` (export `exp`, Oracle 11.2, schéma `ARBIOCHEMSTANDARD`).
> Les colonnes et les clés ci-dessous viennent des instructions `CREATE TABLE` et `ALTER TABLE` du dump.
> Toutes les requêtes sont compatibles Oracle 11g (pas de `FETCH FIRST` : on utilise `ROWNUM`).

## Sommaire

1. [Schéma des liens](#1-schéma-des-liens)
2. [Les deux tables principales](#2-les-deux-tables-principales)
3. [Tables référencées (en amont)](#3-tables-référencées-en-amont)
4. [Tables qui référencent le BC (en aval)](#4-tables-qui-référencent-le-bc-en-aval)
5. [Vues utilisées par l'application](#5-vues-utilisées-par-lapplication)
6. [Requêtes pour retrouver les tables dans Oracle](#6-requêtes-pour-retrouver-les-tables-dans-oracle)
7. [Requêtes pour lire un bon de commande complet](#7-requêtes-pour-lire-un-bon-de-commande-complet)
8. [À vérifier](#8-à-vérifier)

---

## 1. Schéma des liens

```
                    DEVISE ◄──────────────┐ (IDDEVISE, clé étrangère)
                                          │
FOURNISSEUR ◄─ (FOURNISSEUR)              │
MODEPAIEMENT ◄─ (MODEPAIEMENT)     ┌──────┴────────────┐
MAGASIN2 ◄─ (IDMAGASIN)            │ AS_BONDECOMMANDE  │ ◄── PLANPAIEMENTACHAT.IDBCF (clé étrangère)
DMDACHAT ◄─ (IDDMDACHAT)           │   (en-tête)       │ ◄── AS_BONDELIVRAISON.IDBC
DEPARTEMENT ◄─ (SERVICE)           └──────┬────────────┘ ◄── FACTUREFOURNISSEUR.IDBC
                                          │ IDBC (clé étrangère) ◄── FACTUREDECLARATION.IDBC
                                          ▼
                                ┌──────────────────────────┐
                                │ AS_BONDECOMMANDE_FILLE   │ ◄── AS_BONDELIVRAISON_FILLE.IDBC_FILLE
                                │   (lignes)               │ ◄── FACTUREFOURNISSEURFILLE.IDBCDETAIL
                                └──────┬───────────┬───────┘
                                       │ PRODUIT   │ UNITE
                                       ▼           ▼
                                AS_INGREDIENTS   AS_UNITE
```

Légende : « clé étrangère » veut dire que la contrainte existe dans la base. Les autres liens se font par l'identifiant, sans contrainte déclarée : Oracle ne les vérifie pas, c'est le code Java qui les respecte.

---

## 2. Les deux tables principales

### `AS_BONDECOMMANDE` (en-tête)

| Colonne | Type | Rôle |
|---|---|---|
| `ID` | VARCHAR2(500), obligatoire | Identifiant `BC000893` (séquence `GETSEQBONCOMMANDE`) |
| `DATY` | DATE | Date du bon |
| `ETAT` | NUMBER | État (créé, visé, etc.) |
| `REMARQUE` | VARCHAR2(500) | Remarque libre |
| `DESIGNATION` | VARCHAR2(500) | Objet de la commande |
| `MODEPAIEMENT` | VARCHAR2(500) | Vers `MODEPAIEMENT.ID` |
| `FOURNISSEUR` | VARCHAR2(50) | Vers `FOURNISSEUR.ID` |
| `REFERENCE` | VARCHAR2(500) | Référence libre (ex. « BC N° 180 du 15/07/26 ») |
| `IDDEVISE` | VARCHAR2(120) | Vers `DEVISE.ID` (clé étrangère `BC_DEVISE_FK`) |
| `IDMAGASIN` | VARCHAR2(500) | Vers `MAGASIN2.ID` |
| `DATELIMITE` | DATE | Date limite de livraison |
| `SERVICE` | VARCHAR2(255) | Département |
| `IDDMDACHAT` | VARCHAR2(255) | Vers `DMDACHAT.ID` |
| `REFPROFORMA` | VARCHAR2(200) | Numéro du devis fournisseur (texte libre) |
| `REMISE` | NUMBER(30,2) | Remise globale |

### `AS_BONDECOMMANDE_FILLE` (lignes)

| Colonne | Type | Rôle |
|---|---|---|
| `ID` | VARCHAR2(50), obligatoire | Identifiant `BCF000531` (séquence `GETSEQBONDECOMMANDEFILLE`) |
| `PRODUIT` | VARCHAR2(1500) | Vers `AS_INGREDIENTS.ID` (clé étrangère `BCF_PRODUIT`) |
| `IDBC` | VARCHAR2(50) | Vers `AS_BONDECOMMANDE.ID` (clé étrangère `BC_MERE_FILLE`) |
| `QUANTITE` | NUMBER(30,2) | Quantité commandée |
| `PU` | NUMBER(38,2) | Prix unitaire HT |
| `MONTANT` | FLOAT(126) | Montant de la ligne |
| `TVA` | NUMBER(38,2) | TVA en % |
| `UNITE` | VARCHAR2(50) | Vers `AS_UNITE.ID` (clé étrangère `AS_BCFILLE_UNITE_FK`) |
| `REMISE` | NUMBER(30,2) | Remise en % |
| `IDDEVISE` | VARCHAR2(120) | Vers `DEVISE.ID` (clé étrangère `BCFILLE_DEVISE_FK`) |
| `TAUXDECHANGE` | NUMBER(30,2) | Taux de change |

---

## 3. Tables référencées (en amont)

| Table | Colonne du BC | Lien | Colonnes utiles |
|---|---|---|---|
| `DEVISE` | `IDDEVISE` (mère et fille) | Clé étrangère | `ID`, `VAL`, `DESCE` |
| `AS_INGREDIENTS` | `PRODUIT` (fille) | Clé étrangère | `ID`, `LIBELLE`, `PU`, `TVA`, `UNITE`, `ACTIF`, `ISACHAT`, `COMPTE_ACHAT`, `IDFOURNISSEUR` |
| `AS_UNITE` | `UNITE` (fille) | Clé étrangère | `ID`, `VAL`, `DESCE`, `ACTIF` |
| `FOURNISSEUR` | `FOURNISSEUR` | Par identifiant | `ID`, `NOM`, `NIF`, `STAT`, `ADRESSE`, `CONTACT`, `ESTACTIF`, `ECHEANCE`, `DEVISE`, `MAIL`, `BANQUE` |
| `MODEPAIEMENT` | `MODEPAIEMENT` | Par identifiant | `ID`, `VAL`, `DESCE` |
| `MAGASIN2` | `IDMAGASIN` | Par identifiant | `ID`, `VAL`, `DESCE`, `ETAT`, `ACTIF`, `IDPOINT`, `IDTYPEMAGASIN` |
| `DMDACHAT` | `IDDMDACHAT` | Par identifiant | `ID`, `DATY`, `FOURNISSEUR`, `ETAT`, `DATELIMITE`, `IDMAGASIN`, `SERVICE` |
| `DMDACHATFILLE` | (via `DMDACHAT`) | Par identifiant | `ID`, `IDMERE`, `IDPRODUIT`, `QUANTITE`, `PU`, `TVA` : lignes de la demande d'achat qui préremplissent le BC |
| `DEPARTEMENT` (probable) | `SERVICE` | Par identifiant | À confirmer, voir [section 8](#8-à-vérifier) |

---

## 4. Tables qui référencent le BC (en aval)

| Table | Colonne | Lien | Rôle |
|---|---|---|---|
| `PLANPAIEMENTACHAT` | `IDBCF` | Clé étrangère | Planification des paiements d'un BC (`IDFOURNISSEUR`, `IDTYPEDEPART`, `DUREE`, `TAUX`) |
| `AS_BONDELIVRAISON` | `IDBC` | Par identifiant | Bon de livraison reçu (`IDFOURNISSEUR`, `MAGASIN`, `IDFACTUREFOURNISSEUR`, `ETAT`) |
| `AS_BONDELIVRAISON_FILLE` | `IDBC_FILLE` | Par identifiant | Lignes livrées, rattachées à une ligne de BC (`PRODUIT`, `QUANTITE`, `NUMBL`) |
| `FACTUREFOURNISSEUR` | `IDBC` | Par identifiant | Facture du fournisseur (`IDFOURNISSEUR`, `IDMODEPAIEMENT`, `DATEECHEANCEPAIEMENT`, `IDDMDACHAT`...) |
| `FACTUREFOURNISSEURFILLE` | `IDBCDETAIL` | Par identifiant | Lignes de facture rattachées à une ligne de BC (`IDPRODUIT`, `QTE`, `PU`, `TVA`) |
| `FACTUREDECLARATION` | `IDBC` | Par identifiant | Facture de déclaration (mêmes colonnes principales que `FACTUREFOURNISSEUR`) |

Le chemin d'un achat complet est : **demande d'achat → bon de commande → bon de livraison → facture fournisseur**, avec le BC au centre.

---

## 5. Vues utilisées par l'application

| Vue | Usage |
|---|---|
| `AS_BONDECOMMANDE_CPL` | Liste et fiche du BC (classe Java `As_BonDeCommandeCpl`) |
| `AS_BONDECOMMANDE_MF` | Lignes du BC avec infos de la mère (`DATY`, `ETAT`...) |
| `BCFILLERESTEALIVRERLIB` | Quantités restant à livrer par ligne de BC |
| `AS_BONDELIVRAISON_FILLE_LIB`, `AS_BONDELIVRAISON_MF` | Livraisons liées au BC |
| `FACTUREFOURNISSEUR_CPL`, `FFFILLECPL_VISEE` | Factures liées au BC |
| `AS_INGREDIENTS_LIB_ACHAT` | Produits proposés à l'autocomplétion de la saisie (version arbiochem) |

---

## 6. Requêtes pour retrouver les tables dans Oracle

À lancer connecté avec l'utilisateur du projet (`arbiochemstandard`), dans SQL Developer ou SQL*Plus.

### Lister toutes les tables liées aux achats

```sql
SELECT table_name
FROM user_tables
WHERE table_name LIKE '%BONDECOMMANDE%'
   OR table_name LIKE '%BONDELIVRAISON%'
   OR table_name LIKE '%FACTUREFOURNISSEUR%'
   OR table_name LIKE '%DMDACHAT%'
   OR table_name LIKE '%PLANPAIEMENTACHAT%'
ORDER BY table_name;
```

### Voir la structure d'une table

```sql
DESC AS_BONDECOMMANDE;
DESC AS_BONDECOMMANDE_FILLE;
```

Ou, de façon plus détaillée :

```sql
SELECT column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'AS_BONDECOMMANDE'
ORDER BY column_id;
```

### Tables qui ont une clé étrangère vers `AS_BONDECOMMANDE`

```sql
SELECT c.table_name, c.constraint_name, cc.column_name
FROM user_constraints c
JOIN user_constraints p  ON c.r_constraint_name = p.constraint_name
JOIN user_cons_columns cc ON cc.constraint_name = c.constraint_name
WHERE c.constraint_type = 'R'
  AND p.table_name = 'AS_BONDECOMMANDE';
```

Résultat attendu : `AS_BONDECOMMANDE_FILLE` (`IDBC`) et `PLANPAIEMENTACHAT` (`IDBCF`).

### Tables vers lesquelles `AS_BONDECOMMANDE` et sa fille pointent

```sql
SELECT c.table_name AS table_source,
       cc.column_name,
       p.table_name AS table_referencee,
       c.constraint_name
FROM user_constraints c
JOIN user_constraints p   ON c.r_constraint_name = p.constraint_name
JOIN user_cons_columns cc ON cc.constraint_name = c.constraint_name
WHERE c.constraint_type = 'R'
  AND c.table_name IN ('AS_BONDECOMMANDE', 'AS_BONDECOMMANDE_FILLE')
ORDER BY c.table_name;
```

Résultat attendu : `DEVISE`, `AS_INGREDIENTS`, `AS_UNITE`.

### Tables avec une colonne `IDBC` (même sans clé étrangère)

C'est la requête la plus utile, car la plupart des liens n'ont pas de contrainte déclarée.

```sql
SELECT table_name, column_name
FROM user_tab_columns
WHERE column_name IN ('IDBC', 'IDBCF', 'IDBCFILLE', 'IDBCDETAIL', 'IDBC_FILLE')
ORDER BY table_name;
```

### Tables qui mentionnent un fournisseur ou une demande d'achat

```sql
SELECT table_name, column_name
FROM user_tab_columns
WHERE column_name IN ('IDFOURNISSEUR', 'FOURNISSEUR', 'IDDMDACHAT')
ORDER BY column_name, table_name;
```

### Voir la définition d'une vue

```sql
SET LONG 20000
SELECT text FROM user_views WHERE view_name = 'AS_BONDECOMMANDE_CPL';
```

### Voir de quoi dépend une vue

```sql
SELECT referenced_name, referenced_type
FROM user_dependencies
WHERE name = 'AS_BONDECOMMANDE_CPL'
ORDER BY referenced_name;
```

### Voir la séquence qui fabrique les identifiants

```sql
SELECT object_name, object_type
FROM user_objects
WHERE object_name IN ('GETSEQBONCOMMANDE', 'GETSEQBONDECOMMANDEFILLE');
```

### Compter les lignes de chaque table

```sql
SELECT 'AS_BONDECOMMANDE'        AS table_name, COUNT(*) AS nb FROM as_bondecommande
UNION ALL SELECT 'AS_BONDECOMMANDE_FILLE',  COUNT(*) FROM as_bondecommande_fille
UNION ALL SELECT 'AS_BONDELIVRAISON',       COUNT(*) FROM as_bondelivraison
UNION ALL SELECT 'FACTUREFOURNISSEUR',      COUNT(*) FROM facturefournisseur
UNION ALL SELECT 'PLANPAIEMENTACHAT',       COUNT(*) FROM planpaiementachat
UNION ALL SELECT 'DMDACHAT',                COUNT(*) FROM dmdachat
UNION ALL SELECT 'FOURNISSEUR',             COUNT(*) FROM fournisseur;
```

---

## 7. Requêtes pour lire un bon de commande complet

Remplacez `BC000893` par un identifiant de votre base.

### En-tête avec le nom du fournisseur et le mode de paiement

```sql
SELECT bc.id, bc.daty, bc.designation, bc.reference, bc.refproforma,
       f.nom AS fournisseur, mp.val AS mode_paiement,
       bc.iddevise, bc.idmagasin, bc.service, bc.datelimite, bc.iddmdachat, bc.etat
FROM as_bondecommande bc
LEFT JOIN fournisseur  f  ON f.id  = bc.fournisseur
LEFT JOIN modepaiement mp ON mp.id = bc.modepaiement
WHERE bc.id = 'BC000893';
```

### Lignes avec le libellé du produit

```sql
SELECT bcf.id, bcf.produit, i.libelle, bcf.quantite, bcf.pu,
       bcf.tva, bcf.remise, bcf.iddevise, bcf.tauxdechange
FROM as_bondecommande_fille bcf
LEFT JOIN as_ingredients i ON i.id = bcf.produit
WHERE bcf.idbc = 'BC000893'
ORDER BY bcf.id;
```

### Total du BC (même formule que l'écran de saisie)

```sql
SELECT bcf.idbc,
       SUM( (bcf.pu * bcf.quantite)
            - (bcf.pu * bcf.quantite * NVL(bcf.remise,0) / 100)
            + ((bcf.pu * bcf.quantite) - (bcf.pu * bcf.quantite * NVL(bcf.remise,0) / 100)) * NVL(bcf.tva,0) / 100
          ) AS total_ttc
FROM as_bondecommande_fille bcf
WHERE bcf.idbc = 'BC000893'
GROUP BY bcf.idbc;
```

### Suivre un BC jusqu'à la livraison et la facture

```sql
-- Bons de livraison du BC
SELECT id, daty, etat, idfournisseur, magasin, idfacturefournisseur
FROM as_bondelivraison
WHERE idbc = 'BC000893';

-- Factures fournisseur du BC
SELECT id, daty, designation, reference, etat, dateecheancepaiement
FROM facturefournisseur
WHERE idbc = 'BC000893';

-- Plan de paiement du BC
SELECT * FROM planpaiementachat WHERE idbcf = 'BC000893';
```

### Retrouver la demande d'achat d'origine

```sql
SELECT d.id, d.daty, d.fournisseur, d.etat, d.service
FROM dmdachat d
WHERE d.id = (SELECT iddmdachat FROM as_bondecommande WHERE id = 'BC000893');
```

### Voir les 5 derniers BC

```sql
SELECT id, daty, designation, fournisseur
FROM (SELECT id, daty, designation, fournisseur
      FROM as_bondecommande
      ORDER BY daty DESC)
WHERE ROWNUM <= 5;
```

---

## 8. À vérifier

- **Table des départements** : le formulaire de saisie arbiochem lit les départements avec `TypeObjet("DEPARTEMENT")`, et une table `DEPARTEMENT` existe dans le dump. Je n'ai pas pu confirmer que c'est celle-ci. Vérifiez avec : `SELECT * FROM departement WHERE ROWNUM <= 5;` et comparez avec la valeur `DEPARTE001` des BC existants.
- **Valeurs de `ETAT`** : le sens des nombres (créé, visé, annulé...) n'est pas lu dans le dump. Il est géré par `utilitaire.ConstanteEtat` dans le code.
- **Tables avec `IDBC` non retenues** : `FABRICATION`, `OFAB`, `TRAVAUX`, `ORDRETRAVAUX`, `CARTON` ont aussi une colonne `IDBC`, mais je ne sais pas s'il s'agit de bons de commande fournisseur ou client. La requête « Tables avec une colonne `IDBC` » de la section 6 les listera. Comparez leurs valeurs avec `AS_BONDECOMMANDE.ID` pour trancher.
- **Autres tables clients** : `BONDECOMMANDE_CLIENT`, `BONDECOMMANDE_CLIENT_FILLE` et `AS_BONDELIVRAISON_CLIENT` concernent les commandes **clients**, ne les mélangez pas avec les fournisseurs.
- **Lecture du dump** : elle a été faite avec `strings` sur le fichier, sans importer la base. Après l'import, comparez avec `user_tab_columns` et `user_constraints` : ces vues Oracle font foi.
