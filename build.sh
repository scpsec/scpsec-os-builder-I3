#!/bin/bash
# ==============================================================================
# Scpsec OS 1.1 
# Copyright (c) Scpsec Company
# Target Base: Debian x86_64 (Bookworm)
# Target ISO Name: Scpsec-OS-1.1-I3-Desktop-amd64-2026.08.02.iso
# ==============================================================================

set -e

# Ensure root execution
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] This script must be run as root (use: sudo ./build.sh)"
    exit 1
fi

echo "[INFO] Starting Scpsec OS v1.1 i3wm hardened build process with Full Wi-Fi Maintenance Suite..."

# Build environment setup
BUILD_DIR="scpsec-os"
mkdir -p "$BUILD_DIR" && cd "$BUILD_DIR"

echo "[INFO] Cleaning previous live-build state..."
lb clean --purge || true

echo "[INFO] Configuring live-build parameters..."
lb config \
  --distribution bookworm \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free non-free-firmware" \
  --bootappend-live "boot=live components quiet splash username=scpsec user-fullname=scpsec hostname=Scpsec-OS"

echo "[INFO] Creating directory tree..."
mkdir -p config/includes.chroot/etc/firefox/policies/
mkdir -p config/includes.chroot/etc/sudoers.d/
mkdir -p config/includes.chroot/etc/plymouth/
mkdir -p config/includes.chroot/etc/skel/Desktop/
mkdir -p config/includes.chroot/etc/skel/.config/i3/
mkdir -p config/includes.chroot/etc/skel/.config/polybar/
mkdir -p config/includes.chroot/etc/skel/.config/rofi/
mkdir -p config/includes.chroot/etc/skel/.config/picom/
mkdir -p config/includes.chroot/etc/skel/.config/kitty/
mkdir -p config/includes.chroot/etc/skel/.config/dunst/
mkdir -p config/includes.chroot/etc/skel/.config/autostart/
mkdir -p config/includes.chroot/etc/skel/Pictures/Wallpapers/
mkdir -p config/includes.chroot/usr/bin/
mkdir -p config/includes.chroot/usr/share/applications/
mkdir -p config/includes.chroot/usr/share/backgrounds/
mkdir -p config/includes.chroot/usr/share/pixmaps/
mkdir -p config/includes.chroot/usr/share/fonts/nerd-fonts/
mkdir -p config/includes.chroot/usr/share/plymouth/themes/scpsec/
mkdir -p config/includes.chroot/etc/calamares/branding/scpsec/
mkdir -p config/includes.chroot/etc/calamares/modules/
mkdir -p config/includes.chroot/etc/lightdm/lightdm.conf.d/
mkdir -p config/includes.chroot/etc/iwd/
mkdir -p config/package-lists/
mkdir -p config/hooks/live/

# OS Metadata v1.1
echo "[INFO] Writing OS release information..."
cat << 'EOF' > config/includes.chroot/etc/os-release
NAME="Scpsec OS"
VERSION="1.1"
ID=scpsec
ID_LIKE=debian
PRETTY_NAME="Scpsec OS 1.1 (i3wm Edition)"
HOME_URL="https://scpsec.cc"
SUPPORT_URL="https://scpsec.cc"
BUG_REPORT_URL="https://scpsec.cc"
PRIVACY_POLICY_URL="https://scpsec.cc"
BUILD_ID="2026.08.02"
EOF

# Assets & Branding Downloads
echo "[INFO] Downloading assets..."
wget -q -O config/includes.chroot/usr/share/pixmaps/scpsec-logo.png "https://raw.githubusercontent.com/scpsec/scpsec-logo/main/logo_circle.png" || true
wget -q -O config/includes.chroot/usr/share/plymouth/themes/scpsec/scpsec-logo.png "https://raw.githubusercontent.com/scpsec/scpsec-logo/main/logo.png" || true

