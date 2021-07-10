#1 Finding Programs in the PATH
#!/bin/bash
# inpath--Verifies that a specified program is either valid as is
#   or can be found in the PATH directory list

in_path()
{
  # Given a command and the PATH, tries to find the command. Returns 0 if
  #   found and executable; 1 if not. Note that this temporarily modifies
  #   the IFS (internal field separator) but restores it upon completion.
  cmd=$1
  ourpath=$2
  result=1
  oldIFS=$IFS
  IFS=":"

  # "$ourpath" won't work
  for directory in $ourpath
  do
    if [ -x "$directory/$cmd" ] ; then
      result=0  # If we're here, we found the command.
    fi
  done

  IFS=$oldIFS
  return $result
}

checkForCmdInPath()
{
  var=$1

  if [ "$var" != "" ] ; then
    # if [ "${var:0:1}" = "/" ] ; then
    if [ "${var%${var#?}}" = "/" ] ; then
      if [ ! -x $var ] ; then
        return 1
      fi
    elif ! in_path $var "$PATH" ; then
      return 2
    fi
  fi
}

if [ "$BASH_SOURCE" != "$0" ] ; then
  exit 0
fi

if [ $# -ne 1 ] ; then
  echo "Usage: $0 command" >&2
  exit
fi

checkForCmdInPath "$1"
case $? in
  0 ) echo "$1 found in PATH" ;;
  1 ) echo "$1 not found or not executable" ;;
  2 ) echo "$1 not found in PATH" ;;
esac

exit 0
