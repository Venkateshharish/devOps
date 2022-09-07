FROM node:14
USER root
WORKDIR /.
COPY package.json .
RUN npm install
COPY . .
CMD npm start


