FROM node:alpine
RUN apk add --no-cache git
WORKDIR /app
RUN git clone https://github.com/shashankktiwariii/anikatsu-api.git
WORKDIR /app/anikatsu-api
RUN npm install
EXPOSE 3000
CMD npm start
