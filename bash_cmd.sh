#!/bin/sh

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
rpm -ivh PACKAGE_NAME #安装一个rpm包, -i(--install), -v(print verbose information显示安装过), -h(print 50 hash显示hash)
rpm -Uvh PACKAGE_NAME # 升级一个rpm包, -U(--upgrade)
rpm -e PACKAGE_NAME   # 删除一个rpm包, -e(--erase)

## ifconfig (interface config) 网络配置
### 网卡的配置脚本在/etc/sysconfig/network-scripts
ifconfig  #　查看当前的网络状态(列出所有的网卡,ens33或eth0为有线网卡, virbr0为虚拟
　　　　　#　网桥,为本地上的虚拟网卡提供DHCP服务
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

## 进程快照ps (processes snapshot)
# 不加参数直接运行ps,返回当前用户正在运行的进程.
# PID   TTY      TIME     CMD (从左到右:　进程号 终端号 CPU执行时间 启动命令)
# 28824 pts/0    00:00:00 bash
# 29264 pts/0    00:00:00 ps
ps 
# 加参数-ax 将显示当前所有进程,包括后台运行的进程 
ps -ax
# 加参数-u USERNAME, 将显示该用户的进程
ps -u USERNAME
# 使用 -aux参数,显示详细信息
ps -aux --sort -pcpu # -pcpu按cpu降序排列,+pcpu按升序排列
ps -aux --sort -pmem # -pmem按mem降序排列,+pmem按升序排列
# 使用-C cmd过滤条件
ps -C COMMAND # 通过cmd字段检索进程(可能要完全吻合)
# 使用-f 输出更详细的格式化数据
ps -af 
# 使用 -L PID 输出与该进程的子线程
ps -L PID
# 使用 -axjf 显示进程的树列结构
ps -axjf # 也可使用pstree命令

## 向进程发送信号，kill命令
kill -l     # 列出系统所有的信号常量和信号代号
kill -l 9   # 列出代号为9的常量
kill -l HUP # 列出常量的HUP的代号
kill -9 A_PID   # 发送代号表示的信号
kill -HUP A_PID # 发送常量表示的信号 

## 常用信号表
# HUP: hang up, 端终断开信号, 可捕获可忽略. 早期终端使用串行方式(如Modern连接),挂断后相应进程就没有输出终端了
#     现在通常指虚拟终端，也有部分daemon守护进程因为不需要终端，会重新定义该信号的含义,
#     比如httpd截获(intercept)该信号后就重新加载配置文件，相当于重启。
(1) SIGHUP
# INTERRUPT: 中断，可捕获可忽略
#            通常由用户在终端中按下 Ctrl + C 发起，表示想结束此进程的运行，类传TERM的作用。
(2) SIGINT
# QUIT: 退出信号,可捕获(但进程仍会退出),并做一次内核转储(Core dump),将进程的关键信息的快照保存下来
#       通常出用户终端按下 Ctrl + \ 发起
(3) SIGQUIT
(4) SIGILL
(5) SIGTRAP
(6) SIGABRT
(7) SIGBUS
(8) SIGFPE
(9) SIGKILL
# USR1和USR2,用户自定义的信号，没有预先定义的含义
(10) SIGUSR1 (12) SIGUSR2  
(11) SIGSEGV
(13) SIGPIPE
(14) SIGALRM
# TERM: termination, 结束信号, 可捕获可忽略，通知进程尽快结束。
#       进程收到此信号后，可作一些最后善后工作，然后优雅离开。该信号与INT信号类似。 
(15) SIGTERM
(16) SIGSTKFLT
(17) SIGCHLD
(18) SIGCONT
(19) SIGSTOP
(20) SIGTSTP
(21) SIGTTIN
(22) SIGTTOU
(23) SIGURG
(24) SIGXCPU
(25) SIGXFSZ
(26) SIGVTALRM
(27) SIGPROF
(28) SIGWINCH
(29) SIGIO
(30) SIGPWR
(31) SIGSYS
(34) SIGRTMIN
(35) SIGRTMIN+1
(36) SIGRTMIN+2
(37) SIGRTMIN+3
(38) SIGRTMIN+4
(39) SIGRTMIN+5
(40) SIGRTMIN+6
(41) SIGRTMIN+7
(42) SIGRTMIN+8
(43) SIGRTMIN+9
(44) SIGRTMIN+10
(45) SIGRTMIN+11
(46) SIGRTMIN+12
(47) SIGRTMIN+13
(48) SIGRTMIN+14
(49) SIGRTMIN+15
(50) SIGRTMAX-14
(51) SIGRTMAX-13
(52) SIGRTMAX-12
(53) SIGRTMAX-11
(54) SIGRTMAX-10
(55) SIGRTMAX-9
(56) SIGRTMAX-8
(57) SIGRTMAX-7
(58) SIGRTMAX-6
(59) SIGRTMAX-5
(60) SIGRTMAX-4
(61) SIGRTMAX-3
(62) SIGRTMAX-2
(63) SIGRTMAX-1
(64) SIGRTMAX

