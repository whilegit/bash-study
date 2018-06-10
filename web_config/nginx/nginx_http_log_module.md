nginx 日志模块
=========================================

log_format 设置日志模板
---------------------------------------------
```
Syntax:   log_format name [escape=default|json|none] string ...
Default:  log_format combined "..."
Context:  http
```
```
// 总是可以使用的名称为 combined 的预定义模板
log_format combined '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent"';
```
* [参考链接](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format)
* Specifies log format. 定义一个日志模板   
  

access_log 设置访问日志
-----------------------------------------------
```
Syntax:  access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];
         access_log off;
Default:  access_log  logs/access.log  combined;
Context:  http, server, location, if in location, limit_except
```
* Sets the path, format, and configuration for a buffered log write. 
* 如 在http{}中: access_log /data/log/nginx/access.log more;

