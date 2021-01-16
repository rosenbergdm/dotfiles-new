#!/bin/sh
# source "$HOME/.functions"

cd $HOME/Dropbox
srcdbfile="$HOME/Dropbox/keepass/passwords-v3.kdbx"
srckeyfile="$HOME/Dropbox/keepass/keepass-v3.keyx"
zipfiles=""
for f in "$srcdbfile" "$srckeyfile"; do
  ext="$(echo $f | sed -e 's/^.*\././g')"
  tgt="$(gdirname $f)/passwords-backup/$(gbasename $f | sed -e 's/\.kdbx$//g' | sed -e 's/\.keyx$//g')-$(date +%Y%m%d)$ext"
  ziptgt="${tgt//keyx/tar.gz}"
  zipfiles="$zipfiles $tgt"
  if [[ -f "$tgt" ]]; then
    echo "FILE '$tgt' already exists"
  else
    cp "$f" "$tgt"
    echo "FILE COPY of '$f' to '$tgt' COMPLETE"
  fi
done

if [[ -f "$ziptgt" ]]; then
  echo "FILE '$ziptgt' already exists"
else
  tar -czvf "$ziptgt" $zipfiles 2>/dev/null
fi



