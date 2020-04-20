#! /usr/local/bin/bash
#
# dotfiles-check.sh
# Copyright (C) 2020 David Rosenberg <david.m.rosenberg@gmail.com>
#
# Distributed under terms of the MIT license.
#

GIT_EXE=/usr/local/bin/git
DOTFILES_GIT_DIR="$HOME/dotfiles-new.git"
WORK_DIR="$HOME"
# DOTFILES_COMMAND="/usr/local/bin/git --git-dir=$DOTFILES_GIT_DIR --work-tree=$WORK_DIR"
DOTFILES_LOGFILE="/var/log/dotfiles-check.log"

declare -a modified_files
modified_files=( $($GIT_EXE --git-dir="$DOTFILES_GIT_DIR/" --work-tree="$WORK_DIR" status | grep modified | awk '{print $2}' ) )
if [ "${modified_files[@]}:" = ":" ]; then
  echo "All dotfiles managed files committed on $(date)" | tee $DOTFILES_LOGFILE
else
  for f in ${modified_files[@]}; do
    echo "Dotfiles managed file $f is modified but not committed on $(date)" | tee $DOTFILES_LOGFILE
  done
  exit 1
fi

exit 0

