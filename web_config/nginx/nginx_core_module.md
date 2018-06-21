nginx core module ����ģ�������
==========================================

user ����������ָ������ʱ���û�����
----------------------------------------------
```
Syntax:  user user [group] 
Default: user nobody nobody;
Context: main
```
* Defines `user` and `group` credentials used by worker processes. If `group` is omitted, a group whose name equals that of `user` is used. 
  > ����������ָ���û�����������`group`����ʱ���丳ֵΪ`user`��ע�⹤�����̵��ļ���ȡȨ��.   


worker_processes ָ���������̵�����
---------------------------------------------------
```
Syntax: worker_processes number | auto;
Default: worker_processes 1;
Context: main
```
* Defines the number of worker processes. 
* The optimal value depends on many factors including (but not limited to) the number of CPU cores, the number of hard disk drives that store data, and load pattern. When one is in doubt, setting it to the number of available CPU cores would be a good start (the value `auto` will try to auto-detect it). 
* ָ��Ϊ`auto`ʱ,���Զ����CPU�ĺ�������


work_rlimit_nofile ����ϵͳ���ļ��������ĸ���
----------------------------------------------
```
Syntax: worker_rlimit_nofile number;
Default: --
Context: main
```
* Changes the limit on the maximum number of open files(`RLIMIT_NOFILE`) for worker processes. Used to increase the limit without restarting the main process.  
* ʹ�� `ulimit -n` ������ϵͳ���ļ��������������ơ� 

error_log ���ô�����־��Ŀ¼
-------------------------------------------------
```
Syntax: error_log file [level];
Default: error_log logs/error.log error;
Context: main,http,mail,stream,server,location
```
* ���ô�����־���ļ������𣻿�ѡ����Ϊ��debug,info,notice,warn,error,crit,alert,emerg, �������������ء�Ĭ��Ϊerror����  


pid ����һ���ļ����������̵�pid
------------------------------------------------------
```
Syntax:  pid file;
Default: pid logs/nginx.pid; 
Context: main
```
* Defines a `file` that will store the process ID of the main process. 


events ��������ص�����(�鼶)
------------------------------------------------------
```
Syntax:  events {...}
Default: ---
Context: main
```
* Provides the configuration file context in which the directives that affect connection processing are specified.  
* ͨ����������Ϊ 
  ```
  events{
  	worker_connections  65535;    
  	use epoll; 
  }
  ```

work_connections ����һ�����̵Ŀ���ͬʱ�򿪵����������
-------------------------------------------------------
```
Syntax:  worker_connections number;
Default: worker_connections 512;
Context: events
```
* Sets the maximum number of simultaneous connections that can be opened by a worker process. 
* It should be kept in mind that this number includes all connections (e.g. connections with proxied servers, among others), not only connections with clients. 
* Another consideration is that the actual number of simultaneous connections cannot exceed the current limit on the maximum number of open files, which can be changed by `worker_rlimit_nofile`. ������Ҳ���ļ���������һ�֡�


use ����ʹ�õ��¼����� 
------------------------------------------------------
```
Syntax: use method;
Default: ---
Context: events
```
* Specifies the `connection processing` method to use. There is normally no need to specify it explicitly, becauses nginx will by default use the most effient method. ͨ���������ã�nginx���Զ�ѡ������Ч���¼����ơ�Linux Core 2.6�Ժ����ʹ�� epoll. 
  ```
  use epoll;
  ```
  
http ��http��ص��ļ�����(�鼶)
-----------------------------------------------------
```
Syntax:  http{...}
Default: ---
Context: main
```
* Provides the configuration file context in which the HTTP server directives are specified. 



