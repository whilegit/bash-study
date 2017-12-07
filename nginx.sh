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

# 监听指定端口的server
server{
   listen 8000; # server.listen指令设置监听的端口,若未设置则默认为80
   root /data/upl; # 若location中没有root指令,则使用server中的root指令
   location / {
   }
}

## 代理设置
server{
   location / {
      # 所有访问此地址的请求都被转发至 http://localost:8000,即一下server块
      proxy_pass http://localhost:8000;
      # 代理设置(详细请查看 proxy.conf部分，附在文末)
      proxy_connect_timeout 300s;
      ...
   }
   # 正则表达式匹配,以~\.开头
   # 如多个location是正则匹配,以最早匹配的前缀为准.
   location ~\.(gif|jpg|jpeg|png)$ { 
      root /data;
   }
}

## fastcgi设置
server{
   location ~\.php$ {
      root /data/www;
      fastcgi_pass location:9000;  # php-fpm进程或其它fastcgi实现。
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      fastcgi_param QUERY_STRING $query_string;
      ... # 更多fastcgi_params的设置，在fastcgi_params.conf中(附在文末)
   }
   location ~\.(gif|jpg|png)$ {
      root /data;
   }
}

###############################
## 完整的proxy.conf文件
proxy_connect_timeout 300s;
proxy_send_timeout 900;
proxy_read_timeout 900;
proxy_buffer_size 32k;
proxy_buffers 4 64k;
proxy_busy_buffers_size 128k;
proxy_redirect off;
proxy_hide_header Vary;
proxy_set_header Accept-Encoding '';
proxy_set_header Referer $http_referer;
proxy_set_header Cookie $http_cookie;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;


########################################################################
## fastcgi_params.conf

fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;

fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  REQUEST_SCHEME     $scheme;
fastcgi_param  HTTPS              $https if_not_empty;

fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;

# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;



exit 0
