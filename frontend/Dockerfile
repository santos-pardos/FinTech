# Dockerfile para Frontend - FinTech Solutions S.A.
# Desarrollado por TechOps Solutions

# Etapa 1: Build
FROM node:18-alpine AS builder

LABEL maintainer="TechOps Solutions <devops@techops.com>"
LABEL description="Frontend React para sistema de gestión financiera"

WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar todas las dependencias (incluyendo dev)
RUN npm ci && npm cache clean --force

# Copiar código fuente
COPY public/ ./public/
COPY src/ ./src/

# Build de producción
RUN npm run build

# Etapa 2: Producción con Nginx
FROM nginx:alpine

# Copiar build de React al directorio de Nginx
COPY --from=builder /app/build /usr/share/nginx/html

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer puerto 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:80/ || exit 1

# Iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]