# Powerlevel10k — prompt retro de dos lineas inspirado en la referencia.

'builtin' 'local' -a p10k_config_opts
[[ ! -o aliases ]]         || p10k_config_opts+=(aliases)
[[ ! -o sh_glob ]]         || p10k_config_opts+=(sh_glob)
[[ ! -o no_brace_expand ]] || p10k_config_opts+=(no_brace_expand)
'builtin' 'setopt' no_aliases no_sh_glob brace_expand

() {
  emulate -L zsh -o extended_glob

  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(retro_header newline prompt_char)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''

  # Barra superior: capsula violeta, flechas de colores y reloj azul.
  # %1~ muestra solo el directorio actual y usa ~ cuando estamos en HOME.
  function prompt_retro_header() {
    p10k segment -f 255 -t '%F{141}%K{141}%F{236}  %n  %1~ %k%F{141}%f %F{84}❯%F{228}❯%F{203}❯%F{81}❯%f %F{103}%K{103}%F{236}  %D{%H:%M} %k%F{103}%f'
  }
  typeset -g POWERLEVEL9K_RETRO_HEADER_BACKGROUND=
  typeset -g POWERLEVEL9K_RETRO_HEADER_FOREGROUND=
  typeset -g POWERLEVEL9K_RETRO_HEADER_LEFT_LEFT_WHITESPACE=''
  typeset -g POWERLEVEL9K_RETRO_HEADER_LEFT_RIGHT_WHITESPACE=''

  # Segunda linea: indicador verde; cambia a rojo si el comando anterior falla.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=84
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=203
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='λ ❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='λ ❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='λ ❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='λ ❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_LEFT_WHITESPACE=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_RIGHT_WHITESPACE=' '

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
}

(( ${#p10k_config_opts} )) && setopt "${p10k_config_opts[@]}"
'builtin' 'unset' 'p10k_config_opts'
