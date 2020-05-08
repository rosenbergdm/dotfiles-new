#! /usr/local/bin/bash
#
# drive-runner.sh
# Copyright (C) 2020 David Rosenberg <dmr@davidrosenberg.me>
#
# Distributed under terms of the MIT license.
#

SCRIPTFILE="$(greadlink -f "$0")"
DRIVE_EXE=$HOME/bin/drive
LOGFILE=/var/log/drive.log
GDRIVE_DIR=/Volumes/LaptopBackup2/uic-backups/gdrive
tmplogfile="$(mktemp)"


function cleanup() {
  rm -f "${tmplogfile:-NOTEMPLOGFILE}"
  echo "Unknown error in executing $SCRIPTFILE" > /dev/stderr
}
trap cleanup EXIT

cd "$GDRIVE_DIR" || exit
$DRIVE_EXE pull --verbose --ignore-name-clashes >> "$tmplogfile" 2>&1
drivestatus=$?
if [ $drivestatus -eq 0 ]; then 
  echo -e "DRIVE synced to $GDRIVE_DIR on $(date)" | tee -a $LOGFILE
  rm "$tmplogfile"
  trap - EXIT
else
  echo -e "DRIVE FAILED to backup to $GDRIVE_DIR on $(date); log stored at $tmplogfile"
  trap - EXIT
fi

exit $drivestatus


