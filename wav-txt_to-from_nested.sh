#!/bin/bash
#
# This script will nest or de nest .wav and .txt files from Elan directories 
# It is assumed that Elan projects are stored according to the following
# directory structure:
#
#        * parent directory
#            * project_1
#                • project_1.eaf
#                * project_1.pfsx
#                * project_1.txt
#                * project_1.wav
#            * project_2
#                • project_2.eaf
#                * project_2.pfsx
#                * project_2.txt
#                * project_2.wav
#            * project_3
#                • project_3.eaf
#                * project_3.pfsx
#                * project_3.txt
#                * project_3.wav
#
# The script will (a) extract the .wav and .txt files from typically nested
# Elan project directory structure to respective un-nested directories, e.g.:
#
#        * wav_file_dir
#            * project_1.wav
#            * project_2.wav
#            * project_3.wav
#
# and
#
#        * txt_file_dir
#            * project_1.txt
#            * project_2.txt
#            * project_3.txt
#
# ... or (b) move .wav and .txt files from un-nested structure to typically
# nested Elan project structure. The (b) option assumes that the typical Elan
# directory structure already exists and allows the user to define what happens to
# files that cannot be palced.
#
# If tou choose to operate on one directory (Option 1), you must enter an
# absolute path to that directory. Sommething like:
#
#    /home/user/target_directory
#
# If you choose to operate on multiple directories, you must provide
# a .txt file as input. An absolute path should be entered to that file, and
# its contents should be a line by line list of directories to be operated
# on by the script, also in the form of absolute paths.
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
get_1dir_txt_dest(){
	echo ""
	echo -e "\e[91mPlease \e[5menter \e[25mthe destination for your text files."
	echo -e "\e[34mHINT: Use an absolute path.\e[0m"	
	read onedir_txt_dest
}

get_1dir_wav_dest(){
	echo ""
	echo -e "\e[91mPlease \e[5menter \e[25mthe destination for your wav files."
	echo -e "\e[34mHINT: Use an absolute path.\e[0m"	
	read onedir_wav_dest
}

get_one_nest_src_dir(){
	echo ""
	echo -e "\e[91mPlease \e[5menter \e[25mthe directory you want to operate on."
	echo -e "\e[34mHINT: Use an absolute path.\e[0m"
	read working_src_dir
}

get_multi_nest_src_dir(){
	echo ""
	echo -e "\e[91mPlease \e[5menter \e[25ma .txt file listing the directories you want to operate on."
	echo -e "\e[34mHINT: Use absoute paths to the file AND in the file.\e[0m"
	read working_src_dir_list
}

get_txt_src_dir(){
	echo ""
	echo -e "\e[91mPlease \e[5menter \e[25mthe directory you want to move .txt files from."
	echo -e "\e[34mHINT: Use an absolute path.\e[0m"
	read onedir_txt_src
}

get_wav_src_dir(){
	echo ""
	echo -e "\e[91mPlease \e[5menter \e[25mthe directory you want to move .wav files from."
	echo -e "\e[34mHINT: Use an absolute path.\e[0m"
	read onedir_wav_src
}

get_one_nest_dest_dir(){
	echo ""
	echo -e "\e[91mPlease \e[5menter \e[25ma parent directory, where .wav and .txt files will be nested."
	echo -e "\e[34mHINT: Use an absolute path.\e[0m"
	read parent_dest_dir
}

get_multi_nest_dest_dir(){
	echo ""
	echo -e "\e[91mPlease \e[5menter \e[25ma .txt file listing parent directories, where .wav and .txt files will be nested."
	echo -e "\e[34mHINT: Use absoute paths to the file AND in the file.\e[0m"
	read parent_dest_dir_list
}

get_stray_files_dest_dir(){
	echo ""
	echo -e "\e[91mWhere to you want to move stray files? \e[5mEnter\e[25m destination directory."
	echo -e "\e[34mHINT 1: Use an absolute path."
	echo -e "\e[94mHINT 2: Stray files are files with names that don't match an existing nested directory."
	echo -e "\e[34mHINT 3: Just press enter to leave stray files where they are.\e[0m"
	read stray_files_dest	
}

