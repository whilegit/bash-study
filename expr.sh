#!/bin/sh

expr 1 + 2
x=3
y=`expr $x + 2`
z=$(expr $y + 2)
echo $y
echo $z

exit 0
