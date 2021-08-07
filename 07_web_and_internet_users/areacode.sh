# 57 Area Code Lookup
#!/bin/bash

# areaacode--Given a three-digit US telephone area code, identifies the city
#   and state using the simple tabular data at Bennet Yee's website.
source="https://www.bennetyee.org/ucsd-pages/area.html"

if [ -z "$1" ] ; then
  echo "Usage: $0 <three-digit US telephone area code>"
  exit 1
fi

# wc -c returns characters + end of line char, so 3 digits = 4 chars
if [ "$(echo $1 | wc -c)" -ne 4 ] ; then
  echo "$0: wrong length; only works with three-digit US area codes"
  exit 1
fi

# Are they all digits?
if [ ! -z "$(echo $1 | sed 's/[[:digit:]]//g')" ] ; then
  echo "$0: not-digits: area codes can only be made up of digits"
  exit 1
fi

# Now, finally, let's look up the area code...
result="$(curl -s -dump $source | grep "name=\"$1" | \
  sed 's/<[^>]*>//g;s/^ //g' | \
  cut -f2- -d\ | cut -f1 -d\( )"

echo "Area code $1 =$result"

exit 0

