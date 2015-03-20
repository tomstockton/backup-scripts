#!/bin/bash

export TERM=xterm

. /etc/sysconfig/bsfl

LOG_ENABLED=y
LOG_FILE=/var/log/infrastructure-device-backups.log

scripts_dir="/opt/backup-scripts"
username="admin"
password="backup"
cisco_ios_hosts="192.168.1.1 192.168.1.2"
tftp_server="192.168.1.100"

START=`now`
log "Starting Backups"

for host in $cisco_ios_hosts; do
  ${scripts_dir}/backup_cisco_ios.exp $host $username $password $tftp_server ${host}_`date +%Y%m%d-%H%M`.backup
  check_status "${scripts_dir}/backup_cisco_ios.exp $host $username **** $tftp_server $_" "$?"
done

STOP=$(now)
DURATION=$(elapsed $START $STOP)
msg "Backup Duration is $DURATION seconds." "$GREEN"
