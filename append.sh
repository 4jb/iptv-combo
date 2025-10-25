#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_m3u_file> <text_to_append>"
    exit 1
fi

# Assign arguments to variables
INPUT_FILE=$1
APPEND_TEXT=$2
ORIGINAL_FILE="${INPUT_FILE%.m3u}_unmodified.m3u"
OUTPUT_FILE=$INPUT_FILE

# Prepare original
echo "Copying original file to $ORIGINAL_FILE"
cp $INPUT_FILE "${INPUT_FILE%.m3u}_unmodified.m3u.bak"

# Use sed to find lines with '#EXTINF' and append the text
sed -i -E "s/(,#EXTM3U|,-?[^,]*$)/\1${APPEND_TEXT}/" "$INPUT_FILE" 

#"s/^\(#EXTINF.*,\)\(.*\)/\1${APPEND_TEXT} \2/" "$ORIGINAL_FILE" > "$OUTPUT_FILE"

echo "Successfully appended '${APPEND_TEXT}' to channel names."
echo "New playlist saved to: $OUTPUT_FILE"