include ���������ļ�
-----------------------------------------------------
```
Syntax:  include file|mask;
Default: ---
Context: any
```
* Includes another `file` or files matching the specified `mask` into configuration. Included files should consist of syntactically correct directives and blocks. 
* �� include mime.types;  include vhosts/*.conf;  ������ȷ�ġ�


types ��Ӧ���ʱ���ļ���չ����MIME֮���ӳ��
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
* �����Ӧʱ����ͬ���ļ���չ�����ò�ͬ��MIME���ͣ��Թ��������ȷ����
* Maps file name extensions to MIME types of responses. Extensions aree case-insensitive. Several extensions can be mapped to one type, for example:
  ```
  types {
  	  application/octet-stream bin exe dll;
  	  application/octet-stream deb;
  	  ...
  }
  ```
* A sufficiently full mapping table is distributed with nginx in the `conf/mime.types` file.
* ����ֱ�� `include mime.types` �ļ���


default_type ����Ĭ�ϵ�ý������
------------------------------------------------------
```
Syntax:   default_type mime-type;
Default:  default_type text/plain;
Context:  http,server,location
```
* Defines the default MIME type of a response. Mapping of file name extensions to MIME types can be set with the types directive. 
* ����Ҫĳ��location{}����http{}��types����, ȫ������ `application/octet-stream` ����, �����ʹ������ָ��:
  ```
  location /download/ {
  	  types {}
  	  default_type application/octet-stream;
  }
  ```
 
sendfile �����Ƿ����� sendfile() ϵͳ����
-------------------------------------------------
```
Syntax:  sendfile on | off;
Default: sendfile off;
Context: http, server, location, if in location
```
* Enables of disables the user of sendfile().  �Ƿ�����ϵͳ���� sendfile(). 
* ��ͨTCPͨѶ��, �û��ռ�read(FILE *),����ϵͳ����read, �л����ں˶�ȡ�ļ����ŵ��ں�buffer�У����Ƶ��û��ռ��buffer�У��û�����socket writeϵͳ����, �����û��ռ��buffer���ں�buffer��, Ȼ���ں˽�buffer���͵�Э��ջ�У����ͨѶ��
* ���� sendfile ��ͨѶ����� �û�����sendfileϵͳ���ã��ں˶�ȡ�ļ����ں�buffer�У��ں���ֱ���͵�Э��ջ�У����ͨѶ���м��ʡ���û�̬�Ĳ���Ҫ���ƣ������Ч�ʡ�


tcp_nopush �Ƿ����� TCP-NOPUSH ѡ��
-----------------------------------------------------
```
Syntax:   tcp_nopush on | off;
Default:  tcp_nopush off;
Context:  http, server, localtion
```
* ����Ҫ��sendfile����ʹ�ã�������Ч��
* ��������sendfileѡ����Ƿ���Ӧͷ�Ͳ����ļ��Ŀ�ͷ���� ���һ�������͵����ͻ��ˡ� Ĭ������£�tcp_nopush�ǹرյġ�
* ʹ�ļ��������ͣ������ǲ�ֳ�С������,��˵������ļ������ý����� TCP_NODELAY ѡ� 

tcp_nodelay �Ƿ�����TCP-NODELAY ѡ��
------------------------------------------------------
```
Syntax:  tcp_nodelay on | off;
Default: tcp_nodelay on;
Context: http, server, location
```
* �� keep-aliveģʽ�£������ж���TCP���������������ͻ��˶�û��0.2s���ӳ١�  
* ע�⣺__�������� sendfile �� tcp_nopush �󣬵������ļ�ʱ��ѡ��(tcp-nodelay)�������ԡ�__


underscores\_in\_headers �Ƿ�����ͻ��˵���������ʹ���»���
-----------------------------------------------------------
```
Syntax:  underscores_in_headers on | off;
Default: underscores_in_headers off;
Context: http, server
```
* Enables or disables the use of underscores in client request header fields. When the use of underscores is disabled, request header fields whose names contain underscores are marked as invalid and become subject to the `ignore_invalid_headers` directive.  
* If the directive is specified on the `server` level, its value is only used if a server is a default one. 
* �����������ô����ͷ�����»��ߵ��ֶζ�����������


server\_names\_hash\_bucket\_size ���� Server_name�Ĺ�ϣ���С?? ���ò��Ǻ�����
----------------------------------------------------------
```
Syntax:  server_names_hash_bucket_size size;
Default: server_names_hash_bucket_size 32|64|128;
Context: http
```
* Sets the bucket size of the server names hash tables. 


keepalive_timeout  �����ӳ�ʱ����
------------------------------------------
```
Syntax:  keepalive_timeout timeout [header_timeout];
Default: keepalive_timeout 75s;
Context: http, server, location
```
* The first parameter sets a timeout during which a keep-alive client connection will stay open on the server side. The zero value disables keep-alive client connections. The optional second parameters sets a value in the `Keep-Alive: timeout=time` response header field. Two parameters may differ.


client\_max\_body\_size �������������������С
----------------------------------------------
```
Syntax:  client_max_body_size size;
Default: client_max_body_size 1m;
Context: http, server, location
```
* Sets the maximum allowed size of the client request body, specified in the "Content-Length" request header field. If the size in a request exceeds the configured value, the 413 (Request Entity Too Large) error is returned to the client. 


client\_body\_buffer\_size �����������ڴ滺����
----------------------------------------------
```
Synatx:  client_body_buffer_size size;
Default: client_body_buffer_size 8k|16k;
Context: http, server, location
```
* Sets buffer size for reading client request body. In case the request body is larger than the buffer, the whole body or only its part is written to a temporary file. By default, buffer size if equal to two memory pages.  
* ����ͻ��˵��������С���� `client_body_buffer_size`���ã���ô��������Ĳ��ֻ�ȫ���������浽�ļ��У�������һЩI/O������


listen ����ĳ���˿�
-------------------
```
Syntax:   listen address[:port] ....
          listen port ....
          listen unix:path ....
Default:  listen *:80 | *:8000;
Context:  server
```
* �� server���У����� server���м����Ķ˿ڡ�


server_name ��������������
-------------------------
```
Syntax:  server_name name ...  
Default: server_name "";
Context: server
```
* Sets names of a virtual server. 

	// ������������, �����Ƕ��, ��һ��Ϊ primary server name. 
	server {
		server_name example.com www.example.com;
	}
	
	// ʹ�� *ͨ���������ǰ��Ĳ��� �� �����Ĳ���  
	server {
		server_name example.com *.example.com www.example.*
	}
	
	// ��ǰ����һ�����
	server {
		server_name .example.com;   // ��ʾ example.com �� *.example.com
	}
	
	// ʹ��������ʽ, ǰ׺ ~ ��ʾ����һ��������ʽ
	server {
		server_name www.example.com ~^www\d+\.example\.com$;
	}
	
	// ������ʽ�Ĳ�׽(��˳��)  
	server {
		server_name ~^(www\.)?(.+)$; 
		location / {
			root /sites/$2;
		}
	}
	
	// ������ʽ�Ĳ�׽,����������
	server {
		server_name ~^(www\.)?(?<domain>.+)$;
		location / {
			root /sites/$domain;
		}
	}
	
	/** server_name��ƥ��˳�� **/
	1. the exact name
	2. the longest wildcard name starting with an asterisk, e.g. "*.example.com"
	3. the longest wildcard name ending with an asterisk, e.g. "mail.*"
	4. the first matching regular expression (in order of appearance in the configuration file)
	
	
