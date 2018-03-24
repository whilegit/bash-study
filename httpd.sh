#!/bin/sh

# 注意修改
Listen 47.97.63.133:80
ServerName 47.97.63.133:80

# 加载(handler运行模式) 
LoadModule php5_module modules/mod_libphp5.so
 
# Directory 指令修改
<Directory />
	options FollowSymLinks
	AllowOverride none
	Order allow,deny
	Allow from allow
	# Require all denied
</Directory>

# 修改根目录
DocumentRoot "/data/wwwroot/default"
<Directory "/data/wwwroot/default">
	Options Indexes FollowSymLinks
	AllowOverride None
	Order allow,deny
	Allow from all
</Directory>

# 加载虚拟主机
Include conf/vhost/*.conf

exit 0