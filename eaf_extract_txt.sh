#!/bin/bash

# This script iterates through subdirectories, where it is assumed ELAN
# projects (one or more media files, .eaf adn .pfsx files) are stored.
# The script assumes there is one annotation on one tier, and extracts
# the annotation value, then adds it to a .txt file.
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
EXTRACT_TXT(){
for d in "${working_dir}"/*/ ;do
	proj=$(basename "${d}")
	eaf="$proj/$proj.eaf" 
	eaf_abs="${working_dir}/$eaf"
	echo "... extracting transcription from --- $eaf --- ..."	
	if [[ -f "${eaf_abs}" ]]; then
		transcription=$( awk -F'[<>]' '/<ANNOTATION_VALUE>/{print $3;}' "${eaf_abs}")
        echo $transcription
		echo "... ... to --- $proj/$proj.txt --- ..."		
		touch "${working_dir}/$proj/$proj.txt"
		echo $transcription > "${working_dir}/$proj/$proj.txt"
	fi	
done
echo "~~~~"
echo "DONE"
echo "~~~~"
}
one_dir () {
    echo -e ""
	echo -e "\e[91mPlease \e[5menter \e[25mthe directory you want to operate on."
	echo -e ".\e[0m"	
	read working_dir
	EXTRACT_TXT
}
two_dir () {
    echo -e ""
	echo -e "\e[91mPlease \e[5menter \e[25ma .txt file listing the directories you want to operate on."
	echo -e "\e[0m"
	read file_list
	while read line; do
		working_dir="${line}"
		EXTRACT_TXT	
	done < "${file_list}"
}
help_msg(){
	echo -e "\e[33mThis is a script to pull transcription from an .eaf file and add it to"
	echo -e "a .txt file. The assumption is that there's only one annotation to pull from."
	echo -e "The script assumes elan projects in a nested structure and pulls transcription"
	echo -e "from nested projects in the root directory or directories passed to the script."
	echo -e ""
	echo -e "If you choose to operate on one directory (Option 1), you must enter an"
	echo -e "path to that directory. Sommething like:\e[0m"
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
    echo -e "\e[31m |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo -e " | --- Welcome to eaf extract txt! --- |"
    echo -e " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
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
    echo "    |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo "    | --- Welcome to eaf extract txt! --- |"
    echo "    |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo ""
    echo "Generate .eaf files from nested .wav and .txt files."
    echo ""
    echo "Usage: ./eaf_extract_txt.sh -h | -i"
    echo "Usage: ./eaf_extract_txt.sh target-directory"
    echo "Usage: ./eaf_extract_txt.sh -l target-directories.txt"
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
        EXTRACT_TXT
    done < "${file_list}"
elif [ "${1}" ];then
    working_dir="${1}"
    EXTRACT_TXT
else
    echo ""
    echo "~~~ You must supply arguments. ~~~"
    echo ""
    usage
fi



