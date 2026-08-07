#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"
require_command zsh
require_command chsh
require_command getent

zsh_path="$(command -v zsh)"
current="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$current" == "$zsh_path" ]]; then
    ok "Zsh ya es el shell de inicio."
    exit 0
fi

warn "Este cambio modifica el shell de inicio de tu usuario."
confirm "¿Cambiar de $current a $zsh_path?" || { warn "Operación cancelada."; exit 0; }
chsh -s "$zsh_path"
ok "Shell cambiado. Cierra sesión y vuelve a entrar para aplicarlo globalmente."
