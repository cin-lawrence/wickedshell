#!/bin/bash

# 77 Monitoring Network Status
# getstats--Every 'n' minutes, grabs netstats values (via crontab)
logfile="/home/lawrence/.netstatlog"
temp="/tmp/getstats.$$.tmp"

trap "$(which rm) -f $temp" 0

if [ ! -e $logfile ] ; then
  touch $logfile
fi

( netstat -s -p tcp > $temp
# Check your log file the first time this is run: some versions of netstat
#   report more than one line, which is why the "| head -1" is used here.
# The delimiter here is tab, not space
sent="$(grep 'packets sent' $temp | sed -e 's/[^[:digit:]]//g' | sed \
  's/[^[:digit:]]//g' | head -1)"
resent="$(grep 'retransmitted' $temp | sed -e 's/[^[:digit:]]//g' | sed \
  's/[^[:digit:]]//g')"
received="$(grep 'total packets received$' $temp | sed -e 's/[^[:digit:]]//g' | \
  sed 's/[^[:digit:]]//g')"
dupacks="$(grep 'duplicate acks' $temp | sed -e 's/[^[:digit:]]//g' | \
  sed 's/[^[:digit:]]//g')"
outoforder="$(grep 'out-of-order packets' $temp | sed -e 's/[^[:digit:]]//g' | \
  sed 's/[^[:digit:]]//g')"
connectreq="$(grep 'connection requests' $temp | sed -e 's/[^[:digit:]]//g' | \
  sed 's/[^[:digit:]]//g')"
connectacc="$(grep 'connection accepts' $temp | sed -e 's/[^[:digit:]]//g' | \
  sed 's/[^[:digit:]]//g')"
retmout="$(grep 'retransmit timeouts' $temp | sed -e 's/[^[:digit:]]//g' | \
  sed 's/[^[:digit:]]//g')"

/bin/echo -n "time=$(date +%s);"
/bin/echo -n "rec=$received;"
/bin/echo -n "snt=$sent;re=$resent;rec=$received;dup=$dupacks;"
/bin/echo -n "oo=$outoforder;creq=$connectreq;cacc=$connectacc;"
echo "reto=$retmout"
) >> $logfile

exit 0
