# 46 Setting the System Date
#!/bin/bash

# setdate--Friendly frontend to the date command
# Date wants: [[[[[cc]yy]mm]dd]hh]mm[.ss]

# To make things user-friendly, this function prompts for a specific date
#   value, displaying the default in [] based on the current date and time.

. library.sh  # Source our library of bash functions to get echon().
askvalue()
{
  # $1 = field name, $2 = default value, $3 = max value,
  # $4 = required char/digit length

  echon "$1 [$2]:"
  read answer

  if [ ${answer:=$2} -gt $3 ] ; then
    echo "$0: $1 $answer is invalid"
    exit 0
  elif [ "$(( $(echo $answer | wc -c) - 1 ))" -lt $4 ] ; then
    echo "$0: $1 $answer is too short: please specify $4 digits"
    exit 0
  fi

  eval $1=$answer  # Reload the given variable with the specific value.
}

eval $(date "+nyear=%Y nmon=%m nday=%d nhr=%H nmin=%M")

askvalue year $nyear 3000 4
askvalue month $nmon 12 2
askvalue day $nday 31 2
askvalue hour $nhr 24 2
askvalue minute $nmin 59 2

squished="$month$day$hour$minute$year"

echo "Setting date to $squished. You might need to enter your sudo password."
sudo date $squished
exit 0

