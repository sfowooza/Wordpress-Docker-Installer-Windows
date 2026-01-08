# WordPress Docker Installer for Windows
# by Avodah Systems
# Version: 1.0.0

Requires -RunAsAdministrator

# Configuration arrays
$script:DbImages = @{
    "mysql"      = "mysql:8.0"
    "mariadb"    = "mariadb:11.1"
    "postgresql" = "postgres:16-alpine"
}

$script:DbHosts = @{
    "mysql"      = "db:3306"
    "mariadb"    = "db:3306"
    "postgresql" = "db:5432"
}

$script:DbEnvPrefix = @{
    "mysql"      = "MYSQL_"
    "mariadb"    = "MARIADB_"
    "postgresql" = "POSTGRES_"
}

$script:DbRootEnv = @{
    "mysql"      = "MYSQL_ROOT_PASSWORD"
    "mariadb"    = "MARIADB_ROOT_PASSWORD"
    "postgresql" = "POSTGRES_PASSWORD"
}

$script:ComposeFiles = @{
    "mysql"      = "docker-compose.yml"
    "mariadb"    = "docker-compose.mariadb.yml"
    "postgresql" = "docker-compose.postgresql.yml"
}

# Color output functions
function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  $Message" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Blue
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Prompt {
    param([string]$Message)
    Write-Host -NoNewline $Message
}

function Show-Banner {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║   WordPress Docker Installer v1.0.0        ║" -ForegroundColor Cyan
    Write-Host "║   by Avodah Systems                        ║" -ForegroundColor Cyan
    Write-Host "║   Windows Version                           ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Info "This wizard will guide you through installing WordPress with Docker."
    Write-Host ""
}

# Utility functions
function Test-PortAvailable {
    param([int]$Port)

    $connection = New-Object System.Net.Sockets.TcpListener
    try {
        $localEndpoint = New-Object System.Net.IPEndPoint([System.Net.IPAddress]::Loopback, $Port)
        $listener = New-Object System.Net.Sockets.TcpListener $localEndpoint
        $listener.Start()
        $listener.Stop()
        return $true
    } catch {
        return $false
    }
}

function Test-ValidEmail {
    param([string]$Email)
    return $Email -match '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
}