# Wallpaper setup
wget -q -O config/includes.chroot/usr/share/backgrounds/scpsec-wallpaper.png "https://raw.githubusercontent.com/scpsec/scpsec-logo/refs/heads/main/blackhole.jpg" || \
cp config/includes.chroot/usr/share/pixmaps/scpsec-logo.png config/includes.chroot/usr/share/backgrounds/scpsec-wallpaper.png || true
cp config/includes.chroot/usr/share/backgrounds/scpsec-wallpaper.png config/includes.chroot/etc/skel/Pictures/Wallpapers/cyberpunk.jpg

# Modern Shell Configuration (.bashrc)
echo "[INFO] Setting up default user .bashrc..."
cat << 'EOF' > config/includes.chroot/etc/skel/.bashrc
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

CYAN="\[\033[1;36m\]"
MAGENTA="\[\033[1;35m\]"
GREEN="\[\033[1;32m\]"
BLUE="\[\033[1;34m\]"
RED="\[\033[1;31m\]"
YELLOW="\[\033[1;33m\]"
RESET="\[\033[0m\]"

PS1="${MAGENTA}╭─${CYAN}\u${RESET}@${BLUE}\h ${YELLOW}󰋜 \w${RESET}\n${MAGENTA}╰─❯${RESET} "

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias kss='clear'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo apt update && sudo apt upgrade -y'

# Quick Wi-Fi Maintenance Aliases
alias wifix='sudo scpsec-wifi-fix'
alias wimon='sudo airmon-ng start'
alias wioff='sudo airmon-ng stop'

command -v batcat &>/dev/null && alias bat='batcat'
command -v eza &>/dev/null && alias ls='eza --icons' && alias ll='eza -la --icons'

if command -v fastfetch &>/dev/null; then
    fastfetch
elif command -v neofetch &>/dev/null; then
    neofetch
fi
EOF

# Automatic Wi-Fi Repair Tool (scpsec-wifi-fix)
echo "[INFO] Injecting Scpsec Custom Wi-Fi Auto-Fix Tool..."
cat << 'EOF' > config/includes.chroot/usr/bin/scpsec-wifi-fix
#!/bin/bash
# ==============================================================================
# Scpsec OS - Automatic Wi-Fi & Driver Diagnostics Tool
# ==============================================================================
echo -e "\033[1;36m[+] Starting Scpsec Wi-Fi Diagnostics & Repair Tool...\033[0m"

echo "[1] Unblocking RFKILL locks..."
rfkill unblock all

echo "[2] Restarting Network Services..."
systemctl restart NetworkManager || true
systemctl restart iwd || true

echo "[3] Checking Wireless Interfaces..."
INTERFACES=$(ip -br link | grep -E 'wlan|wlp' | awk '{print $1}')

if [ -z "$INTERFACES" ]; then
    echo -e "\033[1;31m[-] No wireless interfaces found!\033[0m"
    echo "[!] Checking PCI/USB hardware drivers:"
    lspci -nnk | grep -i net -A3
    lsusb
    echo -e "\033[1;33m[?] Try running: sudo modprobe iwlwifi OR sudo modprobe rtw88_8822ce\033[0m"
else
    for iface in $INTERFACES; do
        echo -e "\033[1;32m[+] Found interface: $iface\033[0m"
        ip link set $iface up
    done
    echo -e "\033[1;32m[+] Wi-Fi reset completed successfully!\033[0m"
    echo -e "[*] Use 'iwctl' or 'nmcli device wifi list' to connect."
fi
EOF
chmod +x config/includes.chroot/usr/bin/scpsec-wifi-fix

# iwd configuration
cat << 'EOF' > config/includes.chroot/etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
EOF

# Scpsec Welcome Application
echo "[INFO] Creating Scpsec Welcome app..."
cat << 'EOF' > config/includes.chroot/usr/bin/scpsec-welcome
#!/usr/bin/env python3
import sys
import os
import subprocess
import gi

try:
    gi.require_version('Gtk', '4.0')
    gi.require_version('Adw', '1')
    from gi.repository import Gtk, Adw, Gio
except Exception:
    sys.exit(0)

CONFIG_DIR = os.path.expanduser("~/.config")
DISABLE_FLAG_FILE = os.path.join(CONFIG_DIR, "scpsec-welcome-donotshow")

