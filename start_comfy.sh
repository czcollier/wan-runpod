#!/bin/bash

BINARY="python /workspace/ComfyUI/main.py"
LOGFILE="/tmp/comfy.log"

nohup $BINARY > "$LOGFILE" 2>&1 &

echo "comfy running in background. PID: $!"
