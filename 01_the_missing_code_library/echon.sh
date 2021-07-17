#!/bin/bash

echon()
{
  echo "$@" | awk '{ printf "%s", $0 }'
}

# echon "$@"
