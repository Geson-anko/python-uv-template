# Stop on errors
$ErrorActionPreference = "Stop"

# Current package names
$CURRENT_PROJECT_NAME = "python-uv-template"
$CURRENT_PACKAGE_NAME = "python_uv_template"

# Function to print colored messages
function Write-ColorMessage {
    param(
        [string]$Message,
        [string]$Type = "Info"
    )

    $color = switch ($Type) {
        "Info" { "Cyan" }
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
        default { "White" }
    }

    $prefix = switch ($Type) {
        "Info" { "[INFO]" }
        "Success" { "[SUCCESS]" }
        "Warning" { "[WARNING]" }
        "Error" { "[ERROR]" }
        default { "" }
    }

    Write-Host "$prefix " -ForegroundColor $color -NoNewline
    Write-Host $Message
}

# Function to prompt user for yes/no
function Confirm-Action {
    param([string]$Prompt)

    while ($true) {
        $response = Read-Host "$Prompt (y/n)"
        if ($response -match '^[Yy]') { return $true }
        if ($response -match '^[Nn]') { return $false }
        Write-ColorMessage "Please answer yes (y) or no (n)." -Type "Warning"
    }
}

# Function to rename project files
function Rename-Project {
    param([string]$NewProjectName)

    $NewPackageName = $NewProjectName -replace "-", "_"

    Write-ColorMessage "Renaming project from '$CURRENT_PROJECT_NAME' to '$NewProjectName'" -Type "Info"
    Write-ColorMessage "Package name will be: '$NewPackageName'" -Type "Info"

    # Update pyproject.toml
    if (Test-Path "pyproject.toml") {
        Write-ColorMessage "Updating pyproject.toml..." -Type "Info"
        (Get-Content "pyproject.toml") -replace "name = ""$CURRENT_PROJECT_NAME""", "name = ""$NewProjectName""" | Set-Content "pyproject.toml"
    }

    # Rename package directory
    if (Test-Path "src\$CURRENT_PACKAGE_NAME") {
        Write-ColorMessage "Renaming package directory..." -Type "Info"

        if (-not (Test-Path "src\$NewPackageName")) {
            New-Item -Path "src\$NewPackageName" -ItemType Directory -Force | Out-Null
        }

        Get-ChildItem -Path "src\$CURRENT_PACKAGE_NAME" -Force | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination "src\$NewPackageName\" -Recurse -Force
        }

        Remove-Item -Path "src\$CURRENT_PACKAGE_NAME" -Recurse -Force
    }

    # Update imports in Python files
    Write-ColorMessage "Updating Python imports..." -Type "Info"
    Get-ChildItem -Path . -Filter "*.py" -Recurse | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        if ($content -match $CURRENT_PACKAGE_NAME) {
            $content = $content -replace "import $CURRENT_PACKAGE_NAME", "import $NewPackageName"
            $content = $content -replace "from $CURRENT_PACKAGE_NAME", "from $NewPackageName"
            Set-Content -Path $_.FullName -Value $content -NoNewline
        }
    }

    # Update docker-compose.yml
    if (Test-Path "docker-compose.yml") {
        Write-ColorMessage "Updating docker-compose.yml..." -Type "Info"
        $content = Get-Content "docker-compose.yml" -Raw
        $content = $content -replace $CURRENT_PROJECT_NAME, $NewProjectName
        Set-Content -Path "docker-compose.yml" -Value $content -NoNewline
    }

    # Update VSCode settings
    if (Test-Path ".vscode\settings.json") {
        Write-ColorMessage "Updating VSCode settings..." -Type "Info"
        $content = Get-Content ".vscode\settings.json" -Raw
        $content = $content -replace $CURRENT_PROJECT_NAME, $NewProjectName
        $content = $content -replace $CURRENT_PACKAGE_NAME, $NewPackageName
        Set-Content -Path ".vscode\settings.json" -Value $content -NoNewline
    }

    # Update Makefile
    if (Test-Path "Makefile") {
        Write-ColorMessage "Updating Makefile..." -Type "Info"
        $content = Get-Content "Makefile" -Raw
        $content = $content -replace $CURRENT_PROJECT_NAME, $NewProjectName
        Set-Content -Path "Makefile" -Value $content -NoNewline
    }

    # Update justfile
    if (Test-Path "justfile") {
        Write-ColorMessage "Updating justfile..." -Type "Info"
        $content = Get-Content "justfile" -Raw
        $content = $content -replace $CURRENT_PROJECT_NAME, $NewProjectName
        Set-Content -Path "justfile" -Value $content -NoNewline
    }
}

# Main setup process
Write-Host "==================================" -ForegroundColor Green
Write-Host "  Python UV Template Setup Script " -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
Write-Host ""

# Get new package name
if ($args.Count -ge 1) {
    $NEW_PROJECT_NAME = $args[0]
    Write-ColorMessage "Using provided project name: $NEW_PROJECT_NAME" -Type "Info"
} else {
    $NEW_PROJECT_NAME = (Get-Item -Path ".").Name
    Write-ColorMessage "Using current directory name as project name: $NEW_PROJECT_NAME" -Type "Info"
}

# Rename project
Rename-Project -NewProjectName $NEW_PROJECT_NAME

