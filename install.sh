#!/usr/bin/env bash

set -euo pipefail


SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

GREEN='\033[0;32m'
NC='\033[0m' # No Color

install() {
    sudo pacman -S --needed --noconfirm "$@"
}

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Updating system${NC}"
echo -e "${GREEN}========================================${NC}"

sudo pacman -Syu --noconfirm

########################################
# Hyprland
# hyprland          — Wayland-композитор
# waybar            — статус-бар
# mako              — демон нотифікацій
# hyprpolkitagent   — агент авторизації polkit (тепер в офіційних репах)
# hyprpaper         — демон шпалер
# hyprlock          — екран блокування
# hypridle          — демон бездіяльності (idle)
########################################

echo -e "${GREEN}==> Installing Hyprland${NC}"

install \
    hyprland \
    waybar \
    mako \
    hyprpolkitagent \
    hyprpaper \
    hyprlock \
    hypridle

########################################
# Термінал та файловий менеджер
# kitty    — емулятор терміналу
# vim      — текстовий редактор
# dolphin  — файловий менеджер
########################################

echo -e "${GREEN}==> Installing Terminal${NC}"

install \
    kitty \
    vim \
    dolphin

########################################
# Скріншоти та буфер обміну
# grim         — утиліта для скріншотів
# slurp        — вибір області екрана
# cliphist     — історія буфера обміну
# wl-clipboard — буфер обміну для Wayland
########################################

echo -e "${GREEN}==> Installing Screenshot tools${NC}"

install \
    grim \
    slurp \
    cliphist \
    wl-clipboard

########################################
# Wayland
# qt5-wayland                  — підтримка Wayland для Qt5
# qt6-wayland                  — підтримка Wayland для Qt6
# uwsm                         — менеджер Wayland-сесій
# xdg-desktop-portal-hyprland  — портал для Hyprland
# xdg-utils                    — утиліти робочого столу
########################################

echo -e "${GREEN}==> Installing Wayland support${NC}"

install \
    qt5-wayland \
    qt6-wayland \
    uwsm \
    xdg-desktop-portal-hyprland \
    xdg-utils

########################################
# Розробка
# git        — система контролю версій
# base-devel — базові інструменти збірки
# wget       — завантажувач файлів
# curl       — HTTP-клієнт
########################################

echo -e "${GREEN}==> Installing Development tools${NC}"

install \
    git \
    base-devel \
    wget \
    curl

########################################
# Shell
# zsh                        — оболонка командного рядка
# zsh-autosuggestions        — підказки команд на основі історії
# zsh-syntax-highlighting    — підсвітка синтаксису команд
# zsh-completions            — розширений набір автодоповнень
# zsh-history-substring-search — пошук по історії підрядком через стрілки
########################################

echo -e "${GREEN}==> Installing Zsh${NC}"

install \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    zsh-completions \
    zsh-history-substring-search

echo -e "${GREEN}==> Configuring Zsh${NC}"

if [ ! -f "$HOME/.zshrc" ]; then
    touch "$HOME/.zshrc"
fi

cat >> "$HOME/.zshrc" << 'EOF'

# --- Автодоповнення та підказки ---
fpath+=(/usr/share/zsh/site-functions)
autoload -Uz compinit && compinit

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
EOF

sudo chsh -s /usr/bin/zsh "$USER"

########################################
# yay — AUR-хелпер
########################################

echo -e "${GREEN}==> Installing yay${NC}"

if ! command -v yay >/dev/null 2>&1; then
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
else
    echo "yay is already installed."
fi

########################################
# Архіви
# 7zip — утиліта для роботи з архівами
########################################

echo -e "${GREEN}==> Installing Archive tools${NC}"

install \
    7zip

########################################
# Графіка
# mesa           — драйвери OpenGL
# vulkan-radeon  — драйвер Vulkan для AMD
########################################

echo -e "${GREEN}==> Installing Graphics drivers${NC}"

install \
    mesa \
    vulkan-radeon

########################################
# Мережа
# networkmanager          — менеджер мережі
# network-manager-applet  — аплет у треї
########################################

echo -e "${GREEN}==> Installing Networking${NC}"

install \
    networkmanager \
    network-manager-applet

########################################
# Аудіо
# pipewire         — аудіосервер
# pipewire-alsa    — підтримка ALSA
# pipewire-pulse   — сумісність з PulseAudio
# pipewire-jack    — сумісність з JACK
# wireplumber      — менеджер сесій PipeWire
########################################

echo -e "${GREEN}==> Installing Audio${NC}"

install \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-jack \
    wireplumber

########################################
# Bluetooth
# bluez        — стек Bluetooth
# bluez-utils  — утиліти Bluetooth
# blueman      — GUI для Bluetooth
########################################

echo -e "${GREEN}==> Installing Bluetooth${NC}"

install \
    bluez \
    bluez-utils \
    blueman

########################################
# Утиліти
# brightnessctl — керування яскравістю
# playerctl     — керування медіаплеєром
########################################

echo -e "${GREEN}==> Installing Utilities${NC}"

install \
    brightnessctl \
    playerctl

########################################
# Шрифти
# ttf-jetbrains-mono-nerd — Nerd Font
# noto-fonts              — юнікод-шрифти
# noto-fonts-emoji        — емодзі-шрифти
########################################

echo -e "${GREEN}==> Installing Fonts${NC}"

install \
    ttf-jetbrains-mono-nerd \
    noto-fonts \
    noto-fonts-emoji

########################################
# Менеджер входу
# sddm — display manager
########################################

echo -e "${GREEN}==> Installing Login Manager${NC}"

install \
    sddm

########################################
# Файрвол
# ufw — файрвол
########################################

echo -e "${GREEN}==> Installing Firewall${NC}"

install \
    ufw

########################################
# AUR-пакети
# hyprshot                     — утиліта для скріншотів
# brave-bin                    — браузер Brave
# walker                       — застосунок-лаунчер (AUR, потребує elephant)
# elephant                     — бекенд, необхідний для роботи walker
# elephant-providerlist        — провайдер: перемикач провайдерів
# elephant-desktopapplications — провайдер: список desktop-застосунків
########################################

echo -e "${GREEN}==> Installing AUR packages${NC}"

yay -S --needed --noconfirm \
    hyprshot \
    brave-bin \
    walker \
    elephant \
    elephant-providerlist \
    elephant-desktopapplications

########################################
# Enable Services
########################################

echo -e "${GREEN}==> Enabling services${NC}"

sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable sddm
sudo systemctl enable ufw

########################################
echo -e "${GREEN}==> Configuring${NC}"

cp "$SCRIPT_DIR/hypr/hyprland.conf"  ~/.config/hypr/hyprland.conf

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN} Installation completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
