#!/bin/bash

# 101 Calculating Days Until a Specified Date
# daysuntil--Basically, this is the daysago script backward, where the
#   desired date is set as the current date and the current date is used
#   as the basis of the daysago calculation

date="$(which date)"

daysInMonth()
{
  case $1 in
    1|3|5|7|8|10|12 ) dim=31; ;;
    4|6|9|11 ) dim=30; ;;
    2 ) dim=29; ;;
    * ) dim=-1; ;;
  esac
}

isleap()
{
  leapyear=$($date -d  12/31/$1 +%j | grep 366)
}

####################
#### MAIN BLOCK
####################

if [ $# -ne 3 ] ; then
  echo "Usage: $(basename $0) mon day year"
  echo " with just numerical values (ex: 7 7 1776)"
  exit 1
fi

$date --version > /dev/null 2>&1

if [ $? -ne 0 ] ; then
  echo "Sorry, but $(basename $0) can't run without GNU date." >&2
  exit 1
fi

eval $($date "+thismon=%m;thisday=%d;thisyear=%Y;dayofweek=%j")
endmon=$1; endday=$2; endyear=$3

daysInMonth $endmon


if [ $endday -lt 0 -o $endday -gt $dim ] ; then
  echo "Invalid: Month #$startmon only has $dim days." >&2
  exit 1
fi

if [ $endmon -eq 2 -a $endday -eq 29 ] ; then
  isleap $endyear
  if [ -z "$leapyear" ] ; then
    echo "Invalid: $endyear wasn't a leap year; February has 28 days." >&2
    exit 1
  fi
fi

if [ $endyear -lt $thisyear ] ; then
  echo "Invalid: $endmon/$endday/$endyear is prior to the current year." >&2
  exit 1
fi

if [ $endyear -eq $thisyear -a $endmon -lt $thismon ] ; then
  echo "Invalid: $endmon/$endday/$endyear is prior to the current month." >&2
  exit 1
fi

if [ $endyear -eq $thisyear -a $endmon -eq $thismon -a $endday -lt $thisday ] ; then
  echo "Invalid: $endmon/$endday/$endyear is prior to the current date." >&2
  exit 1
fi

if [ $endyear -eq $thisyear -a $endmon -eq $thismon -a $endday -eq $thisday ] ; then
  echo "There are zero days between $endmon/$endday/$endyear and today." >&2
  exit 1
fi

if [ $endyear -eq $thisyear ] ; then
  totaldays=$(( $($date -f "$endmon/$endday/$endyear" +%j) - $($date +%j) ))
else
  thisdatefmt="$thismon/$thisday/$thisyear"
  calculate="$($date -d "12/31/$thisyear" +%j) - $($date -d $thisdatefmt +%j)"
  daysleftinyear=$(( $calculate ))

  daysbetweenyears=0
  tempyear=$(( $thisyear + 1 ))

  while [ $tempyear -lt $endyear ] ; do
    daysbetweenyears=$(( $daysbetweenyears + \
      $($date -d "12/31/$tempyear" +%j) )) \
    tempyear=$(( $tempyear + 1 ))
  done

  dayofyear=$($date --date $endmon/$endday/$endyear +%j)

  totaldays=$(( $daysleftinyear + $daysbetweenyears + $dayofyear ))
fi

echo "There are $totaldays days until the date $endmon/$endday/$endyear."
exit 0
