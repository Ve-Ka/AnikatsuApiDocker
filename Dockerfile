FROM node:alpine
RUN apk add --no-cache git
WORKDIR /app
RUN git clone https://github.com/Ve-Ka/anikatsu-api.git .
RUN npm install
EXPOSE 3000
CMD npm start
