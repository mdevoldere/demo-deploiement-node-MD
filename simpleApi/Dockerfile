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
ENTRYPOINT ["dotnet", "SimpleApi.dll"]