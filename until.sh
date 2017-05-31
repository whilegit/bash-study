#!/bin/sh

until who | grep "$1" > /dev/null
do
   sleep 10 
done

echo "$1" is logged.

exit 0
