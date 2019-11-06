#!/bin/bash

# This script iterates through subdirectories, where it is assumed ELAN
# projects (one or more media files, .eaf adn .pfsx files) are stored.
# The script assumes there is one annotation on one tier, and extracts
# the annotation value, then adds it to a .txt file.

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Enter the directory you want to 'folderize' and 'elanize'."
echo "Hint: use absolute paths"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "Directory:" && read working_dir
echo ""
for d in $working_dir/*/ ;do
	proj=$(basename $d)
	eaf="$proj/$proj.eaf" 
	eaf_abs="$working_dir/$eaf"
	echo "... extracting transcription from --- $eaf --- ..."	
	if [[ -f $eaf_abs ]]; then
		transcription=$( awk -F'[<>]' '/<ANNOTATION_VALUE>/{print $3;}' $eaf_abs)
		echo "... ... adding transctiption to --- $proj/$proj.txt --- ..."		
		touch "$working_dir/$proj/$proj.txt"
		echo $transcription > "$working_dir/$proj/$proj.txt"
	fi	
done
echo "~~~~"
echo "DONE"
echo "~~~~"
