#!/bin/bash
#echo "Enter source file"
#read source_file
#echo "Enter destination directory"
#dest_dirs=ls dest_dir/*/
#echo dest_dir

POPULATE_TXT(){
	dest_files=$(ls -I transcriptions.txt "${dest_dir}" | grep .txt)
 	dest_files_arr=($dest_files)
 	line_idx=0
	while read line; do
		echo "${line}" > "${dest_dir}"/"${dest_files_arr[$line_idx]}"
		(( line_idx++ )) 
	done < "${source_file}"
echo "~~~~"
echo "DONE"
echo "~~~~"
}
one_dir(){
    echo -e ""
	echo -e "\e[91mPlease \e[5menter \e[25mthe directory you want to operate on."
	echo -e "\e[34mHINT: Use an absolute path.\e[0m"	
	read dest_dir
	echo -e "\e[91mPlease \e[5menter \e[25ma source file with transcriptions."
	echo -e "\e[0m"
	read source_file	
	POPULATE_TXT
}
two_dir(){
echo -e ""
	echo -e "\e[91mPlease \e[5menter \e[25ma .txt file listing the directories you want to operate on."
	echo -e "\e[34mHINT: Use absoute paths to the file AND in the file.\e[0m"
	read file_list
	echo -e "\e[91mPlease \e[5menter \e[25ma source file with transcriptions."
	echo -e "\e[0m"
	read source_file	
	while read line; do
		dest_dir=$line
		POPULATE_TXT	
	done < $file_list
}
help_msg(){
	echo -e "\e[33mThis is a script to read lines in a text file (transcriptions.txt) and write"
	echo -e "the line to to a separate txt file in a specified directory. There is no"
	echo -e "specific checking of the file names in the destination directory or the"
	echo -e "lines of text in the transcriptions file. The script operates entirely on"
	echo -e "the assumption that the order of lines in the transcritions file is exactly"
	echo -e "the same as the files in the destination directory."
	echo -e ""
	echo -e "You must enter a path to the destination directory AND to thetranscriptions.txt file."
	echo -e "The path should be relative to the location where the script was initiated, or an"
    echo -e " absolute path Such as:\e[0m"
	echo -e ""
	echo -e "    /home/user/destination_dir"
	echo -e "    /home/user/destination_dir/transcriptions.txt"
	echo -e ""
	echo -e "\e[33mThe transcriptions file need not be in the destination directory, but if it"
	echo -e "is, it MUST be named transcriptions.txt."
	echo -e ""
	echo -e "Got it?"
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
    echo -e "\e[31m |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo -e " | --- Welcome to populate txts! --- |"
    echo -e " |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    sleep 1
    echo ""
    echo -e "You can only populate txts in a single directory\e[33m"
    echo ""
    sleep 1

    COLUMNS=12
    export PS3=$'\e[91mPlease \e[5menter \e[25myour choice:\e[0m '
    options=("Work on a single directory" "Get help" "Quit")
    select opt in "${options[@]}"
    do
	    case $opt in
		    "Work on a single directory")
			    echo "You chose to work on ONE directory."
			    one_dir
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
    echo "    |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo "    | --- Welcome to populate txts! --- |"
    echo "    |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|"
    echo ""
    echo "Populate text files in a directory from a transcription file."
    echo ""
    echo "Usage: ./populate_txt.sh -h | -i"
    echo "Usage: ./populate_txt.sh target-directory transcription-file.txt"
    echo ""
    echo "Options"
    echo "  -h | --help             display this message and exit"
    echo "  -i | --interactive      start program in interactive mode"
}

dest_dir=
source_file=

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
        *)
            break
    esac
    shift
done

if [[ -f "${2}" ]]; then
	dest_dir="${1}"
	source_file="${2}"
	POPULATE_TXT
else
    echo ""
    echo "~~~ You must supply arguments. ~~~"
    echo ""
    usage
fi



