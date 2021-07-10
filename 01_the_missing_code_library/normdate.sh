# 3 Normalizing Date Formats
#!/bin/bash
# normdate--Normalizes month field in date specification to three letters,
#   first letter capitalized. A helper function for Script #7, valid-date.
#   Exists with 0 if no error.

monthNumToName()
{
  # Sets the 'month' variable to the appropriate value.
  case $1 in
    1 ) month="Jan" ;;
    2 ) month="Feb" ;;
    3 ) month="Mar" ;;
    4 ) month="Apr" ;;
    5 ) month="May" ;;
    6 ) month="Jun" ;;
    7 ) month="Jul" ;;
    8 ) month="Aug" ;;
    9 ) month="Sep" ;;
    10 ) month="Oct" ;;
    11 ) month="Nov" ;;
    12 ) month="Dec" ;;
    *) echo "$0: Unknown month value $1" >&2
       exit 1
  esac
  return 0
}

# BEGIN MAIN SCRIPT--DELETE OR COMMENT OUT EVERYTHING BELOW THIS LINE IF
#   YOU WANT TO INCLUDE THIS IN OTHER SCRIPTS.
# ================
# Input validation
if [ $# -eq 1 ] ; then  # To compensate for / or - formats
  set -- $(echo $1 | sed 's/[\/\-]/ /g')
fi

if [ $# -ne 3 ] ; then
  echo "Usage: $0 month day year" >&2
  echo "Formats are August 3 1962 and 8 3 1962" >&2
  exit 1
fi

if [ $3 -le 99 ] ; then
  echo "$0: expected 4-digit year value." >&2
  exit 1
fi

# Is the month input format a number?
if [ -z $(echo $1 | sed 's/[[:digit:]]//g') ] ; then
  monthNumToName $1
else
# Normalize to first 3 letters, first upper- and then lowercase.
  month="$(echo $1 | cut -c1 | tr '[:lower:]' '[:upper:]')"
  month="$month$(echo $1 | cut -c2-3 | tr '[:upper:]' '[:lower:]')"
fi

echo $month $2 $3

exit 0
