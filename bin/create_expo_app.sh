#! /usr/bin/env bash
# create_expo_app.sh
# Copyright (C) 2021 David Rosenberg <dmr@davidrosenberg.me>
# Distributed under terms of the GPLv3 license.
#
# Usage: create_expo_app.sh [-vhq] [--debug] [--directory=<DIRECTORY>] <APPNAME>
#
#
# Arguments:
#   <APPNAME>                Name for application (in CamelCase)
#
# Options:
#   -h --help                display usage
#   -v --verbose             verbose mode
#   -q --quiet               quiet mode
#   --debug                  debug this script
#   --directory=<DIRECTORY>  Directory to make app in [default: APPNAME]
#


set +x
set -eE
set -o pipefail

#{{{ Use GNU utilities and set up functions#{{{#}}}
#{{{ set options from the commandline 
set -o pipefail
set +x
if [ ${DEBUG_SCRIPT:-0} -gt 1 ]; then
  set -x
fi
if echo -- "$@" | grep -- ' -v'>/dev/null; then
  if [ ${DEBUG_SCRIPT:-0} -lt 2 ]; then
    DEBUG_SCRIPT=1
  fi
fi

if echo -- "$@" | grep -- ' -vv'>/dev/null; then
  if [ ${DEBUG_SCRIPT:-0} -lt 2 ]; then
    set -v
  fi
fi
#}}}

#{{{ Basic logging and commands 
WHICH="$(which gwhich || which which)"
ECHO="$($WHICH gecho || $WHICH echo)"
PRINTF="$($WHICH gprintf || $WHICH printf)"

debuglog() {
  if [ ${DEBUG_SCRIPT:-0} -gt 0 ]; then
    ($ECHO "$@" > /dev/stderr) || $ECHO "$ECHO $* > /dev/stderr"
  fi
}

[ ${DEBUG_SCRIPT:-0} -gt 0 ] && debuglog "WHICH=$WHICH" \
 && debuglog "ECHO=$ECHO" \
 && debuglog "PRINTF=$PRINTF"

#}}}

#{{{ Load remainder of commands
DIRNAME="$($WHICH gdirname || $WHICH dirname)" && debuglog "DIRNAME=$DIRNAME"
BASENAME="$($WHICH gbasename || $WHICH basename)" && debuglog "BASENAME=$BASENAME"
READLINK="$($WHICH greadlink || $WHICH readlink)" && debuglog "READLINK=$READLINK"
DATE="$($WHICH gdate || $WHICH date)" && debuglog "DATE=$DATE"
MKTEMP="$($WHICH gmktemp || $WHICH mktemp)" && debuglog "MKTEMP=$MKTEMP"
GIT="$($WHICH git)" && debuglog "GIT=$GIT"
PG_DUMP="$($WHICH pg_dump)" && debuglog "PG_DUMP=$PG_DUMP"
PSQL="$($WHICH psql)" && debuglog "PSQL=$PSQL"
SED="$($WHICH gsed || $WHICH sed)" && debuglog "SED=$SED"
AWK="$($WHICH gawk || $WHICH awk)" && debuglog "AWK=$AWK"
GZIP="$($WHICH gzip )" && debuglog "GZIP=$GZIP"
GUNZIP="$($WHICH gunzip)" && debuglog "GUNZIP=$GUNZIP"
JQ=$($WHICH jq) && debuglog "JQ=$JQ"
WORKINGDIR="$($READLINK -f $($DIRNAME ${BASH_SOURCE[0]})/..)" && debuglog "WORKINGDIR=$WORKINGDIR"
#}}}

#{{{ Error handling routines

failure() {
  local lineno=$1
  local msg=$2
  local errorcode=${3:-0}
  echo "errorcode=$errorcode"
  echo "****Failed at ${BASH_SOURCE[0]}:$lineno: $msg******"
  if [ -z $TMPFILE ]; then
    rm -f "$TMPFILE"
  fi
}
# trap $'failure ${LINENO} "COMMAND=\'$BASH_COMMAND\'"' ERR

error() {
  trap - ERR
  printf "'%s': '%s' failed with exit code %d in function '%s' at line %d.\n" "${1-something}" "${2-${BASH_COMMAND[0]}}" "${3-$?}" ${4-${FUNCNAME[1]}} ${5-${BASH_LINENO[0]}}
  exit 5
}
# }}}
#}}}
myfun() {
  a=${1-${BASH_LINENO}}
  echo "a='$a'"
}

#{{{ docopt parsing of commandline
source $(which docopts.sh) --auto "$@"
[[ ${ARGS[--debug]} == true ]] && docopt_print_ARGS
if [[ "${ARGS[--verbose]}" == true ]]; then
  DEBUG_SCRIPT=${DEBUG_SCRIPT:-1}
fi
#}}}
# Usage: create_expo_app.sh [-vhq] [--debug] [--directory=<DIRECTORY>] <APPNAME>

archive="$HOME/lib/node/MyExpoAppTemplate.tar.gz"

if [[ ${ARGS[<DIRECTORY>]} == APPNAME ]]; then
  export tgtdir="$($READLINK -f "${ARGS[<DIRECTORY>]}")"
else
  export tgtdir="$($READLINK -f "$PWD/${ARGS[<APPNAME>]}")"
fi

debuglog "tgtdir='$tgtdir'"
export parentdir="$($DIRNAME "$tgtdir")"
debuglog "parentdir='$parentdir'"

if [ ! -d "$parentdir" ]; then
  # $PRINTF "%s\n" "Parent directory '$parentdir' does not exist. Aborting"
  error "Parent directory '$parentdir' does not exist" "if [ ! -d "$parentdir" ]" "1" "test" "123"
fi
if [ -a "$tgtdir" ]; then
  # $PRINTF "%s\n" "Target directory '$tgtdir' already exists! Aborting"
  error "Target directory '$tgtdir' already exists" "if [ -a \"$tgtdir\" ]" "1" "test" "130"
fi

mkdir "$tgtdir"
pushd "$tgtdir"
tar -xvf "$archive"
$PERL -pi -e "s/MyTestExpoApp/${ARGS[<APPNAME>]}</g" app.json
yarn
popd
$PRINTF "%s\n" "App '${ARGS[<APPNAME>]}' created successfully at '$tgtdir'"
trap - ERR


# vim: ft=sh
