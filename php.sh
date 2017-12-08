#!/bin/sh


## 编译安装, 编辑前要新建好/usr/local/php文件
./configure \
--prefix=/usr/local/php # configure的标准选项,选择安装位置
--with-config-file-path=/usr/local/php/etc # 设置php.ini的搜索路径
--with-config-file-scan-dir=/usr/local/php/etc/php.d # 其它配置文件的路径
--with-apxs2=/usr/local/apache/bin/apxs # 设置apxs2可执行文件路径,以便php当作mod集成进httpd中
--enable-opcache # 启用字节码缓存功能 
--enable-fpm # 启用fastcgi的fpm进程管理器
--disable-fileinfo # 用来探测文件的类型,封装了libmagic库
--with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd # mysql相关
--with-iconv-dir=/usr/local # iconv编码转换模块,设定其路径;如果找不到,可能还需要加/bin；还是找不到，直接运行 make ZEND_EXTRA_LIBS='-liconv'
--with-freetype-dir --with-jpeg-dir --with-png-dir --with-gd --enable-gd-native-ttf # gd库相关
--enable-exif # 允许单独从jpeg或tiff文件中提出exif头信息,不依赖于gd库
--with-zlib # 增加压缩模块,可能用于http压缩传输
--enable-zip # 支持zip格式文件
--with-libxml-dir=/usr --enable-xml # 启用libxml库
--with-xmlrpc # 类似libxml,允许xml和php变量相互转换
--with-xsl # xslt扩展,对xml进行扩展
--disable-rpath #禁用在搜索路径中传递其他运行库(来源于php.net)??
--enable-bcmath # 任意精度数学库
--enable-shmop # 用于创建linux共享内存段
--enable-sysvsem # 用于linux的信号控制
--enable-inline-optimization # 类传c的inline替换
--with-curl=/usr/local #curl模块
--enable-mbstring --enable-mbregex # 多字节和多字节正则支持
--with-mcrypt # 加密解密模块
--with-openssl=/usr/local/openssl # ssl模块
--with-mhash # 类似mcrypt,但用得不多
--enable-pcntl # 进程控制支持(folk等)
--enable-sockets # sockets扩展,支持socket编程
--enable-ftp # 让php模似ftp客户端
--enable-intl # 国际化模块international
--with-gettext # 同intl模块类似,提供多语言支持
--enable-soap # soap模块,类似概念为web service
--disable-debug # 编译时加入调试符号




exit 0
