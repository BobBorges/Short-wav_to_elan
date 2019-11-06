#!/bin/bash

# This script will check the given directory for a .wav file, then it will
# create an elan file associated with the .wav in the same directory.
# The .eaf file will have one tier and an anotation that occupies the entire
# durration of the .wav file. If there is a .txt file in the directory with
# the same name as the .wav file, the script will assume it is transcription
# and add the contents of the .txt to the annotation.
#
# DEPENDENCIES: soxi, tidy
#
ELANIZE () {
for file in $working_dir/*.wav
do
	if [[ -f $file ]]; then
		file_bare=${file%.wav}
		file_name=${file_bare##*/}
		sec_dur=$(soxi -D $file)					# this gets the durration of the audio file in seconds
		ms_dur_f=$(echo "${sec_dur}*1000"|bc)				# converts seconds to ms
		ms_dur=${ms_dur_f%.*}						# and removes the decimal and post decimal val
		if [[ -f "$working_dir/$file_name.txt" ]]; then			# checks if there's a .txt file by the same name as the .wav
			transcription=$( cat "$working_dir/$file_name.txt")	# assigns contents of .txt to a var
		fi
		# this is a non-pretty version of an empty elan file, filling in vars from the .wav and .txt
		elan="<?xml version=\"1.0\" encoding=\"UTF-8\"?><ANNOTATION_DOCUMENT AUTHOR=\"\" DATE=\"2019-11-05T14:16:24+01:00\" FORMAT=\"3.0\" VERSION=\"3.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://www.mpi.nl/tools/elan/EAFv3.0.xsd\"><HEADER MEDIA_FILE=\"\" TIME_UNITS=\"milliseconds\"><MEDIA_DESCRIPTOR MEDIA_URL=\"file://$file\" MIME_TYPE=\"audio/x-wav\" RELATIVE_MEDIA_URL=\"./$file_name.wav\"/><PROPERTY NAME=\"URN\">urn:nl-mpi-tools-elan-eaf:2bb01589-bf3d-4141-871d-8f31be10fd9b</PROPERTY><PROPERTY NAME=\"lastUsedAnnotationId\">1</PROPERTY></HEADER><TIME_ORDER><TIME_SLOT TIME_SLOT_ID=\"ts1\" TIME_VALUE=\"1\"/><TIME_SLOT TIME_SLOT_ID=\"ts2\" TIME_VALUE=\"$ms_dur\"/></TIME_ORDER><TIER LINGUISTIC_TYPE_REF=\"default-lt\" TIER_ID=\"transcription\"><ANNOTATION><ALIGNABLE_ANNOTATION ANNOTATION_ID=\"a1\" TIME_SLOT_REF1=\"ts1\" TIME_SLOT_REF2=\"ts2\"><ANNOTATION_VALUE>$transcription</ANNOTATION_VALUE></ALIGNABLE_ANNOTATION></ANNOTATION></TIER><LINGUISTIC_TYPE GRAPHIC_REFERENCES=\"false\" LINGUISTIC_TYPE_ID=\"default-lt\" TIME_ALIGNABLE=\"true\"/><CONSTRAINT DESCRIPTION=\"Time subdivision of parent annotation's time interval, no time gaps allowed within this interval\" STEREOTYPE=\"Time_Subdivision\"/><CONSTRAINT DESCRIPTION=\"Symbolic subdivision of a parent annotation. Annotations refering to the same parent are ordered\" STEREOTYPE=\"Symbolic_Subdivision\"/><CONSTRAINT DESCRIPTION=\"1-1 association with a parent annotation\" STEREOTYPE=\"Symbolic_Association\"/><CONSTRAINT DESCRIPTION=\"Time alignable annotations within the parent annotation's time interval, gaps are allowed\" STEREOTYPE=\"Included_In\"/></ANNOTATION_DOCUMENT>" 	
		echo "...creating --- $file_name.eaf --- ..."
		touch "$working_dir/$file_name.eaf"
		# this puts the pretty-print version of the $elan to an .eaf file with the same name as the .wav
		echo "$elan" | tidy -xml -iq - >> "$working_dir/$file_name.eaf" 
	fi
done
echo -e "\e[31m~~~~"
echo -e "DONE"
echo -e "~~~~\e[0m"
}
one_dir () {
	echo "Please enter the directory you want to operate on."
	echo "HINT: Use an absolute path."	
	read working_dir
	ELANIZE
}
two_dir () {
	echo "Please enter a .txt file listing the directories you want to operate on."
	echo "HINT: Use absoute paths to the file AND in the file."
	read file_list
	while read line; do
		working_dir=$line
		ELANIZE	
	done < $file_list
}
help_msg () {
	echo -e "\e[33mThis is a script to create an elan project from a .wav file."
	echo -e "The .eaf file will have one tier and an anotation that occupies the entire"
	echo -e "durration of the .wav file. If there is a .txt file in the directory with"
	echo -e "the same name as the .wav file, the script will assume it is transcription"
	echo -e "and add the contents of the .txt to the annotation."
	echo -e ""
	echo -e "Required DEPENDENCIES: soxi, tidy"
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
echo -e " | --- Welcome to elanize! --- |"
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

