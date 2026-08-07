#!/usr/bin/env bash
set -Eeuo pipefail

dir="$HOME/.config/fastfetch"
printf '\nPerfiles de Fastfetch\n'
printf '────────────────────\n'
printf '1) Compacto (sin imagen)\n'
printf '2) Medio (imagen y datos esenciales)\n'
printf '3) Grande (imagen y datos ampliados)\n'
printf '0) Cancelar\n\n'
read -r -p "Selecciona un perfil: " choice

case "$choice" in
    1) profile=compact ;;
    2) profile=medium ;;
    3) profile=large ;;
    0) exit 0 ;;
    *) printf '[ERROR] Selección inválida.\n' >&2; exit 1 ;;
esac

source_file="$dir/config-$profile.jsonc"
[[ -r "$source_file" ]] || { printf '[ERROR] Falta %s\n' "$source_file" >&2; exit 1; }
cp -- "$source_file" "$dir/config.jsonc"
chmod 0600 "$dir/config.jsonc"
printf '[OK] Perfil activo: %s\n' "$profile"
printf 'Ejecuta ff para verlo inmediatamente.\n'
