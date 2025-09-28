#!/bin/bash

# Kali Linux Docker Helper Script
# Usage: ./kali.sh [command]

set -e

CONTAINER_NAME="kali-linux-container"

show_help() {
    echo "Kali Linux Docker Helper"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start       - Start Kali Linux container"
    echo "  stop        - Stop Kali Linux container"
    echo "  restart     - Restart Kali Linux container"
    echo "  shell       - Open bash shell in container"
    echo "  ssh         - Connect via SSH (password: kali123)"
    echo "  logs        - Show container logs"
    echo "  status      - Show container status"
    echo "  update      - Update Kali packages"
    echo "  install     - Install Kali tools metapackage"
    echo "  clean       - Stop and remove container"
    echo "  help        - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 shell"
    echo "  $0 install kali-tools-top10"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker tidak terinstall. Install Docker terlebih dahulu."
        exit 1
    fi

    if ! docker compose version &> /dev/null; then
        echo "❌ Docker Compose tidak terinstall atau tidak support. Install Docker Compose terlebih dahulu."
        exit 1
    fi
}

container_running() {
    docker ps --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"
}

container_exists() {
    docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"
}

case "${1:-help}" in
    "start")
        check_docker
        echo "🚀 Starting Kali Linux container..."
        docker compose up -d
        echo "✅ Kali Linux container started!"
        echo "💡 Use '$0 shell' to access terminal"
        ;;
    
    "stop")
        echo "🛑 Stopping Kali Linux container..."
        docker compose down
        echo "✅ Container stopped!"
        ;;
    
    "restart")
        echo "🔄 Restarting Kali Linux container..."
        docker compose restart
        echo "✅ Container restarted!"
        ;;
    
    "shell")
        if ! container_running; then
            echo "❌ Container tidak berjalan. Jalankan '$0 start' terlebih dahulu."
            exit 1
        fi
        echo "🖥️  Membuka shell Kali Linux..."
        docker exec -it $CONTAINER_NAME /bin/bash
        ;;
    
    "ssh")
        if ! container_running; then
            echo "❌ Container tidak berjalan. Jalankan '$0 start' terlebih dahulu."
            exit 1
        fi
        echo "🔐 Connecting via SSH (password: kali123)..."
        ssh root@localhost -p 22
        ;;
    
    "logs")
        echo "📋 Container logs:"
        docker compose logs -f $CONTAINER_NAME
        ;;
    
    "status")
        echo "📊 Container Status:"
        if container_running; then
            echo "✅ Container is running"
            docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        elif container_exists; then
            echo "⚠️  Container exists but not running"
            docker ps -a --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}"
        else
            echo "❌ Container does not exist"
        fi
        ;;
    
    "update")
        if ! container_running; then
            echo "❌ Container tidak berjalan. Jalankan '$0 start' terlebih dahulu."
            exit 1
        fi
        echo "📦 Updating Kali packages..."
        docker exec -it $CONTAINER_NAME bash -c "apt update && apt upgrade -y"
        echo "✅ Update completed!"
        ;;
    
    "install")
        if ! container_running; then
            echo "❌ Container tidak berjalan. Jalankan '$0 start' terlebih dahulu."
            exit 1
        fi
        
        PACKAGE=${2:-kali-tools-top10}
        echo "📦 Installing $PACKAGE..."
        docker exec -it $CONTAINER_NAME bash -c "apt update && apt install -y $PACKAGE"
        echo "✅ Installation completed!"
        ;;
    
    "clean")
        echo "🧹 Cleaning up..."
        docker compose down -v
        docker system prune -f
        echo "✅ Cleanup completed!"
        ;;
    
    "help"|*)
        show_help
        ;;
esac