class WelcomeWindow(Adw.ApplicationWindow):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.set_default_size(700, 560)
        self.set_title("Welcome to Scpsec OS")

        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=18)
        main_box.set_margin_top(28)
        main_box.set_margin_bottom(20)
        main_box.set_margin_start(28)
        main_box.set_margin_end(28)

        logo = Gtk.Image.new_from_file("/usr/share/pixmaps/scpsec-logo.png")
        logo.set_pixel_size(96)
        main_box.append(logo)

        title = Gtk.Label(label="Welcome to Scpsec OS 1.1 (i3 Edition)")
        title.add_css_class("title-1")
        main_box.append(title)

        subtitle = Gtk.Label(label="Your high-performance custom security workstation is ready.")
        subtitle.add_css_class("body")
        subtitle.set_wrap(True)
        subtitle.set_justify(Gtk.Justification.CENTER)
        main_box.append(subtitle)

        grid = Gtk.Grid()
        grid.set_column_spacing(16)
        grid.set_row_spacing(16)
        grid.set_halign(Gtk.Align.CENTER)
        grid.set_margin_top(12)

        btn_web = Gtk.Button(label="🌐 Visit Website")
        btn_web.set_size_request(160, 42)
        btn_web.connect("clicked", lambda x: subprocess.Popen(["xdg-open", "https://scpsec.cc"]))
        grid.attach(btn_web, 0, 0, 1, 1)

        btn_settings = Gtk.Button(label="⚙️ Appearance (LXAppearance)")
        btn_settings.set_size_request(160, 42)
        btn_settings.connect("clicked", lambda x: subprocess.Popen(["lxappearance"]))
        grid.attach(btn_settings, 1, 0, 1, 1)

        btn_term = Gtk.Button(label="💻 Open Terminal")
        btn_term.set_size_request(160, 42)
        btn_term.connect("clicked", lambda x: subprocess.Popen(["kitty"]))
        grid.attach(btn_term, 0, 1, 2, 1)

        main_box.append(grid)

        bottom_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        bottom_box.set_margin_top(20)

        self.chk_dont_show = Gtk.CheckButton(label="Don't show this window on launch again")
        self.chk_dont_show.set_halign(Gtk.Align.CENTER)
        bottom_box.append(self.chk_dont_show)

        btn_close = Gtk.Button(label="Get Started")
        btn_close.add_css_class("suggested-action")
        btn_close.add_css_class("pill")
        btn_close.set_halign(Gtk.Align.CENTER)
        btn_close.set_size_request(140, 40)
        btn_close.connect("clicked", self.on_close_clicked)
        bottom_box.append(btn_close)

        main_box.append(bottom_box)
        self.set_content(main_box)

    def on_close_clicked(self, button):
        if self.chk_dont_show.get_active():
            os.makedirs(CONFIG_DIR, exist_ok=True)
            with open(DISABLE_FLAG_FILE, "w") as f:
                f.write("disabled\n")
        self.close()

class WelcomeApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="org.scpsec.welcome", flags=Gio.ApplicationFlags.FLAGS_NONE)

    def do_activate(self):
        if os.path.exists(DISABLE_FLAG_FILE):
            sys.exit(0)
            
        win = WelcomeWindow(application=self)
        win.present()

if __name__ == "__main__":
    app = WelcomeApp()
    app.run(sys.argv)
EOF
chmod +x config/includes.chroot/usr/bin/scpsec-welcome

# Desktop & Autostart Loaders
cat << 'EOF' > config/includes.chroot/usr/share/applications/scpsec-welcome.desktop
[Desktop Entry]
Type=Application
Name=Scpsec Welcome
Comment=Welcome application for new Scpsec OS users
Exec=scpsec-welcome
Icon=/usr/share/pixmaps/scpsec-logo.png
Terminal=false
Categories=System;Utility;
EOF

cat << 'EOF' > config/includes.chroot/etc/skel/.config/autostart/scpsec-welcome.desktop
[Desktop Entry]
Type=Application
Name=Scpsec Welcome
Exec=sh -c "if [ ! -f ~/.config/scpsec-welcome-donotshow ] && [ \"$USER\" != \"scpsec\" ]; then scpsec-welcome; fi"
Icon=/usr/share/pixmaps/scpsec-logo.png
Terminal=false
X-GNOME-Autostart-enabled=true
EOF

