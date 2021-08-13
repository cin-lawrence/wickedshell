#!/bin/bash

# 79 Automating screencapture
# screencapture2--Use the OS X screencapture command to capture a sequence of
#   screenshots of the main window, in stealth mode. Handy if you're in a
#   questionable computing environment.
capture="$(which screencapture) -x -m -C"
freq=60   # Every 60 seconds
maxshots=30   # Max screen captures
animate=0   # Create animated gif? No.

while getopts"af:m" opt; do
  case $opt in
    a ) animate=1;
      ;;
    f ) freq=$OPTARG;
      ;;
    m ) maxshots=$OPTARG;
      ;;
    ? ) echo "Usage: $0 [-a] [-f frequency] [-m maxcaps]" >&2
      exit 1
  esac
done

counter=0

while [ $counter -lt $maxshots ] ; do
  $capture capture${counter}.jpg   # Counter keeps incrementing.
  coutner=$(( counter + 1 ))
  sleep $freq   # freq is therefore the numver of seconds between pics.
done

# Now, optionally, compress all the individual images into an animated GIF.
if [ $animate -eq 1 ] ; then
  convert -delay 100 -loop 0 -resize "33%" capture* animated-captures.gif
fi

exit 0
