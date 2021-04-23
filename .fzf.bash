# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/davidrosenberg/src/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/Users/davidrosenberg/src/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/davidrosenberg/src/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/Users/davidrosenberg/src/fzf/shell/key-bindings.bash"
