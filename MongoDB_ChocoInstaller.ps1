# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "This script must be run as an administrator. Please re-run this script as an administrator."
    exit
}
$installSpecificVersion = $false

# Check if Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    # Prompt the user to install Chocolatey
    $installChocolatey = Read-Host "Chocolatey is not installed. Do you want to install it? (Y/N)"

    if ($installChocolatey -eq "Y" -or $installChocolatey -eq "y") {
        # Install Chocolatey
        Set-ExecutionPolicy Bypass -Scope Process -Force;
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    } else {
        Write-Host "Chocolatey installation declined. Script execution halted."
        exit
    }
}
# Prompt the user for version selection
$installLatest = Read-Host "Do you want to install the latest version of MongoDB? (Y/N (You'll specify the version) )"
if ($installLatest -eq "N" -or $installLatest -eq "n") {
    $specificVersion = Read-Host "Enter the specific version of MongoDB you want to install"
    $packageName = "choco install mongodb --version=$specificVersion"
    $installSpecificVersion = $true
}
else {
    $packageName = "choco install mongodb"
}

try {
    # Install MongoDB
    Invoke-Expression $packageName
    if (!$installSpecificVersion -or $specificVersion -ge "6" ) {
        $packageName2 = "choco install mongodb-shell"
        Invoke-Expression $packageName2
    }
}
catch {
    Write-Host "Installation failed. Script execution halted."
    exit
}

$mongoPath = "C:\Program Files\MongoDB\Server"
$folders = Get-ChildItem -Path $mongoPath -Directory | Where-Object { $_.Name -match "^\d" } | Select-Object -ExpandProperty Name

# Print all folders
Write-Host ("Versions detected in " + $mongoPath + ":")
foreach ($folder in $folders) {
    Write-Host $folder
}

if ($installSpecificVersion) {
    try {
        # Use the matching versiion
        $matchVersion = $folders | Sort-Object { [version]$_ } | Where-Object { [version]$_ -le [version]$specificVersion } | Select-Object -Last 1

        # Modify the path with the highest version
        $mongoPath = Join-Path -Path $mongoPath -ChildPath $matchVersion
        $mongoPath = Join-Path -Path $mongoPath -ChildPath "bin"

    }
    catch {
        Write-Host "Path failed. Script execution halted. Please add PATH manually"
        Write-Host $mongoPath
    }
}
else {
    # Find the highest version
    $highestVersion = $folders | Sort-Object -Descending | Select-Object -First 1

    # Modify the path with the highest version
    $mongoPath = Join-Path -Path $mongoPath -ChildPath $highestVersion
    $mongoPath = Join-Path -Path $mongoPath -ChildPath "bin"

}
# Prompt the user to add the path
$addPath = Read-Host "Do you want to add the MongoDB path to the PATH variables? (Y/N)"
if ($addPath -eq "Y" -or $addPath -eq "y") {
    $addSystemPath = Read-Host "Add to system-level PATH variable? (Y/N)"
    $addUserPath = Read-Host "Add to user-level PATH variable? (Y/N)"

    # Retrieve the current PATH variables
    $existingUserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    $existingMachinePath = [Environment]::GetEnvironmentVariable("PATH", "Machine")

    if ($addSystemPath -eq "Y" -or $addSystemPath -eq "y") {
        # Check if the path already exists in the system-level PATH variable
        if ($existingMachinePath -split ";" -contains $mongoPath) {
            Write-Host "The path is already present in the system-level PATH variable."
        }
        else {
            # Add the path to the system-level PATH variable
            $newMachinePath = $existingMachinePath + ";" + $mongoPath
            [Environment]::SetEnvironmentVariable("PATH", $newMachinePath, "Machine")
            Write-Host "The path has been added to the system-level PATH variable."
        }
    }

    if ($addUserPath -eq "Y" -or $addUserPath -eq "y") {
        # Check if the path already exists in the user-level PATH variable
        if ($existingUserPath -split ";" -contains $mongoPath) {
            Write-Host "The path is already present in the user-level PATH variable."
        }
        else {
            # Add the path to the user-level PATH variable
            $newUserPath = $existingUserPath + ";" + $mongoPath
            [Environment]::SetEnvironmentVariable("PATH", $newUserPath, "User")
            Write-Host "The path has been added to the user-level PATH variable."
        }
    }
    refreshenv
}
else {
    Write-Host "Skipping the addition of MongoDB path to PATH variables. Script execution completed."
}
