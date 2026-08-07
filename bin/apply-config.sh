#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"

for cmd in sed install; do require_command "$cmd"; done

backup_dir="$(new_backup_dir)"
log "Creando respaldo en: $backup_dir"

backup_path "$HOME/.config/ghostty" "$backup_dir" "config/ghostty"
backup_path "$HOME/.config/fastfetch" "$backup_dir" "config/fastfetch"
backup_path "$HOME/.config/eza" "$backup_dir" "config/eza"
backup_path "$HOME/.config/ghostty-ultimate" "$backup_dir" "config/ghostty-ultimate"
backup_path "$HOME/.zshrc" "$backup_dir" "home/.zshrc"
backup_path "$HOME/.p10k.zsh" "$backup_dir" "home/.p10k.zsh"
backup_path "$HOME/.local/bin/ghostty-theme" "$backup_dir" "local/bin/ghostty-theme"
backup_path "$HOME/.local/bin/ghostty-fastfetch" "$backup_dir" "local/bin/ghostty-fastfetch"

mkdir -p \
    "$HOME/.config/ghostty/themes" \
    "$HOME/.config/fastfetch/images" \
    "$HOME/.config/ghostty-ultimate/quotes" \
    "$HOME/.local/bin"

install_file "$PROJECT_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"
for theme in "$PROJECT_DIR"/config/ghostty/themes/*; do
    install_file "$theme" "$HOME/.config/ghostty/themes/$(basename -- "$theme")"
done

install_file "$PROJECT_DIR/config/zsh/zshrc" "$HOME/.zshrc"
install_file "$PROJECT_DIR/config/zsh/p10k.zsh" "$HOME/.p10k.zsh"

for profile in compact medium large; do
    render_template "$PROJECT_DIR/config/fastfetch/config-$profile.jsonc" \
        "$HOME/.config/fastfetch/config-$profile.jsonc"
done
render_template "$PROJECT_DIR/config/fastfetch/config-medium.jsonc" \
    "$HOME/.config/fastfetch/config.jsonc"

shopt -s nullglob
images=("$PROJECT_DIR"/assets/*.png)
((${#images[@]})) || die "No hay imágenes PNG dentro de assets/."
install -m 0600 -- "${images[@]}" "$HOME/.config/fastfetch/images/"
shopt -u nullglob
install -m 0600 -- "$PROJECT_DIR"/quotes/*.txt "$HOME/.config/ghostty-ultimate/quotes/"
install -m 0700 -- "$PROJECT_DIR/bin/theme.sh" "$HOME/.local/bin/ghostty-theme"
install -m 0700 -- "$PROJECT_DIR/bin/fastfetch-profile.sh" "$HOME/.local/bin/ghostty-fastfetch"

printf '%s\n' "$backup_dir" > "$STATE_DIR/last-backup"
ok "Configuraciones aplicadas."
printf 'Respaldo: %s\n' "$backup_dir"

if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f >/dev/null
fi

bash "$PROJECT_DIR/bin/validate.sh"
printf '\nCierra todas las ventanas de Ghostty y vuelve a abrirlo.\n'
