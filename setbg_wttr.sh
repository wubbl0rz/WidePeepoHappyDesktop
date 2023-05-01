#!/bin/bash

TIMEOUT_MIN=15

function setBackground() {
  all_files=$(find "$(dirname "$0")" -type f | grep XPP | sort)
  new_bg=$(echo "$all_files" | grep "M4x_$1_" | grep -v NoMoon | shuf -n 1)
  echo "Set new background for $1: $new_bg"
  feh --bg-fill "$new_bg"
}

function round_hour() {
    hour=$(date -d "$1" +%H)
    if [[ $(date -d "$1" +%M) -ge 30 || $(date -d "$1" +%S) -ge 30 ]]; then
        hour=$((hour + 1))
    fi
    if [[ $hour -eq 24 ]]; then
        hour=0
    fi
    echo "$hour"
}

if ! command -v feh &> /dev/null; then
    echo "feh is not installed"
    exit
fi

while true; do
  hour_now=$(date +%H)

  # check background creation date for timeout
  if [ -f "$HOME/.fehbg" ]; then
    if find ~/.fehbg -mmin +"$TIMEOUT_MIN"; then
      echo "Sleeping $TIMEOUT_MIN min"
      sleep $(("$TIMEOUT_MIN"*60))
      continue
    fi
  fi

  # get sunrise and sunset hours
  sunrise=$(curl -s "https://wttr.in?format=%S")
  sunset=$(curl -s "https://wttr.in?format=%s")
  rounded_sunrise=$(round_hour "$sunrise")
  rounded_sunset=$(round_hour "$sunset")

  if [ "$hour_now" -eq "$rounded_sunrise" ]; then
    setBackground "Sunrise"
  elif [ "$hour_now" -gt "$rounded_sunrise" ] && [ "$hour_now" -le "$(("$rounded_sunrise"+2))" ]; then
    # "morning" is 2 hours after sunrise
    setBackground "Morning"
  elif [ "$hour_now" -gt "$(("$rounded_sunrise"+2))" ] && [ "$hour_now" -lt "$rounded_sunset" ]; then
    setBackground "Day"
  elif [ "$hour_now" -eq "$rounded_sunset" ]; then
    setBackground "Sunset"
  else
    setBackground "Night"
  fi
done
