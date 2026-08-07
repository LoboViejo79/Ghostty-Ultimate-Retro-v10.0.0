# Powerlevel10k — estilo profesional Dracula de una línea inspirado en la captura.

'builtin' 'local' -a p10k_config_opts
[[ ! -o aliases ]]         || p10k_config_opts+=(aliases)
[[ ! -o sh_glob ]]         || p10k_config_opts+=(sh_glob)
[[ ! -o no_brace_expand ]] || p10k_config_opts+=(no_brace_expand)
'builtin' 'setopt' no_aliases no_sh_glob brace_expand

() {
  emulate -L zsh -o extended_glob

  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs prompt_char)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=''

  # Segmento inicial tipo estrella/mascota.
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=228
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=236

  # Directorio morado, como en la referencia.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=236
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=141
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=236
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=38
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
  typeset -g POWERLEVEL9K_HOME_ICON='~'
  typeset -g POWERLEVEL9K_FOLDER_ICON=''

  # Git verde.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=236
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=84
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=236
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=212
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=236
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=228

  # El cursor queda pegado al último segmento, como en la captura.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=84
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=203
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_LEFT_WHITESPACE=' '
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_RIGHT_WHITESPACE=' '

  # Estado y duración solo cuando aportan información.
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=255
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=203
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=236
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=215

  # Reloj a la derecha con forma de cápsula.
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%I:%M %p}'
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=''
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=236
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=255

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
}

(( ${#p10k_config_opts} )) && setopt "${p10k_config_opts[@]}"
'builtin' 'unset' 'p10k_config_opts'
