#!/bin/bash

# 87 Let's Roll Some Dice
# rolldice--Parse requested dice to roll and simulate those rolls.
# Examples: d6 = one 6-sided die
#   2d12 = two 12-sided die
#   d4 3e8 2d20 = one 4-sided die, three 8-sided, and two 20-sided dice

rolldie()
{
  dice=$1
  dicecount=1
  sum=0

  if [ -z "$(echo $dice | grep 'd')" ] ; then
    quantity=1
    sides=$diceelse
  else
    quantity=$(echo $dice | cut -dd -f1)
    if [ -z "$quantity" ] ; then
      quantity=1
    fi
    sides=$(echo $dice | cut -dd -f2)
  fi

  echo ""; echo "rolling $quantity $sides-sided die"

  while [ $dicecount -le $quantity ] ; do
    roll=$(( ($RANDOM % $sides) + 1 ))
    sum=$(( $sum + $roll ))
    echo "roll #$dicecount = $roll"
    dicecount=$(( $dicecount + 1 ))
  done

  echo I rolled $dice and it added up to $sum
}

while [ $# -gt 0 ] ; do
  rolldie $1
  sumtotal=$(( $sumtotal + $sum ))
  shift
done

echo ""
echo "In total, all of those dice add up to $sumtotal"
echo ""

exit 0
