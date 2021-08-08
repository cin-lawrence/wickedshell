#!/bin/bash

# 72 Syncing Files with SFTP
# sftpsync--Given a target directory on an sftp server, makes sure that
#   all new or modified files are uploaded to the remote system. Uses
#   a timestamp file ingeniously called .timestamp to keep track.
timestamp=".timestamp"
tempfile="/tmp/sftpsync.$$"
count=0

trap "$(which rm) -f $tempfile" 0 1 15

if [ $# -eq 0 ] ; then
  echo "Usage: $0 user@host [ remotedir ]" >&2
  exit 1
fi

user="$(echo $1 | cut -d@ -f1)"
server="$(echo $1 | cut -d@ -f2)"

if [ $# -gt 1 ] ; then
  echo "cd $2" >> $tempfile
fi

if [ -f $timestamp ] ; then
  # If no timestamp file, upload all files
  for filename in * ; do
    if [ -f "$filename" ] ; then
      echo "put -P \"$filename\"" >> $tempfile
      count=$(( $count + 1 ))
    fi
  done
else
  for filename in $(find . -newer $timestamp -type f -print) ; do
    echo "put -P \"$filename\"" >> $tempfile
    count=$(( $count + 1))
  done
fi

if [ $count -eq 0 ] ; then
  echo "$0: No files require uploading to $server" >&2
  exit 1
fi

echo "quit" >> $tempfile

echo "Synchronizing: Found $count files in local folder to upload."

if ! sftp -b $tempfile "$user@$server" ; then
  echo "Done. All files synchronized up with $server"
  touch $timestamp
fi

exit 0
