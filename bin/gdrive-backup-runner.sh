#!/usr/local/bin/bash
#
# gdrive-backup-runner.sh
# Copyright (C) 2020 David Rosenberg <dmr@davidrosenberg.me>
#
# Distributed under terms of the MIT license.
#

declare -a TARGETS_SHARED
declare -a TARGETS_NONSHARED
declare -a SOURCES_SHARED
declare -a SOURCES_NONSHARED

TGT_DIR=/Volumes/LaptopBackup2/uic-backups
RCLONE=/usr/local/bin/rclone
SOURCES_SHARED=( "/Phase 2 - M3／M4 Google Drive" "/Old Curriculum - M2 Google Drive")
TARGETS_SHARED=( "Texts/Phase 2/" "Texts/M2 Google Drive/")
SOURCES_NONSHARED=( "/syncable/" )
TARGETS_NONSHARED=( "MyDrive/syncable/" )
SHARED_ARGS='--drive-shared-with-me'
ARGS='--drive-formats "docx,xlsx,pdf" -v'
scriptlog="$(mktemp)"
LOGFILE=/var/log/rclone.log

function sync_dir() {
  src="$1"
  tgt="$2"
  shared="$3"
  if [[ $shared == "shared" ]]; then
    echo "Executing: >$RCLONE $SHARED_ARGS $ARGS sync \"dmrosenb-uic-google:$src\" \"$TGT_DIR/$tgt\""
    eval "$RCLONE $SHARED_ARGS $ARGS sync \"dmrosenb-uic-google:$src\" \"$TGT_DIR/$tgt\""
  else
    eval "$RCLONE $ARGS sync \"dmrosenb-uic-google:$src\" \"$TGT_DIR/$tgt\""
  fi
}

function _cleanup() {
  echo "AN UNKNOWN ERROR HAS OCCURED"
  rm -f "$scriptlog"
  exit 1
}
trap _cleanup EXIT
running_status=0

for ((i=0; i<${#SOURCES_SHARED[@]}; i++)); do
  sync_dir "${SOURCES_SHARED[$i]}" "${TARGETS_SHARED[$i]}" shared | tee -a "$scriptlog"
  if [[ $? -gt 0 ]]; then
    running_status+=1
    echo "$(date) sync of \"${SOURCES_SHARED[$i]}\" to \"${TARGETS_SHARED[$i]}\" FAILED" | tee -a $LOGFILE
  else
    echo "$(date) sync of \"${SOURCES_SHARED[$i]}\" to \"${TARGETS_SHARED[$i]}\" Succeeded" | tee -a $LOGFILE
  fi
done

for ((i=0; i<${#SOURCES_NONSHARED[@]}; i++)); do
  sync_dir "${SOURCES_NONSHARED[$i]}" "${TARGETS_NONSHARED[$i]}" nonshared | tee -a "$scriptlog"
  if [[ $? -gt 0 ]]; then
    running_status+=1
    echo "$(date) sync of \"${SOURCES_NONSHARED[$i]}\" to \"${TARGETS_NONSHARED[$i]}\" FAILED" | tee -a $LOGFILE 
  else
    echo "$(date) sync of \"${SOURCES_NONSHARED[$i]}\" to \"${TARGETS_NONSHARED[$i]}\" Succeeded" | tee -a $LOGFILE
  fi
done

if [[ $running_status -gt 0 ]]; then
  echo "$(date) SYNC FAILED, log at $scriptlog"
  trap - EXIT
  exit $running_status
else
  echo "$(date) SYNC SUCCEEDED"
  rm "$scriptlog"
  trap - EXIT
  exit $running_status
fi
