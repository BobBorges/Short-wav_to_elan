#!/bin/bash

# This reads the names of .wav files in a designated directory or directories,
# and creates a .txt file with the same name.
#
#    ###########
#    # LICENSE #
#    ###########
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
TEXTIZE (){
	for file in $working_dir/*.wav
	do
		if [[ -f $file ]]; then
		file_bare=${file%.wav}
		file_name=${file_bare##*/}
		touch "$working_dir/$file_name.txt"
		fi
	done		
}
one_dir () {
	echo "Please enter the directory you want to operate on."
	echo "HINT: Use an absolute path."	
	read working_dir
	TEXTIZE
}
two_dir () {
	echo "Please enter a .txt file listing the directories you want to operate on."
	echo "HINT: Use absoute paths to the file AND in the file."
	read file_list
	while read line; do
		working_dir=$line
		TEXTIZE	
	done < $file_list
}
help_msg () {
	echo -e "\e[33mThis reads the names of .wav files in a designated directory or directories,"
	echo -e "and creates a .txt file with the same name."
	echo -e ""
	echo -e "If tou choose to operate on one directory (Option 1), you must enter an"
	echo -e "absolute path to that directory. Sommething like:\e[0m"
	echo -e ""
	echo -e "    /home/user/target_directory"
	echo -e ""
	echo -e "\e[33mIf you choose to operate on multiple directories, you must provide"
	echo -e "a .txt file as input. An absolute path should be entered to that fiel, and"
	echo -e "its contents should be a line by line list of directories to be operated"
	echo -e "on by the script."
	echo -e ""
	echo -e "OK?"
	echo -e ""
	sleep 1
	echo -e "\e[31mNow repeating the options:"
	echo -e "\e[33m"
	PS3=""
	sleep 1
	echo "x" | select opt in "${options[@]}"; do break;done;  # $REPLY";;
	export PS3=$'\e[91mPlease \e[5menter \e[25myour choice:\e[0m '
}
echo -e "\e[31m |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
echo -e " | --- Welcome to textize! --- |"
echo -e " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
sleep 1
echo ""
echo -e "How many directories to you want to operate on?\e[33m"
echo ""
sleep 1

COLUMNS=12
export PS3=$'\e[91mPlease \e[5menter \e[25myour choice:\e[0m '
options=("Work on a single directory" "Work on multiple directories" "Get help" "Quit")
select opt in "${options[@]}"
do
	case $opt in
		"Work on a single directory")
			echo "You chose to work on ONE directory."
			one_dir
			break		
			;;
		"Work on multiple directories")
			echo "You chose to work on MULTIPLE directories."
			two_dir
			break
			;;
		"Get help")
			echo "So, you need help? Here it is:"
			help_msg
			;;
		"Quit")
			break
			;;
		*) 
			PS3=""
			echo -e "\e[1mInvalid option!!\e[0m Try again.\e[33m"
			sleep 1
			echo "x" | select opt in "${options[@]}"; do break;done;  # $REPLY";;
			export PS3=$'\e[91mPlease \e[5menter \e[25myour choice:\e[0m '
	esac
done
