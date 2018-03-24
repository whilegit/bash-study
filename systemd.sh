#!/bin/sh

## systemd 替换 init加载方式，成为各Linux发行版本的首选进程控制系统。systemd内容庞大，只能学习部分功能。


## 查看systemd的版本
systemctl --version
## 重启系统
systemctl reboot
## 查看启动耗时
systemd-analyze
## 查看每个服务的启动耗时
systemd-analyze blame
## 查看主机情况(输出主机名、操作系统版本，内核版本等)
hostnamectl
## 输出语言设置
locatectl
## 输出本地时区设置
timedatectl
## 查看当前登录用户
loginctl


## Unit
## Systemd可以管理所有系统资源，不能资源统称为Unit，一共可分为12种Unit
# Service: 系统服务
# Target : 多个Unit构成一个组
# Device : 硬件设备
# Mount  : 文件系统的挂载点
# Automount : 自动挂载点
# Path   : 文件或路径
# Scope  : 不是由 Systemd 启动的外部进程
# Slice  : 进程组
# Snapshot : Systemd快照，可以切回某个快照
# Socket : 进程间通信的Socket
# Swap   : swap文件
# Timer  : 定时器


### 查看系统的所有Unit
## 列出正在运行的Unit
systemctl list-units
## 列出所有Unit, 包括没有找到配置文件或者启动失败
systemctl list-units --all
## 列出所有运行而没有运行的Unit
systemctl list-units --all --state=inactive
## 列出所有加载失败的unit
systemctl list-units --failed
## 列出所有service
systemctl list-units --type=service

### 查看Unit状态
## 显示系统状态(包括结构)
systemctl status
## 显示单个Unit的状态
systemctl status nginx.service
## 显示某个Unit是否正在运行
systemctl is-active nginx.service
## 显示某个Unit服务是否开机运行
systemctl is-enabled nginx.service
## 显示某个Unit是否启动失败
systemctl is-failed nginx.service


### 控制Unit的状态
## 立即操作(启动/停止/重启/重新加载配置文件)一个服务
systemctl start/stop/restart nginx.service
## 显示某个Unit的所有底层参数
systemctl show nginx.service


## 查看依赖关系统
systemctl list-dependencies nginx.service


### Unit 配置文件(如何定义一个Unit)
# Systemd默认从/etc/systemd/system/中读取Unit配置文件。但是该目录中的文件都是符号链接，真正的配置文件存放在
#              /usr/lib/systemd/system/中读取Unit配置文件。但是该目录中的文件都是符号链接，真正的配置文件存放在

# 设置某个Unit开机启动(实质是建立符号链接)
systemctl enable nginx.service   # 开启开机启动
systemctl disable nginx.service  # 禁止开机启动

# 查看配置文件的状态(显示Unit名称和当前状态state)
# 显示有四种状态，
#    enable(已建立启动链接)
#    disable(未建立启动链接)
#    static(该配置没有Install执行部，只能被别的Unit依赖)
#    masked(被禁止建立启动链接)
systemctl list-unit-files   
systemctl list-unit-files --type=service   # 增加--type筛选


### 配置文件结构
# 主要由三个区块构成 [Unit] [Install] [Service]构成，注意大小写

[Unit]
Description=Vsftpd ftp daemon    # Unit的描述
After=network.target             # After表示在network.target启动之后启动本Unit

[Service]  # 仅Service类型的Unit需要本区域
Type=simple/forking/oneshot/dbus/notify/idle    
# Type=simple   默认值，直接执行ExecStart指定的命令，启动主进程
# Type=forking  以fork方式从父进程创建子进程，创建后父进程退出；
# Type=oneshot  一次性进程，systemd会等待该服务退出，再继续往下执行
# Type=dbus     ???
# Type=notify   当前服务启动完毕后，会通知Systemd再继续往下执行
# Type=idle     若有其它任务执行完毕，当前服务才会运行
ExecStart=/usr/local/xxxx      # 真正的启动命令
ExecStartPre=/usr/local/xxxx   # ExecStart命令执行前执行的命令
ExecStartPost=/usr/local/xxxx  # ExecStart命令执行后执行的命令
ExecReload=/usr/local/xxxx     # 重启当前服务时执行的命令
ExecStop=/usr/local/xxxx       # 停止当前服务时执行的命令
ExecStopPost=/usr/local/xxxx   # 执行完ExecStop后再执行的命令
...

[Install]
WantedBy=xxxx.target   # 当建立启动链接时，将放入/etc/systemd/xxxx.target.wants的目录中
RequiredBy=xxxx.target # 当建立启动链接时，将放入/etc/systemd/xxxx.target.required的目录中 (不清楚能否和WantedBy共存??)
Alias=xxxx # 别名
Also=xxxx  # 当本Unit激活时，同时激活其它的Unit

## 以下是vsfptd的一个Service配置，仅供参考
[Unit]
Description=Vsftpd ftp daemon
After=network.target

[Service]
Type=forking
ExecStart=/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

[Install]
WantedBy=multi-user.target


### Target 系统的某种状态(Systemd想要达到的某种系统状态)
# 由许多Unit组成，与传统init启动模式(RunLevel)相似，但并不相同。RunLevel间是互斥，而Target是共存。

## Target与传统RunLevel的对应关系
Runlevel 0  <====>   poweroff.target
Runlevel 1  <====>   rescue.target
Runlevel 2  <====>   multi-user.target
Runlevel 3  <====>   multi-user.target
Runlevel 4  <====>   multi-user.target
Runlevel 5  <====>   graphical.target
Runlevel 6  <====>   reboot.target

## 显示当前系统的所有Target
systemctl list-unit-files --type=target

## 查看某个Target包含的所有Unit
systemctl list-dependencies multi-user.target

## 获取当前默认的Target
systemctl get-default

## 更多关于Target的操作



### 日志管理(Systemd统一管理所有Unit的启动日志，配置文件是/etc/systemd/journald.conf)
journalctl      # 查看本次启动的所有日志
journalctl -k   # 仅查看内核日志
journalctl --since="2017-10-30 18:00:00"  # 查看指定时间以来的日志
journalctl --since "20 min ago"
journalctl --since yesterday
journalctl --since "2018-03-10" --until "2018-03-15 03:00"
journalctl --since 09:00 --until "1 hour ago"

journalctl -n   # 显示最新的10行日志

journalctl -u nginx.service   # 指定Unit的日志

## 更多journalctl的用法查看相关资料























   
