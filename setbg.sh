#!/bin/bash

if ! command -v feh &> /dev/null; then
  echo "feh is not installed"
  exit
fi

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILES=$(find $DIR -type f | grep XPP | sort)
TIMEOUT_MIN=0

setBackground()
{
  if test "`find ~/.fehbg -mmin +$TIMEOUT_MIN`"; then
    FILE=$(echo "$FILES" | grep "M4x_$1_" | grep -v NoMoon | shuf -n 1)
    echo "SET NEW BACKGROUND: $FILE"
    feh --bg-fill $FILE
  else
    ~/.fehbg
  fi
}

while true; do

  HOUR=$(date +%H)

  if test $HOUR -gt 20 -o $HOUR -le 5; then
    setBackground "Night"
  elif test $HOUR -gt 17; then
    setBackground "Sunset"
  elif test $HOUR -gt 10; then
    setBackground "Day"
  elif test $HOUR -gt 7; then
    setBackground "Morning"
  elif test $HOUR -gt 5; then
    setBackground "Sunrise"
  fi
  
  TIMEOUT_MIN=15

  sleep 5
done

