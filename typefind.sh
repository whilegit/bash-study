#!/bin/sh

tmpfile="/tmp/$#.tmp"
if [ $# -le 0 ];then
   echo -e "\nerror: need a type to find\n"
   exit 1
fi

if [ "$1" = "-r" ] && [ $# -eq 2 ];then
  result=$(find '/usr/include' -name '*.h' -exec grep "$2" -H -n {} \;)
  echo "$result"
  result=$(find '/usr/lib' -name '*.h' -exec grep "$2" -H -n {} \;)
  echo "$result"
  exit 0
fi

dofind(){
   result=$(find "$2" -name '*.h' -exec egrep -H -n "((__STD_TYPE|typedef)\s+[0-9a-zA-Z_ ]+\s+($1)\s*[;])|(\#\s*define\s+($1)\\s+[0-9a-zA-Z_ ]+\s*)" {} \;) 
   if [ "$result" = "" ];then
       echo -e "\n$2: 未找到该类型($1)的定义\n" 
       return 1
   fi

   echo "$result"
   echo "$result" > "$tmpfile" 
   set $(wc -l $tmpfile)
   linesfound=$1
   if [ "$1" != 1 ];then
       return 0
   fi

   set $result
   case "$1" in
       *\#*define ) 
          if [ "$3" = 'unsigned' ] || [ "$3" = 'int' ] || [ "$3" = 'char' ] || [ "$3" = "short" ] || [ "$3" = "long" ];then
             break
          else
             dofind "$3" "/usr/include"
             dofind "$3" "/usr/lib/gcc"
          fi
          ;;
       *__STD_TYPE)
           dofind "$2" "/usr/include"
           dofind "$2" "/usr/lib/gcc"
           ;;
       *typedef)
           dofind "$2" "/usr/include"
           dofind "$2" "/usr/lib/gcc"
           ;;
       *)
          echo $1;;
   esac
   
   return 0
}

i=0
params_count=$#
while [ $i -lt $params_count ];do
    dofind "$1" "/usr/include"
    dofind "$1" "/usr/lib/gcc"
    shift
    i=$(($i + 1))    
done

rm -rf $tmpfile 
exit 0
