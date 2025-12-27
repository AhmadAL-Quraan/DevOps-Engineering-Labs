#!/bin/bash

read -p "Enter username: " user

sudo useradd "$user"

sudo passwd "$user"

array=("hr" "dev" "ops" "management" "it")

echo -e "Select department group: 

1) hr 

2) dev 

3) ops 

4) management 

5) it 

"

read -p "Enter group number: " group

index=$((group - 1))

sudo usermod -aG "${array[$index]}" "$user"

if [ "$group" == 5 ]; then

  sudo usermod -aG wheel "$user"

  echo "User added to admin (wheel) group"

fi

#

#    # Error handling

if [ $? -ne 0 ]; then

  echo "An error occurred"

  exit 1

fi

echo "User $user added to group: ${array[$index]}"
