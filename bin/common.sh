#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly PROJECT_DIR
readonly STATE_DIR="$HOME/.local/state/ghostty-ultimate"
readonly BACKUP_BASE="$STATE_DIR/backups"
readonly P10K_DIR="$HOME/.local/share/powerlevel10k"
readonly PLUGIN_DIR="$HOME/.local/share/ghostty-ultimate/plugins"

log()  { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m[OK]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[AVISO]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*" >&2; exit 1; }

require_command() {
    command -v "$1" >/dev/null 2>&1 || die "Falta el comando requerido: $1"
}

confirm() {
    local prompt="$1" answer
    read -r -p "$prompt [s/N]: " answer
    [[ "$answer" =~ ^[sS]$ ]]
}

load_os_release() {
    [[ -r /etc/os-release ]] || die "No se puede leer /etc/os-release."
    # shellcheck disable=SC1091
    . /etc/os-release
}

detect_family() {
    load_os_release
    case "${ID:-}" in
        arch|cachyos|endeavouros|manjaro) printf 'arch\n'; return ;;
        debian|ubuntu|linuxmint|pop|elementary|zorin) printf 'debian\n'; return ;;
        fedora|rhel|centos|rocky|almalinux) printf 'fedora\n'; return ;;
    esac
    case " ${ID_LIKE:-} " in
        *" arch "*) printf 'arch\n' ;;
        *" debian "*) printf 'debian\n' ;;
        *" fedora "*|*" rhel "*) printf 'fedora\n' ;;
        *) printf 'unsupported\n' ;;
    esac
}

distro_name() {
    load_os_release
    printf '%s\n' "${PRETTY_NAME:-${NAME:-Desconocida}}"
}

new_backup_dir() {
    local dir="$BACKUP_BASE/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$dir"
    printf '%s\n' "$dir"
}

backup_path() {
    local source="$1" backup_root="$2" relative="$3"
    [[ -e "$source" || -L "$source" ]] || return 0
    mkdir -p "$(dirname -- "$backup_root/$relative")"
    cp -a -- "$source" "$backup_root/$relative"
}

install_file() {
    local source="$1" destination="$2" mode="${3:-0600}"
    mkdir -p "$(dirname -- "$destination")"
    install -m "$mode" -- "$source" "$destination"
}

render_template() {
    local source="$1" destination="$2" escaped_home
    escaped_home="$(printf '%s' "$HOME" | sed 's/[\/&]/\\&/g')"
    mkdir -p "$(dirname -- "$destination")"
    sed "s/@HOME@/$escaped_home/g" "$source" > "$destination"
    chmod 0600 "$destination"
}

latest_backup_dir() {
    find "$BACKUP_BASE" -mindepth 1 -maxdepth 1 -type d 2>/dev/null |
        sort -r | head -n 1
}
