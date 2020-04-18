export BASH_PROFILE_RUN=1
if [[ -z "$BASHRC_RUN" ]]; then
    # bash_rc has been run
    . $HOME/.bashrc
fi


# startup virtualenv-burrito
# if [ -f $HOME/.venvburrito/startup.sh ]; then
#     . $HOME/.venvburrito/startup.sh
# fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
if [ -e /Users/davidrosenberg/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/davidrosenberg/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
