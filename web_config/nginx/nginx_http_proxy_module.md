nginx ����ģ��
========================================

proxy\_set\_header ���˷�������ӻ��޸�����ͷ
--------------------------------------------
```
Syntax:  proxy_set_header field value;
Default: proxy_set_header Host $proxy_host;
         proxy_set_header Connection close;
Context: http, server, location
```
* ��ת���������������������ͷ�У���ӻ��޸�����ͷ�� 
* Allows redefining or appending fields to the request header passed to the proxied server. 
* These directives are inherited from the previous level if and only if there are no `proxy_set_header` directives defined on the current level.   
* �������δ�����κ� `proxy_set_header`ָ��,��̳��ϼ���`proxy_set_header`ָ�

    // ����������Ĭ�ϵ�����
	proxy_set_header Host $proxy_host;     // �޸��û�������ͷ��Host��Ϊ��˷�������������
	proxy_set_header Connection close; 

* If the value of a header field is an empty string then this field will not be passed to a proxied server.  


proxy\_connect\_timeout ���ô�����������˷����������ӽ׶εĳ�ʱʱ��
-------------------------------------------------------------------
```
Syntax:  proxy_connect_timeout time;
Default: proxy_connect_timeout 60s;
Context: http, server, location
```
* Defines a timeout for establishing a connection with a proxied server. It should be noted that this timeout cannot usually exceed 75 seconds. 


proxy\_send_timeout ������������˷�����ת��requestʱ����س�ʱ
-------------------------------------------------------------------
```
Syntax:  proxy_send_timeout time;
Default: proxy_send_timeout 60s;
Context: http, server, location
```
* Sets a timeout for transmitting a request to the proxied server. The timeout is set only between two successive write operations, not for the transmission of the whole request. If the proxied server does not receive anything with this time, the connction is closed. 
* ���һ��request��Ҫ����ת������˷�������tcp���ĵ�Ӧ��ʱʱ�䡣

proxy\_read\_timeout ����������Ӻ�˷�������ȡresponseʱ����س�ʱ
----------------------------------------------------------------
```
Syntax:  proxy_read_timeout  time;
Default: proxy_read_timeout  60s;
Context: http, server, location
```
* Defines a timeout for reading a response from the proxied server. The timeout is set only between two successive read operations, not for the transmission of the whole response. If the proxied server does not transmit anything within this time, the connection is closed. 
* ����������ڶ�ȡ��˷�������responseʱ���������tcp���ļ�����������ã����ӽ����رա�

 
 proxy\_buffer\_size  nginx �ݴ��˷��������ص���Ӧͷ�Ļ�����
------------------------------------------------------------
```
Syntax:  proxy_buffer_size  size;
Default: proxy_buffer_size  4k|8k;
Context: http, server, location
```
* Sets the `size` of the buffer used for reading the first part of the response received from the proxied server. This part usually contains a small responses header. By default, the buffer size is equal to one memory page. This is either 4K or 8K, depending on a platform. 


proxy\_buffers ����nginx��һ����˴���������ʹ�õĻ�������������С 
----------------------------------------------------------------
```
Syntax:  proxy_buffers number size;
Default: proxy_buffers 8 4k|8k;
Context: http, server, location
```
* Sets the `number` and `size` of the buffers used for reading a response from the proxied server, for a single connection. By default, the buffer size is equal to one memory page. 
* ����һЩ�������� nginx �ͺ�˷������� tcp����ʹ��; 


proxy_buffering �Ƿ���nginx��ȡ��˷���������Ӧʱ�Ļ���
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
* ����ر�, `proxy_buffers` �� `proxy_busy_buffers_size` ��ʧЧ������ `proxy_buffer_size`������Ч��


proxy\_busy\_buffers\_sizes �ڴ�������ʱ�п���һ������Ļ�����
-----------------------------------------------------
```
Syntax:  proxy_busy_buffers_size  size;
Default: proxy_busy_buffers_size  8k|16k;
Context: http, server, location
````
* When `buffering` of responses from the proxied server is enabled, limits the total `size` of the buffers that can be busy sending a response to the client while the response if not yet fully read.  
 
 
proxy\_temp\_file\_write\_size  ����ÿ��д����ʱ�ļ��Ĵ�С
--------------------------------------------------------------
```
Syntax:  proxy_temp_file_write_size size;
Default: proxy_temp_file_write_size 8k|16k;
Context: http, server, location
```
* Limits the `size` of data written to a temporary file at a time, when buffering of responses from the proxied to temporary files is enabled.  


