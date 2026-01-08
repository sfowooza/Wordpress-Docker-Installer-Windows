# WordPress Docker Installer for Windows

A **graphical installer** for WordPress on Windows using Docker. Simply double-click and follow the wizard!

**Version:** 1.0.0
**by Avodah Systems**

![Windows](https://img.shields.io/badge/Windows-10/11-blue) ![Docker](https://img.shields.io/badge/Docker-Desktop-blue)

## 🚀 Quick Start (3 Steps)

1. **Download** - Download and extract the ZIP file
2. **Double-click** - Run `Install-WordPress.bat`
3. **Follow the wizard** - Click through the installation steps

That's it! Your WordPress site will be running in minutes. 🎉

---

## 📋 Requirements

- **Windows 10/11** or **Windows Server 2019+**
- **Docker Desktop for Windows** - [Download](https://www.docker.com/products/docker-desktop)
- **Administrator privileges** (requested automatically by the installer)

---

## 🎬 Installation Walkthrough

### Step 1: Choose Your Database

| Option | Description | Recommended |
|--------|-------------|--------------|
| 🐬 **MySQL** | Most popular, best plugin compatibility | ✅ Yes |
| 🐘 **MariaDB** | Enhanced MySQL alternative | ✅ Yes |
| 🐘 **PostgreSQL** | Advanced features (requires plugin) | ⚠️ Experimental |

### Step 2: Configure Port

- Choose a port for WordPress (default: `8080`)
- Click **Check Port** to verify availability
- Quick-select buttons: `8080`, `8081`, `8185`, `8186`

### Step 3: Configure Your Site

- **Site Title**: Your WordPress site name
- **WordPress URL**: Your site address (e.g., `localhost:8080`)

### Step 4: Create Admin Account

- **Username**: Your admin username
- **Password**: Minimum 8 characters (or click 🔐 **Generate** for a secure password)
- **Email**: Your admin email address

### Step 5: Installation

- Watch the installation progress
- View real-time logs
- Click **Close** when complete

---

## 🎯 After Installation

### Access Your WordPress Site

```
Website:  http://localhost:YOUR_PORT
Admin:     http://localhost:YOUR_PORT/wp-admin/
```

### Your Credentials

The installer saves your credentials to **`credentials.txt`**:
- Admin username and password
- Database connection details
- **Keep this file secure!**

---

## 🛠️ Advanced Management

After installation, you can manage containers using Docker Desktop or use these commands in PowerShell:

```powershell
# Start containers
docker compose up -d

# Stop containers
docker compose down

# View logs
docker compose logs -f

# Remove everything
docker compose down -v
docker volume rm wordpress-docker-installer-windows_wordpress_data
docker volume rm wordpress-docker-installer-windows_db_data
```

---

## ❓ Troubleshooting

### "Windows protected your PC"

Click **More info** → **Run anyway** to proceed.

### Script execution is disabled

The installer handles this automatically. If prompted, click **Run anyway**.

### Docker Desktop is not running

1. Open **Docker Desktop** from the Start Menu
2. Wait for "Docker Desktop is running" message
3. Run the installer again

### Port is already in use

The installer will warn you. Choose a different port:
- Try: `8081`, `8082`, `8185`, `8186`, `8187`
- Avoid: `80` (IIS), `3306` (MySQL), `5432` (PostgreSQL)

### Installation seems stuck

1. Check Docker Desktop is running
2. Open Docker Desktop and check for errors
3. Ensure no other WordPress is using the same port
4. Check the logs in the installer window

---

## 📁 What's Included

```
Wordpress-Docker-Installer-Windows/
├── Install-WordPress.bat      # Double-click this to start
├── GUI-Installer.ps1            # Graphical installation wizard
├── Dockerfile                   # WordPress image with WP-CLI
├── docker-compose.yml           # MySQL configuration
├── docker-compose.mariadb.yml   # MariaDB configuration
├── docker-compose.postgresql.yml # PostgreSQL configuration
└── README.md                    # This file
```

---

## 🔒 Security Notes

1. **Save your credentials** - Keep `credentials.txt` in a safe place
2. **Change password** - Consider changing the admin password after first login
3. **Production use** - For production, consider:
   - Using a reverse proxy (nginx/traefik)
   - Setting up SSL certificates
   - Using a firewall
4. **Backups** - Your data persists in Docker volumes

---

## 🐧 Linux Version

A Linux version of this installer is available:
https://github.com/sfowooza/Wordpress-Docker-Image-Install

---

## 📄 License

MIT License - Free to use and modify.

---

## 🆘 Support

- **Issues**: https://github.com/sfowooza/Wordpress-Docker-Installer-Windows/issues
- **Website**: https://avodahsystems.com

---

## 📝 Changelog

### v1.0.0 (2025-01-08)
- Initial release
- Pure graphical installation wizard (no CLI required)
- 5-step wizard with visual progress tracking
- Support for MySQL, MariaDB, and PostgreSQL
- Port availability checking
- Secure password generation
- Real-time installation logs
