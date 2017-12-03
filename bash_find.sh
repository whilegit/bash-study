#!/bin/sh

#### find (非Bash命令)
find . -name 'pattern'   # -name 表示文件名匹配正则表达式,后面的pattern最好用''括起来
find / -mount -name 'pattern' -print  # -mount 表示不搜索挂载的其它文件系统, -print打印出来.
find . -atime N -mtime M -type f -user USERNAME # 搜索N天前(当天)访问过,Ｍ天前(当天)修改过,类型为普通文件,由USERNAME拥有的文件
       # -atime +N -mtime +M 表示N天前（或更久之前)被访问过，M天前（或更久之前)被修改过
       # -atime -N -mtime -M 表示N天前(至现在)被访问过，M天前（至现在)被修改过
find . -newer other_file # 比other_file要新的文件(指mtime更接近现在)
find . \(-newer X -o -name '_*' \) # 比Ｘ文件新或者文件名符合_*模式.　-a(-and)  -o(-or)  !(-not)  括号要转义 
find . -name 'pattern' -exec ls -l {} \;    # -exec 执行后续的一段命令,不要忽略后面的分号. 把-exec替换成-ok将会有确认信息.
find . -name 'pattern' -exec grep pattern {} -H -n \; # find和grep配合查找指定的内容, -H参数打印匹配的文件名, -n 加上行号
# Linux-c 编程时查找宏类型的定义,可以制作一个bash工具
find /usr/include -name *.h -exec egrep -H -n '((__STD_TYPE|typedef)\s+[0-9a-zA-Z_]+\s+(xxxxxxxx)\s*[;])|(\#\s*define\s+(xxxxxxxx)\s+[0-9a-zA-Z_ ]+\s*)' {} \;

exit 0
