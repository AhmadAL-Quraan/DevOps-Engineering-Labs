#!/bin/bash

mkdir /home/backups 2>/dev/null

check_File_exist(){
if [[ ! -d /home/shared_directory ]]; then
	echo "Nothing to backup --> Shared directory is not exist" 
	return 1;
fi
}
check_File_exist;

if [ -d /home/shared_directory/SysAdmin_Team ]; then
	tar -cf "/home/backups/SysAdmin_Team-backup_$(date +%Y_%m_%d)".tar -C /home/shared_directory/ SysAdmin 2>/dev/null
fi



if [ -d /home/shared_directory/HR_team ]; then
	tar -cf "/home/backups/HR_team-backup_$(date +%Y_%m_%d)".tar -C /home/shared_directory/ HR_team 2>/dev/null
fi
if [ -d /home/shared_directory/Dev_Team ]; then
	tar -cf "/home/backups/Dev_Team-backup_$(date +%Y_%m_%d)".tar -C /home/shared_directory/ Dev_Team 2>/dev/null
fi
