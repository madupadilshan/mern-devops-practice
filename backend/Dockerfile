# Node.js base image (patched Alpine stream)
FROM node:20-alpine3.22

# Container එක ඇතුළත වැඩ කරන ෆෝල්ඩරය (Working Directory) සකස් කිරීම
WORKDIR /app

# Pull latest security patches (including OpenSSL / libcrypto / libssl)
RUN apk upgrade --no-cache

# Package.json ගොනු පමණක් පළමුව copy කිරීම (කාලය ඉතිරි කරගැනීමට)
COPY package*.json ./

# අවශ්‍ය dependencies install කිරීම
RUN npm install

# ඉතිරි සියලුම කේතයන් සහ ගොනු copy කිරීම
COPY . .

# Backend එක ධාවනය වන port එක විවෘත කිරීම
EXPOSE 5000

# App එක start කිරීමට අවශ්‍ය විධානය ලබා දීම
CMD ["npm", "start"]
