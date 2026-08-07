#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"

backup="$(latest_backup_dir)"
[[ -n "$backup" && -d "$backup" ]] || die "No se encontró ningún respaldo."

warn "Se restaurará el respaldo: $backup"
warn "Las configuraciones actuales serán reemplazadas."
confirm "¿Continuar?" || { warn "Restauración cancelada."; exit 0; }

restore_item() {
    local source="$1" destination="$2"
    [[ -e "$source" || -L "$source" ]] || return 0
    rm -rf -- "$destination"
    mkdir -p "$(dirname -- "$destination")"
    cp -a -- "$source" "$destination"
}

restore_item "$backup/config/ghostty" "$HOME/.config/ghostty"
restore_item "$backup/config/fastfetch" "$HOME/.config/fastfetch"
restore_item "$backup/config/eza" "$HOME/.config/eza"
restore_item "$backup/config/ghostty-ultimate" "$HOME/.config/ghostty-ultimate"
restore_item "$backup/home/.zshrc" "$HOME/.zshrc"
restore_item "$backup/home/.p10k.zsh" "$HOME/.p10k.zsh"
restore_item "$backup/local/bin/ghostty-theme" "$HOME/.local/bin/ghostty-theme"
restore_item "$backup/local/bin/ghostty-fastfetch" "$HOME/.local/bin/ghostty-fastfetch"

ok "Respaldo restaurado."
printf 'Reinicia Ghostty para aplicar los cambios.\n'
