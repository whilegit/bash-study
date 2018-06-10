#!/bin/sh

## nginx启动后,可以接收几个命令
nginx -s stop # fast shutdown 立即停止
nginx -s quit # graceful shutdown 平稳关闭,各worker手头的请求会处理完
nginx -s reload # 重新加载配置
nginx -s reopen # 重新打开日志文件

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

## server块的一般信息
# 当一个请求到达服务器后，nginx将判定哪一个server块处理该请求。
# 通常来说，一个server对应三元数组 [ip, socket, server_name], 当三者匹配上后，该server块就会服务于该次请求。
# listen的默认值为 80(单ip情况下), server_name的默认值为"". 
# 每一个端口，都会建立三个hash表，代表该端口所绑定的虚拟主机, 并且该端口可以设定一个默认虚拟主机。
#     实际上，每个server可以监听多个端口.
# server_name的匹配顺序:
1. 精确名称，如找到则立即使用；
2. 最长的形如 *.abc.example.org 类型的名称，如找到则立即使用；
3. 最长的形如 example.* 类型的名称，如找到则立即使用
4. 最先找到的那个正则匹配的名称

# 位于80端口的虚拟主机youdomain.com
server{ listen 80; server_name youdomain.com www.youdomain.com; ... } 
# 使用了default_server属性后(默认主机绑定到80端口)，未匹配到host的请求将被本server块处理，
# 而不是发给第一个server块
server{ listen 80 default_server; server_name youdomain.com; ... }    
# 禁止请求头中Host不匹配的请求访问。加上本server块后，未匹配到host的请求将被禁止访问。
server{ listen 80; server_name ""; return 444;} 
# 如果本机配置了多ip，则必须了提供ip地址
server{ listen 192.168.0.11:80; server_name mydomain.com; ...} 
# 带通配符(wildcard)的域名
server { listen 80; server_name *.example.org; ... } 
server { listen 80; server_name mail.*; ... }  
# 带正则表达式的server_name,附带?<user>捕捉,后续root指令可以使用$user表示捕捉到的值
# 提示：如正则表达式里有{}符号,要把整个server_name后面的内容用引号括起来。
server { listen 80; server_name ~^(?<user>.+)\.example\.net$; ... }


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
   location / {
      root /data/www;
      # 设置默认页面，若文件存在,则进行内部重定向，再次匹配location
      index index.html index.php; 
   }
   location ~\.php$ {
      root /data/www;
      fastcgi_pass host:9000;  # php-fpm进程或其它fastcgi实现。
      # $document_root 的值由 root配置指令设定，此处为/data/www
      # $fastcgi_script_name 是访uri除去域名部分之后的地址，如/index.php
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      fastcgi_param QUERY_STRING $query_string;
      ... # 更多fastcgi_params的设置，在fastcgi_params.conf中(附在文末)
   }
   location ~\.(gif|jpg|png)$ {
      root /data;
   }
}

###### location 语法规则 #############
# Syntax:    location [ = | ~ | ~* | ^~ ] uri {...}
#            location @name {...}
location uri {}    # 前缀匹配(普通)
location ^~ uri {} # 前缀区配(若最长，则不再进行正则匹配)
location = uri {}  # 前缀精准匹配(若匹配，则不再进行后续的匹配)
location ~ uri {}  # 正则匹配(大小写敏感)
location ~* url {} # 正则匹配(不区分大小写)
# 配置规则
# 1. 先按顺序依次进行前缀匹配,并记录最长前缀的那个location;
# 2. 在1的匹配中，若遇到前缀精准匹配,则立即停止其余匹配;
# 3. 步聚1中最终将获得一个最长匹配, 若该location以 ^~ 标示，则立即结束匹配;
# 4. 按先后顺序，进行正则匹配；
# 5. 在4中，一旦有匹配，则立即停止匹配；
# 6. 若4中没有任何一个匹配，则取出3中保存的那个最长的匹配；
# 注：在前缀普通匹配中，字符串以/结尾，且后续是代理proxy相关的指令，如: location /user/ {} 
#     a). 如$uri为 /user ,那么将会产生一个301重定向至 /user/ 
#     b). 如不希望生产301重定向，那么应 再定义一个 location /user {..}块,里面的设置与 /user/ 块相关 

location @name {} # 命名的location,不用于常规地址匹配，仅用于重定向(redirect)

location /user {
   # Syntax: try_files file ... uri; # 最后一个uri是内部重定向的去处
   #         try_files file ... =code;  如try_files $uri =404;
   try_files $uri @httpd; # 表示若未找到@uri,则内部重定向至@httpd这个命名的location
   # 注意：一个location只能使用一个try_files指令
   # 如果当前文件不存在，那么重定向至/images/default.gif(应有另一个location能够匹配这个重定向地址。)
   try_files $uri /images/default.gif; 
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
