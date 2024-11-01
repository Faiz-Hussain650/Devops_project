FROM node:14
WORKDIR /user/app
COPY package.json .
RUN npm install
COPY . .
EXPOSE 8080
CMD ["npm","app.js"]