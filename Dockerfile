FROM node:14-alpine as builder

RUN apk add --no-cache curl \
    && curl -sL https://unpkg.com/@pnpm/self-installer | node

WORKDIR /app

ADD package.json pnpm-lock.yaml /app/

RUN pnpm i

ADD . /app

RUN pnpm run build

# 选择更小的nginx镜像做服务
FROM nginx:alpine

ADD nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder app/dist /usr/share/nginx/html

