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

WHICH=$(which gwhich || which which | head -n1)
GITROOT=$(git rev-parse --show-toplevel)
FIND=$($WHICH gfind || $WHICH find)
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
$ECHO "Running black on .py files"
/usr/local/bin/black `$FIND "$GITROOT" -name "*.py" | grep -v .venv` > $TMPFILE 2>&1
((_error+=$?))
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


$ECHO "Running eslint on .js and .css files"
for fname in $($FIND . -regextype egrep -regex "\./static/[A-z0-9].*.(j|c)s{1,2}"| grep -v sorttable | grep -v eslint | grep -v .venv); do
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

$ECHO "Running prettier on .js and .css files"
/usr/local/bin/prettier `$FIND $GITROOT -regextype egrep -regex ".*static\/.*.(j|c)s{1,2}$"` -l | grep -v .venv > $TMPFILE 2>&1
for fname in $($FIND . -regextype egrep -regex "\./static/[A-z0-9].*.(j|c)s{1,2}" | grep -v .venv); do
  ((_error+=$?)) && _check_error "Line 67"
  ff="$($READLINK -f $fname)"
  if $(grep "$($BASENAME $fname)" <( ($ECHO $MOD_FILES | perl -p -e 's/ /\n/g' ) ) > /dev/null); then
    $ECHO -n "Prettifying and adding '$ff'.... "
    /usr/local/bin/prettier -w "$ff" >/dev/null 2>&1
    ((_error+=$?))
    if [ $_error -gt 0 ]; then
      $ECHO "ERROR on file '$ff'"
      $ECHO "Prettier failed for failed for '$ff', aborting."
      exit 255
    else
      $ECHO "OK."
      git add "$($READLINK -f $fname)"
    fi
  fi
done


$ECHO "Running shellcheck on shell files"
for fname in $(find . -name "*.sh" | grep -v .venv); do
  ff="$($READLINK -f $fname)"
  if $(grep "$($BASENAME $ff)" <( ($ECHO $MOD_FILES | perl -p -e 's/ /\n/g' ) ) >/dev/null); then
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
  fi
done


popd
trap - EXIT
[ -e $TMPFILE ] && rm -f "$TMPFILE"
$ECHO "**** ALL LINTING AND PRETTIFYING COMPLETE ****"
exit 0
