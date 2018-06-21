nginx core module 核心模块的命令
==========================================

user 给工作进程指定运行时的用户及组
----------------------------------------------
```
Syntax:  user user [group] 
Default: user nobody nobody;
Context: main
```
* Defines `user` and `group` credentials used by worker processes. If `group` is omitted, a group whose name equals that of `user` is used. 
  > 给工作进程指定用户名。若忽略`group`参数时给其赋值为`user`。注意工作进程的文件读取权限.   


worker_processes 指定工作进程的数量
---------------------------------------------------
```
Syntax: worker_processes number | auto;
Default: worker_processes 1;
Context: main
```
* Defines the number of worker processes. 
* The optimal value depends on many factors including (but not limited to) the number of CPU cores, the number of hard disk drives that store data, and load pattern. When one is in doubt, setting it to the number of available CPU cores would be a good start (the value `auto` will try to auto-detect it). 
* 指定为`auto`时,将自动检测CPU的核心数；


work_rlimit_nofile 覆盖系统的文件描述符的个数
----------------------------------------------
```
Syntax: worker_rlimit_nofile number;
Default: --
Context: main
```
* Changes the limit on the maximum number of open files(`RLIMIT_NOFILE`) for worker processes. Used to increase the limit without restarting the main process.  
* 使用 `ulimit -n` 将看到系统的文件描述符数量限制。 

error_log 设置错误日志的目录
-------------------------------------------------
```
Syntax: error_log file [level];
Default: error_log logs/error.log error;
Context: main,http,mail,stream,server,location
```
* 设置错误日志的文件及级别；可选级别为：debug,info,notice,warn,error,crit,alert,emerg, 从左到右依次严重。默认为error级别。  


pid 设置一个文件保存主进程的pid
------------------------------------------------------
```
Syntax:  pid file;
Default: pid logs/nginx.pid; 
Context: main
```
* Defines a `file` that will store the process ID of the main process. 


events 跟连接相关的配置(块级)
------------------------------------------------------
```
Syntax:  events {...}
Default: ---
Context: main
```
* Provides the configuration file context in which the directives that affect connection processing are specified.  
* 通常的配置项为 
  ```
  events{
  	worker_connections  65535;    
  	use epoll; 
  }
  ```

work_connections 设置一个进程的可以同时打开的最大连接数
-------------------------------------------------------
```
Syntax:  worker_connections number;
Default: worker_connections 512;
Context: events
```
* Sets the maximum number of simultaneous connections that can be opened by a worker process. 
* It should be kept in mind that this number includes all connections (e.g. connections with proxied servers, among others), not only connections with clients. 
* Another consideration is that the actual number of simultaneous connections cannot exceed the current limit on the maximum number of open files, which can be changed by `worker_rlimit_nofile`. 连接数也是文件描述符的一种。


use 设置使用的事件机制 
------------------------------------------------------
```
Syntax: use method;
Default: ---
Context: events
```
* Specifies the `connection processing` method to use. There is normally no need to specify it explicitly, becauses nginx will by default use the most effient method. 通常无需设置，nginx会自动选择最有效的事件机制。Linux Core 2.6以后可以使用 epoll. 
  ```
  use epoll;
  ```
  
http 跟http相关的文件配置(块级)
-----------------------------------------------------
```
Syntax:  http{...}
Default: ---
Context: main
```
* Provides the configuration file context in which the HTTP server directives are specified. 



