#!/bin/bash

# Acey Duecey
# aceyduecey: Dealer flips over two cards, and you guess whether the
#   next card from the deck will rank between the two. For example,
#   with a 6 and an 8, a 7 is between the two, but a 9 is not.

initializeDeck()
{
  card=1
  while [ $card -le 52 ] ; do
    deck[$card]=$card
    card=$(( $card + 1 ))
  done
}

shuffleDeck()
{
  count=1
  while [ $count != 53 ] ; do
    pickCard
    newdeck[$count]=$picked
    count=$(( $count + 1))
  done
}

pickCard()
{
  local errcount randomcard
  threshold=10
  errcount=0

  while [ $errcount -lt $threshold ] ; do
    randomcard=$(( ($RANDOM % 52) + 1 ))
    errcount=$(( $errcount + 1 ))

    if [ ${deck[$randomcard]} -ne 0 ] ; then
      picked=${deck[$randomcard]}
      deck[$picked]=0
      return $picked
    fi
  done

  randomcard=1

  while [ ${newdeck[$randomcard]} -eq 0 ] ; do
    randomcard=$(( $randomcard + 1 ))
  done

  picked=$randomcard
  deck[$picked]=0
  return $picked
}

showCard()
{
  card=$1

  if [ $card -lt 1 -o $card -gt 52 ] ; then
    echo "Bad card value: $card"
    exit 1
  fi

  suit="$(( (($card - 1) / 13) + 1 ))"
  rank="$(( $card % 13 ))"
  case $suit in
    1 ) suit="Hearts" ;;
    2 ) suit="Clubs" ;;
    3 ) suit="Spades" ;;
    4 ) suit="Diamonds" ;;
    * ) echo "Bad suit value: $suit"
      exit 1
  esac

  case $rank in
    0 ) rank="King" ;;
    1 ) rank="Ace" ;;
    11 ) rank="Jack" ;;
    12 ) rank="Queen" ;;
  esac

  cardname="$rank of $suit"
}

dealCards()
{
  # Acey Deucey has two cards flipped up
  card1=${newdeck[1]}
  card2=${newdeck[2]}
  card3=${newdeck[3]}

  rank1=$(( ${newdeck[1]} % 13 ))
  rank2=$(( ${newdeck[2]} % 13 ))
  rank3=$(( ${newdeck[3]} % 13 ))

  if [ $rank1 -eq 0 ] ; then
    rank1=13
  fi

  if [ $rank2 -eq 0 ] ; then
    rank2=13
  fi

  if [ $rank3 -eq 0 ] ; then
    rank3=13
  fi

  if [ $rank1 -gt $rank2 ] ; then
    temp=$card1; card1=$card2; card2=$temp
    temp=$rank1; rank1=$rank2; rank2=$temp
  fi

  showCard $card1; cardname1=$cardname
  showCard $card2; cardname2=$cardname
  showCard $card3; cardname3=$cardname

  echo "I've dealt:"; echo " $cardname1"; echo " $cardname2"
}

introblurb()
{
  cat << EOF
  Welcome to Acey Deucey. The goal of this game is for you to correctly guess
whether the third card is going to be between the two cards I'll pull from
the deck. For example, if I flip up a 5 of hearts and a jack of diamonds,
you'd bet on whether the next card will have a higher rank and a 5 AND a
lower rank than a jack (that is, a 6, 7, 8, 9, or 10 of any suit).
  Ready? Let's go!
EOF
}

games=0
won=0

if [ $# -gt 0 ] ; then
  introblurb
fi

while [ /bin/true ] ; do
  initializeDeck
  shuffleDeck
  dealCards

  splitValue=$(( $rank2 - $rank1 ))

  if [ $splitValue -eq 0 ] ; then
    echo "No point in betting when they're the same rank!"
    continue
  fi

  /bin/echo -n "The spread is $splitValue. Do you think the next card will "
  /bin/echo -n "be between them? (y/n/q) "
  read answer

  if [ "$answer" = "q" ] ; then
    echo ""
    echo "You played $games games and won $won times."
    exit 0
  fi

  echo "I picked: $cardname3"

  if [ $rank3 -gt $rank1 -a $rank3 -lt $rank2 ] ; then
    winner=1
  else
    winner=0
  fi

  if [ $winner -eq 1 -a "$answer" = "y" ] ; then
    echo "You bet that it would be between the two, and it is. WIN!"
    won=$(( $won + 1 ))
  elif [ $winner -eq 0 -a "$answer" = "n" ] ; then
    echo "You bet that it would not be between the two, and it isn't. WIN!"
    won=$(( $won + 1 ))
  else
    echo "Bad betting strategy. You lose."
  fi

  games=$(( $games + 1 ))
done

exit 0
