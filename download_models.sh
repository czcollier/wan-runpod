#!/bin/bash

# --- Configuration ---
PREFIX_DIR="${DOWNLOAD_PREFIX:-/workspace/ComfyUI/models}"
# Ensure environment variables are accessible
C_TOKEN="$CIVITAI_TOKEN"
H_TOKEN="$HF_TOKEN"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE=$1
mkdir -p "$PREFIX_DIR"

while read -r DIR_NAME URL CUSTOM_NAME || [[ -n "$DIR_NAME" ]]; do

    [[ "$DIR_NAME" =~ ^# || -z "$DIR_NAME" ]] && continue

    TARGET_PATH="$PREFIX_DIR/$DIR_NAME"

    if [[ -n "$CUSTOM_NAME" ]]; then
        FILE_NAME="$CUSTOM_NAME"
    else
        FILE_NAME=$(basename "${URL%%\?*}") # Strip query params for clean filename
    fi

    FULL_FILE_PATH="$TARGET_PATH/$FILE_NAME"
    mkdir -p "$TARGET_PATH"
    echo "checking: $FULL_FILE_PATH"
    if [[ -f "$FULL_FILE_PATH" ]]; then
        echo "Skipping: $FILE_NAME (Already exists)"
        echo "----------------------------"
        continue
    fi

    echo "Starting download: $FILE_NAME -> $TARGET_PATH/"

    # --- Domain Specific Logic ---
    CURL_ARGS=("-L" "$URL" "-o" "$FULL_FILE_PATH")

    if [[ "$URL" == *"civitai.com"* ]]; then
        # Append token to URL. Handle existing query params with ? or &
        if [[ "$URL" == *"?"* ]]; then
            CURL_ARGS[1]="${URL}&token=${C_TOKEN}"
        else
            CURL_ARGS[1]="${URL}?token=${C_TOKEN}"
        fi
        echo "Detected CivitAI: Appending token..."

    elif [[ "$URL" == *"huggingface.co"* ]]; then
        # Add Authorization Header
        CURL_ARGS+=("-H" "Authorization: Bearer $H_TOKEN")
        echo "Detected HuggingFace: Adding Auth Header..."
    fi

    # Execute download with dynamically built arguments
    if curl "${CURL_ARGS[@]}"; then
        echo "Finished: $FILE_NAME"
    else
        echo "Error: Failed to download $URL"
    fi

    echo "----------------------------"

done < "$INPUT_FILE"

echo "All tasks complete."
~                                                                                                               
~                                                                                                               
~                                                 
