# Powerlevel10k: Lean style, two lines, no icons.
# Starts from the bundled Lean template, then overrides below.
# Run `p10k configure` for the full wizard (it replaces this file).

source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/config/p10k-lean.zsh

# Line 1: user@host + folder + git on the left. Line 2: ❯
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs newline prompt_char)

# Always show user@host (Lean hides it unless on SSH or root)
unset POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION
# Host color is picked from a hash of the hostname, so each machine gets its own
() {
  local -a palette=(176 110 114 216 73 147 209 149 175 81)
  local c; local -i h=2166136261  # FNV-1a
  for c in ${(s::)${(%):-%m}}; do (( h = ((h ^ #c) * 16777619) & 0xffffffff )); done
  local -i i=$(( h % $#palette + 1 ))
  typeset -g _host_color=$palette[i]
}
# user in tan (180), @ in gray (244), host in its per-machine color
typeset -g POWERLEVEL9K_CONTEXT{,_REMOTE,_REMOTE_SUDO}_TEMPLATE="%F{180}%n%F{244}@%F{$_host_color}%m%f"

# Right side of line 1: run time (commands over 3s) and clock
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time time)

# No icons, so any font works
typeset -g POWERLEVEL9K_MODE=compatible
typeset -g POWERLEVEL9K_VISUAL_IDENTIFIER_EXPANSION=

typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'

# No blank line between commands
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

(( ! $+functions[p10k] )) || p10k reload
