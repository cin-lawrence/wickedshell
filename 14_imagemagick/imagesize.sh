#!/bin/bash

# 94 A Smarter Image Size Analyzer
# imagesize--Displays image file information and dimensions using the
#   identify utility from ImageMagick

for name; do
  identify -format "%f: %G with %k colors.\n" "$name"
done
exit 0
