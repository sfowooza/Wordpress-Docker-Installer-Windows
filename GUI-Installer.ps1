# WordPress Docker Installer for Windows
# by Avodah Systems
# Version: 1.0.0

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "WordPress Docker Installer v1.0.0"
$form.Size = New-Object System.Drawing.Size(700, 550)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::White

# Title Panel
$titlePanel = New-Object System.Windows.Forms.Panel
$titlePanel.Location = New-Object System.Drawing.Point(0, 0)
$titlePanel.Size = New-Object System.Drawing.Size(700, 80)
$titlePanel.BackColor = [System.Drawing.Color]::FromArgb(45, 125, 154)
$form.Controls.Add($titlePanel)

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "WordPress Docker Installer"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.Size = New-Object System.Drawing.Size(400, 35)
$titlePanel.Controls.Add($titleLabel)

# Subtitle Label
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "by Avodah Systems | Windows Edition"
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 220, 230)
$subtitleLabel.Location = New-Object System.Drawing.Point(20, 50)
$subtitleLabel.Size = New-Object System.Drawing.Size(300, 20)
$titlePanel.Controls.Add($subtitleLabel)

# Step Panel
$stepPanel = New-Object System.Windows.Forms.Panel
$stepPanel.Location = New-Object System.Drawing.Point(20, 100)
$stepPanel.Size = New-Object System.Drawing.Size(660, 370)
$stepPanel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$stepPanel.BackColor = [System.Drawing.Color]::FromArgb(250, 250, 250)
$form.Controls.Add($stepPanel)

# Progress Indicator
$progressPanel = New-Object System.Windows.Forms.Panel
$progressPanel.Location = New-Object System.Drawing.Point(20, 480)
$progressPanel.Size = New-Object System.Drawing.Size(660, 4)
$progressPanel.BackColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$form.Controls.Add($progressPanel)

# Step Progress Circles
function Create-StepCircle {
    param([int]$X, [string]$Number, [bool]$Active)

    $circle = New-Object System.Windows.Forms.Panel
    $circle.Location = New-Object System.Drawing.Point($X, 465)
    $circle.Size = New-Object System.Drawing.Size(30, 30)
    $circle.BackColor = if ($Active) { [System.Drawing.Color]::FromArgb(45, 125, 154) } else { [System.Drawing.Color]::FromArgb(200, 200, 200) }

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Number
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $label.ForeColor = [System.Drawing.Color]::White
    $label.TextAlign = "MiddleCenter"
    $label.Dock = "Fill"
    $circle.Controls.Add($label)

    return $circle
}

# Current step tracking
$script:CurrentStep = 0

# Step labels
$stepLabel1 = New-Object System.Windows.Forms.Label
$stepLabel1.Text = "Database"
$stepLabel1.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$stepLabel1.Location = New-Object System.Drawing.Point(30, 500)
$stepLabel1.Size = New-Object System.Drawing.Size(50, 20)
$stepLabel1.TextAlign = "MiddleCenter"
$form.Controls.Add($stepLabel1)

$stepLabel2 = New-Object System.Windows.Forms.Label
$stepLabel2.Text = "Port"
$stepLabel2.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$stepLabel2.Location = New-Object System.Drawing.Point(150, 500)
$stepLabel2.Size = New-Object System.Drawing.Size(50, 20)
$stepLabel2.TextAlign = "MiddleCenter"
$form.Controls.Add($stepLabel2)

$stepLabel3 = New-Object System.Windows.Forms.Label
$stepLabel3.Text = "Site"
$stepLabel3.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$stepLabel3.Location = New-Object System.Drawing.Point(270, 500)
$stepLabel3.Size = New-Object System.Drawing.Size(50, 20)
$stepLabel3.TextAlign = "MiddleCenter"
$form.Controls.Add($stepLabel3)

$stepLabel4 = New-Object System.Windows.Forms.Label
$stepLabel4.Text = "Admin"
$stepLabel4.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$stepLabel4.Location = New-Object System.Drawing.Point(390, 500)
$stepLabel4.Size = New-Object System.Drawing.Size(50, 20)
$stepLabel4.TextAlign = "MiddleCenter"
$form.Controls.Add($stepLabel4)

$stepLabel5 = New-Object System.Windows.Forms.Label
$stepLabel5.Text = "Install"
$stepLabel5.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$stepLabel5.Location = New-Object System.Drawing.Point(510, 500)
$stepLabel5.Size = New-Object System.Drawing.Size(50, 20)
$stepLabel5.TextAlign = "MiddleCenter"
$form.Controls.Add($stepLabel5)