root ���ø�Ŀ¼
---------------
```
Syntax:  root path; 
Default: root html;
Context: http, server, location, if in location
```
* Sets the root directory for requests.
	
	// ��������, �����ַ /i/top.gifʱ������ /data/w3/i/top.gif �ļ����ͻ��ˡ�
	location /i/ {
		root /data/w3;
	}
	
* `path`λ�ý��ܱ�������������Ϊ`$document_root` �� `$realpath_root`����������


set ���ñ���
-----------
```
Syntax:  set $variable value;
Default: ---
Context: server, location, if
```
* Sets a `value` for the specified variable.


if �������
-----------
```
Syntax:  if (condition) { ... }
Default: ---
Context: server, location
```
* �������ʽ
	
	// ��Сд���е�������ʽ����
	if ( $http_user_agent ~ MSIE) {
		rewrite ^(.*)$ /msie/$1 break;
	}
	
	// ��Сд�����е�������ʽ����
	if ( $http_cookie ~* "id=([^;]+)(?:;|$)" ) {
		set $id $1
	}
	
	// �����ַ�������
	if( $request_method = 'OPTIONS') {
		add_header 'Access-Controller-Allow-Origin' *;
	}
	

index ��������ҳ 
--------------------
```
Syntax:  index file ...
Default: index index.html; 
Context: http, server, location
```
* ʵ�������� __ngx_http_index_module__ �ﶨ��.
* The module processes requests ending with the slash character('/'). 
* ���ڽ�βΪ/�����󣬽�����һ���ڲ��ض���
* ���һ���ļ������Ǿ���·����


