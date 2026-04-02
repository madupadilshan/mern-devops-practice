# Node.js හි සැහැල්ලු (lightweight) සංස්කරණයක් පදනම් කරගැනීම
FROM node:18-alpine

# Container එක ඇතුළත වැඩ කරන ෆෝල්ඩරය (Working Directory) සකස් කිරීම
WORKDIR /app

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
