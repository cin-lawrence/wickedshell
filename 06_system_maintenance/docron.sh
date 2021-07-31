# 49 Ensuring that System cron Jobs Are Run
#!/bin/bash

# docron--Runs the daily, weekly, and monthly system cron jobs on a system
rootcron="/etc/crontab"

if [ $# -ne 1 ] ; then
  echo "Usage: $0 [daily|weekly|monthly]" >&2
  exit 1
fi

# If this script isn't being run by the administrator, fail out.
if [ "$(id -u)" -ne 0 ] ; then
  echo "$0: Command must be run as 'root'" >&2
  exit 1
fi

# We assume that the root cron has entries for 'daily', 'weekly' and
#   'monthly' jobs. If we can't find a match for the o ne specified, well,
#   that's an error. But first, we'll try to get the commdn if there is
#   a match (which is what we expect).
job="$(awk "NF > 6 && /$1/ { for(i=7;i<=NF;i++) print \$i}" $rootcron)"

if [ -z "$job" ] ; then
  echo "$0: Error: no $1 job found in $rootcron" >&2
  exit 1
fi

SHELL=$(which sh)  # To be consistent with cron's default
eval $job
