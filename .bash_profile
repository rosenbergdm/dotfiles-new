[[ "$DEBUG_STARTUP:" == "1:" ]] && echo "RUNNING $HOME/.bash_profile"
export BASH_PROFILE_RUN=1
if [[ -z "$BASHRC_RUN" ]]; then
    # bash_rc has been run
    . $HOME/.bashrc
fi


