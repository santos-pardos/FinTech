# Dockerfile para Backend - FinTech Solutions S.A.
# Desarrollado por TechOps Solutions

# Etapa base con Node.js
FROM node:18-alpine AS base

# Información del mantenedor
LABEL maintainer="TechOps Solutions <devops@techops.com>"
LABEL description="Backend API para sistema de gestión financiera"
LABEL version="1.0.0"

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm ci --only=production && \
    npm cache clean --force

# Copiar código fuente
COPY server.js ./

# Exponer puerto de la aplicación
EXPOSE 3001

# Crear usuario no-root para seguridad
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

# Cambiar a usuario no-root
USER nodejs

# Health check para monitoreo
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3001/api/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Comando para iniciar la aplicación
CMD ["npm", "start"]