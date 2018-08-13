#!/bin/sh
USER="$1"
HOSTNAME="$2"
KEY="$3"
CACHE_IP="$4"

if [ -z "$USER" ]; then
  (>&2 echo "user not defined")
  exit 1
fi

if [ -z "$HOSTNAME" ]; then
  (>&2 echo "hostname not defined")
  exit 2
fi

if [ -z "$KEY" ]; then
  (>&2 echo "public key not defined")
  exit 3
fi

# set hostname
echo "set hostname to $HOSTNAME"
hostname "$HOSTNAME"
echo "$HOSTNAME" > /etc/hostname

# add user w/ sudo access, no password
echo "add user $USER"
useradd --groups 'sudo' --create-home --shell '/bin/bash' "$USER"
sed "s/vagrant/$USER/" /etc/sudoers.d/vagrant > "/etc/sudoers.d/$USER"
service sudo reload

# add user public key to authorized keys
echo "add $USER public key"
ssh_dir="/home/$USER/.ssh"
mkdir "$ssh_dir"
echo "$KEY" > "$ssh_dir/authorized_keys"
chown -R "$USER:$USER" "$ssh_dir"
chmod 700 "$ssh_dir"

# add apt-cache for faster testing
# the host can use apt-cacher-ng 

# check if the address given has the cacher running
if $(nc -z $CACHE_IP 3142); then
  echo "enable apt-cache proxy $CACHE_IP:3142"
  echo "Acquire::http { Proxy \"http://$CACHE_IP:3142\"; };" > /etc/apt/apt.conf.d/02proxy
  # fix nodesource error when connecting through proxy
  echo "Acquire::http::Proxy { deb.nodesource.com DIRECT; };" >> /etc/apt/apt.conf.d/02proxy
fi
