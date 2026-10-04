1. POINT D'ENTRÉE (deux possibilités)
   ├─ bondecommande/bondecommande-liste.jsp      bouton « Nouveau »
   └─ facturefournisseur/dmdachat/dmdachat-fiche.jsp   bouton « Générer BC » (ajoute &iddmdachat=...)
            ↓
2. FORMULAIRE DE SAISIE
   bondecommande/bondecommande-saisie.jsp
   ├─ crée As_BonDeCommande (mère) + As_BonDeCommande_Fille (10 lignes de produits)
   ├─ si iddmdachat : préremplit depuis faturefournisseur/DmdAchat.java
   │                  + faturefournisseur/DmdAchatSuiviCommande.java (quantités restantes)
   └─ le <form> envoie vers  ?but=apresMultiple.jsp  avec acte=insert
            ↓
3. TRAITEMENT DU FORMULAIRE
   apresMultiple.jsp
   ├─ lit classe, classefille, colonneMere (= idbc), nombreLigne
   ├─ reconstruit mère et filles via PageInsertMultiple
   └─ appelle  u.createObjectMultiple(mere, "idbc", filles)
            ↓
4. COUCHE EJB
   user/UserEJB.java (interface)  →  user/UserEJBBean.java (implémentation)
            ↓
5. CLASSES MÉTIER
   faturefournisseur/As_BonDeCommande.java
   ├─ table AS_BONDECOMMANDE
   ├─ construirePK() : identifiant « BC… » via la séquence GETSEQBONCOMMANDE
   └─ controler() : refuse si une ligne a une devise différente de l'en-tête
   faturefournisseur/As_BonDeCommande_Fille.java
   ├─ table AS_BONDECOMMANDE_FILLE
   ├─ construirePK() : identifiant « BCF… » via GETSEQBONDECOMMANDEFILLE
   └─ controler()
            ↓
6. INSERTION EN BASE ORACLE (tables AS_BONDECOMMANDE + AS_BONDECOMMANDE_FILLE)
            ↓
7. REDIRECTION (champ caché « bute »)
   bondecommande/bondecommande-fiche.jsp?id=BC…
   └─ lit la vue faturefournisseur/As_BonDeCommandeCpl.java