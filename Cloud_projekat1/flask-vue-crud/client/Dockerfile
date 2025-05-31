FROM node:14-alpine as builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# Set backend URL during build
ARG VUE_APP_API_URL
ENV VUE_APP_API_URL=$VUE_APP_API_URL

RUN npm run build

FROM node:14-alpine

WORKDIR /app

RUN npm install -g serve

COPY --from=builder /app/dist ./dist

EXPOSE 8080

CMD ["serve", "-s", "dist", "-l", "8080"]
