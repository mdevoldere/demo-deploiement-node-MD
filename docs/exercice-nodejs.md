# Contexte

 **Application simple** :  

Une application web minimale (Node.js / Express, Python Flask ou Spring Boot, peu importe) qui affiche :

*   un message `"Version X"`
*   une route `/test` retournant `200 OK`

> Le but est de se concentrer sur **le déploiement**, pas sur le code.

***

# Préparation

Créer le(s) fichier(s) Docker nécessaires pour exécuter l'application.

# Déploiement de base (classique / “big bang”)

## Intention pédagogique

> Comprendre les limites du déploiement naïf : interruption de service, risque utilisateur.

*   Une seule instance
*   On arrête → on met à jour → on redémarre
*   Downtime accepté

***

## Exercice pratique

### Situation

*   Une application tourne sur un serveur (local ou VM).
*   Les utilisateurs y accèdent via `http://localhost:3000`.

### Tâches demandées

1.  Lancer la **version 1** de l’application.
2.  Simuler des utilisateurs (curl / navigateur).
3.  Arrêter l’application.
4.  Déployer la **version 2** (changer le numéro de version).
5.  Redémarrer l’application.
6.  Observer ce que voient les utilisateurs pendant le déploiement.

### Questions à poser

*   Que se passe‑t‑il pour un utilisateur pendant le déploiement ?
*   Quels sont les risques en production ?
*   Dans quels contextes ce type de déploiement est acceptable ?

**Critère de réussite**

*  Constater un **downtime réel et visible**.

***

# Déploiement progressif (rolling deployment)

## Intention pédagogique

> Réduire l’impact utilisateur sans infrastructure complexe.

## Principe

*   Plusieurs instances
*   On met à jour **une instance à la fois**
*   Le service reste disponible

***

## Exercice pratique

### Mise en place

*   Lancer **2 instances** de l’application :
    *   `app_v1_A` sur le port 3001
    *   `app_v1_B` sur le port 3002
*   Un **reverse proxy simple** (Nginx ou script maison) fait du round‑robin.

### Tâches demandées

1.  Déployer les deux instances en version 1.
2.  Vérifier l’équilibrage (les réponses alternent).
3.  Mettre à jour **une seule instance** en version 2.
4.  Observer les réponses côté client.
5.  Mettre à jour la seconde instance.

### Observation attendue

*   Pendant un moment :
    *   certains utilisateurs voient **V1**
    *   d’autres **V2**
*   Aucun arrêt complet du service.

***

### Questions pédagogiques

*   Avantage par rapport au déploiement de base ?
*   Problème potentiel si V2 contient un bug critique ?
*   Impact sur la base de données ?

***

# Déploiement bleu‑vert

## Intention pédagogique

> Pouvoir **basculer instantanément** entre deux versions stables.

## Principe

*   Environnement **Bleu** = version en production
*   Environnement **Vert** = nouvelle version
*   Le trafic est redirigé **en un point unique**

***

## Exercice pratique

### Mise en place

*   Deux environnements séparés :
    *   `Blue (v1)` sur `localhost:4000`
    *   `Green (v2)` sur `localhost:5000`
*   Un reverse proxy ou config qui pointe vers **Blue**

### Tâches demandées

1.  Déployer la version 1 sur Blue.
2.  Déployer la version 2 sur Green.
3.  Tester Green **sans utilisateur**.
4.  Basculer le trafic vers Green.
5.  Simuler un problème.
6.  Rebasculer vers Blue.

### Point clé à observer

Le rollback est :

*   **rapide**
*   **simple**
*   **sans redéploiement**

***

### Questions à poser

*   Quelle est la condition indispensable pour ce type de déploiement ?
*   Coût infrastructure ?
*   Pourquoi ce type est apprécié en production critique ?

***

# Déploiement canari (canary release)

## Intention pédagogique

> Tester une version en **conditions réelles**, avec un **risque contrôlé**.

## Principe

*   Une minorité des utilisateurs voit la nouvelle version
*   La majorité reste sur l’ancienne
*   On observe avant généralisation

***

## Exercice pratique

### Mise en place

*   4 instances :
    *   3 en version 1
    *   1 en version 2 (le “canari”)
*   Le proxy envoie :
    *   75 % du trafic vers V1
    *   25 % vers V2

### Tâches demandées

1.  Configurer la répartition du trafic.
2.  Identifier visuellement si un utilisateur est sur V1 ou V2.
3.  Observer les retours (logs, erreurs simulées).
4.  Augmenter progressivement la part V2.
5.  Revenir en arrière si nécessaire.

***

### Bonus réaliste

Simuler une métrique :

*   temps de réponse plus lent en V2
*   erreur sur une route spécifique

***

## Comparaison finale (exercice de synthèse)

Remplir une grille :

*   risque utilisateur
*   facilité de rollback
*   coût infra
*   quand l’utiliser

Ou mieux :

> *“Quel mode de déploiement recommandes‑tu pour une application bancaire ? un site vitrine ? une startup ? pourquoi ?”*
