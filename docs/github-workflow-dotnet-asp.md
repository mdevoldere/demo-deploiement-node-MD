# Procédure simplifiée pour déployer une API ASP.NET.

## Déployer une API ASP.NET Core

Contrairement à Node.js où l'on déploie souvent le code source directement, ASP.NET nécessite une étape de **compilation** et de **publication**.

### 1. La commande clé : `dotnet publish`

Cette commande prépare l'application pour le déploiement. Elle :
* Compile le code en fichiers `.dll`.
* Récupère toutes les dépendances (NuGet).
* Nettoie les fichiers de développement.


### 2. Le mode d'hébergement

Il existe deux façons principales de déployer :

* **FDD (Framework Dependent) :** Le serveur de destination doit avoir le runtime .NET installé (plus léger).
* **SCD (Self-Contained) :** L'application inclut son propre runtime (plus lourd, mais tourne partout sans pré-requis).

---

## Procédure de déploiement (Pas à pas)

### Étape 1 : Préparation en local

Avant d'envoyer sur un serveur, on génère le package de sortie :
```bash
dotnet publish -c Release -o ./publish
```
*Le dossier `./publish` contient maintenant tout ce qui est nécessaire pour faire tourner l'API.*

### Étape 2 : Automatisation avec GitHub Actions

Voici comment adapter ce que les élèves ont appris sur Node.js pour ASP.NET. On utilise des **Secrets** pour l'accès au serveur (FTP ou SSH).

```yaml
name: Deploy ASP.NET API

on:
  push:
    branches: [ "main" ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4

    - name: Setup .NET
      uses: actions/setup-dotnet@v4
      with:
        dotnet-version: '8.0.x'

    - name: Publish
      run: dotnet publish -c Release -o ./deploy

    - name: Deploy to Server (via FTP)
      uses: SamKirkland/FTP-Deploy-Action@v4.3.5
      with:
        server: ${{ secrets.FTP_SERVER }}
        username: ${{ secrets.FTP_USERNAME }}
        password: ${{ secrets.FTP_PASSWORD }}
        local-dir: ./deploy/
```

### Étape 3 : Exécution sur le serveur

Une fois les fichiers copiés, l'API est lancée sur le serveur (souvent derrière un reverse proxy comme **Nginx** ou **IIS**) :

```bash
dotnet MonApi.dll
```

---

## Exercice

**Objectif :** Créer un secret pour la chaîne de connexion à la base de données.

1.  Ajoutez une clé dans `appsettings.json` : `"DefaultConnection": "Server=localhost;Database=TestDB;"`.
2.  Dans GitHub, créez un secret nommé `DB_CONNECTION_STRING`.
3.  Modifiez le workflow pour qu'il remplace la valeur lors du déploiement ou qu'il l'injecte via une variable d'environnement :
    ```yaml
    env:
      ConnectionStrings__DefaultConnection: ${{ secrets.DB_CONNECTION_STRING }}
    ```

**Question :**

> "Quelle est la principale différence entre le déploiement d'une app Node.js et celui d'une app ASP.NET ?"
