#!/bin/bash

# Script de despliegue para FinTech Solutions S.A.
# Desarrollado por TechOps Solutions

set -e

echo "================================================"
echo "  FinTech Solutions S.A. - Sistema DevOps"
echo "  Deployment Script v1.0"
echo "================================================"
echo ""

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Función para mostrar mensajes
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    log_error "Docker no está instalado. Por favor instale Docker primero."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    log_error "Docker Compose no está instalado. Por favor instale Docker Compose primero."
    exit 1
fi

log_success "Docker y Docker Compose están instalados correctamente"

# Menú principal
show_menu() {
    echo ""
    echo "Seleccione una opción:"
    echo "1) Construir imágenes Docker"
    echo "2) Iniciar aplicación"
    echo "3) Detener aplicación"
    echo "4) Ver logs"
    echo "5) Limpiar todo (contenedores, imágenes, volúmenes)"
    echo "6) Push a Docker Hub"
    echo "7) Pull desde Docker Hub"
    echo "8) Estado de contenedores"
    echo "9) Salir"
    echo ""
}

# Construir imágenes
build_images() {
    log_info "Construyendo imágenes Docker..."
    docker-compose build --no-cache
    log_success "Imágenes construidas exitosamente"
}

# Iniciar aplicación
start_app() {
    log_info "Iniciando aplicación FinTech Solutions..."
    docker-compose up -d
    log_success "Aplicación iniciada correctamente"
    echo ""
    log_info "Acceda a la aplicación en:"
    echo "  - Frontend: http://localhost"
    echo "  - Backend API: http://localhost:3001"
    echo "  - Base de datos: localhost:5432"
}

# Detener aplicación
stop_app() {
    log_info "Deteniendo aplicación..."
    docker-compose down
    log_success "Aplicación detenida"
}

# Ver logs
view_logs() {
    echo "Seleccione el servicio:"
    echo "1) Frontend"
    echo "2) Backend"
    echo "3) Base de datos"
    echo "4) Todos"
    read -p "Opción: " log_option
    
    case $log_option in
        1) docker-compose logs -f frontend ;;
        2) docker-compose logs -f backend ;;
        3) docker-compose logs -f db ;;
        4) docker-compose logs -f ;;
        *) log_error "Opción inválida" ;;
    esac
}

# Limpiar todo
clean_all() {
    read -p "¿Está seguro de eliminar TODOS los contenedores, imágenes y volúmenes? (y/n): " confirm
    if [ "$confirm" == "y" ]; then
        log_info "Limpiando todos los recursos Docker..."
        docker-compose down -v --rmi all
        log_success "Limpieza completada"
    else
        log_info "Operación cancelada"
    fi
}

# Push a Docker Hub
push_to_hub() {
    read -p "Ingrese su usuario de Docker Hub: " docker_user
    
    log_info "Etiquetando imágenes..."
    docker tag fintech_backend:latest $docker_user/fintech-backend:latest
    docker tag fintech_frontend:latest $docker_user/fintech-frontend:latest
    
    log_info "Subiendo imágenes a Docker Hub..."
    docker push $docker_user/fintech-backend:latest
    docker push $docker_user/fintech-frontend:latest
    
    log_success "Imágenes subidas exitosamente a Docker Hub"
}

# Pull desde Docker Hub
pull_from_hub() {
    read -p "Ingrese el usuario de Docker Hub: " docker_user
    
    log_info "Descargando imágenes desde Docker Hub..."
    docker pull $docker_user/fintech-backend:latest
    docker pull $docker_user/fintech-frontend:latest
    
    log_success "Imágenes descargadas exitosamente"
}

# Estado de contenedores
check_status() {
    log_info "Estado actual de los contenedores:"
    echo ""
    docker-compose ps
    echo ""
    log_info "Uso de recursos:"
    docker stats --no-stream
}

# Loop principal
while true; do
    show_menu
    read -p "Ingrese su opción: " option
    
    case $option in
        1) build_images ;;
        2) start_app ;;
        3) stop_app ;;
        4) view_logs ;;
        5) clean_all ;;
        6) push_to_hub ;;
        7) pull_from_hub ;;
        8) check_status ;;
        9) 
            log_info "Saliendo..."
            exit 0
            ;;
        *)
            log_error "Opción inválida. Por favor intente nuevamente."
            ;;
    esac
    
    read -p "Presione Enter para continuar..."
done