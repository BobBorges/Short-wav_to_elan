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
	for file in "${working_dir}"/*.wav
	do
		if [[ -f $file ]]; then
		file_bare="${file%.wav}"
		file_name="${file_bare##*/}"
		touch "${working_dir}"/$file_name.txt
		fi
	done		
}

one_dir () {
    echo -e ""
	echo -e "\e[91mPlease \e[5menter \e[25mthe directory you want to operate on."
	echo -e "\e[0m"	
	read working_dir
	TEXTIZE
}

two_dir () {
    echo -e ""
	echo -e "\e[91mPlease \e[5menter \e[25ma .txt file listing the directories you want to operate on."
	echo -e "\e[0m"
	read file_list
	while read line; do
		working_dir="${line}"
		TEXTIZE	
	done < "${file_list}"
}

help_msg () {
	echo -e "\e[33mThis reads the names of .wav files in a designated directory or directories,"
	echo -e "and creates a .txt file with the same name."
	echo -e ""
	echo -e "If tou choose to operate on one directory (Option 1), you must enter a path"
	echo -e "to that directory. Either use a path relative to the current location, or an" 
    echo -e "absolute path. Sommething like:\e[0m"
	echo -e ""
	echo -e "    /home/user/target_directory"
	echo -e ""
	echo -e "\e[33mIf you choose to operate on multiple directories, you must provide"
	echo -e "a .txt file as input. A path should be entered to that file, and"
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

interactive(){
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
}

usage(){
    echo " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo " | --- Welcome to textize! --- |"
    echo " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo ""
    echo "Make .txt file for each .wav file."
    echo ""
    echo "Usage: ./wav_make_txt.sh -h | -i"
    echo "Usage: ./wav_make_txt.sh target-directory"
    echo "Usage: ./wav_make_txt.sh -l target-directories.txt"
    echo ""
    echo "Options"
    echo "  -h | --help             display this message and exit"
    echo "  -i | --interactive      start program in interactive mode"
    echo "  -l | --list             pass target directories from .txt file"
    echo ""
}

file_list=
working_dir=
file_list=

while :; do
    case $1 in
        -h|--help)
            usage
            exit
            ;;
        -i|--interactive)
            interactive
            exit
            ;;
        -l|--list)
            if [ "${2}" ];then
                file_list="${2}"
                shift
            else
                echo "-l takes an argument. Please try again."
                exit
            fi
            ;;
        *)
            break
    esac
    shift
done

if [[ -f "${file_list}" ]]; then
    while read line; do
        working_dir="${line}"
        TEXTIZE
    done < "${file_list}"
elif [ "$1" ];then
    working_dir="${1}"
    TEXTIZE
else
    echo ""
    echo "~~~ You must supply arguments. ~~~"
    echo ""
    usage
fi

