nginx 变量
===================================

$host 主机名  
---------------------------------------
* `http_core_module` 引入
* In this order of precedence: host name from the request line, or host name from "Host" request header field, or the server name matching a request.


$uri 规范化的请求地址
--------------------
* `http_core_module` 引入
* current URI in request, normalized
* The value of `$uri` may change during request processing, e.g. when doing internal rerdirects, or when using index files. 


$args 请求参数
-----------------
* arguments in the request line


$document_root 由root或alias指令定义的value，通常为server块的根目录
-----------------------------------------------------------------
* `root` or `alias` directive's value for the current request. 


$fastcgi\_script\_name  脚本路径(后半部分)
-----------------------------------------
* request URI or, if a URI ends with a slash, request URI with an index file name configured by the `fastcgi_index` directive appended to it. 
	
	fastcgi_index index.php;
	fastcgi_param SCRIPT_FILENAME /home/www/php$fastcgi_script_name;
    // 如果请求地址为 /info/，则SCRIPT_FILENAME=/home/www/php/info/index.php


$remote_addr 客户端地址
-----------------------------------------
* `http_core_module` 引入，客户端的ip地址

$remote_port 客户端的端口
-----------------------------------------
* `http_core_module` 引入, 客户端的端口号


$proxy_host 被代理(后端)服务器的主机名
-----------------------------------------
* `http_proxy_module` 引入
* name and port of a proxied server as specified in the `proxy_pass` directive.


$proxy_port 被代理(后端)服务器的端口
-----------------------------------------
* `http_proxy_module` 引入
* port of a proxied server as specified in the `proxy_pass` directive. 

$proxy\_add\_x\_forwarded_for 
-----------------------------------------
* `http_proxy_module` 引入
* The "X-Forwarded-For" client request header field with the `$remote_add` variable appended to it, seperated by a comma.
* 标准格式为 X-Forwarded-For: client1, proxy1, proxy2


