# 13 Debugging Shell Scripts
#!/bin/bash

# hilow--A simple number-guessing game
. validint.sh

biggest=100  # Maximum number possible
guess=0  # Guessed by player
guesses=0  # Bumer of guesses made
# Avoid naming $number to not confliect with validint
hlNumber=$(( $$ % biggest ))  # Random number, between 1 and $biggest
echo "Guess a number between 1 and $biggest"

while [ "$guess" -ne $hlNumber ] ; do
  /bin/echo -n "Guess? ";
  read answer

  if ! validint $answer 1 $biggest ; then
    echo "Please enter a number between 1 and $biggest";
    continue;
  fi

  guess=$answer

  if [ "$guess" -lt $hlNumber ] ; then
    echo "... bigger!"
  elif [ "$guess" -gt $hlNumber ] ; then
    echo "... smaller!"
  fi
  guesses=$(( $guesses + 1 ))
done

echo "Right!! Guessed $hlNumber in $guesses guesses."

exit 0
