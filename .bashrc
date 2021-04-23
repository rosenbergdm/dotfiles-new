#!/usr/local/bin/bash
# shellcheck disable=SC1090
# SC1090: Not all references will be resolvable

[[ "$DEBUG_STARTUP:" == "1:" ]] && echo "Executing $HOME/.bashrc from the top" 1>&2
export BASHRC_RUN=1

declare -a STARTUP_SOURCED=( )
declare -a MY_FUNCTIONS=( )
STARTUP_SOURCED+=("$HOME/bashrc")
source $HOME/.commands
STARTUP_SOURCED+=( $HOME/.commands )
declare -A thresholds=( [4]="4" [3]="3" [2]="2" [1]="1" [0]="0"\
  [trace]="4" [info]="3" [warn]="2" [error]="1" [always]="0" )
export MY_FUNCTIONS
export thresholds
export STARTUP_SOURCED

# debug messaging {{{
_dbg() {
  local thresh=${thresholds["${2:-1}"]}
  if [ ! -z $3 ] && [[ ${3-0} == -n ]]; then
    local newline=''
  else
    local newline='\n'
  fi

  if [ "${DEBUG_STARTUP-0}" -ge $thresh ]; then
    $PRINTF "%s$newline" "$1"
  fi
}
MY_FUNCTIONS+=( _dbg )

set_debug () {
  local lv=${1-always}
  export DEBUG_STARTUP=${thresholds[$lv]};
  echo "Set DEBUG_STARTUP to '${thresholds[$lv]}'"
}
MY_FUNCTIONS+=( set_debug )

source_and_log() {
  local cmdfile="$1"
  local status=1
  local completionfile=${2-THISIS_NOT_A_FILE}
  _dbg "Attempting to load '$cmdfile'..." error -n
  if [ -e "$cmdfile" ]; then
    if [[ ${STARTUP_SOURCED[*]} =~ (^|[[:space:]])"$($BASENAME "$cmdfile")"($|[[:space:]]) ]]; then
      _dbg " FAIL.  Already sourced." error
    else
      source "$cmdfile"
      status=0
      if [ $? -gt 0 ]; then
        _dbg " FAIL.  Error sourcing." error
      else
        _dbg " Success."
        STARTUP_SOURCED+=( $($BASENAME "$cmdfile") )
        if [ -e $completionfile ]; then
          source "$completionfile"
          if [ $? -gt 0 ]; then
            _dbg "Attempting to load completions '$completionfile'... FAIL.  Error loading" error
            status=1
          else
            _dbg "Attempting to load completions '$completionfile'... Success." error
            status=0
          fi
        fi
      fi
    fi
  else
    _dbg " FAIL.  File does not exist."
  fi
  return $status
}
MY_FUNCTIONS+=( source_and_log )
# }}}

if [ -z "$BASH_PROFILE_RUN" ]; then
  source_and_log ~/.bash_profile
fi

for file in ~/.{functions,path,exports,aliases,bash_prompt}; do
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

source_and_log $HOME/.extra
[ -f ~/.fzf.bash ] && source_and_log ~/.fzf.bash

# vim: ft=sh :
