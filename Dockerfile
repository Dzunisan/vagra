FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json ./

RUN npm install -g pnpm

RUN pnpm install

COPY . .

RUN pnpm run build

FROM node:20-alpine

WORKDIR /app

RUN npm install -g pnpm

COPY --from=builder /app/package.json /app/pnpm-lock.yaml ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

RUN pnpm install --prod

EXPOSE 3000


CMD ["pnpm", "start"]
