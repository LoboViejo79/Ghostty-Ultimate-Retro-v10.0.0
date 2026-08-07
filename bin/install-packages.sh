#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"

require_command sudo
family="$(detect_family)"

install_arch() {
    require_command pacman
    local packages=(
        ghostty zsh git eza bat fastfetch fontconfig
        ttf-jetbrains-mono-nerd
        zsh-autosuggestions zsh-syntax-highlighting
    )
    local missing=() pkg
    for pkg in "${packages[@]}"; do
        pacman -Q "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
    done

    if ((${#missing[@]} == 0)); then
        ok "Todos los paquetes requeridos ya están instalados."
        return
    fi

    printf 'Paquetes faltantes:\n'
    printf '  - %s\n' "${missing[@]}"
    warn "No se ejecutará pacman -Syu automáticamente."
    warn "Arch no admite actualizaciones parciales. Si pacman informa incompatibilidades, cancela y actualiza el sistema manualmente."
    confirm "¿Instalar solo los paquetes faltantes?" || return 0
    sudo pacman -S --needed "${missing[@]}"
}

apt_has_candidate() {
    apt-cache policy "$1" 2>/dev/null |
        awk '/Candidate:/ { exit ($2 == "(none)") }'
}

install_debian() {
    require_command apt-get
    require_command apt-cache

    warn "Se actualizará únicamente el índice de paquetes de APT."
    confirm "¿Ejecutar apt-get update?" || die "Se canceló la preparación de APT."
    sudo apt-get update

    local desired=(zsh git eza bat fastfetch fontconfig)
    local available=() unavailable=() pkg
    command -v ghostty >/dev/null 2>&1 || desired+=(ghostty)

    for pkg in "${desired[@]}"; do
        if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q 'install ok installed'; then
            continue
        elif apt_has_candidate "$pkg"; then
            available+=("$pkg")
        else
            unavailable+=("$pkg")
        fi
    done

    if ((${#available[@]})); then
        printf 'Paquetes disponibles para instalar:\n'
        printf '  - %s\n' "${available[@]}"
        confirm "¿Continuar?" && sudo apt-get install --no-install-recommends "${available[@]}"
    else
        ok "No hay paquetes disponibles pendientes."
    fi

    if ((${#unavailable[@]})); then
        warn "No disponibles en los repositorios habilitados: ${unavailable[*]}"
    fi
    command -v ghostty >/dev/null 2>&1 ||
        warn "Ghostty no está instalado. Utiliza un método oficial compatible con tu versión de Debian/Ubuntu."
}

dnf_has_package() {
    dnf -q list --available "$1" >/dev/null 2>&1 ||
    rpm -q "$1" >/dev/null 2>&1
}

install_fedora() {
    require_command dnf
    local desired=(zsh git eza bat fastfetch fontconfig)
    local available=() unavailable=() pkg
    command -v ghostty >/dev/null 2>&1 || desired+=(ghostty)

    for pkg in "${desired[@]}"; do
        if rpm -q "$pkg" >/dev/null 2>&1; then
            continue
        elif dnf_has_package "$pkg"; then
            available+=("$pkg")
        else
            unavailable+=("$pkg")
        fi
    done

    if ((${#available[@]})); then
        printf 'Paquetes disponibles para instalar:\n'
        printf '  - %s\n' "${available[@]}"
        confirm "¿Continuar?" && sudo dnf install "${available[@]}"
    else
        ok "No hay paquetes disponibles pendientes."
    fi

    if ((${#unavailable[@]})); then
        warn "No disponibles en los repositorios habilitados: ${unavailable[*]}"
    fi
    command -v ghostty >/dev/null 2>&1 ||
        warn "Ghostty no está instalado. Utiliza un método oficial compatible con tu versión de Fedora."
}

case "$family" in
    arch) install_arch ;;
    debian) install_debian ;;
    fedora) install_fedora ;;
    *) die "Distribución no soportada automáticamente." ;;
esac

ok "Fase de paquetes finalizada."
