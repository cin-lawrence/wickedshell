# 35 Analyzing Disk Usage
#!/bin/bash

# fquota--Disk quota analysis tool for Unix; assumes all user
#   accounts are >= UID 100

MAXDISKUSAGE=20000 # In megabytes

for name in $(cut -d: -f1,3 /etc/passwd | awk -F: '$2 > 99 {print $1}') ; do
  /bin/echo -n "User $name exceeds disk quota. Disk usage is: "
  find / /usr /var /home -xdev -user $name -type f -ls | \
    awk '{ sum += $7 } END { print sum / (1024 * 1024) " Mbytes" }'
done | awk "\$9 > $MAXDISKUSAGE { print \$0 }"

exit 0
