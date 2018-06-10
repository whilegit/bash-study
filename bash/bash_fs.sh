#!/bin/sh

## umask, 用于创建文件时提供默认的文件mode(即文件权限表)
## 不仅是shell脚本, 对于Ｃ程序创建的文件也适用
umask        # 返回当前用户的掩码. 如002表示-------w-,即掩掉其它用户的写权限
umask 022    # 设置当前用户的掩码

## whereis工具,用于查找可执行文件／源文件/man文档的位置(可执行文件在$PATH指明的目录查找）
whereis nginx

## head 工具
head file-path   # 显示头6行内容
head -n 6  # 显示头6行内容

## tail 工具
tail file-path   # 显示末6行内容
tail -n 6   # 显示末6行内容
tail -n +6  # 显示从第６行开头到末尾的所有内容

## cat工具
cat file-path # 打印文档
cat -n file-path # 打印文档并添加行号
# head和tail组合显示文件特定行的内容
cat file-path | tail -n +16 | head -n 10   #  显示文件第16行"后"的连续10行内容
cat file-path | head -n 16  | tail -n 10   #　显示文件第16行"前"的连续10行内容

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

##rar工具
rar a DEST_FILE.rar SOURCE_FILES   # 压缩命令，SOURCE_FILES可以是多个文件(以空格隔开), 也可以使用*和?通配符
rar e SOURCE_FILE.rar   # 将SOURCE_FILE.rar文件目录解压到当前目录，且不保SOURCE_FILE.rar的目录结构(即解压后的文件没有目录，只有文件) 
rar x SOURCE_FILE.rar   # 与e命令类似，但保留目录结构

##zip和unzip工具
zip -r myfolder.zip FOLDER/* # 将FOLDER目录下的所有内容打进myfolder.zip这个包里
unzip myfolder.zip # 解压myfolder.zip到当前目录

## chmod修改文件模式(详细参考linux-c结构体stat.st_mode)
chmod u+x file_path    # 增加文件属主的执行权限.其中,u可以换成g或者o, +可以换成-, x可以换成r/w/s
chmod mod -R dir_path  # -R 表示对目录递归调用
chmod 664 file_path    # 使用八进制数权限标记

## touch 修改文件的atime和mtime至当前时间(文件不存在，则新建文件)
touch file_name
touch -a file_name # 仅修改atime
touch -m file_name # 仅修改mtime

# 修改文件的属主和属组
chown -R user:group file-path  

## mkdir 新建目录
mkdir dir_name

## rmdir 删除空目录
rmdir dir_name #若目录非空，则报错

## rm 删除文件或目录
rm -d dir_name # 等同于rmdir dir_name, 若目录非空则报错
rm -r dir_name # 递归删除当前目录,子目录及其文件，此目录将被删除. -R和-r相同.
rm file_name   # 删除文件,调用了unlink系统调用
rm -rf dir_name # 强制地／递归删除而不提醒错误

# 改变当前工作目录
cd dir_name 
# 打印工作目录
pwd 
# 复制文件,加上参数-p可以保持文件的属性
cp -R src/file dest/file  
# 将本地文件通过ssh上传至远程服务器(上传前不能登入远程服务器)
# 如果本地是windows,可以安装git bash 集成的MINGW64模拟Linux环境
scp /local/source/file root@remote_ip:/dest/dir 
# 将远程的文件下载至本地
scp root@remote_ip:/src/file /local/dest

## 显示十六进制(这三个命令有些许不同，待有空的时候好好研究一下)
od -t x1 file_name
xxd file_name
hexdump -C file_name

## 查看当前磁盘信息
fdisk -l # 获取当前机器的磁盘信息,若新磁盘未挂载则此处不会显示
df -h    # 该命令同时显示磁盘的使用情况

## 对数据盘进行分区
fdisk -S 56 /dev/vdb # 之后依次输入n,p,1,两次回车,wq,就可完成.

## mkfs.ext4 执行格式化
mkfs.ext4 /dev/vdb1

## /etc/fstab　自动挂载配置文件
# 该文件可读可写,新记录保存后下次启动时就会自动挂载. 
/dev/vdb1 /var/wwwroot ext4 defaults 0 0
# 第一列: 磁盘设备文件或该设备的Label或uuid
# 第二列: 挂载点
# 第三列: 文件系统
# 第四列: 挂载参数,默认值defaults表示　r/w, dev,exec,auto,nouser,async等
# 第五列: 能否被dump备份命令作用(?)
# 第六列: 是否检查扇区,一般根目录设为1

## /etc/mtab 已挂载信息表
# 该文件记录当前已挂载的文件信息,每次mount/unmount命令后,都会修改此文件的相关内容.

## 临时挂载和卸载
mount /dev/xxx /dest/dir # 第一个参数是设备号,第二个参数为目标目录(挂载点)
unmount -v /dev/xxx      # 通过设备号卸载, -v参数表示显示过程
unmount -v /dest/dir     # 通过挂载点卸载

