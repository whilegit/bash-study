nginx 代理模块
========================================

proxy\_set\_header 向后端服务器添加或修改请求头
--------------------------------------------
```
Syntax:  proxy_set_header field value;
Default: proxy_set_header Host $proxy_host;
         proxy_set_header Connection close;
Context: http, server, location
```
* 在转发给被代理服务器的请求头中，添加或修改请求头域。 
* Allows redefining or appending fields to the request header passed to the proxied server. 
* These directives are inherited from the previous level if and only if there are no `proxy_set_header` directives defined on the current level.   
* 如果本级未设置任何 `proxy_set_header`指令,则继承上级的`proxy_set_header`指令。

    // 以下两个是默认的设置
	proxy_set_header Host $proxy_host;     // 修改用户的请求头的Host域为后端服务器的主机名
	proxy_set_header Connection close; 

* If the value of a header field is an empty string then this field will not be passed to a proxied server.  


proxy\_connect\_timeout 设置代理服务器与后端服务器的连接阶段的超时时间
-------------------------------------------------------------------
```
Syntax:  proxy_connect_timeout time;
Default: proxy_connect_timeout 60s;
Context: http, server, location
```
* Defines a timeout for establishing a connection with a proxied server. It should be noted that this timeout cannot usually exceed 75 seconds. 


proxy\_send_timeout 代理服务器向后端服务器转发request时的相关超时
-------------------------------------------------------------------
```
Syntax:  proxy_send_timeout time;
Default: proxy_send_timeout 60s;
Context: http, server, location
```
* Sets a timeout for transmitting a request to the proxied server. The timeout is set only between two successive write operations, not for the transmission of the whole request. If the proxied server does not receive anything with this time, the connction is closed. 
* 如果一个request需要分批转发给后端服务器，tcp报文的应答超时时间。

proxy\_read\_timeout 代理服务器从后端服务器读取response时的相关超时
----------------------------------------------------------------
```
Syntax:  proxy_read_timeout  time;
Default: proxy_read_timeout  60s;
Context: http, server, location
```
* Defines a timeout for reading a response from the proxied server. The timeout is set only between two successive read operations, not for the transmission of the whole response. If the proxied server does not transmit anything within this time, the connection is closed. 
* 代理服务器在读取后端服务器的response时，如果两个tcp包的间隔超过此设置，连接将被关闭。

 
 proxy\_buffer\_size  nginx 暂存后端服务器返回的响应头的缓冲区
------------------------------------------------------------
```
Syntax:  proxy_buffer_size  size;
Default: proxy_buffer_size  4k|8k;
Context: http, server, location
```
* Sets the `size` of the buffer used for reading the first part of the response received from the proxied server. This part usually contains a small responses header. By default, the buffer size is equal to one memory page. This is either 4K or 8K, depending on a platform. 


proxy\_buffers 设置nginx和一个后端代理连接所使用的缓冲区数量及大小 
----------------------------------------------------------------
```
Syntax:  proxy_buffers number size;
Default: proxy_buffers 8 4k|8k;
Context: http, server, location
```
* Sets the `number` and `size` of the buffers used for reading a response from the proxied server, for a single connection. By default, the buffer size is equal to one memory page. 
* 分配一些缓冲区给 nginx 和后端服务器的 tcp连接使用; 


proxy_buffering 是否开启nginx读取后端服务器的响应时的缓存
-------------------------------------------------------
```
Syntax:  proxy_buffering on | off;
Default: proxy_buffering on; 
Context: http, server, location
```
* Enables or disables buffering of responses from the proxied server.  
* When buffering is enabled, nginx receives a response from the proxied server as soon as possible, saving it into the buffers set by the `proxy_buffer_size` and `proxy_buffers` directives.  
* If the whold response does not fit into memory, a part of it can be saved to a `temporary file` on the disk. Writing to temporary files is controlled by the `proxy_max_temp_file_size` and `proxy_temp_file_write_size` directives. 
* When buffering is disabled, the response is passed to a client synchronously, immediately as it is received. 
* 如果关闭, `proxy_buffers` 和 `proxy_busy_buffers_size` 将失效，但是 `proxy_buffer_size`总是有效的


proxy\_busy\_buffers\_sizes 在代理缓冲区时中开辟一个特殊的缓冲区
-----------------------------------------------------
```
Syntax:  proxy_busy_buffers_size  size;
Default: proxy_busy_buffers_size  8k|16k;
Context: http, server, location
````
* When `buffering` of responses from the proxied server is enabled, limits the total `size` of the buffers that can be busy sending a response to the client while the response if not yet fully read.  
 
 
proxy\_temp\_file\_write\_size  设置每次写入临时文件的大小
--------------------------------------------------------------
```
Syntax:  proxy_temp_file_write_size size;
Default: proxy_temp_file_write_size 8k|16k;
Context: http, server, location
```
* Limits the `size` of data written to a temporary file at a time, when buffering of responses from the proxied to temporary files is enabled.  


