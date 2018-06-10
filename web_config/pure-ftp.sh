#!/bin/sh

# 创建用户组和用户
groupadd ftpgroup1   # 如已有组，则不需要专门创建一个，创建完成可用 cat /etc/group查看
useradd -g ftpgroup1 -d /dev/null -s /etc ftpuser1  # 创建用户，这是一个没有home目录的用户，创建成功后可用cat /etc/passwd查看

# 添加ftp虚拟用户
/usr/local/pureftpd/bin/pure-pw useradd USERNAME -u ftpuser1 -d /data/wwwroot
# 删除这个用户
pure-pw userdel USERNAME
# 修改密码
pure-pw passwd USERNAME
# 查看用户信息
pure-pw show USERNAME

# 生成数据库文件
pure-pw mkdb



## 注意如仍然无法连接成功，则可以：
# 1. 调整ftp客户端采用主动或被动模式
# 2. 阿里云ECS还有安全组规则，要开放21端口
# 3. 如ECS本身开启了iptables或firewall，还要再开启21端口，或者关掉了事

exit 0
