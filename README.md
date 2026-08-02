# 🛡️ Scpsec OS 1.1 (i3 Edition)

<p align="center">
  <img src="https://raw.githubusercontent.com/scpsec/scpsec-logo/main/logo_circle.png" alt="Scpsec OS Logo" width="180">
</p>

<p align="center">
  <strong>A lightweight, fast, and security-focused Linux distribution built on Debian 12.</strong>
</p>

<p align="center">
Designed for developers, penetration testers, security researchers, and Linux enthusiasts.
</p>

---

# ✨ Overview

**Scpsec OS** is a customized Linux distribution based on **Debian 12 (Bookworm)** that combines performance, simplicity, and a modern desktop experience.

Instead of a traditional desktop environment, Scpsec OS uses the **i3 Window Manager**, providing an efficient keyboard-driven workflow with minimal resource usage.

The system comes preconfigured with carefully selected applications, custom themes, and security-oriented defaults, making it suitable for both everyday use and cybersecurity tasks.

---

# 🚀 Features

## 🐧 System

* Debian 12 (Bookworm)
* 64-bit (amd64)
* Lightweight and optimized
* Non-free firmware support
* Fast boot and low memory usage

## 🖥 Desktop

* i3 Window Manager
* Catppuccin Macchiato theme
* Polybar status bar
* Picom compositor
* Rofi application launcher
* Dunst notification daemon
* Feh wallpaper manager

## 💻 Terminal

* Kitty terminal emulator
* Fastfetch system information
* Customized Bash configuration
* Developer-friendly shell

## 🛠 Included Utilities

* Calamares graphical installer
* NetworkManager
* GTK theme integration
* Audio support
* Screenshot utilities
* Power management

## 🔐 Security

* Debian Stable security updates
* Minimal attack surface
* Security-focused configuration
* Suitable for penetration testing environments

---

# ⌨️ Default Keyboard Shortcuts

| Shortcut                       | Action                   |
| ------------------------------ | ------------------------ |
| **Super + Enter**              | Open Kitty               |
| **Super + D**                  | Launch Rofi              |
| **Super + Shift + Q**          | Close focused window     |
| **Super + Shift + R**          | Reload i3 configuration  |
| **Super + F**                  | Toggle fullscreen        |
| **Super + 1-9**                | Switch workspace         |
| **Super + Shift + 1-9**        | Move window to workspace |
| **Super + Arrow Keys**         | Change focus             |
| **Super + Shift + Arrow Keys** | Move window              |

> **Super** refers to the **Windows** key.

---

# 📦 Included Software

* Kitty
* i3wm
* Polybar
* Picom
* Rofi
* Dunst
* Feh
* NetworkManager
* Fastfetch
* Calamares Installer

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

## Clone the Repository

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

After the build finishes, the generated ISO will be located inside the project directory.

Example:

```text
Scpsec-OS-1.1-I3-Desktop-amd64-2026.08.02.iso
```

---

# 🔑 Live Session

| Username   | Password |
| ---------- | -------- |
| **scpsec** | **live** |

### Sudo

Passwordless sudo is enabled for the live session.

---

# 📂 Project Structure

```text
.
├── install-deps.sh
├── build.sh
├── README.md
└── LICENSE
```

---

# 📸 Desktop

Features include:

* Catppuccin Macchiato
* Polybar
* Picom blur & transparency
* Rounded terminal
* Fast boot
* Modern dark theme

---

# ❤️ Why Scpsec OS?

* Extremely lightweight
* Modern UI
* Keyboard-first workflow
* Debian stability
* Security-oriented
* Easy to customize
* Open Source

---

# 📜 License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**.

See the **LICENSE** file for more information.

---

# 👥 Maintainers

Developed and maintained by the **Scpsec Team**.

---

# 🌐 Links

- **Website:** https://scpsec.cc
- **GitHub Organization:** https://github.com/scpsec
- **Documentation:** https://docs.scpsec.cc

---

<p align="center">
Made with ❤️ by the Scpsec Team
</p>