# --- i3 Desktop Environment Setup ---
echo "[INFO] Creating i3wm, Polybar, Rofi, Picom & Kitty configs..."

# i3 Config
cat << 'EOF' > config/includes.chroot/etc/skel/.config/i3/config
set $mod Mod4

font pango:JetBrainsMono Nerd Font 10

# Auto Start Services
exec_always --no-startup-id picom -b
exec_always --no-startup-id ~/.config/polybar/launch.sh
exec_always --no-startup-id feh --bg-fill /usr/share/backgrounds/scpsec-wallpaper.png
exec_always --no-startup-id dunst
exec_always --no-startup-id nm-applet
exec --no-startup-id scpsec-welcome

# Gaps & Borders
for_window [class="^.*"] border pixel 2
gaps inner 10
gaps outer 5

# Catppuccin Macchiato Theme
set $bg       #1e1e2e
set $fg       #cdd6f4
set $purple   #cba6f7
set $red      #f38ba8
set $gray     #313244

client.focused           $purple  $purple  $bg     $purple
client.focused_inactive  $gray    $bg      $fg     $gray
client.unfocused         $gray    $bg      $fg     $gray
client.urgent            $red     $red     $bg     $red

# Binds
bindsym $mod+Return exec kitty
bindsym $mod+d exec rofi -show drun -theme ~/.config/rofi/config.rasi
bindsym $mod+Shift+q kill
bindsym $mod+f fullscreen toggle
bindsym $mod+Shift+space floating toggle

# Focus Movement
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# Move Windows
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# Workspaces
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"

bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5

bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5

# Controls
bindsym XF86AudioRaiseVolume exec --no-startup-id pamixer -i 5
bindsym XF86AudioLowerVolume exec --no-startup-id pamixer -d 5
bindsym XF86AudioMute exec --no-startup-id pamixer -t
bindsym XF86MonBrightnessUp exec --no-startup-id brightnessctl set +10%
bindsym XF86MonBrightnessDown exec --no-startup-id brightnessctl set 10%-

bindsym Print exec flameshot gui
bindsym $mod+Shift+r restart
EOF

# Polybar Config
cat << 'EOF' > config/includes.chroot/etc/skel/.config/polybar/config.ini
[colors]
bg = #1e1e2e
bg-alt = #313244
fg = #cdd6f4
accent = #cba6f7
green = #a6e3a1

[bar/main]
width = 100%
height = 28pt
radius = 8
background = ${colors.bg}
foreground = ${colors.fg}
line-size = 3pt
border-size = 4pt
border-color = #00000000
padding-left = 1
padding-right = 1
module-margin = 1

font-0 = "JetBrainsMono Nerd Font:size=10;3"

modules-left = xworkspaces xwindow
modules-right = wlan cpu memory volume date

[module/xworkspaces]
type = internal/i3
enable-click = true
label-focused = %index%
label-focused-background = ${colors.bg-alt}
label-focused-underline = ${colors.accent}
label-focused-padding = 2
label-unfocused = %index%
label-unfocused-padding = 2

[module/xwindow]
type = internal/xwindow
label = %title:0:25:...%

[module/wlan]
type = internal/network
interface-type = wireless
interval = 3.0
format-connected = <label-connected>
format-connected-prefix = "󰤨 "
format-connected-prefix-foreground = ${colors.green}
label-connected = %essid%
format-disconnected = <label-disconnected>
format-disconnected-prefix = "󰤭 "
format-disconnected-prefix-foreground = ${colors.accent}
label-disconnected = Offline

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = " "
format-prefix-foreground = ${colors.accent}
label = %percentage%%

[module/memory]
type = internal/memory
interval = 2
format-prefix = "󰍛 "
format-prefix-foreground = ${colors.accent}
label = %percentage_used%%

[module/volume]
type = internal/pulseaudio
format-volume-prefix = "󰕾 "
format-volume-prefix-foreground = ${colors.green}
label-volume = %percentage%%

