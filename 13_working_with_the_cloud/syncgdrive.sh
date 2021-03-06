#!/bin/bash

# 92 Syncing Files with Google Drive
# syncgdrive--Lets you specify one or more files to automatically copy
#   to your Google Drive folder, which syncs with your cloud account
gdrive="$HOME/Google Drive"
gsync="$gdrive/gsync"
gapp="Google Drive.app"

if [ $# -eq 0 ] ; then
  echo "Usage: $(basename $0) [file or files to sync]" >&2
  exit 1
fi

if [ -z "$(ps -ef | grep "$gapp" | grep -v grep)" ] ; then
  echo "Starting up Google Drive daemon..."
  open -a "$gapp"
fi

if [ ! -d "$gsync" ] ; then
  mkdir "$gsync"
  if [ $? -ne 0 ] ; then
    echo "$(basename $0): Failed trying to mkdir $gsync" >&2
    exit 1
  fi
fi

for name ; do
  echo "Copying file $name to your Google Drive"
  cp -a "$name" "$gdrive/gsync/"
done

exit 0
