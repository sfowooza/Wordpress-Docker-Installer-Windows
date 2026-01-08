# WordPress Docker Installer for Windows

An interactive PowerShell script that installs WordPress with Docker on Windows using MySQL, MariaDB, or PostgreSQL as the database backend.

**Version:** 1.0.0
**by Avodah Systems**

## Features

- **Interactive Installation Wizard** - Step-by-step guided setup
- **Multiple Database Support** - MySQL, MariaDB, and PostgreSQL
- **Auto-Configuration** - Automatically generates secure passwords
- **Docker Compose** - Uses Docker Compose for easy container management
- **WP-CLI Integration** - Automates WordPress core installation

## Requirements

- Windows 10/11 or Windows Server 2019+
- **Docker Desktop for Windows** - [Download here](https://www.docker.com/products/docker-desktop)
- PowerShell 5.1+ (included with Windows)
- Administrator privileges

## Installation

1. Clone or download this repository:
   ```powershell
   git clone https://github.com/sfowooza/Wordpress-Docker-Installer-Windows
   cd Wordpress-Docker-Installer-Windows
   ```

2. Run the installer as Administrator:
   ```powershell
   # Right-click on PowerShell and select "Run as Administrator"
   .\install.ps1
   ```

## Usage

### Interactive Installation

Simply run the script without arguments to start the installation wizard:

```powershell
.\install.ps1
```

The wizard will guide you through:
1. Database selection (MySQL, MariaDB, or PostgreSQL)
2. Port configuration
3. Site configuration (title, admin credentials)
4. WordPress URL
5. Database credentials (auto-generated for security)

### Management Commands

```powershell
# Start existing containers
.\install.ps1 start

# Stop containers
.\install.ps1 stop

# Restart containers
.\install.ps1 restart

# Show container status
.\install.ps1 status

# Show logs
.\install.ps1 logs

# Uninstall (remove containers and volumes)
.\install.ps1 uninstall

# Show help
.\install.ps1 help
```

## Database Options

### MySQL (Default)
- Most popular and well-tested
- Full compatibility with all WordPress plugins
- Image: `mysql:8.0`

### MariaDB
- Drop-in MySQL replacement with enhanced features
- Better performance for some workloads
- Image: `mariadb:11.1`

### PostgreSQL (Experimental)
- Advanced features
- Requires WP PG4WP plugin
- May have compatibility issues with some plugins
- Image: `postgres:16-alpine`

## Project Structure

```
.
├── install.ps1                      # Main installer script
├── Dockerfile                       # Custom WordPress image with WP-CLI
├── docker-compose.yml               # MySQL configuration
├── docker-compose.mariadb.yml       # MariaDB configuration
├── docker-compose.postgresql.yml    # PostgreSQL configuration
└── README.md                        # This file
```

## Generated Files

After installation, the following files are created:

- `.env` - Environment configuration with all settings
- `credentials.txt` - Your database and admin credentials (keep safe!)

## Troubleshooting

### "Script is disabled on this system"

If you see this error, you need to allow script execution:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Port Already in Use

The installer will detect if a port is in use and prompt you to choose another. Common ports to avoid:
- 80 (IIS)
- 443 (IIS)
- 3306 (MySQL)
- 5432 (PostgreSQL)
- 8080 (common alternative)

### Docker Not Running

Make sure Docker Desktop is running:
1. Check system tray for Docker icon
2. Open Docker Desktop
3. Wait for "Docker Desktop is running" message

### Access WordPress

After installation, access your site at:
- `http://localhost:PORT` (where PORT is what you chose during installation)
- Admin area: `http://localhost:PORT/wp-admin/`

## Security Notes

1. **Save Your Credentials** - Store `credentials.txt` securely
2. **Change Passwords** - Consider changing admin password after first login
3. **Firewall** - Consider using a reverse proxy for production
4. **Backups** - Use Docker volumes for data persistence

## Linux Version

A Linux version of this installer is available at:
https://github.com/sfowooza/Wordpress-Docker-Image-Install

## License

MIT License - Feel free to use and modify for your needs.

## Support

For issues and questions:
- GitHub Issues: https://github.com/sfowooza/Wordpress-Docker-Installer-Windows/issues
- Website: https://avodahsystems.com

## Changelog

### v1.0.0 (2025-01-08)
- Initial Windows release
- Support for MySQL, MariaDB, and PostgreSQL
- Interactive installation wizard
- Auto-configuration of WordPress
- Credential management