[module/date]
type = internal/date
interval = 1
date = %H:%M:%S  %a, %b %d
label = %date%
label-foreground = ${colors.accent}
EOF

# Polybar Launcher Script
cat << 'EOF' > config/includes.chroot/etc/skel/.config/polybar/launch.sh
#!/bin/bash
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar main 2>&1 | tee -a /tmp/polybar.log & disown
EOF
chmod +x config/includes.chroot/etc/skel/.config/polybar/launch.sh

# Rofi Launcher Theme
cat << 'EOF' > config/includes.chroot/etc/skel/.config/rofi/config.rasi
configuration {
    modi: "drun,run,window";
    font: "JetBrainsMono Nerd Font 11";
    show-icons: true;
    icon-theme: "Papirus";
}

* {
    bg: #1e1e2e;
    bg-alt: #313244;
    fg: #cdd6f4;
    accent: #cba6f7;
    background-color: @bg;
    text-color: @fg;
}

window {
    width: 35%;
    border-radius: 12px;
    padding: 15px;
    border: 2px solid;
    border-color: @accent;
}

element selected {
    background-color: @bg-alt;
    text-color: @accent;
    border-radius: 6px;
}
EOF

# Picom Compositor Configuration
cat << 'EOF' > config/includes.chroot/etc/skel/.config/picom/picom.conf
backend = "glx";
vsync = true;
fading = true;
fade-delta = 4;
corner-radius = 10;
active-opacity = 0.95;
inactive-opacity = 0.85;
opacity-rule = [
  "100:class_g = 'Rofi'",
  "100:class_g = 'feh'",
  "100:class_g = 'flameshot'"
];
EOF

# Kitty Terminal Config
cat << 'EOF' > config/includes.chroot/etc/skel/.config/kitty/kitty.conf
font_family      JetBrainsMono Nerd Font
font_size        11.0
background_opacity 0.85
confirm_os_window_close 0
padding_width 10

background #1e1e2e
foreground #cdd6f4
selection_background #585b70
selection_foreground #cdd6f4
cursor #f5e0dc
EOF

# Dunst Config
cat << 'EOF' > config/includes.chroot/etc/skel/.config/dunst/dunstrc
[global]
    font = JetBrainsMono Nerd Font 10
    corner_radius = 8
    width = 300
    height = 100
    offset = 20x45
    origin = top-right
    background = "#1e1e2e"
    foreground = "#cdd6f4"
    frame_color = "#cba6f7"
    frame_width = 2
EOF

# Firefox Policies
echo "[INFO] Setting Firefox policies..."
cat << 'EOF' > config/includes.chroot/etc/firefox/policies/policies.json
{
  "policies": {
    "Homepage": {
      "URL": "https://scpsec.cc",
      "Locked": false,
      "StartPage": "homepage"
    },
    "NewTabURL": "https://scpsec.cc",
    "OverrideFirstRunPage": "",
    "OverridePostUpdatePage": "",
    "DontCheckDefaultBrowser": true,
    "DisplayBookmarksToolbar": "never",
    "SearchBar": "unified",
    "EnableTrackingProtection": {
      "Value": true,
      "Locked": false,
      "Cryptomining": true,
      "Fingerprinting": true
    }
  }
}
EOF

# Plymouth Boot Theme
echo "[INFO] Configuring Plymouth boot theme..."
cat << 'EOF' > config/includes.chroot/etc/plymouth/plymouthd.conf
[Daemon]
Theme=scpsec
ShowDelay=0
DeviceTimeout=8
EOF

cat << 'EOF' > config/includes.chroot/usr/share/plymouth/themes/scpsec/scpsec.plymouth
[Plymouth Theme]
Name=Scpsec OS Boot
Description=Official Plymouth theme for Scpsec OS
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/scpsec
ScriptFile=/usr/share/plymouth/themes/scpsec/scpsec.script
EOF

