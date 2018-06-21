nginx http upstream module 上行流模型
==================================
The `ngx_http_upstream_module` module is used to define groups of servers that can be referenced by the `proxy_pass`/`fastcgi_pass`/`uwsgi_pass`/`scgi_pass`/`memcached_pass`, and `grpc_pass` directives. 

upstream 定义一个上行流
-------------------------------
```
Syntax:  upstream name {...}
Default: ---
Context  http
```
* Defines a group of servers. Servers can listen on different ports. In addition, servers listening on TCP and Unix-domain sockets can be mixed. 
	
	upstream backend {
		server backend1.example.com weight=5;
		server 127.0.0.1:8080  max_fails=3  fail_timeout=30;
		server unix:/tmp/backend3;
		
		server backup1.example.com backup;
		
		server unix:/dev/shm/php-fpm.sock;   # php-fpm的unix风格的sock接口
	}
	
	server {
		location / {
			proxy_pass http://backend;    # 引用定义的一个upstream 
		}
	}