include 包含配置文件
-----------------------------------------------------
```
Syntax:  include file|mask;
Default: ---
Context: any
```
* Includes another `file` or files matching the specified `mask` into configuration. Included files should consist of syntactically correct directives and blocks. 
* 如 include mime.types;  include vhosts/*.conf;  都是正确的。


types 响应输出时，文件扩展名与MIME之间的映射
------------------------------------------------------
```
Syntax:  types { ... }
Default: types { 
             text/html   html;
             image/gif   gif;
             images/jpeg jpg;
         }
Context: http, server, location
```
* 输出响应时，不同的文件扩展名设置不同的MIME类型，以供浏览器正确解析
* Maps file name extensions to MIME types of responses. Extensions aree case-insensitive. Several extensions can be mapped to one type, for example:
  ```
  types {
  	  application/octet-stream bin exe dll;
  	  application/octet-stream deb;
  	  ...
  }
  ```
* A sufficiently full mapping table is distributed with nginx in the `conf/mime.types` file.
* 建议直接 `include mime.types` 文件。


default_type 设置默认的媒体类型
------------------------------------------------------
```
Syntax:   default_type mime-type;
Default:  default_type text/plain;
Context:  http,server,location
```
* Defines the default MIME type of a response. Mapping of file name extensions to MIME types can be set with the types directive. 
* 如需要某个location{}忽略http{}的types设置, 全部改用 `application/octet-stream` 类型, 则可以使用如下指令:
  ```
  location /download/ {
  	  types {}
  	  default_type application/octet-stream;
  }
  ```
 
sendfile 设置是否启用 sendfile() 系统调用
-------------------------------------------------
```
Syntax:  sendfile on | off;
Default: sendfile off;
Context: http, server, location, if in location
```
* Enables of disables the user of sendfile().  是否启用系统调用 sendfile(). 
* 普通TCP通讯中, 用户空间read(FILE *),产生系统调用read, 切换到内核读取文件，放到内核buffer中，复制到用户空间的buffer中，用户调用socket write系统调用, 复制用户空间的buffer至内核buffer中, 然后内核将buffer发送到协议栈中，完成通讯。
* 启用 sendfile 后，通讯变成了 用户调用sendfile系统调用，内核读取文件到内核buffer中，内核再直接送到协议栈中，完成通讯，中间节省了用户态的不必要复制，提高了效率。


tcp_nopush 是否启用 TCP-NOPUSH 选项
-----------------------------------------------------
```
Syntax:   tcp_nopush on | off;
Default:  tcp_nopush off;
Context:  http, server, localtion
```
* 必须要与sendfile搭配使用，否则无效。
* 当启用了sendfile选项后，是否将响应头和部分文件的开头部分 打成一个包发送到至客户端。 默认情况下，tcp_nopush是关闭的。
* 使文件满包发送，而不是拆分成小包发送,因此当发送文件此设置将覆盖 TCP_NODELAY 选项。 

tcp_nodelay 是否启用TCP-NODELAY 选项
------------------------------------------------------
```
Syntax:  tcp_nodelay on | off;
Default: tcp_nodelay on;
Context: http, server, location
```
* 在 keep-alive模式下，不管有多大的TCP包，立即发送至客户端而没有0.2s的延迟。  
* 注意：__当开启了 sendfile 和 tcp_nopush 后，当发送文件时本选项(tcp-nodelay)将被忽略。__


underscores\_in\_headers 是否允许客户端的请求域中使用下划线
-----------------------------------------------------------
```
Syntax:  underscores_in_headers on | off;
Default: underscores_in_headers off;
Context: http, server
```
* Enables or disables the use of underscores in client request header fields. When the use of underscores is disabled, request header fields whose names contain underscores are marked as invalid and become subject to the `ignore_invalid_headers` directive.  
* If the directive is specified on the `server` level, its value is only used if a server is a default one. 
* 如果开启，那么请求头中有下划线的字段都将被舍弃。


server\_names\_hash\_bucket\_size 设置 Server_name的哈希表大小?? 作用不是很明白
----------------------------------------------------------
```
Syntax:  server_names_hash_bucket_size size;
Default: server_names_hash_bucket_size 32|64|128;
Context: http
```
* Sets the bucket size of the server names hash tables. 


keepalive_timeout  长连接超时设置
------------------------------------------
```
Syntax:  keepalive_timeout timeout [header_timeout];
Default: keepalive_timeout 75s;
Context: http, server, location
```
* The first parameter sets a timeout during which a keep-alive client connection will stay open on the server side. The zero value disables keep-alive client connections. The optional second parameters sets a value in the `Keep-Alive: timeout=time` response header field. Two parameters may differ.


client\_max\_body\_size 设置请求体的最大允许大小
----------------------------------------------
```
Syntax:  client_max_body_size size;
Default: client_max_body_size 1m;
Context: http, server, location
```
* Sets the maximum allowed size of the client request body, specified in the "Content-Length" request header field. If the size in a request exceeds the configured value, the 413 (Request Entity Too Large) error is returned to the client. 


client\_body\_buffer\_size 设置请求体内存缓冲区
----------------------------------------------
```
Synatx:  client_body_buffer_size size;
Default: client_body_buffer_size 8k|16k;
Context: http, server, location
```
* Sets buffer size for reading client request body. In case the request body is larger than the buffer, the whole body or only its part is written to a temporary file. By default, buffer size if equal to two memory pages.  
* 如果客户端的请求体大小超过 `client_body_buffer_size`设置，那么该请求体的部分或全部将被缓存到文件中，增加了一些I/O操作。


listen 监听某个端口
-------------------
```
Syntax:   listen address[:port] ....
          listen port ....
          listen unix:path ....
Default:  listen *:80 | *:8000;
Context:  server
```
* 在 server块中，设置 server块中监听的端口。


server_name 设置虚拟主机名
-------------------------
```
Syntax:  server_name name ...  
Default: server_name "";
Context: server
```
* Sets names of a virtual server. 

	// 定义虚拟主机, 可以是多个, 第一个为 primary server name. 
	server {
		server_name example.com www.example.com;
	}
	
	// 使用 *通配符代替最前面的部分 或 最后面的部分  
	server {
		server_name example.com *.example.com www.example.*
	}
	
	// 最前面是一个点号
	server {
		server_name .example.com;   // 表示 example.com 和 *.example.com
	}
	
	// 使用正则表达式, 前缀 ~ 表示这是一个正则表达式
	server {
		server_name www.example.com ~^www\d+\.example\.com$;
	}
	
	// 正则表达式的捕捉(按顺序)  
	server {
		server_name ~^(www\.)?(.+)$; 
		location / {
			root /sites/$2;
		}
	}
	
	// 正则表达式的捕捉,并创建变量
	server {
		server_name ~^(www\.)?(?<domain>.+)$;
		location / {
			root /sites/$domain;
		}
	}
	
	/** server_name的匹配顺序 **/
	1. the exact name
	2. the longest wildcard name starting with an asterisk, e.g. "*.example.com"
	3. the longest wildcard name ending with an asterisk, e.g. "mail.*"
	4. the first matching regular expression (in order of appearance in the configuration file)
	
	
