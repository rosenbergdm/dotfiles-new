#!/bin/sh

cd $HOME/Dropbox
tgtfile="$HOME/Dropbox/passwords-backup/passwords-$(date +%Y%m%d).kdbx"
if [[ -f "$tgtfile"  ]]; then
    echo "FILE ALREADY EXISTS"
else
    cp "./passwords.kdbx" "$tgtfile"
    echo "FILE COPY of passwords.kdbx to $tgtfile COMPLETE"
fi

