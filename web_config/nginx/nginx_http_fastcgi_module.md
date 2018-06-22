nginx http fastcgi module
=========================

fastcgi_pass 设置FastCGI服务器地址
---------------------------------
```
Syntax:  fastcgi_pass address;
Default: ---
Context: location, if in location
```
* Sets the address of a FastCGI server. The address can be specified as a domain name or IP address, and a port; 
	
	// 设置本机的9000端口为本地址块的FastCGI服务器
	fastcgi_pass localhost:9000;
	
	// 使用 unix风格的 socket 地址 
	fastcgi_pass  unix:/tmp/fastcgi.socket;
	
	// 使用 upstream 指令定义的上行流  
	fastcgi_pass  php-dev;   


fastcgi_param 设置传给fastcgi的变量
----------------------------------
```
Syntax:  fastcgi_param  parameter value [if_not_empty];
Default: ---
Context: http, server, location
```
* Sets a `parameter` that should be passed to the FastCGI server. The `value` can contain text, variables, and their combination. The following example shows the minimum required setting for PHP:

    // 给 PHP 至少定义两个变量 
	fastcgi_param SCRIPT_FILENAME /home/www/php$fastcgi_script_name;
	fastcgi_param QUERY_STRING $query_string 
	
	// 其它变量
	fastcgi_param REQUEST_METHOD $request_method;
	fastcgi_param CONTENT_TYPE   $content_type;
	fastcgi_param CONTENT_LENGTH $content_length;
	
	
fastcgi_index 设置目录的索引页
-----------------------------
```
Syntax:  fastcgi_index name;
Default: ---
Context: http, server, location
```
* Sets a file name that will be appended after a URI that ends with a slash, in the value of `fastcgi_script_name`. 


fastcgi\_connect\_timeout 设置fastcgi的连接建立超时时间
-----------------------------------------------------
```
Syntax:  fastcgi_connect_timeout time;
Default: fastcgi_connect_timeout 60s;
Context: http, server, location
```
* Defines a timeout for establishing a connection with a FastCGI server. It should be noted that this timeout cannot usually exceed 75 seconds. 


fastcgi\_keep\_conn  保持代理关系的长连接
---------------------------------------
```
Syntax:  fastcgi_keep_conn  on | off;
Default: fastcgi_keep_conn  off;
Context: http, server, location
```
* By default, a FastCGI server will close a connection right after sending the response. However, when this directive is set to the value `on`, nginx will instruct a FastCGI server to keep connections open. 


fastcgi\_send\_timeout 设置nginx向fastcgi服务器转发请求头时的一种超时
-------------------------------------------------------------------
```
Syntax:  fastcgi_send_timeout time;
Default: fastcgi_send_timeout 60s;
Context: http, server, location
```
* Sets a timeout for transmitting a request to the FastCGI server. The timeout is set only between two successive write operatios, not for the transmission of the whole request. 


fastcgi\_read\_timeout 设置nginx从fastcgi服务器读取response的一种超时
-------------------------------------------------------------------
```
Syntax:  fastcgi_read_timeout  time;
Default: fastcgi_read_timeout  60s;
Context: http, server, location
```
* Defines a timeout for reading a response from the FastCGI server. The timeout is set only between two successive read operations, not for the transmission of the whole response. If the FastCGI server does not transmit anything within this time, the connection is closed.  


fastcgi\_buffer\_size 设置读取 fastcgi响应的第一块响应内容的缓冲区
---------------------------------------------------------------
```
Syntax:  fastcgi_buffer_size  size;
Default: fastcgi_buffer_size  4k|8k;
Context: http, server, location;
```
* Sets the `size` of the buffer used for reading the first part of the response received from the FastCGI server. This part usually contains a small response header. 


fastcgi_buffers 设置某个fastcgi连接所使用的缓冲区数量及大小
---------------------------------------------------------
```
Syntax:   fastcgi_buffers number size;
Default:  fastcgi_buffers 8 4k|8k;
Context:  http, server, location
```
* Sets the `number` and `size` of the buffers used for reading a response from the FastCGI server, for a single connection. 
 

fastcgi\_busy\_buffers\_size 从fastcgi_buffers中划出的一块特殊缓冲区
------------------------------------------------------------------
```
Syntax:   fastcgi_busy_buffers_size  size;
Default:  fastcgi_busy_buffers_size  8k|16k;
Context:  http, server, location
```
* When buffering of responses from the FastCGI server is enabled, limits the total size of buffers that can be busy sending a response to the client while the response is not yet fully read.  


fastcgi\_temp\_file\_write\_size 缓冲区不够时，多出的内容一次性写入临时文件的大小
--------------------------------------------------------------------------------
```
Syntax:  fastcgi_temp_file_write_size  size;
Default: fastcgi_temp_write_size  8k|16k;
Context: http, server, location
```
* Limits the size of data written to a temporary file at a time, when buffering of responses from the FastCGI server to temporary files is enabled. 


fastcgi\_intercept\_errors 是否拦截fastcgi服务器传回的大于等于300的HTTP状态码 
----------------------------------------------------------------------------
```
Syntax:  fastcgi_intercept_errors on | off;
Default: fastcgi_intercept_errors off;
Context: http, server, location
```
* Determines whether FastCGI server responses with codes greater than or equal to 300 should be passed to a client or be intercepted and redirected to nginx for processing with the `error_page` directive. 



