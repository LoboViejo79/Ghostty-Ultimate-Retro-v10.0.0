#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"

printf '\nInstalación guiada\n'
printf '──────────────────\n'
bash "$PROJECT_DIR/bin/diagnose.sh"
printf '\n'

if confirm "¿Instalar únicamente los paquetes que falten?"; then
    bash "$PROJECT_DIR/bin/install-packages.sh"
fi

if ! command -v git >/dev/null 2>&1; then
    die "Git no está disponible. Instálalo antes de continuar."
fi
bash "$PROJECT_DIR/bin/install-p10k.sh"

warn "El siguiente paso reemplaza configuraciones del usuario, pero crea un respaldo previo."
confirm "¿Aplicar las configuraciones de Ghostty, Zsh, Fastfetch y temas?" ||
    { warn "Configuración cancelada."; exit 0; }

bash "$PROJECT_DIR/bin/apply-config.sh"

if confirm "¿Deseas establecer Zsh como shell de inicio?"; then
    bash "$PROJECT_DIR/bin/change-shell.sh"
fi

ok "Instalación guiada completada."
