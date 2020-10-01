#!/usr/local/bin/bash
[[ "$DEBUG_STARTUP:" == "1:" ]] && echo "RUNNING $HOME/.bashrc" 1>&2

declare -a STARTUP_SOURCED
declare -a MY_FUNCTIONS
STARTUP_SOURCED+=("$HOME/bashrc")

_d_source_and_log() {
  [ -r "$1" ] && source "$1" && STARTUP_SOURCED+=("$1")
}
source_and_log() {
  [[ "$DEBUG_STARTUP:" == "1:" ]] && echo "Sourcing '$1'" 1>&2
  echo "${STARTUP_SOURCED[@]}" | grep -v "$1" >/dev/null && _d_source_and_log "$1" || echo "$1 already sourced, skipping" 1>&2
}

export BASHRC_RUN=1
if [[ -z "$BASH_PROFILE_RUN" ]]; then
  [[ "$DEBUG_STARTUP:" == "1:" ]] && echo "running . ~/.bash_profile" 1>&2
    # bash_profile hasn't been run
  source_and_log ~/.bash_profile
fi


for file in ~/.{functions,path,bash_prompt,exports,aliases,extra}; do
  source_and_log "$file"
done


if [ -f /usr/local/etc/bash_completion ]; then
  source_and_log /usr/local/etc/bash_completion
fi
# NOTE this sources ~/.bash_completion as well; ~/.bash_completion will source all files in $HOME/bash_completion.d/
source_and_log $rvm_path/scripts/completion
rvm use ruby-2.7.0 >/dev/null


test -e "${HOME}/.iterm2_shell_integration.bash" && source_and_log "${HOME}/.iterm2_shell_integration.bash"
