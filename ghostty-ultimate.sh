#!/usr/bin/env bash
set -Eeuo pipefail
PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR

pause_menu() {
    printf '\n'
    read -r -p "Pulsa Enter para continuar..." _
}

while true; do
    clear
    printf '%s\n' \
      '╭──────────────────────────────────────────────────────╮' \
      '│         Ghostty Ultimate Retro v10.0.0           │' \
      '╰──────────────────────────────────────────────────────╯' \
      '' \
      '1) Diagnóstico previo (no modifica nada)' \
      '2) Instalar solo paquetes faltantes (sin actualizar todo)' \
      '3) Aplicar o reinstalar configuraciones' \
      '4) Instalación guiada completa' \
      '5) Validar instalación actual' \
      '6) Seleccionar tema' \
      '7) Seleccionar perfil de Fastfetch' \
      '8) Restaurar el respaldo más reciente' \
      '9) Mostrar respaldos' \
      '10) Cambiar shell de inicio a Zsh' \
      '11) Instalar o actualizar Yazi' \
      '0) Salir' \
      ''
    read -r -p "Selecciona una opción: " choice
    case "$choice" in
        1)  bash "$PROJECT_DIR/bin/diagnose.sh"; pause_menu ;;
        2)  bash "$PROJECT_DIR/bin/install-packages.sh"; pause_menu ;;
        3)  bash "$PROJECT_DIR/bin/apply-config.sh"; pause_menu ;;
        4)  bash "$PROJECT_DIR/bin/install-guided.sh"; pause_menu ;;
        5)  bash "$PROJECT_DIR/bin/validate.sh"; pause_menu ;;
        6)  bash "$PROJECT_DIR/bin/theme.sh"; pause_menu ;;
        7)  bash "$PROJECT_DIR/bin/fastfetch-profile.sh"; pause_menu ;;
        8)  bash "$PROJECT_DIR/bin/restore.sh"; pause_menu ;;
        9)  printf '\n%s\n' "$HOME/.local/state/ghostty-ultimate/backups"; pause_menu ;;
        10) bash "$PROJECT_DIR/bin/change-shell.sh"; pause_menu ;;
        11) bash "$PROJECT_DIR/bin/install-yazi.sh" --update; pause_menu ;;
        0)  exit 0 ;;
        *)  printf '\nOpción inválida: %s\n' "$choice"; pause_menu ;;
    esac
done
