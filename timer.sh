#!/bin/bash

# Initialize variables to track time and mouse movement
MINUTES=0  # Total MINUTES the mouse has been moved
MOVED=false  # Flag to track if the mouse is currently moving
PREV_X=0  # Previous X-coordinate of the mouse
PREV_Y=0  # Previous Y-coordinate of the mouse
LAST_CHECK=$(date +%s)  # Timestamp of the last mouse position check
ELAPSE=10
CURRENT_DATE=$(date +"%d-%m-%Y")
my_directory="./timelog"
[ -d $my_directory ] || mkdir $my_directory



# Create the data file with the current date as the filename
DATA_FILE="$my_directory/mouse_data_$CURRENT_DATE.txt"
if [ ! -f "$DATA_FILE" ]; then
  touch "$DATA_FILE"
fi
# Continuously monitor the mouse position
while true
do
  # Get the current timestamp
  CURRENT_TIME=$(date +%s)

  # Check if 60 MINUTES have passed since the last mouse position check
  if [ $((CURRENT_TIME - LAST_CHECK)) -ge 60 ]; then

    # Get the current mouse position using xdotool
    eval $(xdotool getmouselocation --shell)

    # Check if the mouse has moved since the last check
    if [ $X -ne $PREV_X ] || [ $Y -ne $PREV_Y ]; then
      MINUTES=$((MINUTES + 1))
	  echo "Total Time: $MINUTES" > "$DATA_FILE"
      # If the mouse was previously not moving, mark it as moving and record the start time
      if [ $MOVED = false ]; then
        MOVED=true
        START_TIME=$(date +%s)
      fi
    else
      # If the mouse was previously moving, mark it as not moving and record the end time
      if [ $MOVED = true ]; then
        MOVED=false
        END_TIME=$(date +%s)
      fi
    fi

    # Update the previous mouse position
    PREV_X=$X
    PREV_Y=$Y

    # Update the last check timestamp
    LAST_CHECK=$CURRENT_TIME
  fi


  # Sleep for 1 second before checking again
  sleep 1
done
