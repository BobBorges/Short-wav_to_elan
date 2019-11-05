#!/bin/bash
#
# This is a script to put files .wav files within a directory into individual 
# subdirectories that are also named the same way as the files. If there is a
# .txt file with the same name as the .wav file, it will also be moved to the
# new subdirectory.
#
# Once the new subdirectory is created and files added, the script will
# create an elan file with associated with the .wav in its subdirectory.
# The .eaf file will have one tier and an anotation that occupies the entire
# durration of the .wav file. If there is a .txt file in the directory with
# the same name as the .wav file, the script will assume it is transcription
# and add the contents of the .txt to the annotation.
#
# DEPENDENCIES: soxi, tidy
#
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
    echo "... putting the file --- $file --- into its folder ..."
	file_bare=${file%.wav}
	file_name=${file_bare##*/}
	mkdir $working_dir/$file_name
    sub_dir=$working_dir/$file_name
    mv $file $sub_dir
        if [[ -f "$file_bare.txt" ]]; then
            echo "... and putting --- $file_bare.txt --- in too ..."
            mv "$file_bare.txt" $sub_dir
        fi
    for file in $sub_dir/*.wav
    do
        if [[ -f $file ]]; then
            file_bare=${file%.wav}
            file_name=${file_bare##*/}
            sec_dur=$(soxi -D $file)					        # this gets the durration of the audio file in seconds
            ms_dur_f=$(echo "${sec_dur}*1000"|bc)				# converts seconds to ms
            ms_dur=${ms_dur_f%.*}						        # and removes the decimal and post decimal val
            if [[ -f "$sub_dir/$file_name.txt" ]]; then			# checks if there's a .txt file by the same name as the .wav
                transcription=$( cat "$sub_dir/$file_name.txt")	# assigns contents of .txt to a var
            fi
            # this is a non-pretty version of an empty elan file, filling in vars from the .wav and .txt
            elan="<?xml version=\"1.0\" encoding=\"UTF-8\"?><ANNOTATION_DOCUMENT AUTHOR=\"\" DATE=\"2019-11-05T14:16:24+01:00\" FORMAT=\"3.0\" VERSION=\"3.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://www.mpi.nl/tools/elan/EAFv3.0.xsd\"><HEADER MEDIA_FILE=\"\" TIME_UNITS=\"milliseconds\"><MEDIA_DESCRIPTOR MEDIA_URL=\"file://$file\" MIME_TYPE=\"audio/x-wav\" RELATIVE_MEDIA_URL=\"./$file_name.wav\"/><PROPERTY NAME=\"URN\">urn:nl-mpi-tools-elan-eaf:2bb01589-bf3d-4141-871d-8f31be10fd9b</PROPERTY><PROPERTY NAME=\"lastUsedAnnotationId\">1</PROPERTY></HEADER><TIME_ORDER><TIME_SLOT TIME_SLOT_ID=\"ts1\" TIME_VALUE=\"1\"/><TIME_SLOT TIME_SLOT_ID=\"ts2\" TIME_VALUE=\"$ms_dur\"/></TIME_ORDER><TIER LINGUISTIC_TYPE_REF=\"default-lt\" TIER_ID=\"transcription\"><ANNOTATION><ALIGNABLE_ANNOTATION ANNOTATION_ID=\"a1\" TIME_SLOT_REF1=\"ts1\" TIME_SLOT_REF2=\"ts2\"><ANNOTATION_VALUE>$transcription</ANNOTATION_VALUE></ALIGNABLE_ANNOTATION></ANNOTATION></TIER><LINGUISTIC_TYPE GRAPHIC_REFERENCES=\"false\" LINGUISTIC_TYPE_ID=\"default-lt\" TIME_ALIGNABLE=\"true\"/><CONSTRAINT DESCRIPTION=\"Time subdivision of parent annotation's time interval, no time gaps allowed within this interval\" STEREOTYPE=\"Time_Subdivision\"/><CONSTRAINT DESCRIPTION=\"Symbolic subdivision of a parent annotation. Annotations refering to the same parent are ordered\" STEREOTYPE=\"Symbolic_Subdivision\"/><CONSTRAINT DESCRIPTION=\"1-1 association with a parent annotation\" STEREOTYPE=\"Symbolic_Association\"/><CONSTRAINT DESCRIPTION=\"Time alignable annotations within the parent annotation's time interval, gaps are allowed\" STEREOTYPE=\"Included_In\"/></ANNOTATION_DOCUMENT>" 	
            echo "... ...creating --- $file_name.eaf --- ..."
            touch "$sub_dir/$file_name.eaf"
            # this puts the pretty-print version of the $elan to an .eaf file with the same name as the .wav
            echo "$elan" | tidy -xml -iq - >> "$sub_dir/$file_name.eaf" 
        fi
    done
    fi
done
echo "~~~~"
echo "DONE"
echo "~~~~"
