#!/usr/local/bin/bash
#
# gmvault-runner.sh
# Copyright (C) 2020 David Rosenberg <david.m.rosenberg@gmail.com>
#
# Distributed under terms of the MIT license.
#


GMVAULT_EXE=/usr/local/bin/gmvault
LOGFILE=/var/log/gmvault.log
GMVAULT_DB=/Volumes/LaptopBackup2/gmvault-backup-uic/uic-db
ACCOUNT="dmrosenb@uic.edu"
tmplogfile="$(mktemp)"


function cleanup() {
  rm -rf "$tmplogfile"
}
trap cleanup EXIT


$GMVAULT_EXE sync "$ACCOUNT" -d "$GMVAULT_DB" >> "$tmplogfile" 2>&1
gmvaultstatus=$?
if [ $gmvaultstatus -eq 0 ]; then
  echo -e "GMVAULT backed up $ACCOUNT to $GMVAULT_DB successfully on $(date)" | tee $LOGFILE
else
  echo -e "GMVAULT FAILED to backp $ACCOUNT to $GMVAULT_DB on $(date); gmvault log stored at $tmplogfile"
  trap - EXIT
fi

exit $gmvaultstatus


