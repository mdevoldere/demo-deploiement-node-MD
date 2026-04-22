FROM node:20.20-alpine

# WORKDIR, RUN, CMD, COPY, EXEC, EXPOSE

# Se rendre dans le répertoire
# RUN cd /app
WORKDIR /app

# Copier le code de l'app dans le conteneur
COPY ./simpleApp/* ./

# Lancer la commande npm install
RUN npm install

EXPOSE 3000

# Executer l'application en arrière plan
CMD ["node", "index.js"]
