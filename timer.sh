#!/bin/bash

# Initialize variables to track time and mouse movement
SECONDS=0  # Total seconds the mouse has been moved
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

  # Check if 5 seconds have passed since the last mouse position check
  if [ $((CURRENT_TIME - LAST_CHECK)) -ge 5 ]; then

    echo "Total seconds: $SECONDS" > "$DATA_FILE"
    # Get the current mouse position using xdotool
    eval $(xdotool getmouselocation --shell)

    # Check if the mouse has moved since the last check
    if [ $X -ne $PREV_X ] || [ $Y -ne $PREV_Y ]; then
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
        # Add the time the mouse was moving to the total seconds
        # SECONDS=$((SECONDS + (END_TIME - START_TIME)))
      fi
    fi

    # Update the previous mouse position
    PREV_X=$X
    PREV_Y=$Y

    # Update the last check timestamp
    LAST_CHECK=$CURRENT_TIME
  fi

  # If the mouse is currently moving, increment the total seconds
  if [ $MOVED = true ]; then
    SECONDS=$((SECONDS + 1))
  fi

  # Print the total seconds the mouse has been moved
  printf "\rtotal seconds: $SECONDS"

  # Sleep for 1 second before checking again
  sleep 1
  # im new to shel so i do not know where i did wrong that this happened to me. i meant the below part of code!
  #but it is working. dont be worry.
  SECONDS=$((SECONDS - 1))
done
