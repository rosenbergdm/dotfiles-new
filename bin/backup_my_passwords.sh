#!/bin/sh
source "$HOME/.functions"

cd $HOME/Dropbox
tgtfile="$HOME/Dropbox/passwords-backup/passwords-v2-$(date +%Y%m%d).kdbx"
keyfile="$HOME/Dropbox/passwords-backup/keepass-v2-$(date +%Y%m%d).key"
if [[ -f "$tgtfile"  ]]; then
    echo "FILE ALREADY EXISTS"
else
    cp "./passwords-v2.kdbx" "$tgtfile"
    echo "FILE COPY of passwords.kdbx to $tgtfile COMPLETE"
fi
if [[ -f "$keyfile" ]]; then
  echo "FILE ALREADY EXISTS"
else
  cp "./keepass2" "$keyfile"
  echo "FILE COPY of keepass2 to $keyfile COMPLETE"
fi


