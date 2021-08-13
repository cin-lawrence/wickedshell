#1/bin/bash

# 80 Setting the Terminal Title Dynamically
# titleterm--Tells the OSX Terminal application to change its title
#   to the value specified as an argument to this succint script

if [ $# -eq 0 ] ; then
  echo "Usage: $0 title" >&2
  exit 1
else
  echo -e "\033]0;$@\007"
fi

exit 0
