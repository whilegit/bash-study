#!/bin/sh
sample_text="global varible"
foo(){
   local sample_text="local varible"
   echo "Function foo is executing"
   
   echo $sample_text
}

echo "script starting"
echo $sample_text
foo
echo "script ended"
echo $sample_text

exit 0