# Language selection
Write-Host ""
Write-ColorMessage "Select your preferred language for documentation:" -Type "Info"
Write-Host "  1) English"
Write-Host "  2) Japanese (日本語)"

while ($true) {
    $lang_choice = Read-Host "Enter your choice (1 or 2)"
    switch ($lang_choice) {
        "1" {
            $SELECTED_LANG = "en"
            Write-ColorMessage "English selected" -Type "Success"
            break
        }
        "2" {
            $SELECTED_LANG = "ja"
            Write-ColorMessage "Japanese (日本語) selected" -Type "Success"
            break
        }
        default {
            Write-ColorMessage "Please enter 1 or 2" -Type "Warning"
            continue
        }
    }
    break
}

# Build tool selection
Write-Host ""
Write-ColorMessage "Select your preferred build tool:" -Type "Info"
Write-Host "  1) Make"
Write-Host "  2) Just"

while ($true) {
    $build_choice = Read-Host "Enter your choice (1 or 2)"
    switch ($build_choice) {
        "1" {
            $SELECTED_BUILD = "make"
            Write-ColorMessage "Make selected" -Type "Success"
            break
        }
        "2" {
            $SELECTED_BUILD = "just"
            Write-ColorMessage "Just selected" -Type "Success"
            break
        }
        default {
            Write-ColorMessage "Please enter 1 or 2" -Type "Warning"
            continue
        }
    }
    break
}

# Cleanup confirmation
Write-Host ""
Write-ColorMessage "The following cleanup actions will be performed:" -Type "Warning"
Write-Host "  - Replace README files with a simple template"

if ($SELECTED_LANG -eq "en") {
    Write-Host "  - Remove Japanese documentation files (*.ja.md)"
} else {
    Write-Host "  - Remove English documentation files and rename Japanese files"
}

if ($SELECTED_BUILD -eq "make") {
    Write-Host "  - Remove justfile"
} else {
    Write-Host "  - Remove Makefile"
}

Write-Host "  - Remove setup scripts (setup.sh, Setup.ps1, rename.sh, Rename.ps1)"
Write-Host ""

if (-not (Confirm-Action -Prompt "Do you want to proceed with cleanup?")) {
    Write-ColorMessage "Cleanup cancelled. Project has been renamed but no files were removed." -Type "Warning"
    exit 0
}

# Perform cleanup
Write-ColorMessage "Starting cleanup..." -Type "Info"

# Replace README files
Write-ColorMessage "Replacing README files..." -Type "Info"
"# $NEW_PROJECT_NAME" | Set-Content "README.md"
if (Test-Path "README.ja.md") {
    Remove-Item "README.ja.md" -Force
}

# Language-specific cleanup
if ($SELECTED_LANG -eq "en") {
    Write-ColorMessage "Removing Japanese documentation files..." -Type "Info"
    Get-ChildItem -Path ".github" -Filter "*.ja.md" -Recurse | Remove-Item -Force
} else {
    Write-ColorMessage "Processing Japanese documentation files..." -Type "Info"
    # Rename Japanese files to remove .ja suffix
    Get-ChildItem -Path ".github" -Filter "*.ja.md" -Recurse | ForEach-Object {
        $newName = $_.Name -replace "\.ja\.md$", ".md"
        $newPath = Join-Path $_.Directory.FullName $newName
        Move-Item -Path $_.FullName -Destination $newPath -Force
    }
    # Remove original English files
    @("Bug_Report.md", "Feature_Request.md", "Task.md", "PULL_REQUEST_TEMPLATE.md") | ForEach-Object {
        $file = Get-ChildItem -Path ".github" -Filter $_ -Recurse
        if ($file) {
            Remove-Item $file.FullName -Force
        }
    }
}

# Build tool cleanup
if ($SELECTED_BUILD -eq "make") {
    Write-ColorMessage "Removing justfile..." -Type "Info"
    if (Test-Path "justfile") {
        Remove-Item "justfile" -Force
    }
} else {
    Write-ColorMessage "Removing Makefile..." -Type "Info"
    if (Test-Path "Makefile") {
        Remove-Item "Makefile" -Force
    }
}

# Remove setup scripts
Write-ColorMessage "Removing setup scripts..." -Type "Info"
@("rename.sh", "Rename.ps1", "setup.sh") | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item $_ -Force
    }
}

# Final cleanup summary
Write-Host ""
Write-ColorMessage "Setup completed successfully!" -Type "Success"
Write-Host ""
Write-Host "Summary:" -ForegroundColor Green
Write-Host "  - Project renamed to: $NEW_PROJECT_NAME"
Write-Host "  - Documentation language: $(if ($SELECTED_LANG -eq 'en') { 'English' } else { 'Japanese' })"
Write-Host "  - Build tool: $(if ($SELECTED_BUILD -eq 'make') { 'Make' } else { 'Just' })"
Write-Host "  - README replaced with simple template"
Write-Host "  - Unnecessary files removed"
Write-Host ""
Write-ColorMessage "Don't forget to:" -Type "Info"
Write-Host "  - Run '$SELECTED_BUILD venv' to set up your virtual environment"
Write-Host "  - Update your README.md with project-specific information"
Write-Host "  - Commit these changes to your repository"

# Self-delete
Write-ColorMessage "Removing this setup script..." -Type "Info"
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
