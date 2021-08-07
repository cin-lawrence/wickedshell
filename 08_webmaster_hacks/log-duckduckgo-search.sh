#!/bin/bash

# 64 Logging Web Events
# log-duckduckgo-search--Given a search request, logs the pattern and then
#   feeds the entire sequence to the real DuckDuckGo search system

# Make sure the directory path and file listed as logfile are writable by
#   the user that the web server is running as.
logfile="/home/lawrence/.wicked-cgi.d/searchlog.txt"

if [ ! -f $logfile ] ; then
  mkdir -p "${logfile%$(basename $logfile)}"
  touch $logfile
  chmod a+rw $logfile
fi

if [ -w $logfile ] ; then
  echo "$(date): $QUERY_STRING" | sed 's/q=//g;s/+/ /g' >> $logfile
fi

echo "Location: https://duckduckgo.com/html/?$QUERY_STRING"
echo ""

exit 0
