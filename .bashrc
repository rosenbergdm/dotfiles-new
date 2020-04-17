export BASHRC_RUN=1
if [[ -z "$BASH_PROFILE_RUN" ]]; then
    # bash_profile hasn't been run
  . ~/.bash_profile
fi


for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
  [ -r "$file" ] && source "$file"
done


if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
# NOTE this sources ~/.bash_completion as well



set_python_3

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export extra_cabal_flags="'--package-db=/Users/davidrosenberg/.ghcup/ghc/8.8.3/lib/ghc-8.8.3/package.conf.d' '--package-db=/Users/davidrosenberg/.cabal/store/ghc-8.8.3/package.db' --extra-lib-dirs='/usr/X11/lib' --ghc-options='-L/usr/X11/lib'"
export PATH="$PATH:$HOME/.rvm/bin"
