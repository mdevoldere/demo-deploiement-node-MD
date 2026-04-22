# Node.js Express Deployment Demo



Ce projet est une application de démonstration utilisant **Node.js** et **Express**. Il sert de support pédagogique pour comprendre les stratégies de déploiement et l'automatisation des tests via **GitHub Actions**.

## Fonctionnalités

- Serveur web Express minimaliste.
- Route d'affichage HTML dynamique.
- Point de terminaison `/test` (Health Check) pour le monitoring.
- Suite de tests automatisée avec **Jest** et **Supertest**.

## Installation et Lancement

1. **Cloner le dépôt :**
   ```bash
   git clone <url-du-depot>
   cd <nom-du-projet>
   ```

2. **Installer les dépendances :**
   ```bash
   npm install
   ```

3. **Lancer l'application :**
   ```bash
   npm start
   ```
   L'application sera accessible sur `http://localhost:3000`.

---

## 🧪 Tests

Nous utilisons **Jest** pour le lanceur de tests et **Supertest** pour simuler les requêtes HTTP sans encombrer les ports réseau.

### Lancer les tests en local
```bash
# Exécution simple
npm test

# Mode observation (rechargement automatique)
npm test -- --watchAll
```

### Tests inclus :
* **Accessibilité :** Vérifie que la page d'accueil répond (200 OK).
* **Intégrité :** Vérifie que le JSON du Health Check contient la bonne version.

---

## 🤖 Intégration Continue (CI)

Ce projet utilise **GitHub Actions**. À chaque `push` ou `pull_request` sur la branche `main`, le workflow suivant est déclenché :

1. Récupération du code (`actions/checkout`).
2. Installation de Node.js v20.
3. Installation des dépendances (`npm install`).
4. Exécution de la suite de tests (`npm test`).

Le fichier de configuration se trouve dans `.github/workflows/test-app.yml`.

---

## 🏗 Stratégies de Déploiement

Cette application est conçue pour être déployée selon plusieurs modèles :

| Stratégie | Description | Risque |
| :--- | :--- | :--- |
| **Classique** | Arrêt de la V1 puis démarrage de la V2. | Moyen (Downtime) |
| **Progressif** | Remplacement instance par instance. | Faible |
| **Bleu-Vert** | Deux environnements complets, bascule du trafic. | Très Faible |
| **Canari** | Test sur 5% des utilisateurs avant généralisation. | Minimal |

---
