#!/bin/sh

FILE=grive.lock

if [ ! -f "$FILE" ]; then
   touch $FILE
   echo "Starting Sync"
   grive $PARAMS
   rm $FILE
   echo "Finished Sync"
else
   echo "Lock-file present $FILE, try increasing time between runs, next schedule will be $CRON"
fi
