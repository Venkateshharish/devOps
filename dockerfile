FROM node:14
WORKDIR /dev-task/.
COPY package.json .
RUN npm install
COPY . .
CMD npm start
EXPOSE 8888
