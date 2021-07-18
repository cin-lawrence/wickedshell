# 18 Displaying the Contents of Directories
#!/bin/bash

# formatdir--Outputs a directory listing in a friendly and useful format.

# Note that you need to ensure "scriptbc" is in your current PATH
# because it's invoked within the script more than once.
# scriptbc=$(which scriptbc)
scriptbc="../01_the_missing_code_library/scriptbc.sh"
KB_IN_GB=$((1024 * 1024))
KB_IN_MB=1024

# Function to format sizes in KB to KB, MB, or GB for more readable output
readablesize()
{
  if [ "$1" -ge $KB_IN_GB ] ; then
    echo "$($scriptbc -p 2 $1 / $KB_IN_GB)GB"
  elif [ "$1" -ge $KB_IN_MB ] ; then
    echo "$($scriptbc -p 2 $1 / $KB_IN_MB)MB"
  else
    echo "${1}KB"
  fi
}

################
## MAIN CODE

if [ $# -gt 1 ] ; then
  echo "Usage: $0 [dirname]" >&2
  exit 1
elif [ $# -eq 1 ] ; then  # Specify a directory other than the current one?
  cd "$@"  # Then let's change to that that one.
  if [ $? -ne 0 ] ; then  # Or quit if the directory doesn't exist.
    exit 1
  fi
fi

for file in * ; do
  if [ -d "$file" ] ; then
    size=$(ls "$file" | wc -l | sed 's/[^[:digit:]]//g')
    if [ $size -eq 1 ] ; then
      echo "$file ($size entry)|"
    else
      echo "$file ($size entries)|"
    fi
  else
    size="$(ls -sk "$file" | awk '{ print $1 }')"
    echo "$file ($(readablesize $size))|"
  fi
done | \
  sed 's/ /^^^/g' | \
  xargs -n 2 | \
  sed 's/\^\^\^/ /g' | \
  awk -F\| '{ printf "%-39s %-39s\n", $1, $2 }'

exit 0
