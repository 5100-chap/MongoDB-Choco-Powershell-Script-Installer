# MongoDB Installer PowerShell Script

This repository contains a PowerShell script for installing MongoDB on your Windows machine. The script utilizes the Chocolatey package manager to simplify the installation process. It offers the flexibility to install either the latest version of MongoDB or a specific version as per your requirements. Additionally, it provides an option to add the MongoDB path to your system-level or user-level PATH variables after a successful installation.

## Features

- Checks if the script is running with administrator privileges.
- Verifies the presence of Chocolatey package manager and prompts for installation if it is not found.
- Allows you to choose between installing the latest version of MongoDB or a specific version.
- Detects the installed MongoDB path after a successful installation.
- Offers the option to add the MongoDB path to system-level or user-level PATH variables.

## Prerequisites

To run this script, ensure that the following prerequisites are met:

- Windows 10 or later.
- PowerShell 5.1 or later.
- Administrator privileges.

## Usage

To use the script, follow these steps:

1. Clone this repository or save the .ps1 script to your local machine.
2. Open PowerShell with administrator privileges.
3. Navigate to the directory where you cloned the repository.
4. Run the PowerShell script using the command `.\mongodb_installer.ps1`.

## Script Functionality

The script performs the following actions:

1. Checks if it is running with administrator privileges.
2. Verifies if Chocolatey is installed. If Chocolatey is not found, it prompts the user to install it.
3. Asks the user whether they want to install the latest version of MongoDB or a specific version. If the user opts for a specific version, they can provide the desired version.
4. Installs MongoDB using Chocolatey.
5. Retrieves all MongoDB versions installed in "C:\Program Files\MongoDB\Server".
6. If the user selects a specific version, the script sets the path to the highest installed version that is less than or equal to the specified version. Otherwise, it sets the path to the highest installed version.
7. Offers the choice to add the MongoDB path to the PATH variables. If the user agrees, it asks if they want to add it to the system-level PATH variable, user-level PATH variable, or both. The script checks if the path is already present in the chosen PATH variable(s) and adds it if it is not.

## License

This script is released under the MIT License. For more details, see the [LICENSE](LICENSE) file in this repository.
