#!/bin/bash

# This is a script to put files .wav files within a directory into individual 
# subdirectories that are also named the same way as the files. If there is a
# .txt file with the same name as the .wav file, it will also be moved to the
# new subdirectory.

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Enter the directory you want to 'folderize'. Hint: use absolute paths"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "Directory:" && read working_dir
echo ""
echo "The following files will be put into sub directories:"
ls $working_dir/*.wav
sleep 1
echo "If there's a .txt file with the same name as a .wav, it will be put in the new sub directory too."
sleep 3
for file in $working_dir/*.wav
do
    if [[ -f $file ]]; then
    echo "...putting the file --- $file --- into its folder..."
	file_bare=${file%.wav}
	file_name=${file_bare##*/}
	mkdir $working_dir/$file_name
    sub_dir=$working_dir/$file_name
    mv $file $sub_dir
        if [[ -f "$file_bare.txt" ]]; then
            mv "$file_bare.txt" $sub_dir
        fi
    fi
done
echo "~~~~"
echo "DONE"
echo "~~~~"
