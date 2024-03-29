#!/bin/bash

# This is a script to put files .wav files within a directory into individual 
# subdirectories that are also named the same way as the files. If there is a
# .txt file with the same name as the .wav file, it will also be moved to the
# new subdirectory.
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
FOLDERIZE () {
    for file in "${working_dir}"/*.wav
    do
        if [[ -f "${file}" ]]; then
            echo "...putting the file --- "${file}" --- into its folder..."
	        file_bare=${file%.wav}
	        file_name=${file_bare##*/}
	        mkdir "${working_dir}"/$file_name
            sub_dir="${working_dir}/$file_name"
            mv "${file}" "${sub_dir}"
            if [[ -f "$file_bare.txt" ]]; then
                mv "$file_bare.txt" "${sub_dir}"
            fi
        fi
    done
    echo "~~~~"
    echo "DONE"
    echo "~~~~"
}
one_dir () {
    echo -e ""
	echo -e "\e[91mPlease \e[5menter \e[25mthe directory you want to operate on."
	echo -e "\e[0m"	
	read working_dir
	FOLDERIZE
}
two_dir () {
    echo -e ""
	echo -e "\e[91mPlease \e[5menter \e[25ma .txt file listing the directories you want to operate on."
	echo -e "\e[0m"
	read file_list
	while read line; do
		working_dir="${line}"
		FOLDERIZE	
	done < "${file_list}"
}
help_msg () {
    echo -e "\e[33mThis is a script to put files .wav files within a directory into individual"
    echo -e "subdirectories that are also named the same way as the files. If there is a"
    echo -e ".txt file with the same name as the .wav file, it will also be moved to the"
        echo -e "new subdirectory."
	echo -e ""
	echo -e "If tou choose to operate on one directory (Option 1), you must enter a path"
	echo -e "to that directory. Relative paths are relative to the location where the script was"
    echo -e "initiatied. If that sounds complicated, use an absolute path Sommething like:\e[0m"
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

interactive(){
    echo -e "\e[31m |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo -e " | --- Welcome to folderize! --- |"
    echo -e " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
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
    echo " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo " | --- Welcome to folderize! --- |"
    echo " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo ""
    echo "Nest .wav and .txt files in subdirectories."
    echo ""
    echo "Usage: ./folderize_wav_files.sh -h | -i"
    echo "Usage: ./folderize_wav_files.sh target-directory"
    echo "Usage: ./folderize_wav_files.sh -l target-directories.txt"
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
        working_dir=$line
        FOLDERIZE
    done < "${file_list}"
elif [ "${1}" ];then
    working_dir="${1}"
    FOLDERIZE
else
    echo ""
    echo "~~~ You must supply arguments. ~~~"
    echo ""
    usage
fi

