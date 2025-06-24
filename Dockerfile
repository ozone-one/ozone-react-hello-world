FROM blrdbharbor.ozonecloud.ai/ozone-public-registry/ozoneprod/node:14.5.0-alpine AS build-stage

WORKDIR /app

COPY ./app ./

ARG API_URL="/api"
ENV API_URL="/api"

RUN npm install --production

RUN npm run build

FROM blrdbharbor.ozonecloud.ai/ozone-public-registry/ozoneprod/nginx:1.19.2-alpine

WORKDIR /var/www/html

COPY  --from=build-stage ./app/build ./app-fe/

COPY ./nginx/default /etc/nginx/sites-enabled/default

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

RUN echo "Hello World" > /var/www/html/index.html

CMD ["nginx"]

EXPOSE 3000
