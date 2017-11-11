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

##rar和unrar工具
rar a DEST_FILE.rar SOURCE_FILES   # 压缩命令，SOURCE_FILES可以是多个文件(以空格隔开), 也可以使用*和?通配符
rar e SOURCE_FILE.rar   # 将SOURCE_FILE.rar文件目录解压到当前目录，且不保SOURCE_FILE.rar的目录结构(即解压后的文件没有目录，只有文件) 
rar x SOURCE_FILE.rar   # 与e命令类似，但保留目录结构

## chmod修改文件模式(详细参考linux-c结构体stat.st_mode)
chmod u+x file_path    # 增加文件属主的执行权限.其中,u可以换成g或者o, +可以换成-, x可以换成r/w/s
chmod mod -R dir_path  # -R 表示对目录递归调用
chmod 664 file_path    # 使用八进制数权限标记

## /etc/passwd文件,该文件存放系统的用户信息
#
# 用户名:口令:uid:所属主gid:用户描述:用户家目录:用户Shell 
# lzr:x:1000:1000:Linzhongren-Centos7.0:/home/lzr:/bin/bash 
useradd USERNAME -g GROUPNAME
passwd USERNAME  # 为一个用户设置密码
#
# 超级用户的uid为0, uid在100以下通常被系统使用.普通用户的uid从100(或1000)开始. 
# /etc/passwd中用户对应的gid为主组,是其登入后默认的组. 实际上,每一个linux用户可以属于多个组,参见/etc/group文件
#
## /etc/group文件,该文件存放系统的用户组信息
groupadd GROUPNAME
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

## ssh远程登录命令
ssh -l <username> host  # 如 ssh -l root remote_ip

## 显示十六进制(这三个命令有些许不同，待有空的时候好好研究一下)
od -t x1 file_name
xxd file_name
hexdump -C file_name

## rpm包的安装和删除
rpm -qa    # -q(--query)列出所有已安装的rpm包 
rpm -ivh PACKAGE_NAME #安装一个rpm包, -i(--install), -v(print verbose information显示安装过程), -h(print 50 hash显示hash值)
rpm -Uvh PACKAGE_NAME #升级一个rpm包, -U(--upgrade)
rpm -e PACKAGE_NAME   # 删除一个rpm包, -e(--erase)

## ifconfig (interface config) 网络配置
### 网卡的配置脚本在/etc/sysconfig/network-scripts
ifconfig  #　查看当前的网络状态(列出所有的网卡,ens33或eth0为有线网卡, virbr0为虚拟\
　　　　　#　网桥,为本地上的虚拟网卡提供DHCP服务)
ifconfig ens33 down  # 打闭网卡
ifconfig ens33 up    # 开启网卡
ifconfig ens33 hw ether 00:00:00:00:ff:ff  # 临时修改网卡的mac地址
ifconfig ens33 192.168.6.128 netmask 255.255.255.0 # 临时修改网卡的ip地址

## 测试文件类型
file file_path  
file -b file_path # 返回值中不包括文件名 --brief
file -i file_path # 返回MIME类型，如: text/html;charset=utf-8

##netstat 命令
netstat -a  ## 列出所有的连接（包括处于监听中的端口）
netstat -at ## 列出所有TCP连接
netstat -au ## 列出的甩UDP连接
netstat -l  ## 列出的正在监听的连接，可以加上-t和-u
netstat -atn ## 列出所有tcp连接，并禁用反向域名解析(加快查询速度),此处与-at功能类似，其中t可以用-u替换。加上-n可以显示端口而不显示此端口代表的协议
netstat -ptln ## 列示所有正在监听的tcp连接，并显示pid(需要运行在root之下)
netstat -ptlne ## 加上e可以显示一些扩展信息，如进程所属的用户
netstat -st ## 打印tcp连接的统计信息，如出入数据量
netstat -r  ## 打印内核的路由信息
netstat -i  ## 打印网卡信息，与ifconfig类似
netstat -c ## 持续输出
netstat -ptln | grep 80 # 查看80端口的占用情况

# 进程的六种状态
  # R 运行态或等待运行态(Running or Runnable On run queue)
  # S 可中断睡眠态(Interruptible Sleep), 此种状态可接受中断信号,大多数进程处于这种状态之下.
      #进程可能在等待某个信号量,或调用了sleep函数等,一旦条件达成,可自动恢复执行.
  # D 不可断睡眠态(uninterruptible Sleep), 可能处于等待某些IO操作中,不可被中断,若进程长时间处于此状态,则表示某些IO出现故障,必须重启系统(原因是kill无法杀掉此类进程)
  # T 暂停或跟踪态(Stopped or Traced), 当进程收到SIGSTOP等信号时,进入该状态,进行暂停运行;如继续收到SIGCONT信号,则恢复执行;在Linux C的GBD调试中,也进入此状态.
  # Z 退出状态之僵尸状态(Exit_Zombie),进程运行结束,需父进程调用wait系统调用过来收尸(task struct)
  # X 退出状态之清除阶段(Exit_Dead), 进程将立即释放所有资源,包括task struct, ps命令极难捕捉到此状态. 

# vsftpd的安装
## 可以使用yum安装
## 配置文件一般在/etc/vsftpd上
   # 禁止匿名用户的登录　anonymous_enable=NO
   # 启用userlist文件的效力 userlist_enable=YES
   # 将userlist文件设置成白名单 userlist_deny=NO
   # 设置本地用户的登录用户为/var/wwwroot
## ftpusers目录为禁止登录的用户，总是生效，不改动
## 添加允许登录的用户至userlist文件
