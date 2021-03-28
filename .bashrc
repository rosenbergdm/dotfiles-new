#!/usr/local/bin/bash
# shellcheck disable=SC1090
# SC1090: Not all references will be resolvable

[[ "$DEBUG_STARTUP:" == "1:" ]] && echo "Executing $HOME/.bashrc from the top" 1>&2
export BASHRC_RUN=1

declare -a STARTUP_SOURCED=( )
declare -a MY_FUNCTIONS=( )
STARTUP_SOURCED+=("$HOME/bashrc")

_d_source_and_log() {
  [ -r "$1" ] && source "$1" && STARTUP_SOURCED+=("$1")
}

source_and_log() {
  [[ "$DEBUG_STARTUP:" == "1:" ]] && echo "Sourcing '$1'" 1>&2
  echo "${STARTUP_SOURCED[@]}" | grep -v "$1" >/dev/null && _d_source_and_log "$1" || echo "$1 already sourced, skipping" 1>&2
}

if [ -z "$BASH_PROFILE_RUN" ]; then
  [[ "$DEBUG_STARTUP:" == "1:" ]] && echo "$HOME/.bash_profile not sourced yet.  Sourcing" 1>&2
  source_and_log ~/.bash_profile
fi

for file in ~/.{functions,path,exports,aliases,bash_prompt,extra}; do
  source_and_log "$file"
done


# For bash_completion@2
if [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
  # This will end up sourcing "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
  # Then it will read from the following dirs for commands of the form 'cmd', 'cmd.bash' or '_cmd':
  #   ${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions
  #   ${XDG_DATA_DIRS:-/usr/local/share:/usr/share}/*/bash-completion/completions
  #   ${BASH_SOURCE%/}/completions (for scripts) or ./completions (for not being in a script)
  # For each of these it will load the completion when the command is required
  # TLDR
  #   Dynamically loaded completions go in  $HOME/.local/share/bash-completion/completions
  #   Eagerly loaded completions should be loaded by $HOME/.config/bash/completion
  #   In the end completions stored in $HOME/.bash_completion will be executed
  source_and_log /usr/local/etc/profile.d/bash_completion.sh
fi
