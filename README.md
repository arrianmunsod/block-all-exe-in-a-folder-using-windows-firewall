# Block EXE Files in a Folder Using Windows Firewall

A PowerShell script that automatically creates Windows Firewall outbound blocking rules for every `.exe` file inside a selected folder and all its subfolders.

Compatible with **Windows 10 and Windows 11**.

## Features

- Automatically requests Administrator privileges.
- Prompts the user to enter a folder path.
- Recursively searches the selected folder and all subfolders for `.exe` files.
- Creates an individual Windows Firewall outbound blocking rule for each executable.
- Prevents the selected executables from establishing outbound network connections.
- Detects existing rules and skips them to prevent duplicates.
- Allows multiple folders to be processed in a single session.
- Does not modify or delete executable files.

## Repository Contents

| File | Description |
|---|---|
| `block-EXE-firewall.ps1` | Main PowerShell script that searches for executable files and creates Windows Firewall blocking rules. |

## Installation

### Step 1 — Download the PowerShell Script

1. Open this GitHub repository.
2. Click `block-EXE-firewall.ps1`.
3. Click the **Download raw file** button.
4. Save the file to your preferred location, such as your Desktop.

You only need to download the `.ps1` file. No additional files or installations are required.

## Usage

### Step 1 — Run the Script

1. Locate the downloaded `block-EXE-firewall.ps1` file.
2. Right-click the file.
3. Select **Run with PowerShell**.
4. When the User Account Control (UAC) prompt appears, click **Yes**.

The script automatically requests Administrator privileges if it is not already running with elevated permissions.

### Step 2 — Enter the Target Folder

Once the PowerShell window opens, the script will prompt:

```text
Enter the folder path:
```

Enter the folder containing the executable files you want to block.

Example:

```text
C:\Program Files\Example
```

You can also paste paths containing spaces without manually adding quotation marks.

### Step 3 — Wait for the Script to Process the Files

The script automatically searches the selected folder and all its subfolders for `.exe` files.

For example:

```text
C:\Example
├── Program.exe
├── Launcher.exe
└── Bin
    ├── Engine.exe
    └── Helper.exe
```

All four executable files will be detected.

The script then creates an individual Windows Firewall outbound blocking rule for each executable.

Example output:

```text
[BLOCKED] C:\Example\Program.exe
[BLOCKED] C:\Example\Launcher.exe
[BLOCKED] C:\Example\Bin\Engine.exe
[BLOCKED] C:\Example\Bin\Helper.exe
```

### Step 4 — Process Another Folder

After processing the selected folder, the script displays a summary:

```text
============================================================
Finished.
Folder           : C:\Example
EXE files found  : 4
Rules created    : 4
Rules skipped    : 0
============================================================
```

The script automatically returns to the folder prompt.

You can enter another folder without restarting the script.

### Step 5 — Finish

When you are finished, simply close the PowerShell window.

The firewall rules created by the script remain active even after the PowerShell window is closed.

**You do not need to keep the script running for the firewall rules to work.**

## Important Notes

- The script blocks **outbound network connections** for the executable files it finds.
- It does not delete, modify, or uninstall executable files.
- It searches recursively through all subfolders.
- Existing rules with matching names are skipped instead of being duplicated.
- Running the script again on the same folder will not create duplicate rules for files that already have matching rules.
- Administrator privileges are required to create Windows Firewall rules.
- If new executable files are added to a previously processed folder, run the script again to create rules for those files.
- The script does not automatically monitor folders for newly added executable files.

## Example Scenario

Suppose you want to block all executable files under:

```text
C:\MyPrograms
```

Enter that path when prompted.

The script will locate:

```text
C:\MyPrograms\App1.exe
C:\MyPrograms\App2.exe
C:\MyPrograms\Tools\Tool.exe
C:\MyPrograms\Tools\Updater.exe
```

It will then create individual Windows Firewall outbound blocking rules for all four executables.

## Development Note

AI-assisted development. Code reviewed and tested by the author.

---

<p align="center">
  <a href="https://github.com/arrianmunsod">
    <strong>← BACK TO ARRIAN'S GITHUB PROFILE</strong>
  </a>
  <br>
  <sub>Explore more projects, scripts, and technical documentation.</sub>
</p>
