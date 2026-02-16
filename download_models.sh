#!/bin/bash

# --- Configuration ---
PREFIX_DIR="${DOWNLOAD_PREFIX:-./downloads}"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE=$1
mkdir -p "$PREFIX_DIR"

# Read the file line by line
# Added a third variable: CUSTOM_NAME
while read -r DIR_NAME URL CUSTOM_NAME || [[ -n "$DIR_NAME" ]]; do
    
    # Skip lines starting with # or empty lines
    [[ "$DIR_NAME" =~ ^# || -z "$DIR_NAME" ]] && continue

    TARGET_PATH="$PREFIX_DIR/$DIR_NAME"
    
    # Determine the filename: Use CUSTOM_NAME if provided, else use basename of URL
    if [[ -n "$CUSTOM_NAME" ]]; then
        FILE_NAME="$CUSTOM_NAME"
    else
        FILE_NAME=$(basename "$URL")
    fi

    FULL_FILE_PATH="$TARGET_PATH/$FILE_NAME"

    # Create the directory if it doesn't exist
    mkdir -p "$TARGET_PATH"

    echo "Checking for existing: $FULL_FILE_PATH"

    # Check if file exists
    if [[ -f "$FULL_FILE_PATH" ]]; then
        echo "Skipping: $FILE_NAME (Already exists)"
        echo "----------------------------"
        continue
    fi

    echo "Starting download: $FILE_NAME -> $TARGET_PATH/"

    # Execute download
    # Using -o instead of -O because -o allows us to specify the exact output name
    if curl -L "$URL" -o "$FULL_FILE_PATH"; then
        echo "Finished: $FILE_NAME"
    else
        echo "Error: Failed to download $URL"
    fi

    echo "----------------------------"

done < "$INPUT_FILE"

echo "All tasks complete."
