#!/bin/sh

echo "Is it Morning? Pealse enter yes or no"
read timeofday

case "$timeofday" in
   [Yy]* ) echo "Good Moning.";;
   n* | N*) echo "Good Afternoon.";;
   *  ) 
      echo "Sorry, answer not recognized."
      exit 1
      ;;
esac
exit 0
