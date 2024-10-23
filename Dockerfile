FROM node:18.20.4 AS build

ARG CLIENT_ID
ARG API_KEY

WORKDIR /src/build-your-own-radar
COPY package.json package-lock.json ./
COPY . ./
RUN apt update && apt upgrade -y && npm ci && npm run build:prod

FROM nginx:1.23.0

WORKDIR /opt/build-your-own-radar
COPY --from=build /src/build-your-own-radar/dist/ ./
COPY default.template /etc/nginx/conf.d/default.conf
RUN mkdir files
COPY spec/end_to_end_tests/resources/localfiles/* ./files/
