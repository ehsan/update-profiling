#!/bin/bash

set -e

LOCK_FILE=/tmp/profiling-update.lockfile

# check for the lock file to prevent running multiple instances of the script
# at the same time.
if [ -e "$LOCK_FILE" ]; then
  exit 0
fi
trap "rm -f \"$LOCK_FILE\"; exit" INT TERM EXIT
touch $LOCK_FILE

cd $HOME/profiling/profiling
hg incoming m-c > /dev/null
if [ $? -eq 0 ]; then
  hg pull m-c > /dev/null && \
     hg merge > /dev/null && \
     hg commit -m "Automated merge from mozilla-central" > /dev/null
  hg push > /dev/null
fi

