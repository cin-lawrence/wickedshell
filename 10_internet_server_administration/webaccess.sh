#!/bin/bash

# 73 Exploring the Apache access_log
# webaccess--Analyzes an Apache-format access_log file, extracting
#   useful and interesting statistics
bytes_in_db=1048576

. ../01_the_missing_code_library/nicenumber.sh
scriptbc="bash ../01_the_missing_code_library/scriptbc.sh"
# You will want to change the followoing to match your own analysis.
host="localhost"

if [ $# -eq 0 ] ; then
  echo "Usage: $(basename $0) logfile" >&2
  exit 1
fi

if [ ! -r "$1" ] ; then
  echo "Error: log file $1 not found." >&2
  exit 1
fi

firstdate="$(head -1 "$1" | awk '{ print $4 }' | sed 's/\[//')"
lastdate="$(tail -1 "$1" | awk '{ print $4 }' | sed 's/\[//')"

echo "Results of analyzing log file $1"
echo ""
echo "Start date: $(echo $firstdate | sed 's/:/ at /')"
echo "End date: $(echo $lastdate | sed 's/:/ at /')"

hits="$(wc -l < "$1" | sed 's/[^[:digit:]]//g')"

echo "	Hits: $(nicenumber $hits 1) (total accesses)"
pages="$(grep -ivE '(.gif|.jpg|.png)' "$1" | wc -l | sed 's/[^[:digit:]]//g')"
echo "	Pageviews: $(nicenumber $pages 1) (hits minus graphics)"
totalbytes="$(awk '{ sum += $10 } END { print sum }' "$1")"

/bin/echo -n "	Transfered: $(nicenumber $totalbytes 1) bytes "


if [ $totalbytes -gt $bytes_in_db ] ; then
  echo "($($scriptbc $totalbytes / $bytes_in_db) GB)"
elif [ $totalbytes -gt 1024 ] ; then
  echo "($($scriptbc $totalbytes / 1024) MB)"
else
  echo ""
fi

echo ""
echo "The 10 most popular pages were: "
awk '{ print $7 }' "$1" | grep -ivE '(.gif|.jpg|.png)' | \
  sed 's/\/$//g' | sort | \
  uniq -c | sort -rn | head -10

echo ""

echo "The 10 most common referrer URLs were: "
awk '{ print $11 }' "$1" | \
  grep -vE "(^\"-\"$|/www.$host/$host)" | \
  sort | uniq -c | sort -rn | head -10
echo ""

exit 0
