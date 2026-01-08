# WordPress Docker Installer for Windows

A **graphical installer** for WordPress on Windows using Docker. No command-line knowledge required!

**Version:** 1.0.0
**by Avodah Systems**

![Screenshot](https://img.shields.io/badge/Windows-10/11-blue) ![Docker](https://img.shields.io/badge/Docker-Desktop-blue) ![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue)

## Features

- **🖥️ Graphical Installation Wizard** - No command line needed
- **🗄️ Multiple Database Support** - MySQL, MariaDB, PostgreSQL
- **🔐 Auto-Security** - Automatically generates secure passwords
- **✅ Port Availability Checking** - Validates ports before installation
- **📊 Progress Tracking** - Visual installation progress
- **🎨 Modern UI** - Clean, intuitive interface

## Screenshots

### Welcome Screen
![Step 1: Database Selection](docs/screenshot1.png)

### Port Configuration
![Step 2: Port](docs/screenshot2.png)

### Installation Progress
![Step 3: Progress](docs/screenshot3.png)

## Requirements

- **Windows 10/11** or **Windows Server 2019+**
- **Docker Desktop for Windows** - [Download here](https://www.docker.com/products/docker-desktop)
- **Administrator privileges** (requested automatically)
- **PowerShell 5.1+** (included with Windows)

## Quick Start

### Option 1: Double-Click (Easiest)

1. Download and extract the ZIP file
2. Double-click `Install-WordPress.bat`
3. Follow the installation wizard
4. Done! 🎉

### Option 2: Right-Click Run

1. Download and extract the ZIP file
2. Right-click on `Install-WordPress.bat`
3. Select "Run as administrator"
4. Follow the installation wizard

## Installation Steps

### Step 1: Choose Your Database

| Database | Description | Recommended |
|----------|-------------|--------------|
| **MySQL** | Most popular, best plugin compatibility | ✅ Yes |
| **MariaDB** | Enhanced MySQL alternative | ✅ Yes |
| **PostgreSQL** | Advanced, requires plugin | ⚠️ Experimental |

### Step 2: Configure Port

- Choose a port for WordPress (default: 8080)
- The installer checks if the port is available
- Quick-select buttons for common ports

### Step 3: Site Configuration

- Enter your site title
- Enter your WordPress URL (e.g., `localhost:8080`)

### Step 4: Admin Account

- Create your admin username
- Set admin password (or generate secure one)
- Enter admin email

### Step 5: Installation

- Watch real-time progress
- Automatic WordPress configuration
- View installation logs

## After Installation

### Access Your Site

```
URL: http://localhost:PORT
Admin: http://localhost:PORT/wp-admin/
```

### Generated Files

- **`.env`** - Configuration file (keep it safe!)
- **`credentials.txt`** - Your login credentials (save this!)

### Management Commands

You can also use the command-line version for advanced management:

```powershell
# Start containers
.\install.ps1 start

# Stop containers
.\install.ps1 stop

# Restart containers
.\install.ps1 restart

# View status
.\install.ps1 status

# View logs
.\install.ps1 logs

# Uninstall
.\install.ps1 uninstall
```

## Troubleshooting

### "Windows protected your PC"

Click "More info" → "Run anyway" to allow the installer.

### Script Execution Issues

Open PowerShell as Administrator and run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Docker Not Running

1. Open Docker Desktop from Start Menu
2. Wait for "Docker Desktop is running" message
3. Run the installer again

### Port Already in Use

The installer will warn you. Choose a different port:
- Try 8081, 8082, 8185, 8186, etc.
- Avoid: 80 (IIS), 3306 (MySQL), 5432 (PostgreSQL)

### Installation Failed

1. Check Docker Desktop is running
2. Verify you have administrator privileges
3. Check the logs in the installer window
4. Ensure port is not in use by another application

## Advanced Usage

### Command-Line Installer

For advanced users who prefer command-line:
```powershell
.\install.ps1
```

### Custom Configuration

Edit the `.env` file after installation for advanced settings.

## Project Structure

```
Wordpress-Docker-Installer-Windows/
├── Install-WordPress.bat      # Double-click this to start
├── GUI-Installer.ps1            # Graphical installer
├── install.ps1                  # Command-line installer
├── Dockerfile                   # WordPress image with WP-CLI
├── docker-compose.yml           # MySQL configuration
├── docker-compose.mariadb.yml   # MariaDB configuration
├── docker-compose.postgresql.yml # PostgreSQL configuration
└── README.md                    # This file
```

## Security Notes

1. **Save your credentials** - Keep `credentials.txt` secure
2. **Change default password** - Consider changing admin password after first login
3. **Firewall** - For production, consider using a reverse proxy
4. **Backups** - Data persists in Docker volumes

## Linux Version

A Linux version of this installer is available:
https://github.com/sfowooza/Wordpress-Docker-Image-Install

## License

MIT License - Free to use and modify.

## Support

- **Issues**: https://github.com/sfowooza/Wordpress-Docker-Installer-Windows/issues
- **Website**: https://avodahsystems.com

## Changelog

### v1.0.0 (2025-01-08)
- Initial release
- Graphical installation wizard
- Support for MySQL, MariaDB, PostgreSQL
- Port availability checking
- Real-time installation progress
- Secure password generation
