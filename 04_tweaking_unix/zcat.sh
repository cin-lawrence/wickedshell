# 33 Working with Compressed Files
#!/bin/bash

# zcat, zmore, and zgrep--This script should be either symbolically
#   linked or hard linked to all three names. It allows users to work with
#   compressed files transparently
Z="compress"; unZ="uncompress"; Zlist=""
gz="gzip"; ungz="gunzip"; gzlist=""
bz="bzip2"; unbz="bunzip2"; bzlist=""

# First step is to try isolate the filenames in the comand lines.
# We'll do this lazily by stepping through each argument, testing to
#   see whether it's a filename. If it is and it has a compression
#   suffix, we'll decompress the file, rewrite the filename, and proceed.
# When done, we'll recompress everything that was decompressed.
for arg ; do
  if [ -f "$arg" ] ; then
    case "$arg" in
      *.Z ) $unZ "$arg"
        arg="$(echo $arg | sed 's/\.Z$//')"
        Zlist="$Zlist \"$arg\""
        ;;
      *.gz ) $ungz "$arg"
        arg="$(echo $arg | sed 's/\.gz$//')"
        gzlist="$gzlist \"$arg\""
        ;;
      *.bz ) $unbz "$arg"
        arg="$(echo $arg | sed 's/\.bz$//')"
        bzlist="$bzlist \"$arg\""
        ;;
    esac
  fi
  newargs="${newargs:-""}\"$arg\""
done

case $0 in
  zcat* ) eval cat $newargs ;;
  zmore* ) eval more $newargs ;;
  zgrep* ) eval grep $newargs ;;
  * ) echo "$0: unknown base name. Can't proceed." >&2
    exit 1
esac

# Now compress everything
if [ ! -z "$Zlist" ] ; then
  eval $Z $Zlist
fi
if [ ! -z "$gzlist" ] ; then
  eval $gz $gzlist
fi
if [ ! -z "$bzlist" ] ; then
  eval $bz $bzlist
fi

# And done!

exit 0
