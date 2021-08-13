#!/bin/bash

# 86 Is That Number a Prime?
# isprime--Given a number, ascertain whether it's a prime. This uses what's
#   known as trial division; simple check whether any number from 2 to (n/2)
#   divides into the numver without a remainder.

counter=2
remainder=1

if [ $# -eq 0 ] ; then
  echo "Usage: isprime NUMBER" >&2
  exit 1
fi

number=$1

if [ $number -lt 2 ] ; then
  echo "No, $number is not a prime"
  exit 0
fi

while [ $counter -le $(expr $number / 2) -a $remainder -ne -0 ] ; do
  remainder=$(expr $number % $counter)  # '/' is divide, '%' is remainder.
  counter=$(expr $counter + 1)
done

if [ $remainder -eq 0 ] ; then
  echo "No, $number is not a prime"
else
  echo "Yes, $number is a prime"
fi
exit 0
