FROM node:14-alpine as builder

ARG ACCESS_KEY_ID
ARG ACCESS_KEY_SECRET
ARG ENDPOINT
ENV PUBLIC_URL https://wesley-peng.oss-cn-shenzhen.aliyuncs.com/

RUN npm install -g pnpm

WORKDIR /app

# 为了更好的缓存，把它放在前边
RUN wget http://gosspublic.alicdn.com/ossutil/1.7.7/ossutil64 -O /usr/local/bin/ossutil \
  && chmod 755 /usr/local/bin/ossutil \
  && ossutil config -i $ACCESS_KEY_ID -k $ACCESS_KEY_SECRET -e $ENDPOINT

ADD package.json pnpm-lock.yaml /app/

RUN pnpm i

ADD . /app

RUN pnpm run build && pnpm run oss:cli

# 选择更小的nginx镜像做服务
FROM nginx:alpine

ADD nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder app/dist /usr/share/nginx/html

