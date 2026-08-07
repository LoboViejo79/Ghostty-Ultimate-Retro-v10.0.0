#!/usr/bin/env bash
set -Eeuo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"

errors=0
check() {
    if "$@" >/dev/null 2>&1; then
        printf '  ✔ %s\n' "$*"
    else
        printf '  ✘ %s\n' "$*" >&2
        errors=$((errors + 1))
    fi
}

printf '\nValidación\n'
printf '──────────\n'

for cmd in zsh git; do
    if command -v "$cmd" >/dev/null 2>&1; then
        printf '  ✔ comando %s\n' "$cmd"
    else
        printf '  ✘ falta comando %s\n' "$cmd" >&2
        errors=$((errors + 1))
    fi
done

[[ -r "$HOME/.zshrc" ]] && check zsh -n "$HOME/.zshrc"
[[ -r "$HOME/.p10k.zsh" ]] && check zsh -n "$HOME/.p10k.zsh"

if command -v fastfetch >/dev/null 2>&1; then
for profile in compact medium large; do
    cfg="$HOME/.config/fastfetch/config-$profile.jsonc"
    if [[ ! -r "$cfg" ]]; then
        printf '  ✘ falta %s\n' "$cfg" >&2
        errors=$((errors + 1))
        continue
    fi
    tmp="$(mktemp --suffix=.jsonc)"
    sed "s#@RANDOM_IMAGE@#$HOME/.config/fastfetch/images/tux.png#g" "$cfg" > "$tmp"
    check fastfetch --config "$tmp"
    rm -f -- "$tmp"
done
else
    warn "Fastfetch no está disponible; se omite su validación."
fi

if command -v ghostty >/dev/null 2>&1 && [[ -r "$HOME/.config/ghostty/config" ]]; then
    check ghostty +validate-config
else
    warn "Ghostty no está disponible; se omite su validación binaria."
fi

for theme in Dracula-Official Catppuccin-Mocha TokyoNight Nord Gruvbox-Dark Everforest-Dark Kanagawa-Wave; do
    [[ -r "$HOME/.config/ghostty/themes/$theme" ]] ||
        { printf '  ✘ falta tema %s\n' "$theme" >&2; errors=$((errors + 1)); }
done

if ((errors)); then
    die "La validación encontró $errors error(es)."
fi
ok "Validación completada sin errores."
