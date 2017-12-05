#!/bin/sh

## nginx启动后,可以接收几个命令
nginx -s stop # fast shutdown 立即停止
nginx -s quit # graceful shutdown 平稳关闭,各worker手头的请求会处理完
nginx -s reload # 重新加载配置　

## 日志通常在 /usr/local/nginx/logs或/var/log/nginx, 有access.log和error.log

## nginx配置文件
# 基本结构
...
events{...}
http{
   ...
   server{
      ...
      location{
         ...
      }
      ...
   }
   server{
      location{}
      location{}
   }
   ...
}

# 静态资源处理,对于网页和图片等静态资源,可以直接定义如下的location
#     如果一个server定义了多个location,则前缀最长的location胜出.
#     如访问localhost/index.html 匹配/data/www/index.html
#     如访问localhost/images/icon.png 匹配/data/www/images/icon.png
server{
   location / { # 前缀长度为1,肯定最后匹配
      root /data/www; 
   }
   location /images/ {
      root /data;
   }
}

## 代理设置
server{
   location / {
      # 所有访问此地址的请求都被转发至 http://localost:8000,即一下server块
      proxy_pass http://localhost:8000;
   }
   # 正则表达式匹配,以~\.开头
   # 如多个location是正则匹配,以最早匹配的前缀为准.
   location ~\.(gif|jpg|jpeg|png)$ { 
      root /data;
   }
}
server{
   listen 8000; # server.listen指令设置监听的端口,若未设置则默认为80
   root /data/upl; # 若location中没有root指令,则使用server中的root指令
   location / {
   }
}




exit 0
