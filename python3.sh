#! /bin/sh
## 安装 python3
# CentOS默认已安装python2,安装位置通常在/usr/bin/python目录下，此处应该安装python3

#1.安装必要的依赖.
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel

#2. 下装 python3源代码
wget https://www.python.org/ftp/python/3.6.5/Python-3.6.2.tar.xz

#3. 解压、安装
tar -xvJf Python-3.6.5.tar.xz
cd Python-3.6.2
./configure --prefix=/usr/local/python3
make && make install

#4. 创建软连接
ln -s /usr/local/python3/bin/python3 /usr/bin/py3
ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3

#5. 测试
py3



