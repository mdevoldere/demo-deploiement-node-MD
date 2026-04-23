# Stocker des informations sensibles

Dans un pipeline CI/CD, les **Secrets** sont le "coffre-fort" qui permet de manipuler des données sensibles (mots de passe, clés API, jetons de déploiement) sans jamais les afficher en clair dans le code.

---

## Les Secrets GitHub

### 1. Pourquoi utiliser des Secrets ?

Vos workflows de déploiement ont souvent besoin d’informations sensibles :

* Un token pour déployer
* Un mot de passe de base de données
* Une clé API pour un service externe
* Des identifiants cloud (AWS, GCP, Azure)

Si vous écrivez un mot de passe directement dans votre fichier `.yml`, toute personne ayant accès au dépôt peut le voir. Pire : si le dépôt est public, des robots peuvent voler vos clés en quelques secondes.

Vous vous dites peut-être : « C’est juste mon dépôt perso, personne ne regarde. » Voici la réalité :

| Ce que vous pensez | Ce qui se passe vraiment |
| --- | --- |
| « Mon dépôt est privé » | Les collaborateurs et les outils CI voient tout | 
| « Je supprimerai après »	| Le mot de passe reste dans l’historique Git pour toujours | 
| « Personne ne cherche ça » | Des bots scannent GitHub 24h/24 et trouvent les mots de passe en quelques minutes | 
| « Je peux faire un fork privé » | Si quelqu’un fork votre dépôt, il a votre mot de passe | 


**Un secret GitHub, c’est une variable spéciale stockée dans un coffre-fort chiffré.** Pensez-y comme un gestionnaire de mots de passe intégré à GitHub, spécialement conçu pour vos workflows.

* **Chiffré :** Stocké de manière sécurisée par GitHub.
* **Masqué :** Dans les logs de l'Action, le secret apparaîtra comme `***`.
* **Unidirectionnel :** Une fois enregistré, on ne peut plus le lire dans l'interface, on peut seulement le modifier ou le supprimer.
* **Isolé :** Un workflow ne peut pas lire les secrets d’un autre dépôt.

### 2. Où les trouver ?

Ils se configurent dans votre dépôt GitHub :

`Settings` -> `Secrets and variables` -> `Actions` -> `New repository secret`.

---

## Exercice : Protéger la version de l'application

Imaginez que la version de votre application soit une information sensible ou que vous deviez vous connecter à une base de données.

### Étape 1 : Créer le Secret
1. Allez dans les paramètres de votre dépôt GitHub.
2. Créez un secret nommé `APP_VERSION`.
3. Donnez-lui la valeur `2.0.0-PROD`.

### Étape 2 : Modifier le code pour accepter une variable d'environnement

Modifiez le début du fichier `index.js` pour qu'il utilise la variable d'environnement si elle existe :

```javascript
// Utilise la variable d'env ou "1.0.0" par défaut
const VERSION = process.env.APP_VERSION || "1.0.0";
```

### Étape 3 : Injecter le Secret dans le Workflow

Modifiez le fichier `.github/workflows/test-app.yml` pour passer le secret lors des tests :

```yaml
    - name: Lancer les tests
      run: npm test
      env:
        APP_VERSION: ${{ secrets.APP_VERSION }}
```

### Étape 4 : Le test de vérité

Modifier les tests dans `app.test.js` pour vérifier que la version récupérée est bien `2.0.0-PROD` et non `1.0.0`.

---

## Point de vigilance (Sécurité)

Dans github, **`vars`** (Variables) et **`secrets`** (Secrets) sont différents :
* **`vars.MA_VAR`** : Pour les données non-sensibles (ex: nom d'un cluster, URL publique).
* **`secrets.MON_PASS`** : Pour les données privées (ex: Clé SSH, Token DockerHub).

### Question :

> "Si je fais un `console.log(process.env.APP_VERSION)` dans mon code et que je regarde les logs sur GitHub, que vais-je voir ?"
>