cat << 'EOF' > config/includes.chroot/usr/share/plymouth/themes/scpsec/scpsec.script
logo.image = Image("scpsec-logo.png");
logo.sprite = Sprite(logo.image);
logo.sprite.SetX(Window.GetWidth() / 2 - logo.image.GetWidth() / 2);
logo.sprite.SetY(Window.GetHeight() / 2 - logo.image.GetHeight() / 2);

Window.SetBackgroundTopColor(0.047, 0.208, 0.400);
Window.SetBackgroundBottomColor(0.047, 0.208, 0.400);
EOF

# LightDM Default Session Set to i3
echo "[INFO] Setting LightDM default session to i3..."
cat << 'EOF' > config/includes.chroot/etc/lightdm/lightdm.conf.d/50-default-i3.conf
[Seat:*]
user-session=i3
autologin-user=scpsec
autologin-user-timeout=0
EOF

# Sudo Permissions
echo "scpsec ALL=(ALL) NOPASSWD: ALL" > config/includes.chroot/etc/sudoers.d/scpsec-live
chmod 0440 config/includes.chroot/etc/sudoers.d/scpsec-live

# Desktop Shortcuts
cat << 'EOF' > config/includes.chroot/etc/skel/Desktop/install-scpsec.desktop
[Desktop Entry]
Type=Application
Name=Install Scpsec OS
Comment=Install Scpsec OS to your computer
Exec=sudo calamares
Icon=/usr/share/pixmaps/scpsec-logo.png
Terminal=false
Categories=System;
EOF

cat << 'EOF' > config/includes.chroot/etc/skel/Desktop/scpsec-website.desktop
[Desktop Entry]
Type=Link
Name=Scpsec Website
URL=https://scpsec.cc
Icon=/usr/share/pixmaps/scpsec-logo.png
EOF

