#!/bin/sh

# vsftpd的安装
## 可以使用yum安装
## 配置文件一般在/etc/vsftpd上
   # 禁止匿名用户的登录　anonymous_enable=NO
   # 启用userlist文件的效力 userlist_enable=YES
   # 将userlist文件设置成白名单 userlist_deny=NO
   # 设置本地用户的登录目录 local_root=/var/wwwroot
## ftpusers目录为禁止登录的用户，总是生效，不改动
## 添加允许登录的用户至userlist文件

exit 0