function New-RandomPassword {
    param([int]$Length = 16)

    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*'
    $password = -join (1..$Length | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    return $password
}

function Test-DockerInstalled {
    try {
        $null = docker --version 2>&1
        return $?
    } catch {
        return $false
    }
}

function Test-DockerComposeInstalled {
    try {
        $null = docker compose version 2>&1
        return $?
    } catch {
        return $false
    }
}

function Test-DockerRunning {
    try {
        $null = docker ps 2>&1
        return $?
    } catch {
        return $false
    }
}

# Main installation wizard
function Invoke-InstallationWizard {
    Show-Banner

    # Check dependencies
    Write-Info "Checking dependencies..."
    $allGood = $true

    if (-not (Test-DockerInstalled)) {
        Write-Error "Docker is not installed or not in PATH"
        Write-Info "Please install Docker Desktop for Windows from: https://www.docker.com/products/docker-desktop"
        $allGood = $false
    } else {
        Write-Success "Docker is installed"
    }

    if (-not (Test-DockerComposeInstalled)) {
        Write-Error "Docker Compose is not available"
        $allGood = $false
    } else {
        Write-Success "Docker Compose is available"
    }

    if (-not (Test-DockerRunning)) {
        Write-Warning "Docker is not running. Please start Docker Desktop."
        $allGood = $false
    } else {
        Write-Success "Docker is running"
    }

    if (-not $allGood) {
        Write-Error "Please fix the above issues before continuing."
        exit 1
    }

    # Database Selection
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Step 0: Database Selection" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""

    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║       Choose Your Database Backend         ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Available database options:"
    Write-Host ""
    Write-Host "  1) MySQL      [Default] - Most popular, well-tested" -ForegroundColor Green
    Write-Host "  2) MariaDB    [Drop-in MySQL replacement] - Enhanced features" -ForegroundColor Green
    Write-Host "  3) PostgreSQL [Advanced] - Requires additional plugin" -ForegroundColor Green
    Write-Host ""
    Write-Info "MySQL and MariaDB work out of the box."
    Write-Info "PostgreSQL requires the 'WP PG4WP' plugin."
    Write-Host ""

    $dbChoice = "1"
    $validChoice = $false
    while (-not $validChoice) {
        Write-Prompt "Select database [1-3, default: 1]: "
        $input = Read-Host
        if ([string]::IsNullOrWhiteSpace($input)) {
            $input = "1"
        }

        switch ($input) {
            "1" {
                $dbType = "mysql"
                $dbDisplayName = "MySQL"
                $validChoice = $true
            }
            "2" {
                $dbType = "mariadb"
                $dbDisplayName = "MariaDB"
                $validChoice = $true
            }
            "3" {
                $dbType = "postgresql"
                $dbDisplayName = "PostgreSQL"
                Write-Warning "PostgreSQL requires the WP PG4WP plugin."
                Write-Prompt "Continue with PostgreSQL? [Y/n]: "
                $confirm = Read-Host
                if ($confirm -ne "n" -and $confirm -ne "N") {
                    $validChoice = $true
                } else {
                    continue
                }
            }
            default {
                Write-Error "Invalid choice. Please enter 1, 2, or 3."
            }
        }
    }
    Write-Success "Selected: $dbDisplayName"
    Write-Host ""

    # Port Configuration
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Step 1: Port Configuration" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""

    $wpPort = 8080
    $validPort = $false
    while (-not $validPort) {
        Write-Prompt "Enter the port for WordPress [default: 8080]: "
        $portInput = Read-Host
        if ([string]::IsNullOrWhiteSpace($portInput)) {
            $portInput = "8080"
        }

        if ($portInput -match '^\d+$' -and [int]$portInput -gt 0 -and [int]$portInput -le 65535) {
            $wpPort = [int]$portInput
            if (Test-PortAvailable -Port $wpPort) {
                Write-Success "Port $wpPort is available"
                $validPort = $true
            } else {
                Write-Error "Port $wpPort is already in use! Please choose another port."
            }
        } else {
            Write-Error "Please enter a valid port number (1-65535)."
        }
    }
    Write-Host ""

    # Site Configuration
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Step 2: Site Configuration" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""

    Write-Prompt "Enter your site title [default: My WordPress Site]: "
    $siteTitle = Read-Host
    if ([string]::IsNullOrWhiteSpace($siteTitle)) {
        $siteTitle = "My WordPress Site"
    }
    Write-Success "Site title set to: $siteTitle"

    Write-Prompt "Enter admin username [default: admin]: "
    $adminUser = Read-Host
    if ([string]::IsNullOrWhiteSpace($adminUser)) {
        $adminUser = "admin"
    }
    Write-Success "Admin username: $adminUser"

    # Password
    $validPassword = $false
    while (-not $validPassword) {
        Write-Prompt "Enter admin password (min 8 characters): "
        $adminPassword = Read-Host -AsSecureString
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($adminPassword))

        if ($plainPassword.Length -lt 8) {
            Write-Error "Password must be at least 8 characters long"
            continue
        }

        Write-Prompt "Confirm admin password: "
        $confirmPassword = Read-Host -AsSecureString
        $plainConfirm = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmPassword))

        if ($plainPassword -eq $plainConfirm) {
            Write-Success "Admin password set"
            $validPassword = $true
        } else {
            Write-Error "Passwords do not match"
        }
    }

    # Email
    $validEmail = $false
    while (-not $validEmail) {
        Write-Prompt "Enter admin email: "
        $adminEmail = Read-Host

        if (Test-ValidEmail -Email $adminEmail) {
            Write-Success "Admin email: $adminEmail"
            $validEmail = $true
        } else {
            Write-Error "Please enter a valid email address"
        }
    }
    Write-Host ""

    # WordPress URL
    Write-Prompt "Enter WordPress URL [default: localhost:$wpPort]: "
    $wpUrlInput = Read-Host
    if ([string]::IsNullOrWhiteSpace($wpUrlInput)) {
        $wpUrlInput = "localhost:$wpPort"
    }
    # Remove http:// or https:// prefix if present
    $wpUrl = $wpUrlInput -replace '^https?://', ''
    Write-Success "WordPress URL: $wpUrl"
    Write-Host ""

    # Database Configuration
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Step 3: Database Configuration" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    Write-Info "Database: $dbDisplayName"
    Write-Info "Press Enter to use auto-generated secure credentials"
    Write-Host ""

    Write-Prompt "Database name [default: wordpress]: "
    $dbName = Read-Host
    if ([string]::IsNullOrWhiteSpace($dbName)) {
        $dbName = "wordpress"
    }

    Write-Prompt "Database user [default: wpuser]: "
    $dbUser = Read-Host
    if ([string]::IsNullOrWhiteSpace($dbUser)) {
        $dbUser = "wpuser"
    }

    # Generate secure passwords
    $dbPassword = New-RandomPassword
    $dbRootPassword = New-RandomPassword
    Write-Success "Database configured with secure random passwords"
    Write-Host ""

    # Installation Summary
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Installation Summary" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Database:       $dbDisplayName"
    Write-Host "  Port:           $wpPort"
    Write-Host "  Site Title:     $siteTitle"
    Write-Host "  Admin Username: $adminUser"
    Write-Host "  Admin Email:    $adminEmail"
    Write-Host "  WordPress URL:  $wpUrl"
    Write-Host "  Database Name:  $dbName"
    Write-Host "  Database User:  $dbUser"
    Write-Host ""

    if ($dbType -eq "postgresql") {
        Write-Warning "Note: WP PG4WP plugin will be auto-installed for PostgreSQL support."
    }
    Write-Host ""

    # Confirmation
    Write-Prompt "Start installation with these settings? [Y/n]: "
    $confirm = Read-Host
    if ($confirm -eq "n" -or $confirm -eq "N") {
        Write-Info "Installation cancelled."
        exit 0
    }

    # Create environment file
    Write-Info "Creating environment configuration..."

    $composeFile = $script:ComposeFiles[$dbType]

    $envContent = @"
