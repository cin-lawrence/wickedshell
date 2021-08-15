#!/bin/bash

# 97 Creating Image Thumbnails
# thumbnails--Creates thumbnail images for the graphics file specified,
#   matching exact dimensions or not-to-exceed dimensions

convargs="-unsharp 0x.5 -resize"
count=0; exact=""; fit=""

usage()
{
  echo "Usage: $0 (-e|-f) thumbnail-size image [image] [image]" >&2
  echo "  -e resize to exact dimensions, ignoring original proportions" >&2
  echo "  -f fit image into specified dimensions, retaining proportions" >&2
  echo "  -s strip EXIF information (make ready for web use)" >&2
  echo "  Please use WIDTHxHEIGHT for requested size (e.g., 100x 100)"
  exit 1
}

###############
## BEGIN MAIN
if [ $# -eq 0 ] ; then
  usage
fi

while getopts "e:f:s" opt ; do
  case $opt in
    e ) exact="$OPTARG"; ;;
    f ) fit="$OPTARG"; ;;
    s ) strip="-strip"; ;;
    ? ) usage; ;;
  esac
done
shift $(( $OPTIND - 1 ))

rwidth="$(echo $exact $fit | cut -dx -f1)"
rheight="$(echo $exact $fit | cut -dx -f2)"

for image ; do
  width="$(identify -format "%w" "$image")"
  height="$(identify -format "%h" "$image")"

  if [ $width -le $rwidth -a $height -le $rheight ] ; then
    echo "Image $image is already smaller than requested dimensions. Skipped."
  else
    suffix="$(echo $image | rev | cut -d. -f1 | rev)"
    prefix="$(echo $image | rev | cut -d. -f2- | rev)"
    newname="$prefix-thumb.$suffix"

    # Add the "!" suffix to ignore proportions as needed.
    if [ -z "$fit" ] ; then
      size="$exact!"
      echo "Creating ${rwidth}x${rheight} (exact size) thumb for file $image"
    else
      size="$fit"
      echo "Creating ${rwidth}x${rheight} (max size) thumb for file $image"
    fi

    convert "$image" $strip $convargs "$size" "$newname"
  fi

  count=$(( $count + 1 ))
done

if [ $count -eq 0 ] ; then
  echo "Warning: no images found to process."
fi

exit 0

