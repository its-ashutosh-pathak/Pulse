FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY src ./src

EXPOSE 7860

# Hugging Face exposes port 7860 by default
ENV PORT 7860

CMD ["node", "src/app.js"]
