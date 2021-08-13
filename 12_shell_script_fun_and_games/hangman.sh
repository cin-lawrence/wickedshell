#!/bin/bash

# 84 Hangman: Guess the Word Before It's Too Late
# hangman--A simple version of the hangman game. Instead of showing a
#   gradually embodied hanging man, this simply has a bad-guess countdown.
# You can optionally indicate the initial distance from the gallow as
#   the only argument.

randomquote="bash ../08_webmaster_hacks/randomquote.sh"
wordlib="/usr/lib/games/long-words.txt"
empty="\."  # We need something for the sed [set] when $guessed="".
games=0


if [ ! -r $wordlib ] ; then
  echo "$0: Missing word library $wordlib" >&2
  echo "(online: https://github.com/dwyl/english-words/blob/master/words.txt" >&2
  echo "save the file as $wordlib and you're ready to play!)" >&2
  exit 1
fi

while [ "$guess" != "quit" ] ; do
  match=$($randomquote $wordlib)
  match="$(echo $match | sed -e 's/[^[:alpha:]]*//g')"

  if [ $games -gt 0 ] ; then
    echo ""
    echo "*** New Game! ***"
  fi

  games="$(( $games + 1))"
  guessed=""; guess=""; bad=${1:-6}
  partial="$(echo $match | sed  "s/[^$empty${guessed}]/-/g")"

  # The guess > analyze > show results > loop happens in thie block.
  while [ "$guess" != "$match" -a "$guess" != "quit" ] ; do
    echo ""
    if [ ! -z "$guessed" ] ; then
      /bin/echo -n "guessed: $guessed, "
    fi
    echo "steps from gallows: $bad, word so far: $partial"
    /bin/echo -n "Guess a letter: "
    read guess
    echo ""
    if [ "$guess" = "$match" ] ; then
      echo "You got it!"
    elif [ "$guess" = "quit" ] ; then
      exit 0
    elif [ ""$(echo $guess | wc -c | sed 's/[^[:digit:]]//g') -ne 2 ] ; then
      echo "Uh oh: You can only guess a single letter at a time"
    elif [ -z "$(echo $guess | sed "s/[$empty$guessed]//g")" ] ; then
      echo "Uh oh: You have already tried $guess"
    elif [ "$(echo $match | sed "s/$guess/-/g")" != "$match" ] ; then
      guessed="$guessed$guess"
      partial="$(echo $match | sed "s/[^$empty${guessed}]/-/g")"
      if [ "$partial" = "$match" ] ; then
        echo "** You've been pardoned!! Well done! The word was \"$match\"."
        guess="$match"
      else
        echo "* Great! The letter \"$guess\" appears in the word!"
      fi
    elif [ $bad -eq 1 ] ; then
      echo "** Uh oh: you've run out of steps. You're on the platform..."
      echo "  The word you were trying to guess was \"$match\""
      guess="$match"
    else
      echo "* Nope, \"$guess\" does not appear in the word."
      guessed="$guessed$guess"
      bad=$(( $bad - 1 ))
    fi
  done
done

exit 0
