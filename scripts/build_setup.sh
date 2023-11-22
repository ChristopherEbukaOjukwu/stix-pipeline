#!/bin/bash

set exuo pipefail

export DEBIAN_FRONTEND=noninteractive
### some common dependencies
### could probably pare it down a bit
################################################################################
sudo apt-get update
sudo apt-get install -y \
    build-essential curl git libcurl4-openssl-dev \
    curl wget software-properties-common libxml2-dev mime-support \
    automake libtool pkg-config libssl-dev ncurses-dev awscli \
    python-pip libbz2-dev liblzma-dev unzip imagemagick openjdk-11-jdk

### mount storage
################################################################################
export TMPDIR=/mnt/local/temp
sudo mkdir /mnt/local

# setup raid 0 if more than one drive specified
# the nvme drive naming convention is not consistent enough
# so I have just resorted to filtering out nvme disks with
# the expected size (ex smallest c5d has a 50GB so > 40 is my threshold)
num_drives=$(lsblk -b -o NAME,SIZE | grep 'nvme'| awk '$2 > 4e10' | wc -l)
drive_list=$(lsblk -b -o NAME,SIZE | grep 'nvme' |
                awk '$2 > 4e10' |
                awk 'BEGIN{ORS=" "}{print "/dev/"$1 }')
if [[ $num_drives > 1 ]]; then
    drive_list=$(lsblk -b -o NAME,SIZE | grep 'nvme' |
                 awk '$2 > 4e10' |
                 awk 'BEGIN{ORS=" "}{print "/dev/"$1 }')
    sudo mdadm --create --verbose \
         /dev/md0 \
         --level=0 \
         --raid-devices=$num_drives $drive_list
    sudo mkfs -t xfs /dev/md0
    sudo mount /dev/md0 /mnt/local
else
    sudo mkfs -t xfs $drive_list
    sudo mount $drive_list /mnt/local
fi

user=$(whoami)
sudo chown $user /mnt/local
mkdir /mnt/local/data
mkdir /mnt/local/temp
echo "export TMPDIR=/mnt/local/temp" >> ~/.profile




