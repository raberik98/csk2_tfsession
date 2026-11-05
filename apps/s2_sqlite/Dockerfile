FROM oven/bun:1-alpine

WORKDIR /app

COPY index.js .

USER bun

EXPOSE 3000

CMD ["bun", "run", "index.js"]