chmod +x config/includes.chroot/etc/skel/Desktop/*.desktop || true

# Calamares Configuration
echo "[INFO] Setting up Calamares installer..."
cat << 'EOF' > config/includes.chroot/etc/calamares/branding/scpsec/branding.desc
---
componentName: scpsec
welcomeStyleCalamares: true
welcomeExpandingLogo: true

strings:
  productName: "Scpsec OS"
  shortProductName: "Scpsec"
  version: "1.1"
  shortVersion: "1.1"
  versionedName: "Scpsec OS 1.1"
  shortVersionedName: "Scpsec 1.1"
  sidebar: "Scpsec OS"
  navigation: "Installer"
  supportUrl: "https://scpsec.cc"

images:
  productLogo: "/usr/share/pixmaps/scpsec-logo.png"
  productIcon: "/usr/share/pixmaps/scpsec-logo.png"

slideshow: "show.qml"
slideshowAPI: 2

style:
  SidebarBackground: "#1e1e2e"
  SidebarText: "#cdd6f4"
  SidebarTextSelect: "#cba6f7"
  SidebarTextHighlight: "#cdd6f4"
EOF

cat << 'EOF' > config/includes.chroot/etc/calamares/branding/scpsec/show.qml
import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Welcome to Scpsec OS 1.1 (i3 Edition)"
            font.pixelSize: 24
            color: "#cdd6f4"
        }
    }
}
EOF

cat << 'EOF' > config/includes.chroot/etc/calamares/modules/packages.conf
---
backend: apt
skip_if_no_change: true
update_db: false

purge:
  - calamares
  - calamares-settings-debian
  - live-boot
  - live-boot-initramfs-tools
  - live-config
  - live-config-systemd
  - live-tools
EOF

cat << 'EOF' > config/includes.chroot/etc/calamares/modules/removeuser.conf
---
username: scpsec
EOF

cat << 'EOF' > config/includes.chroot/etc/calamares/settings.conf
---
modules-search: [ local ]

instances:
- id: scpsec
  module: branding
  config: branding.desc

sequence:
- show:
  - welcome
  - locale
  - keyboard
  - partition
  - users
  - summary
- exec:
  - partition
  - mount
  - unpackfs
  - machineid
  - fstab
  - locale
  - keyboard
  - localecfg
  - users
  - displaymanager
  - networkcfg
  - hwclock
  - grubcfg
  - bootloader
  - removeuser
  - packages
  - umount
- show:
  - finished

branding: scpsec
prompt-at-end: true
EOF

# Complete Package Manifest (With Full Wi-Fi Diagnostics & Maintenance Suite)
echo "[INFO] Creating Package Manifest with Wi-Fi Tools..."
cat << 'EOF' > config/package-lists/scpsec.list.chroot
# Display Server & Display Manager Core
xorg
xserver-xorg
desktop-base
lightdm
lightdm-gtk-greeter

# Core i3 Desktop Environment
i3
i3blocks
i3lock
polybar
rofi
picom
kitty
feh
dunst
flameshot
lxappearance
arandr
xclip
papirus-icon-theme
brightnessctl
pamixer

# Full Wi-Fi Maintenance, Analysis & Security Tools
iwd
wireless-tools
iw
rfkill
network-manager
network-manager-gnome
wpasupplicant
macchanger
aircrack-ng
wireshark
tshark
net-tools
dnsutils
pcaputils
ethtool

# Drivers & Hardware Firmwares (Full Coverage)
firmware-linux
firmware-linux-nonfree
firmware-realtek
firmware-iwlwifi
firmware-atheros
firmware-ipw2x00
firmware-libertas
firmware-brcm80211
firmware-b43-installer
firmware-zd1211

# scpsec Welcome GUI Stack
python3
python3-gi
gir1.2-gtk-4.0
gir1.2-adw-1

# Live System & Installer
calamares
calamares-settings-debian
qml-module-qtquick2
qml-module-qtquick-controls
squashfs-tools
live-boot
live-config
live-config-systemd

# Bootloader & Kernel Tools
plymouth
plymouth-themes
grub-common
grub-pc-bin
grub-efi-amd64-bin
efibootmgr

# User Applications
firefox-esr
nautilus
eog
gnome-calculator
gnome-system-monitor

# Build & System Utilities
sudo
git
curl
wget
flatpak
p7zip-full
unzip
neofetch
gettext
make
build-essential
EOF

# Chroot Hook
echo "[INFO] Registering Chroot Hook..."
cat << 'EOF' > config/hooks/live/0090-scpsec-system-setup.hook.chroot
#!/bin/sh
set -e

# Live User Password setup
if id "scpsec" >/dev/null 2>&1; then
    echo "scpsec:live" | chpasswd
else
    useradd -m -s /bin/bash scpsec || true
    echo "scpsec:live" | chpasswd
fi

# Fetch JetBrainsMono Nerd Font System-wide
FONT_DIR="/usr/share/fonts/nerd-fonts"
mkdir -p "$FONT_DIR"
TMP_FONT=$(mktemp -d)
wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O "$TMP_FONT/font.zip" || true
if [ -f "$TMP_FONT/font.zip" ]; then
    unzip -q "$TMP_FONT/font.zip" -d "$FONT_DIR"
    rm -rf "$TMP_FONT"
    fc-cache -f || true
fi

# Direct Download & Install Fastfetch inside Chroot
FASTFETCH_DEB="fastfetch-linux-amd64.deb"
wget -q "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.deb" -O "/tmp/$FASTFETCH_DEB" || true
if [ -f "/tmp/$FASTFETCH_DEB" ]; then
    dpkg -i "/tmp/$FASTFETCH_DEB" || apt-get install -f -y
    rm -f "/tmp/$FASTFETCH_DEB"
fi

# Enable LightDM, NetworkManager, and iwd Services
systemctl enable lightdm.service || true
systemctl enable NetworkManager.service || true
systemctl enable iwd.service || true
EOF

chmod +x config/hooks/live/0090-scpsec-system-setup.hook.chroot

# Execute Live Build
echo "[INFO] Running live-build..."
lb build

# ISO Rename to Target Name
FINAL_ISO_NAME="Scpsec-OS-1.1-I3-Desktop-amd64-2026.08.02.iso"
if [ -f live-image-amd64.hybrid.iso ]; then
    mv live-image-amd64.hybrid.iso "$FINAL_ISO_NAME"
    echo "[SUCCESS] Build completed! Created ISO: $FINAL_ISO_NAME"
fi