function Update-StepIndicators {
    param([int]$Step)

    $form.Controls.Remove($circle1) 2>$null
    $form.Controls.Remove($circle2) 2>$null
    $form.Controls.Remove($circle3) 2>$null
    $form.Controls.Remove($circle4) 2>$null
    $form.Controls.Remove($circle5) 2>$null

    $circle1 = Create-StepCircle -X 35 -Number "1" -Active ($Step -ge 1)
    $circle2 = Create-StepCircle -X 155 -Number "2" -Active ($Step -ge 2)
    $circle3 = Create-StepCircle -X 275 -Number "3" -Active ($Step -ge 3)
    $circle4 = Create-StepCircle -X 395 -Number "4" -Active ($Step -ge 4)
    $circle5 = Create-StepCircle -X 515 -Number "5" -Active ($Step -ge 5)

    $form.Controls.Add($circle1)
    $form.Controls.Add($circle2)
    $form.Controls.Add($circle3)
    $form.Controls.Add($circle4)
    $form.Controls.Add($circle5)
}

# Buttons
$backButton = New-Object System.Windows.Forms.Button
$backButton.Text = "← Back"
$backButton.Location = New-Object System.Drawing.Point(480, 490)
$backButton.Size = New-Object System.Drawing.Size(90, 35)
$backButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$backButton.FlatStyle = "Flat"
$backButton.Cursor = "Hand"
$backButton.Add_Click({ Show-PreviousStep })
$form.Controls.Add($backButton)

$nextButton = New-Object System.Windows.Forms.Button
$nextButton.Text = "Next →"
$nextButton.Location = New-Object System.Drawing.Point(580, 490)
$nextButton.Size = New-Object System.Drawing.Size(90, 35)
$nextButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$nextButton.FlatStyle = "Flat"
$nextButton.BackColor = [System.Drawing.Color]::FromArgb(45, 125, 154)
$nextButton.ForeColor = [System.Drawing.Color]::White
$nextButton.Cursor = "Hand"
$nextButton.Add_Click({ Show-NextStep })
$form.Controls.Add($nextButton)

# Step Panels
$stepPages = @()

# ===== STEP 1: Database Selection =====
$step1Panel = New-Object System.Windows.Forms.Panel
$step1Panel.Location = New-Object System.Drawing.Point(10, 10)
$step1Panel.Size = New-Object System.Drawing.Size(640, 350)
$step1Panel.BackColor = [System.Drawing.Color]::White

$step1Title = New-Object System.Windows.Forms.Label
$step1Title.Text = "Choose Your Database Backend"
$step1Title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$step1Title.Location = New-Object System.Drawing.Point(20, 20)
$step1Title.Size = New-Object System.Drawing.Size(400, 30)
$step1Panel.Controls.Add($step1Title)

$step1Desc = New-Object System.Windows.Forms.Label
$step1Desc.Text = "Select the database backend for your WordPress installation:"
$step1Desc.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$step1Desc.Location = New-Object System.Drawing.Point(20, 55)
$step1Desc.Size = New-Object System.Drawing.Size(500, 20)
$step1Desc.ForeColor = [System.Drawing.Color]::Gray
$step1Panel.Controls.Add($step1Desc)

# Database option cards
$dbOptions = @("MySQL", "MariaDB", "PostgreSQL")
$dbDescriptions = @(
    "Most popular and well-tested. Full plugin compatibility.",
    "Drop-in MySQL replacement with enhanced features.",
    "Advanced features. Requires additional plugin (experimental)."
)
$dbIcons = @("🐬", "🐘", "🐘")

$dbGroup = New-Object System.Windows.Forms.GroupBox
$dbGroup.Location = New-Object System.Drawing.Point(20, 85)
$dbGroup.Size = New-Object System.Drawing.Size(600, 130)
$dbGroup.Text = "Database Options"
$dbGroup.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$step1Panel.Controls.Add($dbGroup)

$selectedDb = New-Object System.Windows.Forms.RadioButton
for ($i = 0; $i -lt 3; $i++) {
    $rb = New-Object System.Windows.Forms.RadioButton
    $rb.Text = "$($dbIcons[$i])  $($dbOptions[$i])"
    $rb.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $rb.Location = New-Object System.Drawing.Point(20, 25 + ($i * 38))
    $rb.Size = New-Object System.Drawing.Size(200, 25)
    $rb.Tag = $dbOptions[$i].ToLower()
    $rb.Checked = ($i -eq 0)

    $desc = New-Object System.Windows.Forms.Label
    $desc.Text = $dbDescriptions[$i]
    $desc.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $desc.Location = New-Object System.Drawing.Point(40, 48 + ($i * 38))
    $desc.Size = New-Object System.Drawing.Size(550, 20)
    $desc.ForeColor = [System.Drawing.Color]::Gray

    $dbGroup.Controls.Add($rb)
    $dbGroup.Controls.Add($desc)

    if ($i -eq 0) { $selectedDb = $rb }
    $rb.Add_CheckedChanged({ $selectedDb = $this })
}

