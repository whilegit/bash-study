#!/bin/sh

## umask, 用于创建文件时提供默认的文件mode(即文件权限表)
## 不仅是shell脚本, 对于Ｃ程序创建的文件也适用
umask        # 返回当前用户的掩码. 如002表示-------w-,即掩掉其它用户的写权限
umask 022    # 设置当前用户的掩码

## time工具,用于测算应用程序运行的时间
time ./command
TIMEFORMAT="" time ./command  # 加上TIMEFORMAT环境变量,让time输出ＣＰＵ使用率

## head 工具
head file-path   # 显示头6行内容
head -n 6  # 显示头6行内容

## tail 工具
tail file-path   # 显示末6行内容
tail -n 6   # 显示末6行内容
tail -n +6  # 显示从第６行开头到末尾的所有内容
 
## head和tail组合显示文件特定行的内容
cat file-path | tail -n +16 | head -n 10   #  显示文件第16行"后"的连续10行内容
cat file-path | head -n 16  | tail -n 10   #　显示文件第16行"前"的连续10行内容

## whereis工具,用于查找可执行文件／源文件/man文档的位置(可执行文件在$PATH指明的目录查找）
whereis nginx

## cat工具
cat file-path # 打印文档
cat -n file-path # 打印文档并添加行号

## tar工具
tar -v ... # 显示所有过程
tar -f xxx.tar.gz # 指明操作的压缩文件,必须使用
tar -c DIR  # 解压到某个目录
#　以下四个命令每次tar时只能使用一个
tar -c # 建立压缩文件
tar -x # 解压
tar -t # 测试文档
tar -r # 向压缩文件追加文件
tar -u # 更新压缩文件里的某些文件
# 文档的属性(可能使用别的工具的某些功能)
tar -z ... # 指明使用gzip属性(文件名通常为.tar.gz)
tar -j ... # 指明使用bzip2属性(文件名通常为.tar.bz2)
#　示例
tar -czvf jpg.tar.gz /dir/*.jpg  # 将目录里的所有jpg文件打包
tar -xzvf jpg.tar.gz        # 解压文件

## chmod修改文件模式(详细参考linux-c结构体stat.st_mode)
chmod u+x file_path    # 增加文件属主的执行权限.其中,u可以换成g或者o, +可以换成-, x可以换成r/w/s
chmod mod -R dir_path  # -R 表示对目录递归调用
chmod 664 file_path    # 使用八进制数权限标记

## /etc/passwd文件,该文件存放系统的用户信息
#
# 用户名:口令:uid:所属主gid:用户描述:用户家目录:用户Shell 
# lzr:x:1000:1000:Linzhongren-Centos7.0:/home/lzr:/bin/bash 
#
# 超级用户的uid为0, uid在100以下通常被系统使用.普通用户的uid从100(或1000)开始. 
# /etc/passwd中用户对应的gid为主组,是其登入后默认的组. 实际上,每一个linux用户可以属于多个组,参见/etc/group文件
#
## /etc/group文件,该文件存放系统的用户组信息
#
# 组名:口令:gid:组内用户列表(如有多个,以逗号隔开)
# lzr:x:1000:lzr
#
chown -R user:group file-path  # 修改文件的属主和属组
id -u # 获取当前用户的uid,如要获取其它用户的uid,在命令后加上其用户名
id -g # 获取当前用户的gid,如要获取其它用户的gid,在命令后加上其用户名

## touch 修改文件的atime和mtime至当前时间(文件不存在，则新建文件)
touch file_name
touch -a file_name # 仅修改atime
touch -m file_name # 仅修改mtime

## mkdir 新建目录
mkdir dir_name

## rmdir 删除空目录
rmdir dir_name #若目录非空，则报错

## rm 删除文件或目录
rm -d dir_name # 等同于rmdir dir_name, 若目录非空则报错
rm -r dir_name # 递归删除当前目录,子目录及其文件，此目录将被删除. -R和-r相同.
rm file_name   # 删除文件,调用了unlink系统调用
rm -rf dir_name # 强制地／递归删除而不提醒错误

cd dir_name # 改变当前工作目录
pwd # 打印工作目录


