#!/bin/bash

# push-to-cgi--Push a given CGI script to Apache2 CGI folder
set -e

cgidir="/usr/lib/cgi-bin"

if [ $# -ne 1 ] ; then
  echo "$(basename $0) failed: only 1 argument allowed" >&2
  exit 1
fi

dst="$cgidir/$1"

sudo cp $1 $dst
sudo chmod 755 $dst
sudo chmod +x $dst


echo "Copied $1 to $dst and changed mods"
ls -l $dst
