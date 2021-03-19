#! /usr/bin/env bash
# Copyright David M. Rosenberg
# Distributed under terms of the MIT license.
#
# Usage: pre-commit
#
# Clean up code before pushing

set +x
set -o pipefail
if [ ${DEBUG_SCRIPT:-0} -gt 1 ]; then
  set -x
fi
if echo -- "$@" | grep -- ' -v'>/dev/null; then
  echo "-v option passed, setting DEBUG_SCRIPT"
  if [ ${DEBUG_SCRIPT:-0} -lt 2 ]; then
    DEBUG_SCRIPT=1
  fi
fi

PROCESS_ALL=0
if echo -- "$@" | grep -- '--all' >/dev/null; then
  PROCESS_ALL=1
fi

WHICH=$(which gwhich || which which | head -n1)
GITROOT=$(git rev-parse --show-toplevel)
FIND=$($WHICH gfind || $WHICH find)
GREP=$($WHICH grep)
READLINK=$($WHICH greadlink || $WHICH readlink)
BASENAME=$($WHICH gbasename || $WHICH basename)
STARTDIR="$($READLINK -f $GITROOT)"
ECHO="$($WHICH gecho || $WHICH echo )"
TMPFILE=$(mktemp)
_error=0
_cleanup() {
  [ -e $TMPFILE ] && rm $TMPFILE
  $ECHO "ABORTED AFTER CLEANUP"
}
_check_error() {
  if [ $_error -gt 0 ]; then
    [ -e $TMPFILE ] && rm $TMPFILE
    trap - EXIT
    $ECHO "ERROR.  Aborting"
    $ECHO "ERROR MSG: $*"
    exit 255
  fi
}
trap _cleanup EXIT
pushd $STARTDIR


MOD_FILES="$(git status | grep modified | awk '{print $2}')"
if [ $PROCESS_ALL -gt 0 ]; then
  MOD_FILES="$($FIND "$GITROOT" -regextype egrep -regex '.*.(py|html|sh|css|js)$' | egrep -v '(.venv)|(.git)|(__py)|(sorttable)|(eslint)')"
fi


if grep '.py$' <( ($ECHO $MOD_FILES | tr ' ' "\n" | grep -v .venv) ) >/dev/null; then
  $ECHO "Running black on .py files"
  /usr/local/bin/black `$GREP '.py$' <( ($ECHO $MOD_FILES | tr ' ' "\n" | grep -v .venv 2>&1) )` --verbose > $TMPFILE 2>&1
  ((_error+=$?))
  cat $TMPFILE
  _check_error "Running /usr/local/bin/black' on py files"
  for fname in $(cat $TMPFILE | grep '^reformatted' | awk '{print $2}' 2>&1); do
    ff="$($READLINK -f $fname)"
    if $(grep $($BASENAME $ff) <( ($ECHO $MOD_FILES | perl -p -e 's/ /\n/g' ) ) > /dev/null 2>&1); then
      ((_error+=$?))
      _check_error "Finding modified py files (ln 36)"
      $ECHO "Updating '$ff' with black.... success"
      $ECHO "Re-adding updated file '$ff'"
      git add "$ff"
    fi
  done
else
  $ECHO "Skipping running black as no .py files to modify"
fi


if grep '.js$' <( ($ECHO $MOD_FILES | tr ' ' "\n" | egrep -v '(.venv)|(eslint)|(sorttable)|(jquery)' ) ) >/dev/null; then
  $ECHO "Running eslint on .js files"
  for fname in $(grep '.js$' <( ($ECHO $MOD_FILES | tr ' ' "\n" | egrep -v '(.venv)|(eslint)|(sorttable)|(jquery)' ) ) ); do
    ((_error+=$?)) && _check_error "Running eslint"
    ff="$($READLINK -f $fname)"
    if $(grep "$($BASENAME $ff)" <( ($ECHO $MOD_FILES | perl -p -e 's/ /\n/g' ) ) > /dev/null); then
      $ECHO -n "Running eslint on '$ff'..."
      eslint --fix "$ff"
      ((_error+=$?))
      if [ $_error -gt 0 ]; then
        echo " ERROR running elsint on '$ff'"
        echo "Aborting"
        _check_error
      else
        $ECHO " OK."
        $ECHO "Re-adding '$ff'"
        git add "$ff"
      fi
    fi
  done
else
  $ECHO "Skipping eslint as no .js files to modify"
fi

if egrep '.(js)|(css)$' <( ($ECHO $MOD_FILES | egrep -v '(.venv)|(eslint)|(sorttable)' ) ) >/dev/null; then
  $ECHO "Running prettier on .js and .css files"
  /usr/local/bin/prettier `egrep '.(js)|(css)$' <( ($ECHO $MOD_FILES | tr ' ' "\n" | egrep -v '(.venv)|(eslint)|(sorttable)|(jquery)' ) )` -w > $TMPFILE 2>&1
  ((_error+=$?)) && _check_error "Line 109"
  cat $TMPFILE
  for fname in $(cat $TMPFILE | awk '{print $1}'); do
    ff="$($READLINK -f $fname)"
    git add "$ff"
  done
else
  $ECHO "Skipping prettier as no .js or .css files to modify"
fi


if grep '.sh$' <( ($ECHO $MOD_FILES | tr ' ' "\n" | grep -v htmldjango ) )>/dev/null 2>&1; then
  $ECHO "Running shellcheck on shell files"
  for fname in $(grep '.sh$' <( ($ECHO $MOD_FILES | tr ' ' "\n" | grep -v htmldjango | grep -v docopts.sh) ) ); do
    ff="$($READLINK -f $fname)"
    $ECHO -n "Checking '$ff'..."
    /usr/local/bin/shellcheck -S error "$ff" >/dev/null 2>&1
    ((_error+=$?))
    if [ $_error -gt 0 ]; then
      $ECHO  " ERROR. Shellcheck failed for '$ff'"
      $ECHO "Aborting"
      exit 255
    else
      $ECHO " Success, no errors.  Run with -S warning to get more info"
    fi
  done
else
  $ECHO "Skipping shellcheck as no .sh files modified"
fi


if grep '.html$' <( ($ECHO $MOD_FILES | tr ' ' "\n") ) >/dev/null; then
  $ECHO "Running format-htmldjango.sh on html files"
  $GITROOT/scripts/format-htmldjango.sh $(grep '.html$' <( ($ECHO $MOD_FILES | tr ' ' "\n") ) )
  ((_error+=$?))
  if [ $_error -gt 0 ]; then
    $ECHO " ERROR. format-htmldjango.sh failed"
    $ECHO "Aborting"
    exit 255
  else
    $ECHO " Success."
    git add $(grep '.html$' <( ($ECHO $MOD_FILES | tr ' ' "\n") ) )
  fi
else
  $ECHO "No html files modified.  Skipping format-htmldjango.sh"
fi

popd
trap - EXIT
[ -e $TMPFILE ] && rm -f "$TMPFILE"
$ECHO "**** ALL LINTING AND PRETTIFYING COMPLETE ****"
exit 0