# PostgreSQL warning
$postgresWarning = New-Object System.Windows.Forms.Label
$postgresWarning.Text = "⚠ PostgreSQL requires the WP PG4WP plugin. Some plugins may not be compatible."
$postgresWarning.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$postgresWarning.Location = New-Object System.Drawing.Point(20, 225)
$postgresWarning.Size = New-Object System.Drawing.Size(580, 20)
$postgresWarning.ForeColor = [System.Drawing.Color]::Orange
$postgresWarning.Visible = $false
$step1Panel.Controls.Add($postgresWarning)

$dbGroup.Controls[0].Add_CheckedChanged({
    if ($this.Checked -and $this.Text -match "PostgreSQL") {
        $postgresWarning.Visible = $true
    }
})

$dbGroup.Controls[3].Add_CheckedChanged({
    if ($this.Checked -and $this.Text -match "PostgreSQL") {
        $postgresWarning.Visible = $true
    } else {
        $postgresWarning.Visible = $false
    }
})

$dbGroup.Controls[6].Add_CheckedChanged({
    if ($this.Checked -and $this.Text -match "PostgreSQL") {
        $postgresWarning.Visible = $true
    } else {
        $postgresWarning.Visible = $false
    }
})

$stepPages += $step1Panel

# ===== STEP 2: Port Configuration =====
$step2Panel = New-Object System.Windows.Forms.Panel
$step2Panel.Location = New-Object System.Drawing.Point(10, 10)
$step2Panel.Size = New-Object System.Drawing.Size(640, 350)
$step2Panel.BackColor = [System.Drawing.Color]::White
$step2Panel.Visible = $false

$step2Title = New-Object System.Windows.Forms.Label
$step2Title.Text = "Configure Port"
$step2Title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$step2Title.Location = New-Object System.Drawing.Point(20, 20)
$step2Title.Size = New-Object System.Drawing.Size(200, 30)
$step2Panel.Controls.Add($step2Title)

$step2Desc = New-Object System.Windows.Forms.Label
$step2Desc.Text = "Enter the port number for WordPress to listen on:"
$step2Desc.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$step2Desc.Location = New-Object System.Drawing.Point(20, 55)
$step2Desc.Size = New-Object System.Drawing.Size(400, 20)
$step2Desc.ForeColor = [System.Drawing.Color]::Gray
$step2Panel.Controls.Add($step2Desc)

$portTextBox = New-Object System.Windows.Forms.TextBox
$portTextBox.Text = "8080"
$portTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$portTextBox.Location = New-Object System.Drawing.Point(20, 95)
$portTextBox.Size = New-Object System.Drawing.Size(150, 30)
$step2Panel.Controls.Add($portTextBox)

$portError = New-Object System.Windows.Forms.Label
$portError.Text = "⚠ Port is already in use"
$portError.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$portError.Location = New-Object System.Drawing.Point(20, 130)
$portError.Size = New-Object System.Drawing.Size(300, 20)
$portError.ForeColor = [System.Drawing.Color]::Red
$portError.Visible = $false
$step2Panel.Controls.Add($portError)

$checkPortButton = New-Object System.Windows.Forms.Button
$checkPortButton.Text = "Check Port"
$checkPortButton.Location = New-Object System.Drawing.Point(180, 95)
$checkPortButton.Size = New-Object System.Drawing.Size(100, 30)
$checkPortButton.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$checkPortButton.Add_Click({
    $port = $portTextBox.Text
    if ($port -match '^\d+$' -and [int]$port -gt 0 -and [int]$port -le 65535) {
        try {
            $tcp = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, [int]$port)
            $tcp.Start()
            $tcp.Stop()
            $portError.Text = "✓ Port $port is available"
            $portError.ForeColor = [System.Drawing.Color]::Green
            $portError.Visible = $true
        } catch {
            $portError.Text = "✗ Port $port is already in use"
            $portError.ForeColor = [System.Drawing.Color]::Red
            $portError.Visible = $true
        }
    } else {
        $portError.Text = "✗ Please enter a valid port (1-65535)"
        $portError.ForeColor = [System.Drawing.Color]::Red
        $portError.Visible = $true
    }
})
$step2Panel.Controls.Add($checkPortButton)

$commonPortsLabel = New-Object System.Windows.Forms.Label
$commonPortsLabel.Text = "Common ports to avoid: 80 (IIS), 443 (IIS), 3306 (MySQL), 5432 (PostgreSQL)"
$commonPortsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$commonPortsLabel.Location = New-Object System.Drawing.Point(20, 170)
$commonPortsLabel.Size = New-Object System.Drawing.Size(450, 20)
$commonPortsLabel.ForeColor = [System.Drawing.Color]::Gray
$step2Panel.Controls.Add($commonPortsLabel)