nested_src_one_or_more(){
	echo -e ""
	echo -e "\e[31mDo you want to move files from one nested directory or multiple nested directories?\e[33m"
	echo -e ""
	export PS3=$'\e[91mPlease \e[5menter \e[25myour choice:\e[0m '
	options=("Move from ONE nested directory" "Move from MULTIPLE nested directories" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Move from ONE nested directory")
				echo ""
				echo "You chose to move files from ONE nested directory."
				get_one_nest_src_dir
				break
				;;
			"Move from MULTIPLE nested directories")
				echo ""
				echo "You chose to move from MULTIPLE nested directories"
				get_multi_nest_src_dir				
				break
				;;
			"Quit")
				break
				;;
		esac
	done		
}

nested_dest_one_or_more(){
	echo -e ""
	echo -e "\e[31mDo you want to move files to be nested in one parent directory or multiple parent directories?"
	echo -e "\e[34mHINT: Destination parent-child directory structure should already exist,"
	echo -e "      otherwise your source files will be considered 'stray'."
	echo -e "      You will get to decide what to do with stray files.\e[33m"
	echo -e ""
	export PS3=$'\e[91mPlease \e[5menter \e[25myour choice:\e[0m '
	options=("Send files to be nested in ONE parent directory" "Send files to be nested in MULTIPLE parent directories" "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
			"Send files to be nested in ONE parent directory")
				echo ""
				echo "You chose to send files to be nested in ONE parent directory."
				get_one_nest_dest_dir
				break
				;;
			"Send files to be nested in MULTIPLE parent directories")
				echo ""
				echo "You chose to send files to be nested in MULTIPLE parent directories"
				get_multi_nest_dest_dir				
				break
				;;
			"Quit")
				break
				;;
		esac
	done		

}

mv_from_nested(){
	shopt -s nullglob
	for d in $1/*/ ;do				#input parameter $1 will be src
		dir_name=$(basename $d)
		wav="$dir_name/$dir_name.wav"
		txt="$dir_name/$dir_name.txt"
		echo "--- moving $wav to $onedir_wav_dest ---"
		mv "$d/$dir_name.wav" $onedir_wav_dest
		echo "--- moving $txt to $onedir_txt_dest ---"
		mv "$d/$dir_name.txt" $onedir_txt_dest
	done
}	

mv_from_1dir(){
	shopt -s nullglob
	for d in $1/*/ ; do				#input parameter $1 will be dest
		dir_name=$(basename $d)
		if [ -f $onedir_wav_src/$dir_name.wav ]; then
			echo "~~~ Moving $onedir_wav_src/$dir_name.wav to  $d. ~~~"
			mv $onedir_wav_src/$dir_name.wav $d
		else
			echo -e "\e[91m~~~ There is no corresponding .wav file found for the $d directory. ~~~"
		fi
		if [ -f $onedir_wav_src/$dir_name.txt ]; then
			echo "~~~ Moving $onedir_wav_src/$dir_name.txt to $d. ~~~"
			mv $onedir_wav_src/$dir_name.txt $d
		else
			echo -e "\e[91m~~~ There is no corresponding .txt file found for the $d directory. ~~~"
		fi
	done
}

