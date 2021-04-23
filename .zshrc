#!/usr/bin/env zsh
# encoding: utf-8
# 
# .zshrc_runner

local RCDIR
RCDIR=$HOME/.zshrc.d
fpath=(/usr/local/share/zsh/functions $fpath)

systype=$(uname)

ZSHLOAD_DEBUG=1

for fname in $(ls ${RCDIR}/??_*(^/)); do
    if ! [[ -z "$ZSHLOAD_DEBUG" ]]; then
        print "Processing ${${fname:t}//??_/}"
    fi
    source ${fname}
done

if [[ $systype == "Linux" ]]; then
    export PATH
elif [[ $systype == "Darwin" ]]; then
    export PATH=/opt/local/Library/Frameworks/Python.Framework/Versions/2.6/bin:/usr/bin:/usr/local/bin:/xbin/bin:/usr/bin:/usr/local/bin:/opt/local/bin:$PATH
fi

# Added to incorporate rvm use

if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
fi

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