# Quick select buttons
$quickPortsLabel = New-Object System.Windows.Forms.Label
$quickPortsLabel.Text = "Quick Select:"
$quickPortsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$quickPortsLabel.Location = New-Object System.Drawing.Point(20, 210)
$quickPortsLabel.Size = New-Object System.Drawing.Size(100, 20)
$step2Panel.Controls.Add($quickPortsLabel)

$ports = @(8080, 8081, 8185, 8186)
$pos = 130
foreach ($p in $ports) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $p
    $btn.Location = New-Object System.Drawing.Point($pos, 205)
    $btn.Size = New-Object System.Drawing.Size(60, 28)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $btn.Tag = $p
    $btn.Add_Click({
        $portTextBox.Text = $this.Tag
        $portError.Visible = $false
    })
    $step2Panel.Controls.Add($btn)
    $pos += 70
}

$stepPages += $step2Panel

# ===== STEP 3: Site Configuration =====
$step3Panel = New-Object System.Windows.Forms.Panel
$step3Panel.Location = New-Object System.Drawing.Point(10, 10)
$step3Panel.Size = New-Object System.Drawing.Size(640, 350)
$step3Panel.BackColor = [System.Drawing.Color]::White
$step3Panel.Visible = $false

$step3Title = New-Object System.Windows.Forms.Label
$step3Title.Text = "Configure Your Site"
$step3Title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$step3Title.Location = New-Object System.Drawing.Point(20, 20)
$step3Title.Size = New-Object System.Drawing.Size(250, 30)
$step3Panel.Controls.Add($step3Title)

# Site Title
$siteTitleLabel = New-Object System.Windows.Forms.Label
$siteTitleLabel.Text = "Site Title:"
$siteTitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$siteTitleLabel.Location = New-Object System.Drawing.Point(20, 70)
$siteTitleLabel.Size = New-Object System.Drawing.Size(100, 20)
$step3Panel.Controls.Add($siteTitleLabel)

$siteTitleTextBox = New-Object System.Windows.Forms.TextBox
$siteTitleTextBox.Text = "My WordPress Site"
$siteTitleTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$siteTitleTextBox.Location = New-Object System.Drawing.Point(130, 68)
$siteTitleTextBox.Size = New-Object System.Drawing.Size(300, 25)
$step3Panel.Controls.Add($siteTitleTextBox)

# WordPress URL
$wpUrlLabel = New-Object System.Windows.Forms.Label
$wpUrlLabel.Text = "WordPress URL:"
$wpUrlLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$wpUrlLabel.Location = New-Object System.Drawing.Point(20, 110)
$wpUrlLabel.Size = New-Object System.Drawing.Size(120, 20)
$step3Panel.Controls.Add($wpUrlLabel)

$wpUrlTextBox = New-Object System.Windows.Forms.TextBox
$wpUrlTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$wpUrlTextBox.Location = New-Object System.Drawing.Point(130, 108)
$wpUrlTextBox.Size = New-Object System.Drawing.Size(300, 25)
$step3Panel.Controls.Add($wpUrlTextBox)

$urlNote = New-Object System.Windows.Forms.Label
$urlNote.Text = "Example: localhost:8080 or 192.168.1.100:8080"
$urlNote.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$urlNote.Location = New-Object System.Drawing.Point(130, 133)
$urlNote.Size = New-Object System.Drawing.Size(300, 20)
$urlNote.ForeColor = [System.Drawing.Color]::Gray
$step3Panel.Controls.Add($urlNote)

$stepPages += $step3Panel

# ===== STEP 4: Admin Configuration =====
$step4Panel = New-Object System.Windows.Forms.Panel
$step4Panel.Location = New-Object System.Drawing.Point(10, 10)
$step4Panel.Size = New-Object System.Drawing.Size(640, 350)
$step4Panel.BackColor = [System.Drawing.Color]::White
$step4Panel.Visible = $false

$step4Title = New-Object System.Windows.Forms.Label
$step4Title.Text = "Configure Administrator Account"
$step4Title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$step4Title.Location = New-Object System.Drawing.Point(20, 20)
$step4Title.Size = New-Object System.Drawing.Size(350, 30)
$step4Panel.Controls.Add($step4Title)

# Admin Username
$adminUserLabel = New-Object System.Windows.Forms.Label
$adminUserLabel.Text = "Admin Username:"
$adminUserLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$adminUserLabel.Location = New-Object System.Drawing.Point(20, 70)
$adminUserLabel.Size = New-Object System.Drawing.Size(120, 20)
$step4Panel.Controls.Add($adminUserLabel)

$adminUserTextBox = New-Object System.Windows.Forms.TextBox
$adminUserTextBox.Text = "admin"
$adminUserTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$adminUserTextBox.Location = New-Object System.Drawing.Point(150, 68)
$adminUserTextBox.Size = New-Object System.Drawing.Size(200, 25)
$step4Panel.Controls.Add($adminUserTextBox)

