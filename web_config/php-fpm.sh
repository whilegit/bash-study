#!/bin/sh

## 安装和启动
# 编译方式安装php时，应添加编辑选项 --enable-fpm, 否则安装后没有php-fpm服务端可执行文件
# 运行php-fpm: 
#    php编译成功后，php-fpm的可执行文件通常在 $prefix/sbin/php-fpm中
#    其配置文件通常$prefix/etc/php-fpm.conf
sbin/php-fpm -c etc/php.ini -y etc/php-fpm.conf # 可启动php-fpm守护进程，使用netstat -ptln查看9000端口
# 继续配置nginx的fastcgi设置即可。



exit 0