root 设置根目录
---------------
```
Syntax:  root path; 
Default: root html;
Context: http, server, location, if in location
```
* Sets the root directory for requests.
	
	// 以下设置, 请求地址 /i/top.gif时将发放 /data/w3/i/top.gif 文件给客户端。
	location /i/ {
		root /data/w3;
	}
	
* `path`位置接受变量，但不可以为`$document_root` 和 `$realpath_root`这两个变量


set 设置变量
-----------
```
Syntax:  set $variable value;
Default: ---
Context: server, location, if
```
* Sets a `value` for the specified variable.


if 条件语句
-----------
```
Syntax:  if (condition) { ... }
Default: ---
Context: server, location
```
* 条件表达式
	
	// 大小写敏感的正则表达式测试
	if ( $http_user_agent ~ MSIE) {
		rewrite ^(.*)$ /msie/$1 break;
	}
	
	// 大小写不敏感的正则表达式测试
	if ( $http_cookie ~* "id=([^;]+)(?:;|$)" ) {
		set $id $1
	}
	
	// 测试字符串内容
	if( $request_method = 'OPTIONS') {
		add_header 'Access-Controller-Allow-Origin' *;
	}
	

index 设置索引页 
--------------------
```
Syntax:  index file ...
Default: index index.html; 
Context: http, server, location
```
* 实际上是在 __ngx_http_index_module__ 里定义.
* The module processes requests ending with the slash character('/'). 
* 处于结尾为/的请求，将产生一个内部重定向。
* 最后一个文件可以是绝对路径。


location 定义地址块
-------------------------
```
Syntax:  location [ = | ~ | ~* | ^~ ] uri {...}
Default: ---
Context: server, location
```
* Sets configuration depending on a request URI. 根据 请求的uri，设置相应的配置。
	
	// 精确定义地址, 匹配到精确地址后立即使用它的配置，搜索立即终止(即不再匹配正则表达式)
	location = / {
		[ configuration A ]
	}
	
	// 前缀地址: 
	location / {
		[ configuration B ]
	}
	
	// 较长的前缀匹配
	location /documents/ {
		[ configuration C ]
	}
	
	// 附终止行为的前缀匹配。
	location ^~ /images/ {
		[ configuration D ]
	}
	
	// 正则匹配
	location ~* \.(gif|jpg|jpeg)$ {
		[ configuration E ]
	}
	
	/** location 的匹配逻辑 **/
    1. 先进行精确匹配，如有则立即使用该配置；
    2. 然后进行全部的前缀匹配,记下最长的那个匹配；
    3. 第2步中那个最长匹配附还终止条件(^~)，则立即使用该匹配; 
    4. 进行正则匹配，直到有一个匹配成功为止；如有，则立即使用该匹配；
    5. 如没有一个正则匹配成功，则使用第2步记录下来的那个匹配。
    
* 如果 uri前面加有 @ 符号，则这个是命名的地址块，可以被其它指令使用


try_files 检查文件是否存在，并相应处理请求
-----------------------------------------
```
Syntax:  try_files file ... uri; 
         try_files file ... =code; 
Default: --- 
Context: server, location
```
* Checks the existence of files in the specified order and uses the first found file for request processing; the processing is performed in the current context. 

    // 检查 $uri文件是否存在，如存在则使用之；如不存在，则返回 /images/default.gif
	location /images/ {
		try_files $uri /images/default.gif;
	}
	
	// 最后一个 =404 表示实在找不到文件时，返回一个404状态码
	location / {
		try_files $uri $uri/index.html $uri.html =404;  
	}
	
	// 转给其他地址块
	location / {
		try_files /systen/maintenance.html $uri $uri/index.html $uri.html @mongrel; 
	}
	location @mongrel {               // 定义一个叫mongrel的具名地址块
		proxy_pass http://mongrel;     // 此于的 mongrel 定义在 upstream中
	}









