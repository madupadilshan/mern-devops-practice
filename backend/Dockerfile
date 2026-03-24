# --- Stage 1: Dependencies Install කිරීම ---
FROM node:20-alpine AS deps

# OS එකේ ආරක්ෂක සිදුරු වසා දැමීම (Patching OS vulnerabilities)
RUN apk update && apk upgrade --no-cache

WORKDIR /app
# Package files පමණක් මුලින් copy කිරීමෙන් Docker layer caching ප්‍රයෝජනයට ගත හැක
COPY package*.json ./
# Production සඳහා අවශ්‍ය පැකේජ පමණක් install කිරීම (dev dependencies ඉවත් කර ඇත)
RUN npm ci --only=production

# --- Stage 2: Production Image එක සැකසීම ---
FROM node:20-alpine

# මෙහිදීද OS එක යාවත්කාලීන කිරීම (ආරක්ෂාව සඳහා ඉතා වැදගත්)
RUN apk update && apk upgrade --no-cache

WORKDIR /app

# ආරක්ෂාව සඳහා පෙරනිමි 'node' නැමැති non-root user භාවිතා කිරීම
USER node

# පළමු අදියරෙන් (deps) node_modules ෆෝල්ඩරය පමණක් ලබා ගැනීම
COPY --chown=node:node --from=deps /app/node_modules ./node_modules

# ඉතිරි කේතය copy කිරීම (හිමිකාරීත්වය node user ට ලබාදෙමින්)
COPY --chown=node:node . .

# Backend එක ධාවනය වන Port එක
EXPOSE 5000

# යෙදුම ධාවනය කිරීම
CMD ["npm", "start"]