# Admin Password
$adminPassLabel = New-Object System.Windows.Forms.Label
$adminPassLabel.Text = "Admin Password:"
$adminPassLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$adminPassLabel.Location = New-Object System.Drawing.Point(20, 110)
$adminPassLabel.Size = New-Object System.Drawing.Size(120, 20)
$step4Panel.Controls.Add($adminPassLabel)

$adminPassTextBox = New-Object System.Windows.Forms.TextBox
$adminPassTextBox.PasswordChar = "•"
$adminPassTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$adminPassTextBox.Location = New-Object System.Drawing.Point(150, 108)
$adminPassTextBox.Size = New-Object System.Drawing.Size(200, 25)
$step4Panel.Controls.Add($adminPassTextBox)

$generatePassButton = New-Object System.Windows.Forms.Button
$generatePassButton.Text = "🔐 Generate"
$generatePassButton.Location = New-Object System.Drawing.Point(360, 108)
$generatePassButton.Size = New-Object System.Drawing.Size(100, 25)
$generatePassButton.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$generatePassButton.Add_Click({
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%'
    $pass = -join (1..16 | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
    $adminPassTextBox.Text = $pass
    $adminPassConfirmTextBox.Text = $pass
})
$step4Panel.Controls.Add($generatePassButton)

# Confirm Password
$adminPassConfirmLabel = New-Object System.Windows.Forms.Label
$adminPassConfirmLabel.Text = "Confirm Password:"
$adminPassConfirmLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$adminPassConfirmLabel.Location = New-Object System.Drawing.Point(20, 150)
$adminPassConfirmLabel.Size = New-Object System.Drawing.Size(120, 20)
$step4Panel.Controls.Add($adminPassConfirmLabel)

$adminPassConfirmTextBox = New-Object System.Windows.Forms.TextBox
$adminPassConfirmTextBox.PasswordChar = "•"
$adminPassConfirmTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$adminPassConfirmTextBox.Location = New-Object System.Drawing.Point(150, 148)
$adminPassConfirmTextBox.Size = New-Object System.Drawing.Size(200, 25)
$step4Panel.Controls.Add($adminPassConfirmTextBox)

$passError = New-Object System.Windows.Forms.Label
$passError.Text = "⚠ Passwords do not match"
$passError.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$passError.Location = New-Object System.Drawing.Point(20, 178)
$passError.Size = New-Object System.Drawing.Size(200, 20)
$passError.ForeColor = [System.Drawing.Color]::Red
$passError.Visible = $false
$step4Panel.Controls.Add($passError)

# Admin Email
$adminEmailLabel = New-Object System.Windows.Forms.Label
$adminEmailLabel.Text = "Admin Email:"
$adminEmailLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$adminEmailLabel.Location = New-Object System.Drawing.Point(20, 210)
$adminEmailLabel.Size = New-Object System.Drawing.Size(100, 20)
$step4Panel.Controls.Add($adminEmailLabel)

$adminEmailTextBox = New-Object System.Windows.Forms.TextBox
$adminEmailTextBox.Text = "admin@example.com"
$adminEmailTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$adminEmailTextBox.Location = New-Object System.Drawing.Point(150, 208)
$adminEmailTextBox.Size = New-Object System.Drawing.Size(300, 25)
$step4Panel.Controls.Add($adminEmailTextBox)

$emailError = New-Object System.Windows.Forms.Label
$emailError.Text = "⚠ Please enter a valid email address"
$emailError.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$emailError.Location = New-Object System.Drawing.Point(150, 238)
$emailError.Size = New-Object System.Drawing.Size(250, 20)
$emailError.ForeColor = [System.Drawing.Color]::Red
$emailError.Visible = $false
$step4Panel.Controls.Add($emailError)

$stepPages += $step4Panel

# ===== STEP 5: Installation Progress =====
$step5Panel = New-Object System.Windows.Forms.Panel
$step5Panel.Location = New-Object System.Drawing.Point(10, 10)
$step5Panel.Size = New-Object System.Drawing.Size(640, 350)
$step5Panel.BackColor = [System.Drawing.Color]::White
$step5Panel.Visible = $false

$step5Title = New-Object System.Windows.Forms.Label
$step5Title.Text = "Installing WordPress..."
$step5Title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$step5Title.Location = New-Object System.Drawing.Point(20, 20)
$step5Title.Size = New-Object System.Drawing.Size(250, 30)
$step5Panel.Controls.Add($step5Title)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 70)
$progressBar.Size = New-Object System.Drawing.Size(600, 25)
$progressBar.Style = "Continuous"
$step5Panel.Controls.Add($progressBar)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Initializing..."
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$statusLabel.Location = New-Object System.Drawing.Point(20, 105)
$statusLabel.Size = New-Object System.Drawing.Size(600, 60)
$statusLabel.ForeColor = [System.Drawing.Color]::Gray
$step5Panel.Controls.Add($statusLabel)

