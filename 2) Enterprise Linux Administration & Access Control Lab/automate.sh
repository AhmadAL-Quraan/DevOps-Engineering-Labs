#!/bin/bash

# make the scriptLog file to print the stderr and stdout there, Also print the results on the terminal (using tee command)

touch /home/scriptLog.txt 
# This is process sub which runs the command in the background and provide you with a file discriptor
exec > >(tee -a /home/scriptLog.txt) 2>&1
#file def 666, dir def 777
umask 002 


while true; do
	read -p "Please enter the new username that you wanna make: " username;

# CHeck if user name is not empty
	if [ "$username" == '' ]; then
		echo "YOU SHOULDN'T LET IT EMPTY, Please write something"
	# Check if user name starts with a capital letter (Not symbol nor number)
	elif [[ ! "$username" =~ ^[A-Z] ]]; then
		echo "YOU CAN'T make the user name starts with anything except capital letters"
	else 
		break;
	fi
done

adduser "$username" 

mkdir /home/"$username"/workspace;

original_path="/home/$username/workspace";


# first make the dir
mkdir "$original_path"/projects;
mkdir "$original_path"/scripts;
mkdir "$original_path"/backup;
mkdir "$original_path"/logs
touch "$original_path"/projects/project1.txt
touch "$original_path"/projects/project2.txt
touch "$original_path"/scripts/run.sh
touch "$original_path"/logs/system.log

# change the dir owner from root ---> user 
find /home/"$username"/ \( -type d -o -type f \) -exec chown "$username":"$username" {} \;

# For each user give the group read and execute for workspace/ and workspace/scripts/ directories, 
find /home/"$username"/ -type d \( -name "workspace" -o -name "scripts" \) -exec chmod g=rx {} \;

# For any other dir or files inside we must not give the group any permission on them and give them read to project2.txt file 
find /home/"$username"/ ! \( -name workspace -o -name "scripts" \)  -exec chmod u=rwx,g=,o= {} \;
chmod u=rwx,g=r "$original_path"/projects/project2.txt

# Join a group


# Check if the user entered any valid group, and keep checking 

checkValidGroup(){

	while true; do

		echo -e "\nPlease Enter the group number that you are part of:\n\n 1) HR_Team\n 2) Developer_Team\n 3) Systemadmin_Team\n"

		read teamNumber;

		groups=("HR_Team" "Developer_Team" "SystemAdmin_Team");
		fileForGroups=("HR_team" "Dev_Team" "SysAdmin_Team");
		case "$teamNumber" in 1|2|3) 
	
			((teamNumber--));
			#Just check if group exist and if not make it
			getent group "${groups[teamNumber]}" > /dev/null || sudo addgroup "${groups[teamNumber]}";
			
			#Add the user on it 
			usermod -aG "${groups[teamNumber]}" "$username";
			#Check if the shared Dir exist and if not make it 
			if [ ! -d /home/shared_directory ]; then
				mkdir /home/shared_directory;
			fi
			#Check if the shared dir for the group exist and if not make it
			if [ ! -d /home/shared_directory/"${fileForGroups[teamNumber]}" ]; then
				mkdir /home/shared_directory/"${fileForGroups[teamNumber]}";
				chown :"${groups[teamNumber]}" /home/shared_directory/"${fileForGroups[teamNumber]}";

			fi
			
			return 0;
			;; 
			*)
			  echo -e "\nERROR: Please enter a valid group, you can't join a group that is not exist"	
			;;
		esac
	done
}

checkValidGroup;

# Password-aging policies for the user 
chage -m 7 -M 30 -W 7 "$username"

echo -e "\nPlease notice that your password-aging policy has been changed, with minimum days of 7 days and max with 30" 