# WordPress Docker Configuration - Windows
DB_TYPE=$dbType
DB_IMAGE=$($script:DbImages[$dbType])
DB_HOST=$($script:DbHosts[$dbType])
DB_ENV_PREFIX=$($script:DbEnvPrefix[$dbType])
DB_ROOT_ENV=$($script:DbRootEnv[$dbType])

# WordPress Configuration
WP_PORT=$wpPort
WP_SITE_TITLE=$siteTitle
WP_ADMIN_USER=$adminUser
WP_ADMIN_PASSWORD=$plainPassword
WP_ADMIN_EMAIL=$adminEmail
WP_URL=$wpUrl

# Database Configuration
DB_NAME=$dbName
DB_USER=$dbUser
DB_PASSWORD=$dbPassword
DB_ROOT_PASSWORD=$dbRootPassword

# Auto-install WordPress
WP_AUTO_INSTALL=true
COMPOSE_FILE=$composeFile
"@

    $envContent | Out-File -FilePath ".env" -Encoding UTF8
    Write-Success "Environment file created"

    # Start installation
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "Starting WordPress Installation" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""

    # Clean up any previous installation
    Write-Info "Cleaning up any previous installation..."
    docker compose -f $composeFile down -v 2>$null
    docker rm -f wp_installer_wordpress wp_installer_db 2>$null

    # Pull images
    Write-Info "Pulling Docker images..."
    docker compose -f $composeFile pull

    # Start containers
    Write-Info "Starting Docker containers..."
    docker compose -f $composeFile up -d

    # Wait for WordPress to be ready
    Write-Host ""
    Write-Info "Waiting for WordPress to be ready..."
    Write-Host ""

    $maxAttempts = 60
    $attempt = 0
    while ($attempt -lt $maxAttempts) {
        $status = docker compose -f $composeFile ps --format json | ConvertFrom-Json
        $wpContainer = $status | Where-Object { $_.Service -eq "wordpress" }

        if ($wpContainer.State -eq "running" -and $wpContainer.Health -eq "healthy") {
            break
        }
        Write-Host -NoNewline "."
        Start-Sleep -Seconds 2
        $attempt++
    }

    Write-Host ""

    # Additional wait for WordPress to fully initialize
    Write-Info "Waiting for WordPress to be ready..."
    Start-Sleep -Seconds 15

    # Check if WordPress is accessible
    $maxHttpAttempts = 30
    $httpAttempt = 0
    while ($httpAttempt -lt $maxHttpAttempts) {
        try {
            $response = docker compose -f $composeFile exec -T wordpress curl -f http://localhost/ 2>$null
            if ($?) {
                Write-Host ""
                Write-Success "WordPress is responding!"
                break
            }
        } catch {
            # Ignore errors, just retry
        }
        Write-Host -NoNewline "."
        Start-Sleep -Seconds 2
        $httpAttempt++
    }

    Write-Host ""
    Write-Info "Configuring WordPress..."

    # Wait a bit more
    Start-Sleep -Seconds 5

    # Install WordPress core
    $installResult = docker compose -f $composeFile exec -T wordpress wp core install `
        --url="http://$wpUrl" `
        --title="$siteTitle" `
        --admin_user="$adminUser" `
        --admin_password="$plainPassword" `
        --admin_email="$adminEmail" `
        --skip-email `
        --allow-root 2>&1

    if ($installResult -match "Success") {
        Write-Success "WordPress installed successfully!"

        # Set permalink structure
        docker compose -f $composeFile exec -T wordpress wp rewrite structure '/%postname%/' --allow-root 2>$null | Out-Null
        Write-Success "Permalink structure set"

        # Delete default content
        docker compose -f $composeFile exec -T wordpress wp post delete 1 --force --allow-root 2>$null | Out-Null
        docker compose -f $composeFile exec -T wordpress wp post delete 2 --force --allow-root 2>$null | Out-Null
        Write-Success "Default content removed"

        # Activate default theme
        docker compose -f $composeFile exec -T wordpress wp theme activate twentytwentyfour --allow-root 2>$null
        if ($?) {
            Write-Success "Default theme activated"
        }
    } else {
        Write-Warning "WordPress installation may have issues, but container is running."
    }

    Write-Success "WordPress configured!"

    # Save credentials
    $credsContent = @"
WordPress Docker Installer - Credentials - Windows
Generated: $(Get-Date -Format "ddd MMM dd HH:mm:ss yyyy KST")

Database Type: $dbDisplayName

WordPress Site:
---------------
URL: http://$wpUrl
Admin Username: $adminUser
Admin Password: $plainPassword
Admin Email: $adminEmail

Database:
---------------
Database Type: $dbDisplayName
Database Name: $dbName
Database User: $dbUser
Database Password: $dbPassword
Root Password: $dbRootPassword

Keep this file secure!
"@

    $credsContent | Out-File -FilePath "credentials.txt" -Encoding UTF8
    Write-Success "Credentials saved to credentials.txt"

    # Done
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Success "Installation Complete!"
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    Write-Success "Your WordPress site is ready!"
    Write-Host ""
    Write-Host "  Database:       $dbDisplayName" -ForegroundColor Cyan
    Write-Host "  URL:            http://$wpUrl" -ForegroundColor Cyan
    Write-Host "  Admin Username: $adminUser" -ForegroundColor Cyan
    Write-Host "  Admin Password: $plainPassword" -ForegroundColor Cyan
    Write-Host ""
    Write-Warning "SAVE YOUR CREDENTIALS!"
    Write-Host ""
    Write-Info "Database credentials have been saved in the .env file."
    Write-Host ""
    Write-Host "Useful commands:" -ForegroundColor White
    Write-Host "  Stop:    docker compose down" -ForegroundColor Gray
    Write-Host "  Start:   docker compose up -d" -ForegroundColor Gray
    Write-Host "  Logs:    docker compose logs -f" -ForegroundColor Gray
    Write-Host "  Shell:   docker compose exec wordpress powershell" -ForegroundColor Gray
    Write-Host ""
    Write-Info "You can access your WordPress site at: http://$wpUrl"
    Write-Host ""
}

# Management functions
function Invoke-Uninstall {
    Show-Banner

    Write-Host "╔════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║     Uninstall WordPress Docker             ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""

    Write-Warning "This will stop and remove all WordPress containers and volumes."
    Write-Host ""

    Write-Prompt "Are you sure? [y/N]: "
    $confirm = Read-Host

    if ($confirm -ne "y" -and $confirm -ne "Y") {
        Write-Info "Uninstall cancelled."
        return
    }

    Write-Info "Stopping containers..."

    foreach ($composeFile in @("docker-compose.yml", "docker-compose.mariadb.yml", "docker-compose.postgresql.yml")) {
        if (Test-Path $composeFile) {
            docker compose -f $composeFile down -v 2>$null | Out-Null
        }
    }

    docker rm -f wp_installer_wordpress wp_installer_db 2>$null | Out-Null

    Write-Host ""
    Write-Info "Removing volumes..."

    @("wordpress-docker-installer-windows_wordpress_data", "wordpress-docker-installer-windows_db_data") | ForEach-Object {
        docker volume rm $_ 2>$null | Out-Null
    }

    # Clean up config files
    @(".env", "credentials.txt") | ForEach-Object {
        if (Test-Path $_) {
            Remove-Item $_ -Force
        }
    }

    Write-Success "Uninstallation complete"
}

function Start-Containers {
    if (-not (Test-Path ".env")) {
        Write-Error "No configuration found. Please run the installer first."
        return
    }

    # Get compose file from .env
    $envContent = Get-Content ".env" | Where-Object { $_ -match "COMPOSE_FILE=" }
    if ($envContent) {
        $composeFile = ($envContent -split "=")[1]
    } else {
        $composeFile = "docker-compose.yml"
    }

    Write-Info "Starting WordPress containers..."
    docker compose -f $composeFile up -d
    Write-Success "Containers started"

    Write-Host ""
    Write-Info "Access your site at the URL you configured during installation."
}

function Stop-Containers {
    Write-Info "Stopping WordPress containers..."

    foreach ($composeFile in @("docker-compose.yml", "docker-compose.mariadb.yml", "docker-compose.postgresql.yml")) {
        if (Test-Path $composeFile) {
            docker compose -f $composeFile down 2>$null | Out-Null
        }
    }

    Write-Success "Containers stopped"
}

function Restart-Containers {
    Stop-Containers
    Start-Sleep -Seconds 2
    Start-Containers
}

function Show-Logs {
    $composeFile = "docker-compose.yml"
    if (Test-Path ".env") {
        $envContent = Get-Content ".env" | Where-Object { $_ -match "COMPOSE_FILE=" }
        if ($envContent) {
            $composeFile = ($envContent -split "=")[1]
        }
    }

    Write-Info "Showing logs (Ctrl+C to exit)..."
    docker compose -f $composeFile logs -f
}

function Show-Status {
    $composeFile = "docker-compose.yml"
    if (Test-Path ".env") {
        $envContent = Get-Content ".env" | Where-Object { $_ -match "COMPOSE_FILE=" }
        if ($envContent) {
            $composeFile = ($envContent -split "=")[1]
        }
    }

    docker compose -f $composeFile ps
}

function Show-Help {
    Show-Banner

    Write-Host "Usage: .\install.ps1 [command]" -ForegroundColor White
    Write-Host ""
    Write-Host "Commands:" -ForegroundColor White
    Write-Host "  (none)    Run the installation wizard" -ForegroundColor Gray
    Write-Host "  start     Start existing WordPress containers" -ForegroundColor Gray
    Write-Host "  stop      Stop WordPress containers" -ForegroundColor Gray
    Write-Host "  restart   Restart WordPress containers" -ForegroundColor Gray
    Write-Host "  status    Show container status" -ForegroundColor Gray
    Write-Host "  logs      Show container logs" -ForegroundColor Gray
    Write-Host "  uninstall Remove all containers and volumes" -ForegroundColor Gray
    Write-Host "  help      Show this help message" -ForegroundColor Gray
    Write-Host ""
}

# Main entry point
function Main {
    # Check if running as administrator
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Error "This script requires administrator privileges. Please run PowerShell as Administrator."
        exit 1
    }

    $command = $args[0]

    switch ($command) {
        "start" { Start-Containers }
        "stop" { Stop-Containers }
        "restart" { Restart-Containers }
        "status" { Show-Status }
        "logs" { Show-Logs }
        "uninstall" { Invoke-Uninstall }
        "help" { Show-Help }
        "" { Invoke-InstallationWizard }
        default {
            Write-Error "Unknown command: $command"
            Show-Help
            exit 1
        }
    }
}

Main @args
