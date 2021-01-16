[[ "$DEBUG_STARTUP:" == "1:" ]] && echo "RUNNING $HOME/.bash_profile"
export BASH_PROFILE_RUN=1
if [[ -z "$BASHRC_RUN" ]]; then
    # bash_rc has been run
    . $HOME/.bashrc
fi



test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

