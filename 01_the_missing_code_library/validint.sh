# Validating Integer Input
#!/bin/bash
# validint--Validates integer input, allowing negative integers too
validnum()
{
  # Validate arg: returns 0 if all upper+lower+digits; 1 otherwise

  # Remove all unacceptable chars.
  validchars="$(echo $1 | sed -e 's/[^0-9]//g')"

  if [ "$validchars" = "$1" ] ; then
    return 0
  else
    return 1
  fi
}


validint()
{
  # Validate first field and test that value against min value $2 and/or
  #   max value $3 if they are supplied. If the value isn't within range
  #   or it's not composed of just digits, fail.
  number="$1";
  min="$2";
  max="$3";

  if [ -z $number ] ; then
    echo "You didn't enter anything. Please enter a number." >&2
    return 1
  fi

  if ! validnum $number ; then
    echo "You didn't enter a number. Please enter a number." >&2
    return 1
  fi

  # Is the first character a '-' sign?
  if [ "${number%${number#?}}" = "-" ] ; then
    testvalue="${number#?}"  # Grab all but the first character to test.
  else
    testvalue="$number"
  fi

  # Create a version of the number that has no digits for testing.
  nodigits="$(echo $testvalue | sed 's/[[:digit:]]//g')"

  # Check for nodigit characters.
  if [ ! -z $nodigits ] ; then
    echo "Invalid number format! Only digits, no commas, spaces, etc." >&2
    return 1
  fi

  # Is the input less than the minimum value?
  # if [ ! -z $min -a "$number" -lt "$min" ] ; then
  if [ ! -z $min ] && [ "$number" -lt "$min" ] ; then
    echo "Your value is too small: smallest acceptable value if $min." >&2
    return 1
  fi

  # Is the input greater than the maximum value?
  # if [ ! -z $max -a "$number" -gt "$max" ] ; then
  if [ ! -z $max ] && [ "$number" -gt "$max" ] ; then
    echo "Your value is too big: largest acceptable value is $max." >&2
    return 1
  fi

  return 0
}

# Input validation
# if validint "$1" "$2" "$3" ; then
#   echo "Input is a valid integer within your constraints."
# fi
