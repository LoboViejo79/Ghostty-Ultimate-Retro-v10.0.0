#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG="$HOME/.config/ghostty/config"
[[ -r "$CONFIG" ]] || { printf '[ERROR] No existe %s\n' "$CONFIG" >&2; exit 1; }

themes=(
    Dracula-Official
    Catppuccin-Mocha
    TokyoNight
    Nord
    Gruvbox-Dark
    Everforest-Dark
    Kanagawa-Wave
)

printf '\nTemas disponibles\n'
printf '─────────────────\n'
for i in "${!themes[@]}"; do
    printf '%d) %s\n' "$((i + 1))" "${themes[$i]}"
done
printf '0) Cancelar\n\n'

read -r -p "Selecciona un tema: " choice
[[ "$choice" == 0 ]] && exit 0
[[ "$choice" =~ ^[0-9]+$ ]] || { printf '[ERROR] Selección inválida.\n' >&2; exit 1; }
(( choice >= 1 && choice <= ${#themes[@]} )) || { printf '[ERROR] Selección fuera de rango.\n' >&2; exit 1; }

theme="${themes[$((choice - 1))]}"
[[ -r "$HOME/.config/ghostty/themes/$theme" ]] ||
    { printf '[ERROR] Falta el tema local %s\n' "$theme" >&2; exit 1; }

tmp="$(mktemp)"
awk -v selected="$theme" '
    BEGIN { changed=0 }
    /^[[:space:]]*theme[[:space:]]*=/ {
        print "theme = " selected
        changed=1
        next
    }
    { print }
    END {
        if (!changed) print "theme = " selected
    }
' "$CONFIG" > "$tmp"
cat "$tmp" > "$CONFIG"
rm -f -- "$tmp"

printf '[OK] Tema activo: %s\n' "$theme"
printf 'Recarga con Ctrl+Shift+R o reinicia Ghostty.\n'
