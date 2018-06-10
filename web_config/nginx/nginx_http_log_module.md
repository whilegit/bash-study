nginx ��־ģ��
=========================================

log_format ������־ģ��
---------------------------------------------
```
Syntax:   log_format name [escape=default|json|none] string ...
Default:  log_format combined "..."
Context:  http
```
```
// ���ǿ���ʹ�õ�����Ϊ combined ��Ԥ����ģ��
log_format combined '$remote_addr - $remote_user [$time_local] '
                    '"$request" $status $body_bytes_sent '
                    '"$http_referer" "$http_user_agent"';
```
* [�ο�����](http://nginx.org/en/docs/http/ngx_http_log_module.html#log_format)
* Specifies log format. ����һ����־ģ��   
  

access_log ���÷�����־
-----------------------------------------------
```
Syntax:  access_log path [format [buffer=size] [gzip[=level]] [flush=time] [if=condition]];
         access_log off;
Default:  access_log  logs/access.log  combined;
Context:  http, server, location, if in location, limit_except
```
* Sets the path, format, and configuration for a buffered log write. 
* �� ��http{}��: access_log /data/log/nginx/access.log more;

