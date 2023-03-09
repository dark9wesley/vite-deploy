FROM node:14-alpine

RUN npm i pnpm -g

WORKDIR /app

ADD . /app

RUN pnpm i && pnpm run build

CMD npx serve -s dist

EXPOSE 3000

