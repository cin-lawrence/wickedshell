# 28 Wrapping Only Long Lines
#!/bin/bash

# toolong--Feeds the fmt command only those lines in the input stream
#   that are longer than the specified length
width=72
fmt="bash ../02_improving_on_user_commands/fmt.sh"

if [ ! -r "$1" ] ; then
  echo "Cannot read file $1" >&2
  echo "Usage: $0 filename" >&2
  exit 1
fi

while read input ; do
  if [ ${#input} -gt $width ] ; then
    echo "$input" | fmt
  else
    echo "$input"
  fi
done < $1

exit 0
