#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"

update_mode=false
[[ "${1:-}" == "--update" ]] && update_mode=true

if command -v yazi >/dev/null 2>&1 && [[ "$update_mode" == false ]]; then
    ok "Yazi ya está instalado: $(yazi --version | head -n 1)"
    exit 0
fi

family="$(detect_family)"

if [[ "$update_mode" == true ]] && command -v yazi >/dev/null 2>&1; then
    printf 'Versión instalada: %s\n' "$(yazi --version | head -n 1)"
    case "$family" in
        arch)
            confirm "¿Actualizar Yazi con pacman?" || exit 0
            sudo pacman -S --needed yazi
            ;;
        debian)
            if dpkg-query -W -f='${Status}' yazi 2>/dev/null | grep -q 'install ok installed'; then
                confirm "¿Actualizar Yazi desde APT?" || exit 0
                sudo apt-get update
                sudo apt-get install --only-upgrade yazi
            elif command -v snap >/dev/null 2>&1 && snap list yazi >/dev/null 2>&1; then
                confirm "¿Actualizar Yazi desde Snapcraft?" || exit 0
                sudo snap refresh yazi
            else
                die "No se pudo identificar el gestor que instaló Yazi."
            fi
            ;;
        fedora)
            if rpm -q yazi >/dev/null 2>&1; then
                confirm "¿Actualizar Yazi con DNF?" || exit 0
                sudo dnf upgrade yazi
            elif command -v snap >/dev/null 2>&1 && snap list yazi >/dev/null 2>&1; then
                confirm "¿Actualizar Yazi desde Snapcraft?" || exit 0
                sudo snap refresh yazi
            else
                die "No se pudo identificar el gestor que instaló Yazi."
            fi
            ;;
        *) die "Actualiza Yazi con el mismo gestor que utilizaste para instalarlo." ;;
    esac
    ok "Actualización de Yazi finalizada: $(yazi --version | head -n 1)"
    exit 0
fi

install_with_snap() {
    command -v snap >/dev/null 2>&1 || return 1
    warn "Yazi no está disponible en los repositorios habilitados; se puede instalar desde Snapcraft."
    confirm "¿Instalar Yazi mediante Snap?" || return 1
    sudo snap install yazi --classic
}

case "$family" in
    arch)
        require_command sudo
        require_command pacman
        confirm "¿Instalar Yazi y su dependencia file con pacman?" || exit 0
        sudo pacman -S --needed yazi file
        ;;
    debian)
        require_command sudo
        require_command apt-get
        require_command apt-cache
        if ! apt-cache show yazi >/dev/null 2>&1; then
            warn "APT no encuentra Yazi en el índice actual."
            if confirm "¿Actualizar el índice de APT para volver a buscar?"; then
                sudo apt-get update
            fi
        fi
        if apt-cache show yazi >/dev/null 2>&1; then
            confirm "¿Instalar Yazi y su dependencia file con APT?" || exit 0
            sudo apt-get install --no-install-recommends yazi file
        else
            install_with_snap || die "Yazi no está disponible mediante APT y Snap no se utilizó. Consulta https://yazi-rs.github.io/docs/installation/"
        fi
        ;;
    fedora)
        require_command sudo
        require_command dnf
        if dnf -q list --available yazi >/dev/null 2>&1 || rpm -q yazi >/dev/null 2>&1; then
            confirm "¿Instalar Yazi y su dependencia file con DNF?" || exit 0
            sudo dnf install yazi file
        else
            install_with_snap || die "Yazi no está en los repositorios DNF habilitados y Snap no se utilizó. Consulta https://yazi-rs.github.io/docs/installation/"
        fi
        ;;
    *)
        install_with_snap || die "Distribución no soportada automáticamente. Consulta https://yazi-rs.github.io/docs/installation/"
        ;;
esac

command -v yazi >/dev/null 2>&1 || die "La instalación terminó, pero el comando yazi no está disponible en PATH."
ok "Yazi instalado correctamente: $(yazi --version | head -n 1)"
