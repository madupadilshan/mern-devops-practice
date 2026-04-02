# --- Stage 1: Build කිරීම ---
FROM node:20-alpine3.22 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Vite හරහා React app එක dist folder එකට build කිරීම
RUN npm run build

# --- Stage 2: Serve කිරීම (Nginx භාවිතයෙන්) ---
FROM nginx:alpine
# පළමු අදියරේදී සෑදුණු dist ෆෝල්ඩරයේ ඇති ගොනු ටික පමණක් Nginx වෙතට copy කිරීම
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