location �����ַ��
-------------------------
```
Syntax:  location [ = | ~ | ~* | ^~ ] uri {...}
Default: ---
Context: server, location
```
* Sets configuration depending on a request URI. ���� �����uri��������Ӧ�����á�
	
	// ��ȷ�����ַ, ƥ�䵽��ȷ��ַ������ʹ���������ã�����������ֹ(������ƥ��������ʽ)
	location = / {
		[ configuration A ]
	}
	
	// ǰ׺��ַ: 
	location / {
		[ configuration B ]
	}
	
	// �ϳ���ǰ׺ƥ��
	location /documents/ {
		[ configuration C ]
	}
	
	// ����ֹ��Ϊ��ǰ׺ƥ�䡣
	location ^~ /images/ {
		[ configuration D ]
	}
	
	// ����ƥ��
	location ~* \.(gif|jpg|jpeg)$ {
		[ configuration E ]
	}
	
	/** location ��ƥ���߼� **/
    1. �Ƚ��о�ȷƥ�䣬����������ʹ�ø����ã�
    2. Ȼ�����ȫ����ǰ׺ƥ��,��������Ǹ�ƥ�䣻
    3. ��2�����Ǹ��ƥ�丽����ֹ����(^~)��������ʹ�ø�ƥ��; 
    4. ��������ƥ�䣬ֱ����һ��ƥ��ɹ�Ϊֹ�����У�������ʹ�ø�ƥ�䣻
    5. ��û��һ������ƥ��ɹ�����ʹ�õ�2����¼�������Ǹ�ƥ�䡣
    
* ��� uriǰ����� @ ���ţ�������������ĵ�ַ�飬���Ա�����ָ��ʹ��


try_files ����ļ��Ƿ���ڣ�����Ӧ��������
-----------------------------------------
```
Syntax:  try_files file ... uri; 
         try_files file ... =code; 
Default: --- 
Context: server, location
```
* Checks the existence of files in the specified order and uses the first found file for request processing; the processing is performed in the current context. 

    // ��� $uri�ļ��Ƿ���ڣ��������ʹ��֮���粻���ڣ��򷵻� /images/default.gif
	location /images/ {
		try_files $uri /images/default.gif;
	}
	
	// ���һ�� =404 ��ʾʵ���Ҳ����ļ�ʱ������һ��404״̬��
	location / {
		try_files $uri $uri/index.html $uri.html =404;  
	}
	
	// ת��������ַ��
	location / {
		try_files /systen/maintenance.html $uri $uri/index.html $uri.html @mongrel; 
	}
	location @mongrel {               // ����һ����mongrel�ľ�����ַ��
		proxy_pass http://mongrel;     // ���ڵ� mongrel ������ upstream��
	}