address_stray_files(){
	if [ -z ${stray_files_dest} ]; then
		shopt -s nullglob
		for wav in $onedir_wav_src/*.wav; do
			echo -e "\e[33m~~~ $wav was left in the source directory because no destination folder was found. ~~~"
		done 
		for txt in $onedir_txt_src/*.txt; do
			echo -e "\e[33m~~~ $txt was left in the source directory because no destination folder was found. ~~~"
		done 		
	else
		shopt -s nullglob
		for wav in $onedir_wav_src/*.wav; do
			echo "~~~ Moving $wav to the stray files directory, $stray_files_dest. ~~~"
			mv $wav $stray_files_dest
		done
		for txt in $onedir_txt_src/*.txt; do
			echo "~~~ Moving $txt to the stray files directory, $stray_files_dest. ~~~"
			mv $txt $stray_files_dest
		done

	fi
}

mv_to_1dir(){
	nested_src_one_or_more
	get_1dir_wav_dest
	get_1dir_txt_dest
	if [ -z ${working_src_dir} ]; then
		while read line; do
			mv_from_nested $line 
		done < $working_src_dir_list
	else
		mv_from_nested $working_src_dir
	fi
}

mv_to_nested(){
	nested_dest_one_or_more
	get_wav_src_dir
	get_txt_src_dir
	get_stray_files_dest_dir
	if [ -z ${parent_dest_dir} ]; then
		while read line; do
			mv_from_1dir $line
		done < $parent_dest_dir_list
	else
		mv_from_1dir $parent_dest_dir
	fi
	address_stray_files
}

help_msg(){
	echo -e "\e[33mIt is assumed that Elan projects are stored according to the following" 
	echo -e "directory structure:"
	echo -e ""
	echo -e "        parent directory/"
	echo -e "            project_1/"
	echo -e "                project_1.eaf"
	echo -e "                project_1.pfsx"
	echo -e "                project_1.txt"
	echo -e "                project_1.wav"
	echo -e "            project_2/"
	echo -e "                project_2.eaf"
	echo -e "                project_2.pfsx"
	echo -e "                project_2.txt"
	echo -e "                project_2.wav"
	echo -e "            project_3/"
	echo -e "                project_3.eaf"
	echo -e "                project_3.pfsx"
	echo -e "                project_3.txt"
	echo -e "                project_3.wav"
	echo -e ""
	echo -e "The script will (a) extract the .wav and .txt files from typically nested"
	echo -e "Elan project directory structure to respective un-nested directories, e.g.:"
	echo -e ""
	echo -e "        wav_file_dir/"
	echo -e "            project_1.wav"
	echo -e "            project_2.wav"
	echo -e "            project_3.wav"
	echo -e ""
	echo -e "and"
	echo -e ""
	echo -e "        txt_file_dir/"
	echo -e "            project_1.txt"
	echo -e "            project_2.txt"
	echo -e "            project_3.txt"
	echo -e ""
	echo -e "... or (b) move .wav and .txt files from un-nested structure to typically"
	echo -e "nested Elan project structure. The (b) option assumes that the typical Elan"
	echo -e "directory structure already exists and allows the user to define what happens to"
	echo -e "files that cannot be palced."
	echo -e ""
	echo -e "If tou choose to operate on one directory (Option 1), you must enter an"
	echo -e "absolute path to that directory. Sommething like:\e[0m"
	echo -e ""
	echo -e "    /home/user/target_directory"
	echo -e ""
	echo -e "\e[33mIf you choose to operate on multiple directories, you must provide"
	echo -e "a .txt file as input. An absolute path should be entered to that file, and"
	echo -e "its contents should be a line by line list of directories to be operated"
	echo -e "on by the script, also in the form of absolute paths."
	echo -e ""
	echo -e "OK?"
	echo -e 
	sleep 1
	echo -e "\e[31mNow repeating the options:"
	echo -e "\e[33m"
	PS3=""
	sleep 1
	echo "x" | select opt in "${options[@]}"; do break;done;  # $REPLY";;
	export PS3=$'\e[91mPlease \e[5menter \e[25myour choice:\e[0m '
}

interactive(){
    echo -e "\e[31m |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo -e " | --- Welcome to move wav & txt to or from nested directories! --- |"
    echo -e " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    sleep 1
    echo ""
    echo -e "Do you want to move wav and txt files to or from a nested directory structure?"
    echo -e "\e[34mHINT: You will be able to choose individual source / destination directories"
    echo -e "      for non-nested txt and wav files.\e[33m"
    echo ""
    sleep 1
    COLUMNS=12
    export PS3=$'\e[91mPlease \e[5menter \e[25myour choice:\e[0m '
    options=("Move files from a nested directory structure to a non-nested directory structure" "Move files from a non-nested directory structure to a nested directory structure" "Get help" "Quit")
    select opt in "${options[@]}"
    do
	    case $opt in
		    "Move files from a nested directory structure to a non-nested directory structure")
			    echo ""
			    echo "You chose to move files to a single directory."
			    mv_to_1dir
			    break		
			    ;;
		    "Move files from a non-nested directory structure to a nested directory structure")
			    echo ""
			    echo "You chose to move files to a nested directory structure."
			    mv_to_nested
			    break
			    ;;
		    "Get help")
			    echo ""
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
    echo " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo " | --- Welcome to move wav & txt to or from nested directories! --- |"
    echo " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo ""
    echo "Nest or de-nest .wav and .txt files"
    echo ""
    echo "Usage: ./wav-txt_to-from_nested.sh -h | -i"
    echo "Usage: ./wav-txt_to-from_nested.sh -n nested-destination wav-source txt-source [stray-files-destination]"
    echo "Usage: ./wav-txt_to-from_nested.sh -n -l nested-destination-list.txt wav-source txt-source [stray-files-destination]"
    echo "Usage: ./wav-txt_to-from_nested.sh -d nested-source wav-destination txt-destination"
    echo "Usage: ./wav-txt_to-from_nested.sh -d -l nested-source-list.txt wav-destination txt-destination"
    echo ""
    echo "Options"
    echo "  -h | --help             display this message and exit"
    echo "  -i | --interactive      start program in interactive mode"
    echo "  -n | --nest             nest"
    echo "  -d | --de-nest          de-nest"
    echo "  -l | --list             pass nested directories from .txt file"
    echo ""
    echo "HINT: use absolute paths."
}

operation=
other_args=()
onedir_txt_src=
onedir_wav_src=
parent_dest_dir=
parent_dest_dir_list=
stray_files_dest=
working_src_dir=
working_src_dir_list=
onedir_txt_dest=
onedir_wav_dest=

for arg in "$@"; do
    case $arg in
        -h|--help)
            usage
            exit
            ;;
        -i|--interactive)
            interactive
            exit
            ;;
        -d|--de-nest)
            operation="denest"
            shift
            ;;
        -n|--nest)
            operation="nest"
            shift
            ;;
        -l|--list)
            if [ $operation == "nest" ] && [[ -f $2 ]];then
                parent_dest_dir_list=$2
            elif [ $operation == "denest" ] && [[ -f $2 ]];then
                working_src_dir_list=$2 
            else
                echo "-l takes a file argument. Please try again"
            fi
            shift
            shift
            ;;
        *)
            other_args+=("$1")
            shift
            ;;
    esac
done

if (( ${#other_args[@]} >= 2 )) ;then
    if [ "$operation" ]; then
        echo "$operation"
        if [ $operation == "nest" ]; then
            if [ "$parent_dest_dir_list" ]; then
                onedir_wav_src=${other_args[0]}
                onedir_txt_src=${other_args[1]}
                if [ "${other_args[2]}" ]; then
                    stray_files_dest=${other_args[2]}
                fi
                while read line; do
                    mv_from_1dir $line
                done < $parent_dest_dir_list
                address_stray_files
            else
                parent_dest_dir=${other_args[0]}
                onedir_wav_src=${other_args[1]}
                onedir_txt_src=${other_args[2]}
                if [ "${other_args[3]}" ]; then
                    stray_files_dest=${other_args[3]}
                fi
                mv_from_1dir $parent_dest_dir
                address_stray_files
            fi
        else # de-nest
            if [ "$working_src_dir_list" ]; then
                onedir_wav_dest=${other_args[0]}
                onedir_txt_dest=${other_args[1]}
                while read line; do
                    mv_from_nested $line
                done < $working_src_dir_list
            else        
                working_src_dir=${other_args[0]}
                onedir_wav_dest=${other_args[1]}
                onedir_txt_dest=${other_args[2]}
                mv_from_nested $working_src_dir
            fi
        fi
    else
        echo ""
        echo "You need to decide what operation: -d | -n. Please try again."
        echo ""
        usage
    fi
else
    echo ""
    echo " You haven't supplied a suitable number of arguments. Please try again."
    echo ""
    usage
fi
