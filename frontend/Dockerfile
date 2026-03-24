# --- Stage 1: React App එක Build කිරීම ---
FROM node:20-alpine AS builder
WORKDIR /app

# Docker Compose එකෙන් එවන දත්තය (Argument එක) ලබාගැනීම
ARG VITE_API_URL
# එය Environment Variable එකක් ලෙස සකසා ගැනීම
ENV VITE_API_URL=$VITE_API_URL

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build


# --- Stage 2: Nginx හරහා Serve කිරීම ---
FROM nginx:alpine
# පළමු අදියරේ සෑදූ dist ෆෝල්ඩරයේ ඇති ගොනු Nginx හි html ෆෝල්ඩරයට copy කිරීම
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

# Nginx ධාවනය කිරීම
CMD ["nginx", "-g", "daemon off;"]
