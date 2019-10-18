FROM node:8.16.2-alpine

WORKDIR /node-app

# Update Base Image and Add Some Packages To Enable Troubleshooting of Container 
RUN apk update && apk upgrade && \
    apk add --no-cache curl bash git openssh make busybox-extras 

# Leverage Cached Docker layers
COPY package*.json ./

RUN npm install 

COPY . .

RUN npm run build

EXPOSE 3000

CMD [ "npm", "start" ]