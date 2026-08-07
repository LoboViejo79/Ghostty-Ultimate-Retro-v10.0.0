#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"

family="$(detect_family)"
printf '\nDiagnóstico de Ghostty Ultimate Retro\n'
printf '─────────────────────────────────────\n'
printf 'Distribución: %s\n' "$(distro_name)"
printf 'Familia detectada: %s\n\n' "$family"

[[ "$family" != unsupported ]] &&
    ok "Familia compatible detectada." ||
    warn "Distribución no soportada automáticamente; la configuración manual puede seguir funcionando."

commands=(ghostty zsh git eza fastfetch fc-cache)
for cmd in "${commands[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        printf '  ✔ %s\n' "$cmd"
    else
        printf '  ✘ %s\n' "$cmd"
    fi
done

if command -v bat >/dev/null 2>&1 || command -v batcat >/dev/null 2>&1; then
    printf '  ✔ bat/batcat\n'
else
    printf '  ✘ bat/batcat\n'
fi

[[ -d "$P10K_DIR/.git" ]] &&
    ok "Powerlevel10k instalado." ||
    warn "Powerlevel10k no está instalado."

[[ -r "$HOME/.config/ghostty/config" ]] &&
    ok "Configuración de Ghostty detectada." ||
    warn "No existe ~/.config/ghostty/config."

[[ -r "$HOME/.zshrc" ]] &&
    ok "Configuración de Zsh detectada." ||
    warn "No existe ~/.zshrc."

image_count=0
if [[ -d "$PROJECT_DIR/assets" ]]; then
    image_count="$(find "$PROJECT_DIR/assets" -maxdepth 1 -type f -iname '*.png' | wc -l)"
fi
printf 'Imágenes PNG incluidas en el proyecto: %s\n' "$image_count"

printf '\nNo se modificó ningún archivo ni paquete.\n'
