# 17 Logging File Removals
#!/bin/bash

# logrmm--Logs all file deletion requests unless the -s flag is used.

removelog="/var/log/remove.log"

if [ $# -eq 0 ] ; then
  echo "Usage: $0 [-s] list of files or directories" >&2
  exit 1
fi

if [ "$1" = "-s" ] ; then
  # Silent operation requested... don't log
  shift
else
  echo "$(date): ${USER}: $@" >> $removelog
fi

/bin/rm "$@"

exit 0
