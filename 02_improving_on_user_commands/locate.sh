#  19 Locating Files by Filename
#!/bin/bash

# locate--Searches the locate database for the specified pattern

locatedb="/var/locate.db"

exec grep -i "$@" $locatedb