$logTextBox = New-Object System.Windows.Forms.TextBox
$logTextBox.Multiline = $true
$logTextBox.ReadOnly = $true
$logTextBox.ScrollBars = "Vertical"
$logTextBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$logTextBox.Location = New-Object System.Drawing.Point(20, 160)
$logTextBox.Size = New-Object System.Drawing.Size(600, 140)
$logTextBox.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
$logTextBox.Text = "Ready to start installation..."
$step5Panel.Controls.Add($logTextBox)

$completePanel = New-Object System.Windows.Forms.Panel
$completePanel.Location = New-Object System.Drawing.Point(20, 310)
$completePanel.Size = New-Object System.Drawing.Size(600, 1)
$completePanel.BackColor = [System.Drawing.Color]::Green
$completePanel.Visible = $false
$step5Panel.Controls.Add($completePanel)

$stepPages += $step5Panel

# Add all panels to step panel
foreach ($page in $stepPages) {
    $stepPanel.Controls.Add($page)
}

# Navigation functions
function Show-NextStep {
    # Validation
    if ($script:CurrentStep -eq 1) {
        # Validate database selection
        if (-not $selectedDb.Checked) {
            [System.Windows.Forms.MessageBox]::Show("Please select a database.", "Selection Required", "OK", "Warning")
            return
        }
    }

    if ($script:CurrentStep -eq 2) {
        # Validate port
        $port = $portTextBox.Text
        if (-not ($port -match '^\d+$' -and [int]$port -gt 0 -and [int]$port -le 65535)) {
            [System.Windows.Forms.MessageBox]::Show("Please enter a valid port number (1-65535).", "Invalid Port", "OK", "Warning")
            return
        }

        try {
            $tcp = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, [int]$port)
            $tcp.Start()
            $tcp.Stop()
        } catch {
            $result = [System.Windows.Forms.MessageBox]::Show("Port $port is already in use. Continue anyway?", "Port in Use", "YesNo", "Warning")
            if ($result -ne "Yes") {
                return
            }
        }
    }

    if ($script:CurrentStep -eq 3) {
        # Validate site title
        if ([string]::IsNullOrWhiteSpace($siteTitleTextBox.Text)) {
            [System.Windows.Forms.MessageBox]::Show("Please enter a site title.", "Required Field", "OK", "Warning")
            return
        }

        # Validate URL
        if ([string]::IsNullOrWhiteSpace($wpUrlTextBox.Text)) {
            [System.Windows.Forms.MessageBox]::Show("Please enter a WordPress URL.", "Required Field", "OK", "Warning")
            return
        }
    }

    if ($script:CurrentStep -eq 4) {
        # Validate admin fields
        if ([string]::IsNullOrWhiteSpace($adminUserTextBox.Text)) {
            [System.Windows.Forms.MessageBox]::Show("Please enter an admin username.", "Required Field", "OK", "Warning")
            return
        }

        if ($adminPassTextBox.Text.Length -lt 8) {
            [System.Windows.Forms.MessageBox]::Show("Password must be at least 8 characters.", "Invalid Password", "OK", "Warning")
            return
        }

        if ($adminPassTextBox.Text -ne $adminPassConfirmTextBox.Text) {
            [System.Windows.Forms.MessageBox]::Show("Passwords do not match.", "Password Mismatch", "OK", "Warning")
            return
        }

        if ($adminEmailTextBox.Text -notmatch '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') {
            [System.Windows.Forms.MessageBox]::Show("Please enter a valid email address.", "Invalid Email", "OK", "Warning")
            return
        }

        # Show confirmation
        $dbType = foreach ($rb in $dbGroup.Controls) { if ($rb -is [System.Windows.Forms.RadioButton] -and $rb.Checked) { $rb.Tag } }
        $confirmMsg = "Ready to install WordPress with:`n`n"
        $confirmMsg += "Database: " + (Get-Culture).TextInfo.ToTitleCase($dbType) + "`n"
        $confirmMsg += "Port: " + $portTextBox.Text + "`n"
        $confirmMsg += "Site Title: " + $siteTitleTextBox.Text + "`n"
        $confirmMsg += "Admin: " + $adminUserTextBox.Text + "`n"
        $confirmMsg += "Email: " + $adminEmailTextBox.Text + "`n`n"
        $confirmMsg += "Continue?"

        $result = [System.Windows.Forms.MessageBox]::Show($confirmMsg, "Confirm Installation", "YesNo", "Question")
        if ($result -ne "Yes") {
            return
        }

        # Start installation
        $script:CurrentStep = 5
        Update-StepIndicators -Step 5
        Show-Step 5
        $backButton.Visible = $false
        $nextButton.Visible = $false
        Start-Installation
        return
    }

    $script:CurrentStep++
    Update-StepIndicators -Step $script:CurrentStep
    Show-Step $script:CurrentStep
}

