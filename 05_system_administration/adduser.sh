# 40 Adding USers to the System
#!/bin/bash

# adduser--Adds a new user to the system, including building their
#   home directory, copying in default config data, etc.
#    For a standard Unix/Linux system, not OS X.
pwfile="/etc/passwd"
shadowfile="/etc/shadow"
gfile="/etc/group"
hdir="/home"

if [ "$(id -un)" != "root" ] ; then
  echo "Error: You must be root to run this command." >&2
  exit 1
fi
echo "Add new user account to $(hostname)"
/bin/echo -n "login: " ; read login

# The next line sets the highest possible user ID value at 5000,
#   but you should adjust this number to match the top end
#   of your user ID range
uid="$(awk -F: '{ if (big < $3 && $3 < 5000) big=$3 } END { print big + 1 }' \
  $pwfile)"
homedir=$hdir/$login

# We are giving each user their own group.
gid=$uid

/bin/echo -n "full name: " ; read fullname
/bin/echo -n "shell: " ; read shell

echo "Setting up account $login for $fullname..."
echo ${login}:x:${uid}:${gid}:${fullname}:${homedir}:$shell >> $pwfile
echo ${login}:*:11647:0:99999:7::: >> $shadowfile
echo "${login}:x:${gid}:$login" >> $gfile

mkdir $homedir
cp -R /etc/skel/.[a-zA-Z]* $homedir
chmod 755 $homedir
chown -R ${login}:${login} $homedir

# Settings an initial password
exec passwd $login
