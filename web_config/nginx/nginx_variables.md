nginx ����
===================================

$host ������  
---------------------------------------
* `http_core_module` ����
* In this order of precedence: host name from the request line, or host name from "Host" request header field, or the server name matching a request.


$uri �淶���������ַ
--------------------
* `http_core_module` ����
* current URI in request, normalized
* The value of `$uri` may change during request processing, e.g. when doing internal rerdirects, or when using index files. 


$args �������
-----------------
* arguments in the request line


$document_root ��root��aliasָ����value��ͨ��Ϊserver��ĸ�Ŀ¼
-----------------------------------------------------------------
* `root` or `alias` directive's value for the current request. 


$fastcgi\_script\_name  �ű�·��(��벿��)
-----------------------------------------
* request URI or, if a URI ends with a slash, request URI with an index file name configured by the `fastcgi_index` directive appended to it. 
	
	fastcgi_index index.php;
	fastcgi_param SCRIPT_FILENAME /home/www/php$fastcgi_script_name;
    // ��������ַΪ /info/����SCRIPT_FILENAME=/home/www/php/info/index.php


$remote_addr �ͻ��˵�ַ
-----------------------------------------
* `http_core_module` ���룬�ͻ��˵�ip��ַ

$remote_port �ͻ��˵Ķ˿�
-----------------------------------------
* `http_core_module` ����, �ͻ��˵Ķ˿ں�


$proxy_host ������(���)��������������
-----------------------------------------
* `http_proxy_module` ����
* name and port of a proxied server as specified in the `proxy_pass` directive.


$proxy_port ������(���)�������Ķ˿�
-----------------------------------------
* `http_proxy_module` ����
* port of a proxied server as specified in the `proxy_pass` directive. 

$proxy\_add\_x\_forwarded_for 
-----------------------------------------
* `http_proxy_module` ����
* The "X-Forwarded-For" client request header field with the `$remote_add` variable appended to it, seperated by a comma.
* ��׼��ʽΪ X-Forwarded-For: client1, proxy1, proxy2


