#!/bin/sh

## time工具,用于测算应用程序运行的时间
time ./command
TIMEFORMAT="" time ./command  # 加上TIMEFORMAT环境变量,让time输出ＣＰＵ使用率

## whereis工具,用于查找可执行文件／源文件/man文档的位置(可执行文件在$PATH指明的目录查找）
whereis nginx

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
id -u # 获取当前用户的uid,如要获取其它用户的uid,在命令后加上其用户名
id -g # 获取当前用户的gid,如要获取其它用户的gid,在命令后加上其用户名

## ssh远程登录命令
ssh -l <username> host  # 如 ssh -l root remote_ip

# 将本地文件通过ssh上传至远程服务器(上传前不能登入远程服务器)
# 如果本地是windows,可以安装git bash 集成的MINGW64模拟Linux环境
scp /local/source/file root@remote_ip:/dest/dir 
# 将远程的文件下载至本地
scp root@remote_ip:/src/file /local/dest

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
   # 设置本地用户的登录目录 local_root=/var/wwwroot
## ftpusers目录为禁止登录的用户，总是生效，不改动
## 添加允许登录的用户至userlist文件

