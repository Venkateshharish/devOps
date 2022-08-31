FROM node:14
WORKDIR /.
COPY package.json .
RUN npm install
COPY . .
CMD npm start
EXPOSE 8888
