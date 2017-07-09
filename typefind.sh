#!/bin/sh

# 查找linux c类型的定义出处(typedef,define,struct)
# author:lzr
# email: 6215714@qq.com
# 使用方法：
#    typefind size_t 
#    typefind -r size_t
#    typefind size_t mode_t

path1='/usr/include'
path2='/usr/lib/gcc'
tmpfile="/tmp/$$.tmp"
params_count=$#

# 无参数则退出
if [ $params_count -le 0 ];then
   echo -e "\nerror: need a type to find\n"
   exit 1
fi
# 如果加参数-r 则进行全文查找
if [ "$1" = "-r" ] && [ $params_count -eq 2 ];then
  result=$(find "$path1" -name '*.h' -exec grep "$2" -H -n {} \;)
  echo "$result"
  result=$(find "$path2" -name '*.h' -exec grep "$2" -H -n {} \;)
  echo "$result"
  exit 0
fi

# 具体的查找函数,几个正则表达式(递归调用)
# 第一个是__STD_TYPE(是typedef的别名)和typedef
# 第二个是define
# 第三个是struct
dofind(){
   result=$(find "$2" -name '*.h' -exec egrep -H -n "\
((__STD_TYPE|typedef)\s+[0-9a-zA-Z_ ]+\s+($1)\s*[;])|\
(\#\s*define\s+($1)\s+[0-9a-zA-Z_ ]+\s*)|\
((^[^\(]*struct\s*($1)\s*(\/\*.*?\*\/)?\s*\{?\s*(\/\*.*?\*\/)?\s*)$)\
" {} \;) 
   if [ "$result" = "" ];then
       echo -e "\n$2: 未找到该类型($1)的定义\n" 
       return 1
   fi
   
   # 如果有找到匹配的行，保存到临时文件。若有多行则不再继续分析
   echo "$result"
   echo "$result" > "$tmpfile" 
   set $(wc -l $tmpfile) #wc统计命令，-l统计行数
   linesfound=$1
   if [ "$1" != 1 ];then
       return 0
   fi

   # 单行文本继续分析，进一步查找定义的根源
   set $result
   case "$1" in
       *\#define | \#) 
          if [ "$3" = 'unsigned' ] || [ "$3" = 'int' ] || [ "$3" = 'char' ] || [ "$3" = "short" ] || [ "$3" = "long" ];then
             break
          else
             dofind "$3" "$path1"
             dofind "$3" "$path2"
          fi
          ;;
       *__STD_TYPE)
           dofind "$2" "$path1"
           dofind "$2" "$path2"
           ;;
       *typedef)
           dofind "$2" "$path1"
           dofind "$2" "$path2"
           ;;
       *)
          echo $1;;
   esac
   
   return 0
}

# 支持一次查找多个类型
i=0
while [ $i -lt $params_count ];do
    dofind "$1" "$path1"
    dofind "$1" "$path2"
    shift
    i=$(($i + 1))    
done

rm -rf $tmpfile 
exit 0
