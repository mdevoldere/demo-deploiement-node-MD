### 1. Le Dockerfile (Multi-stage)

Pour ASP.NET, on utilise un build en deux étapes : une pour **compiler** (lourde) et une pour **exécuter** (très légère).

Ci-dessous, un `Dockerfile` adapté aux projets ASP.NET :

```dockerfile
# ÉTAPE 1 : Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copier le fichier projet et restaurer les dépendances (cache)
COPY *.csproj ./
RUN dotnet restore

# Copier le reste et compiler
COPY . ./
RUN dotnet publish -c Release -o out

# ÉTAPE 2 : Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Exposer le port par défaut d'ASP.NET
EXPOSE 80
ENTRYPOINT ["dotnet", "VotreNomDeProjet.dll"]
```


---

### 2. Les commandes pour lancer l'app

1.  **Construire l'image :**
    ```bash
    docker build -t mon-api-aspnet .
    ```

2.  **Lancer le conteneur :**
    ```bash
    docker run -d -p 8080:80 --name api-container mon-api-aspnet
    ```
    *L'API sera alors accessible sur `http://localhost:8080`.*

---

### 3. Intégration avec les Secrets GitHub

Dans un scénario réel, on ne veut pas que l'image Docker contienne des secrets. On les passe au moment du `run`.

**Exercice :**
Modifiez le workflow GitHub Actions pour construire l'image et l'envoyer sur un registre (comme DockerHub), puis montrez comment passer un secret lors du lancement :

```yaml
# Exemple de commande de lancement sur le serveur via l'Action
run: |
  docker run -d \
    -e ConnectionStrings__DefaultConnection="${{ secrets.DB_CONNECTION_STRING }}" \
    -p 80:80 \
    mon-api-aspnet
```

###  A retenir :

* **L'image SDK** est utilisée uniquement pour construire l'app (elle contient tous les outils de dev).
* **L'image ASPNET** (Runtime) est celle qui est déployée (elle est optimisée et sécurisée).
* Les **Secrets** sont injectés via des variables d'environnement (`-e`) au démarrage du conteneur.
