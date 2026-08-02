# 🛡️ Scpsec OS 1.2 (i3 Edition)

<p align="center">
  <img src="https://raw.githubusercontent.com/scpsec/scpsec-logo/main/logo_circle.png" alt="Scpsec OS Logo" width="180">
</p>

<p align="center">
  <strong>A lightweight, fast, and security-focused Linux distribution built on Debian 12.</strong>
</p>

<p align="center">
Designed for developers, penetration testers, security researchers, system administrators, and Linux enthusiasts.
</p>

---

# ✨ Overview

**Scpsec OS** is a customized Linux distribution based on **Debian 12 (Bookworm)** that combines performance, simplicity, and a modern desktop experience.

Unlike traditional desktop environments, Scpsec OS is powered by the **i3 Window Manager**, delivering an efficient keyboard-driven workflow while consuming minimal system resources.

The operating system comes preconfigured with carefully selected applications, modern themes, hardware support, networking utilities, security tools, and productivity enhancements, making it suitable for both everyday use and professional cybersecurity work.

---

# 🚀 What's New in Version 1.2

## 📶 Improved Wi-Fi Management

Scpsec OS now provides a complete Wi-Fi management experience.

### Features

- NetworkManager integration
- nm-applet system tray
- Automatic network scanning
- One-click wireless connection
- Better driver compatibility
- Automatic interface recovery

### SCPSEC Wi-Fi Recovery

A custom utility is included:

```bash
wifix
```

or

```bash
scpsec-wifi-fix
```

The utility automatically:

- Unblocks Wi-Fi using rfkill
- Restarts NetworkManager
- Reloads wireless interfaces
- Attempts driver recovery
- Restores network connectivity

---

## 󰂯 Bluetooth Support

Bluetooth works out of the box.

Included components:

- BlueZ
- Blueman
- bluetooth.service enabled
- Blueman Applet
- Polybar Bluetooth indicator

You can connect, remove and manage Bluetooth devices directly from the desktop.

---

## 🔊 Audio & Brightness

Scpsec OS includes a complete multimedia experience.

### Audio

- PipeWire / PulseAudio support
- pamixer
- pavucontrol
- Polybar volume indicator

### Brightness

- brightnessctl
- Keyboard multimedia shortcuts
- Polybar brightness module

Supported multimedia keys:

- XF86AudioRaiseVolume
- XF86AudioLowerVolume
- XF86AudioMute
- XF86MonBrightnessUp
- XF86MonBrightnessDown

---

## ⚡ Power Menu

A fully customized Rofi power menu is included.

Shortcut:

```
Super + Shift + E
```

Available options:

- 🔒 Lock
- 🚪 Logout
- 🔄 Reboot
- ⚡ Shutdown

Powered by:

```
/usr/bin/scpsec-powermenu
```

---

## 🔔 Notifications

Desktop notifications are handled by **Dunst**.

Features:

- Catppuccin Macchiato theme
- Rounded notifications
- Transparency
- Low resource usage
- Automatic startup

---

## 🛡 Expanded Security Toolkit

Scpsec OS now ships with a larger collection of security tools.

Included utilities:

- aircrack-ng
- Wireshark
- tshark
- macchanger
- iwd
- wpasupplicant

Ideal for:

- Network analysis
- Wireless auditing
- Packet inspection
- Security research
- Penetration testing

---

## 📡 Improved Hardware Support

Scpsec OS includes additional firmware packages for better hardware compatibility.

Included firmware:

- firmware-iwlwifi
- firmware-realtek
- firmware-atheros
- firmware-b43-installer
- firmware-linux
- firmware-linux-nonfree

Wireless adapters work immediately after boot on most supported hardware.

---

# 🚀 Features

## 🐧 System

- Debian 12 (Bookworm)
- 64-bit (amd64)
- Lightweight
- Optimized
- Fast boot
- Low RAM usage
- Non-free firmware included
- Better hardware compatibility

