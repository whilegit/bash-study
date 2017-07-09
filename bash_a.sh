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

