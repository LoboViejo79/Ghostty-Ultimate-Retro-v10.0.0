#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"
require_command git

clone_or_update() {
    local url="$1" target="$2" name="$3"
    mkdir -p "$(dirname -- "$target")"
    if [[ -d "$target/.git" ]]; then
        log "Actualizando $name mediante fast-forward..."
        git -C "$target" pull --ff-only
    elif [[ -e "$target" ]]; then
        die "$target existe, pero no es un repositorio Git administrable."
    else
        log "Instalando $name..."
        git clone --depth=1 "$url" "$target"
    fi
}

clone_or_update \
    "https://github.com/romkatv/powerlevel10k.git" \
    "$P10K_DIR" \
    "Powerlevel10k"

clone_or_update \
    "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "$PLUGIN_DIR/zsh-autosuggestions" \
    "zsh-autosuggestions"

clone_or_update \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
    "$PLUGIN_DIR/zsh-syntax-highlighting" \
    "zsh-syntax-highlighting"

ok "Powerlevel10k y complementos de Zsh disponibles."
