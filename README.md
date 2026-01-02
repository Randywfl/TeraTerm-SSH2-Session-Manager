TeraTerm is a Very Fine SSH Client for general professional use.  The main weakness is lacking the abiliy to save your sessions as you go.  There is a Very lame "menu" companion app that I was never able to get working so I decided to create my own session manager. It is somewhat limited in that it only works for SSH2 sessions, but that is all I needed.

SSHTTSM On Steroids
# 3-Way Client Session Manager

**3-Way Client Session Manager** is a Windows utility for managing and launching SSH/SFTP sessions using **Tera Term**, **PuTTY**, or **WinSCP** from a single interface.  
It supports saved sessions, optional credential storage, Tera Term macros, and automatic session backups.

---

## Features

- Launch **Tera Term**, **PuTTY**, or **WinSCP**
- Centralized SSH session list
- Optional saved username/password (obfuscated, not plain text)
- Tera Term macro (`.ttl`) support
- Built-in macro editor
- Session backup rotation
- Ping test for server reachability
- Single-instance protection

---

## Requirements

- Windows
- One or more of the following installed:
  - **Tera Term**
  - **PuTTY**
  - **WinSCP**

The program automatically searches common install paths.  
Local portable copies placed in the application folder are also supported.

---

## Installation

1. Install **Tera Term** if macro support is required.  
2. Copy `3-Way_CSM.exe` to a folder of your choice.  
3. (Optional) Place `putty.exe` and/or `WinSCP.exe` in the same folder.  
4. Run the application.

> Only one instance may run at a time.

---

## Creating a Session

1. Enter:
   - **Session Name**
   - **IP Address**
   - **Port** (default: 22)
2. (Optional) Enter **Username** and **Password**
3. Enable **User/Pswd OK** to allow credentials to be saved
4. Click **SAVE Session**

Sessions appear in the list on the left.

---

## Connecting to a Session

1. Choose a client:
   - **Tera Term**
     - Select Macro if desired
   - **PuTTY**
   - **WinSCP**
2. Select a session from the list
3. Click **CONNECT** or press **Enter**

### Client Notes

- **PuTTY**
  - Uses CLI interface for SSH2 connections
- **Tera Term**
  - Uses CLI interface for SSH2 connections
- **WinSCP**
  - Uses CLI interface for SFTP connections

---

## Password Handling

- Passwords are stored in an **obfuscated, non-readable form**
- To save credentials:
  1. Enter **Username** and **Password** (optional)  
  2. Enable **User/Pswd OK**  
  3. Click **SAVE Session**  

- Use **Show Password** to temporarily reveal credentials

---

## Tera Term Macros (`.ttl`)

- Macro files are loaded from the teraterm5 (sessions) folder
- Up to **8 macros** are displayed in the main window
- Select a macro before connecting to execute it automatically

### Macro Editor

- Select mcro file if available
- Click **EDIT**
- Edit the existing macro or create a new one
- Save or reload macro directly from the built-in editor

> Restart the application for newly added macros to appear in the main window.

---

## Session Storage & Backups

Sessions are stored in a rotating backup system:

| File Name   | Description             |
|------------|--------------------------|
| `Sessions` | Active sessions file     |
| `Sessions1`| Most recent backup       |
| `Sessions2`| Older backup             |

> Each save operation rotates the files automatically.

---

## Useful Shortcuts

- **Enter** – Connect to selected session
- **Delete** – Remove selected session
- **Ctrl+C** – Copy `IP:Port` to clipboard
- **ESC** – Close dialogs or editors

---

## Ping Test

Click **PING** to verify:

- Server reachability
- Active internet connection

Uses the system `ping.exe`.

---

## Sessions Folder

Click **Sessions Folder** button to browse:

- Session files
- Backup files
- Tera Term macro (`.ttl`) files

---

## About & Licensing

This application uses CLI to launch **unmodified third-party software**:

- Tera Term
- PuTTY
- WinSCP

All trademarks and licenses belong to their respective authors.  
License, documents, and homepage links are accessible from the **About** window.

---

## Disclaimer

Provided **AS-IS**, without warranty of any kind.

---

Enjoy using **3-Way Client Session Manager**
