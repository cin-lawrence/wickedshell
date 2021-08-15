#!/bin/bash

# 90 Syncing Dropbox
# syncdropbox--Synchronize a set of files or a specified folder with Dropbox.
#   This is accomplished by copying the folder into ~/Dropbox or the set of
#   files into the sync folder in Dropbox and then launching Dropbox.app
#   as needed.

name="syncdropbox"
dropbox="$HOME/Dropbox"
sourcedir=""
targetdir="sync"


if [ $# -eq 0 ] ; then
  echo "Usage: $0 [-d source-folder] [file, file, file]" >&2
  exit 1
fi

if [ "$1" = "-d" ] ; then
  sourcedir="$2"
  shift; shift
fi

# Validity check
if [ ! -z "$sourcedir" -a $# -ne 0 ] ; then
  echo "$name: You can't specify both a directory and specific files." >&2
  exit 1
fi

if [ ! -z "$sourcedir" ] ; then
  if [ ! -d "$sourcedir" ] ; then
    echo "$name: Please specify a source directory with -d." >&2
    exit 1
  fi
fi

####################
#### MAIN BLOCK
####################

if [ ! -z "$sourcedir" ] ; then
  if [ -f "$dropbox/$sourcedir" -o -d "$dropbox/$sourcedir" ] ; then
    echo "$name: Specified source directory $sourcedir already exists." >&2
    exit 1
  fi

  echo "Copying contents of $sourcedir to $dropbox..."
  cp -a "$sourcedir" $dropbox
else
  if [ ! -d "$dropbox/$targetdir" ] ; then
    mkdir "$dropbox/$targetdir"
    if [ $? -ne 0 ] ; then
      echo "$name: Error encountered during mkdir $dropbox/$targetdir." >&2
      exit 1
    fi
  fi

  cp -p -v "$@" "$dropbox/$targetdir"
fi

exec startdropbox -s
