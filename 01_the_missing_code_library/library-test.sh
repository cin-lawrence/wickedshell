# 12 Building a Shell Script Library
#!/bin/bash

# Library test script
# Start by sourcing (reading in) the library.sh file.
. library.sh

# Test validint functionality
echon "First off, do you have echo in your path? (1=yes, 2=no)"
read answer
while ! validint $answer 1 2 ; do
  echon "${boldon}Try again${boldoff}. Do you have echo "
  echon "in your path? (1=yes, 2=no)"
  read answer
done

# Is the command that checks what's in the path working?
if ! checkForCmdInPath "echo" ; then
  echo "Nope, can't find the echo command."
else
  echo "The echo command is in the PATH."
fi

echo ""
echon "Enter a year you think might be a leap year."
read year
# Test to see if the year specified is between 1 and 9999 by
#  using validint with a min and max value.
while ! validint $year 1 9999 ; do
  echon "Please enter a year in the ${boldon}correct${boldoff} format: "
  read year
done

# Now test whether it is indeed a leap year.
if isLeapYear $year ; then
  echo "${greenf}You're right! $year is a leap year.${reset}"
else
  echo "${redf}Nope, that's not a leap year.${reset}"
fi

exit 0
