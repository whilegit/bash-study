#!/bin/sh

#登录mysql,其中-p和密码不能有空格
#刚装好mysql5.7时，会自动生成一个临时密码，存放于/var/log/mysqld.log里
# 可使用命令　grep 'temporary password' /var/log/mysqld.log　查看
mysql -h localhost -u root -pPASSWORD 

##重置root密码的流程
#停止服务
service mysqld stop
#进入安全模式,不能少了&符号
mysqld_safe --skip-grant-tables &
#启动安全模式后，使用mysql命令就可以免密登录了
mysql
#选择mysql库
mysql> use mysql;
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

## 导入数据库映像文件
mysql> source /db/img/file  # 时间通常很长，最好打开screen工具或者加上&转为后台运行

# 显示数据库列表
mysql> show databases;
# 选择数据库
mysql> use DBNAME;
# 显示数据表
mysql> show tables;
# 显示数据表结构
mysql> show columns from TABLE_NAME;

# 增加一个用户
## 命令的%可以改成localhost,这样用户只能在本机登入,百分号%表示任何地方可以登入
mysql> create user 'USERNAME'@'%' identified by 'PASSWORD';

## 授予权限
# 授予全部权限
mysql> grant all privileges on *.* to 'USERNAME'@'%' identified by 'PASSWORD' with grant option;
# 授予部分权限,仅授予USERNAME从192.168.1.124登入,DANAME库全部表的select,update,insert权限
mysql> grant select,update,insert on DBNAME.* to 'USERNAME'@'192.168.1.124' identified by 'PASSWORD' with grant option;
# 刷新权限表
mysql> flush privileges;

