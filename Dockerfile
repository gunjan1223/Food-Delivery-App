#Base Image
FROM node:16

#Working Directory
WORKDIR /app

#copying the package.json and package-lock.json files to the working directory
COPY package*.json ./

#Installation
RUN npm install

#Copy application code
COPY . .

#Building React app
RUN npm build

#Expose port to access app
EXPOSE 3000

#starting node.js server
CMD [ "npm", "start" ]