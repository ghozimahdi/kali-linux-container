# Kali Linux Docker Container

Proyek ini menyediakan setup Docker Compose untuk menjalankan Kali Linux dalam container dengan akses terminal lengkap.

## Fitur

- **Kali Linux Rolling** - Versi terbaru dari Kali Linux
- **SSH Server** - Akses remote melalui SSH
- **Persistent Storage** - Data disimpan dalam Docker volume
- **Shared Folder** - Folder shared antara host dan container
- **Network Access** - Port forwarding untuk berbagai layanan
- **Pre-installed Tools** - Sudah termasuk tools dasar seperti nano, vim, curl, wget, git

## Quick Start

### 1. Jalankan Container

```bash
# Menggunakan script helper (Recommended)
./kali.sh start

# Atau manual dengan docker compose
docker compose up -d
```

### 2. Akses Terminal Kali Linux

```bash
# Cara termudah dengan script helper
./kali.sh shell

# Atau manual
docker exec -it kali-linux-container /bin/bash
```

### 3. Akses via SSH (Optional)

```bash
# Via script helper
./kali.sh ssh

# Atau manual
ssh root@localhost
# Password: kali123
```

### 3. Update dan Install Tools Kali

Setelah masuk ke container, Anda bisa menginstall tools Kali:

```bash
# Update package list
apt update && apt upgrade -y

# Install Kali meta packages
apt install -y kali-tools-top10
# atau untuk full installation
# apt install -y kali-linux-large

# Install specific tools
apt install -y nmap sqlmap burpsuite hydra john aircrack-ng
```

## Struktur Directory

```
myhacking/
├── docker-compose.yml
├── shared/                 # Folder shared dengan container
└── README.md              # File ini
```

## Port Forwarding

Container mengexpose port berikut ke host:

- `22` - SSH Server
- `80` - HTTP
- `443` - HTTPS
- `8080` - Alternative HTTP

## Persistent Data

Data disimpan dalam Docker volume `kali-data` yang di-mount ke `/root` dalam container. Data akan tetap ada meskipun container dihapus.

## Useful Commands

### Management Container

```bash
# Dengan script helper (Recommended)
./kali.sh start          # Start container
./kali.sh stop           # Stop container
./kali.sh restart        # Restart container
./kali.sh logs           # View logs
./kali.sh status         # Check status
./kali.sh clean          # Remove everything

# Manual dengan docker compose
docker compose up -d     # Start container
docker compose down      # Stop container
docker compose restart  # Restart container
docker compose logs -f  # View logs
docker compose down -v  # Remove container dan volumes
```

### Dalam Container

```bash
# Update system
apt update && apt upgrade -y

# Install Kali metapackages
apt install kali-tools-top10

# Check network interfaces
ip addr show

# Start/stop services
service ssh start
service apache2 start
```

## Security Notes

⚠️ **Warning**: Container ini menggunakan password default `kali123` untuk user root.

Untuk production atau penggunaan yang lebih aman:

1. Ganti password default:

```bash
passwd root
```

2. Setup SSH key authentication
3. Disable password authentication di SSH
4. Gunakan user non-root

## Troubleshooting

### Container tidak start

```bash
# Check logs
docker-compose logs kali-linux

# Check container status
docker ps -a
```

### Tidak bisa connect SSH

```bash
# Pastikan SSH service running dalam container
docker exec -it kali-linux-container service ssh status

# Start SSH service jika belum running
docker exec -it kali-linux-container service ssh start
```

### Permission issues

Container berjalan dengan `privileged: true` untuk akses penuh ke system resources.

## Customization

Untuk menambahkan tools atau konfigurasi custom, edit section `command` dalam `docker-compose.yml` atau buat Dockerfile custom.

## Support

Jika mengalami masalah, periksa:

1. Docker dan Docker Compose terinstall dengan benar
2. Port tidak bentrok dengan aplikasi lain
3. Cukup disk space untuk image Kali Linux (~2GB+)
