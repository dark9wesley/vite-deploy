FROM node:14-alpine as builder

RUN apk add --no-cache curl \
    && curl -sL https://unpkg.com/@pnpm/self-installer | node

WORKDIR /app

ADD package.json pnpm-lock.yaml /app

RUN pnpm i

ADD . /app

RUN pnpm run build

CMD npx serve -s dist

EXPOSE 3000

