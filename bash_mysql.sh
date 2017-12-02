#!/bin/sh

#登录mysql,其中-p和密码不能有空格
#刚装好mysql5.7时，会自动生成一个临时密码，存放于/var/log/mysqld.log里
# 可使用命令　grep 'temporary password' /var/log/mysqld.log　查看
mysql -h localhost -u root -pPASSWORD 

##重置root密码的流程
#停止服务
service mysql stop
#进入安全模式,不能少了&符号
mysqld_safe --skip-grant-tables &
#启动安全模式后，使用mysql命令就可以免密登录了
mysql
#选择mysql库
mysql> use mysql
#修改密码
mysql> update user set password=password("new-password") Where user="root";
       Alter USER 'root'@'localhost' IDENTIFIED BY 'new-password'; # 也可以使用这个语句
#刷新权限
mysql> flush privileges;
#退出mysql
mysql> exit
#之后要将刚才启动安全模式的进程干掉
#重启服务
service mysqld start
# 然后就可以用新密码登录了




