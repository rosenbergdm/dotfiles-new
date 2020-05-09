#! /usr/local/bin/bash
#
# logtask.sh
# Copyright (C) 2020 David Rosenberg <dmr@davidrosenberg.me>
# Simple time / task logging utility
#
# Distributed under terms of the MIT license.
#

DEFAULT_TASKLOGFILE="${TASKLOGFILE:-$HOME/mytasks.txt}"
FN_DEBUG=1

get_task_status() {
  taskfile="$1"
  # [ $FN_DEBUG == "1" ] && echo "taskfile=$taskfile"
  if [[ ! -f $taskfile ]]; then
    if [ $FN_DEBUG -eq 1 ]; then
      echo "TRACE: get_task_status exception due to file $taskfile not existing" > /dev/stderr
      exit 1
    else
      echo "ERROR" > /dev/stderr && exit 1
    fi
  else
    last_command="$(tail -n1 "$taskfile" | awk '{print $1}')"
    [ $last_command == "Start" ] && echo "Start" && return
    [ $last_command == "Stop" ] && echo "Stop" && return
    echo "ERROR" > /dev/stderr && exit 1
  fi
}

start_task() {
  taskfile="$1"
  taskname="$2"
  passed_task="$3"
  last_task_type="$(get_task_status $taskfile)"
  if [ ! -f "$taskfile" ]; then
    default_task="Start"
  elif [ $last_task_type == "Start" ]; then
    default_task="Stop"
  elif [ $last_task_type == "Stop" ]; then
    default_task="Start"
  else
    echo "ERROR" > /dev/stderr && exit 1
  fi
  tasktype="$(echo ${passed_task:-$default_task} | tr A-Z a-z)"
  echo "${tasktype[@]^} task '$taskname' at $(date +'%Y-%m-%d %H:%M:%S')" | tee -a "$taskfile"


}

  # echo "${





