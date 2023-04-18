FROM node:alpine
RUN apk add --no-cache git
WORKDIR /app
RUN git clone https://github.com/shashankktiwariii/anikatsu-api.git
RUN npm install
EXPOSE 3000
CMD npm start