---

## 🖥 Desktop

- i3 Window Manager
- Polybar
- Picom
- Rofi
- Kitty
- Dunst
- Feh
- Catppuccin Macchiato
- GTK Theme Integration

---

## 💻 Terminal

- Kitty Terminal
- Fastfetch
- Customized Bash
- Developer-friendly environment

---

## 📶 Networking

- NetworkManager
- nm-applet
- SCPSEC Wi-Fi Recovery Tool
- Bluetooth Applet
- Automatic Network Management

---

## 🛠 Utilities

- Calamares Installer
- Screenshot Tools
- Clipboard Support
- Power Management
- Brightness Control
- Volume Control

---

## 🔐 Security

- Debian Stable Updates
- Minimal Attack Surface
- Hardened Configuration
- Wireless Security Toolkit
- Packet Analysis Tools
- MAC Address Utilities

---

# ⌨ Default Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| **Super + Enter** | Open Kitty |
| **Super + D** | Launch Rofi |
| **Super + Shift + Q** | Close Window |
| **Super + Shift + R** | Reload i3 |
| **Super + F** | Fullscreen |
| **Super + Shift + E** | Power Menu |
| **Super + 1-9** | Switch Workspace |
| **Super + Shift + 1-9** | Move Window |
| **Super + Arrow Keys** | Change Focus |
| **Super + Shift + Arrow Keys** | Move Window |
| **XF86Audio Keys** | Volume Control |
| **XF86Brightness Keys** | Brightness Control |

> **Super** refers to the **Windows key**.

---

# 📦 Included Software

### Desktop

- i3wm
- Polybar
- Picom
- Kitty
- Rofi
- Dunst
- Feh

### Networking

- NetworkManager
- nm-applet
- BlueZ
- Blueman
- iwd
- wpasupplicant

### Security

- aircrack-ng
- Wireshark
- tshark
- macchanger

### Utilities

- Fastfetch
- Calamares Installer
- brightnessctl
- pamixer
- pavucontrol

---

# 🏗 Build the ISO

## Install Dependencies

```bash
sudo apt update

sudo apt install -y \
live-build \
git \
wget \
curl
```

---

## Clone Repository

```bash
git clone https://github.com/scpsec/scpsec-os-builder-I3.git

cd scpsec-os-builder-I3
```

---

## Build

```bash
chmod +x build-scpsec-i3.sh

sudo ./build-scpsec-i3.sh
```

After the build completes:

```
Scpsec-OS-1.2-I3-Desktop-amd64-2026.08.02.iso
```

---

# 🔑 Live Session

| Username | Password |
|----------|----------|
| **scpsec** | **live** |

Passwordless sudo is enabled in the live session.

---

# 📂 Project Structure

```text
.
├── build.sh
├── build-scpsec-i3.sh
├── install-deps.sh
├── README.md
└── LICENSE
```

---

# 📸 Desktop Highlights

- Catppuccin Macchiato
- Polybar
- Picom Transparency
- Rounded Kitty Terminal
- Dunst Notifications
- Rofi Launcher
- Fast Boot
- Lightweight Design
- Keyboard-driven Workflow

---

# ❤️ Why Scpsec OS?

- Extremely Lightweight
- Fast Boot
- Low Memory Usage
- Debian Stability
- Modern User Interface
- Professional Development Environment
- Wireless Ready
- Security Focused
- Cybersecurity Toolkit Included
- Beginner Friendly
- Easy to Customize
- Open Source

---

# 📜 License

Licensed under the **GNU General Public License v3.0 (GPL-3.0).**

See the **LICENSE** file for additional information.

---

# 👥 Maintainers

Developed and maintained by the **Scpsec Team**.

---

# 🌐 Links

**Website**

https://scpsec.cc

**Documentation**

https://docs.scpsec.cc

**GitHub**

https://github.com/scpsec

---

<p align="center">

Built with ❤️ by the Scpsec Team

</p>