function Show-PreviousStep {
    if ($script:CurrentStep -gt 1) {
        $script:CurrentStep--
        Update-StepIndicators -Step $script:CurrentStep
        Show-Step $script:CurrentStep
    }
}

function Show-Step {
    param([int]$Step)

    for ($i = 0; $i -lt $stepPages.Count; $i++) {
        $stepPages[$i].Visible = ($i -eq ($Step - 1))
    }

    $backButton.Visible = ($Step -gt 1)

    if ($Step -eq 4) {
        $nextButton.Text = "Install →"
    } else {
        $nextButton.Text = "Next →"
    }
}

function Start-Installation {
    # Get configuration
    $dbType = foreach ($rb in $dbGroup.Controls) { if ($rb -is [System.Windows.Forms.RadioButton] -and $rb.Checked) { $rb.Tag } }
    $port = $portTextBox.Text
    $siteTitle = $siteTitleTextBox.Text
    $wpUrl = $wpUrlTextBox.Text -replace '^https?://', ''
    $adminUser = $adminUserTextBox.Text
    $adminPass = $adminPassTextBox.Text
    $adminEmail = $adminEmailTextBox.Text

    # Database config
    $dbName = "wordpress"
    $dbUser = "wpuser"
    $dbPassword = -join ((48..57 + 65..90 + 97..122 | Get-Random -Count 16 | ForEach-Object { [char]$_ }))
    $dbRootPassword = -join ((48..57 + 65..90 + 97..122 | Get-Random -Count 16 | ForEach-Object { [char]$_ }))

    # Compose file mapping
    $composeFiles = @{
        "mysql" = "docker-compose.yml"
        "mariadb" = "docker-compose.mariadb.yml"
        "postgresql" = "docker-compose.postgresql.yml"
    }
    $composeFile = $composeFiles[$dbType]

    # Update UI
    function Update-Progress {
        param([string]$Status, [int]$Percent, [string]$Log = "")

        $statusLabel.Text = $Status
        $progressBar.Value = $Percent
        if ($Log) {
            $logTextBox.AppendText("`n$Log")
            $logTextBox.SelectionStart = $logTextBox.Text.Length
            $logTextBox.ScrollToCaret()
        }
        $form.Refresh()
    }

    # Run installation in background
    $job = Start-Job -ScriptBlock {
        param($config, $composeFile)

        $output = @()

        function Write-Output {
            param([string]$Msg)
            $output += $Msg
            Write-Host $Msg
        }

        try {
            Write-Output "Creating environment configuration..."

            $envContent = @"
DB_TYPE=$($config.DbType)
WP_PORT=$($config.Port)
WP_SITE_TITLE=$($config.SiteTitle)
WP_ADMIN_USER=$($config.AdminUser)
WP_ADMIN_PASSWORD=$($config.AdminPass)
WP_ADMIN_EMAIL=$($config.AdminEmail)
WP_URL=$($config.WpUrl)
DB_NAME=$($config.DbName)
DB_USER=$($config.DbUser)
DB_PASSWORD=$($config.DbPassword)
DB_ROOT_PASSWORD=$($config.DbRootPassword)
WP_AUTO_INSTALL=true
COMPOSE_FILE=$composeFile
"@

            $envContent | Out-File -FilePath ".env" -Encoding UTF8
            Write-Output "Environment file created"

            Write-Output "Cleaning up previous installation..."
            docker compose -f $composeFile down -v 2>$null | Out-Null
            docker rm -f wp_installer_wordpress wp_installer_db 2>$null | Out-Null

            Write-Output "Pulling Docker images..."
            $pullResult = docker compose -f $composeFile pull 2>&1
            Write-Output $pullResult

            Write-Output "Starting Docker containers..."
            $upResult = docker compose -f $composeFile up -d 2>&1
            Write-Output $upResult

            Write-Output "Waiting for WordPress to be ready..."
            Start-Sleep -Seconds 30

            $maxAttempts = 60
            $attempt = 0
            while ($attempt -lt $maxAttempts) {
                $status = docker compose -f $composeFile ps --format json | ConvertFrom-Json
                $wpContainer = $status | Where-Object { $_.Service -eq "wordpress" }

                if ($wpContainer.State -eq "running" -and $wpContainer.Health -eq "healthy") {
                    Write-Output "WordPress is healthy!"
                    break
                }
                Write-Output "."
                Start-Sleep -Seconds 2
                $attempt++
            }

            Write-Output "Installing WordPress core..."
            $installResult = docker compose -f $composeFile exec -T wordpress wp core install `
                --url="http://$($config.WpUrl)" `
                --title="$($config.SiteTitle)" `
                --admin_user="$($config.AdminUser)" `
                --admin_password="$($config.AdminPass)" `
                --admin_email="$($config.AdminEmail)" `
                --skip-email `
                --allow-root 2>&1
            Write-Output $installResult

            Write-Output "Configuring WordPress..."
            docker compose -f $composeFile exec -T wordpress wp rewrite structure '/%postname%/' --allow-root 2>$null | Out-Null
            Write-Output "Permalink structure set"

            docker compose -f $composeFile exec -T wordpress wp post delete 1 --force --allow-root 2>$null | Out-Null
            docker compose -f $composeFile exec -T wordpress wp post delete 2 --force --allow-root 2>$null | Out-Null
            Write-Output "Default content removed"

            docker compose -f $composeFile exec -T wordpress wp theme activate twentytwentyfour --allow-root 2>$null | Out-Null
            Write-Output "Default theme activated"

            # Save credentials
            $credsContent = @"
WordPress Docker Installer - Credentials
Generated: $(Get-Date -Format "ddd MMM dd HH:mm:ss yyyy")

Database Type: $($config.DbType)

WordPress Site:
---------------
URL: http://$($config.WpUrl)
Admin Username: $($config.AdminUser)
Admin Password: $($config.AdminPass)
Admin Email: $($config.AdminEmail)

Database:
---------------
Database Name: $($config.DbName)
Database User: $($config.DbUser)
Database Password: $($config.DbPassword)
Root Password: $($config.DbRootPassword)

Keep this file secure!
"@

            $credsContent | Out-File -FilePath "credentials.txt" -Encoding UTF8
            Write-Output "Credentials saved to credentials.txt"

            Write-Output "INSTALL_COMPLETE"

        } catch {
            Write-Output "ERROR: $_"
            Write-Output "INSTALL_FAILED"
        }

        return $output
    } -ArgumentList @{
        DbType = $dbType
        Port = $port
        SiteTitle = $siteTitle
        AdminUser = $adminUser
        AdminPass = $adminPass
        AdminEmail = $adminEmail
        WpUrl = $wpUrl
        DbName = $dbName
        DbUser = $dbUser
        DbPassword = $dbPassword
        DbRootPassword = $dbRootPassword
    }, $composeFile

    # Monitor job
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 500
    $timer.Add_Tick({
        if ($job.State -ne "Running") {
            $timer.Stop()
            $result = Receive-Job -Job $job
            Remove-Job -Job $job

            foreach ($line in $result) {
                $logTextBox.AppendText("`n$line")
                $logTextBox.SelectionStart = $logTextBox.Text.Length
                $logTextBox.ScrollToCaret()
            }

            if ($result -match "INSTALL_COMPLETE") {
                $statusLabel.Text = "Installation Complete!"
                $progressBar.Value = 100
                $completePanel.Visible = $true

                # Show success message
                $successMsg = "WordPress has been installed successfully!`n`n"
                $successMsg += "URL: http://$wpUrl`n"
                $successMsg += "Admin: $adminUser`n`n"
                $successMsg += "Credentials saved to credentials.txt"

                [System.Windows.Forms.MessageBox]::Show($successMsg, "Installation Complete", "OK", "Information")

                # Change button to close
                $nextButton.Text = "Close"
                $nextButton.Visible = $true
                $nextButton.Add_Click({ $form.Close() })
            } else {
                $statusLabel.Text = "Installation Failed"
                $progressBar.Value = 0
                $completePanel.BackColor = [System.Drawing.Color]::Red
                $completePanel.Visible = $true

                [System.Windows.Forms.MessageBox]::Show("Installation failed. Check the logs above for details.", "Installation Failed", "OK", "Error")
                $backButton.Visible = $true
            }

            $form.Refresh()
        } else {
            # Get partial output
            $result = Receive-Job -Job $job -Keep
            foreach ($line in $result) {
                if ($line -notmatch $logTextBox.Text.Split("`n")[-1]) {
                    $logTextBox.AppendText("`n$line")
                    $logTextBox.SelectionStart = $logTextBox.Text.Length
                    $logTextBox.ScrollToCaret()
                }
            }

            # Update progress based on output
            $allOutput = $logTextBox.Text
            if ($allOutput -match "Creating environment") { $statusLabel.Text = "Creating environment..."; $progressBar.Value = 10 }
            elseif ($allOutput -match "Pulling Docker") { $statusLabel.Text = "Pulling Docker images..."; $progressBar.Value = 20 }
            elseif ($allOutput -match "Starting Docker") { $statusLabel.Text = "Starting containers..."; $progressBar.Value = 40 }
            elseif ($allOutput -match "Waiting for WordPress") { $statusLabel.Text = "Waiting for WordPress..."; $progressBar.Value = 60 }
            elseif ($allOutput -match "Installing WordPress") { $statusLabel.Text = "Installing WordPress..."; $progressBar.Value = 80 }
        }
    })
    $timer.Start()
}

# Initialize
Update-StepIndicators -Step 1
Show-Step 1

# Show form
[void]$form.ShowDialog()
