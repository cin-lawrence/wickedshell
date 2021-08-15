#!/bin/bash

# 100 Calculating Days Between Dates
# daysago--Given a date in the form month/day/year, calculates how many
#   days in the past that was, factoring in leap years, etc.

# date="$(which gdate)"
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
startmon=$1; startday=$2; startyear=$3
daysInMonth $startmon

if [ $startday -lt 0 -o $startday -gt $dim ] ; then
  echo "Invalid: Month #$startmon only has $dim days." >&2
  exit 1
fi

if [ $startmon -eq 2 -a $startday -eq 29 ] ; then
  isleap $startyear
  if [ -z "$leapyear" ] ; then
    echo "Invalid: $startyear wasn't a leap year; February has 28 days." >&2
    exit 1
  fi
fi

#########################
#### CALCULATING DAYS
#########################

daysleftinyear=0
if [ $startyear -gt $thisyear ] ; then
  echo "Invalid: Can not calculate future dates"
  exit 1
fi

startdatefmt="$startmon/$startday/$startyear"
calculate="$((10#$($date -d "12/31/$startyear" +%j))) \
  -$((10#$($date -d $startdatefmt +%j)))"
daysleftinyear=$(( $calculate ))

daysbetweenyears=0
tempyear=$(( $startyear + 1 ))

while [ $tempyear -lt $thisyear ] ; do
  daysbetweenyears=$(( $daysbetweenyears + $((10#$(date -d "12/31/$tempyear" +%j))) ))
  tempyear=$(( $tempyear + 1 ))
done

dayofyear=$($date +%j)

if [ ! $startyear -eq $thisyear ] ; then
  totaldays=$(( $((10#$daysleftinyear)) + \
    $((10#$daysbetweenyears)) + \
    $((10#$dayofyear)) ))
else
  totaldays=$(( $((10#$dayofyear)) + \
    $((10#$daysleftinyear)) - \
    $(date -d 12/31/$thisyear +%j) ))
fi

/bin/echo -n "$totaldays days have elapsed between "
/bin/echo -n "$startmon/$startday/$startyear "
echo "and today, day $dayofyear of $thisyear."

exit 0
