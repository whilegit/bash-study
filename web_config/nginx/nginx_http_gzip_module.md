nginx gzip module ѹ��ģ��
========================


gzip ������ر� gzip
---------------------------------------
```
Syntax:  gzip on | off;
Default: gzip off;
Context: http, server, location, if in location
```
* Enables or disables gzipping of responses. ������رն���Ӧ��gzipѹ��


gzip_static ��̬ѹ��
--------------------------------------------
```
Syntax:  gzip_static on|off|always;
Default: gzip_static off;
Context: http, server, location
```
* ���� __ngx_http_gzip_static_module__ ģ�飬���� __ngx_http_gzip_module__ģ�顣
* Allows sending precompressed files with the `.gz` filename extension instead of regular files.
* ��Ҫʹ��bash�ű�Ԥ�����ɾ�̬��Դ��gzipѹ��


gzip\_comp\_level ����ѹ������
----------------------------------------------
```
Syntax:  gzip_comp_level level;
Default: gzip_comp_level 1;
Context: http, server, location
```
* sets a gzip compression level of a response. Acceptable values are in the range from 1 to 9;


gzip\_buffers ���� gzipʹ�õĻ�����
----------------------------------
```
Syntax:  gzip_buffers number size;
Default: gzip_buffers 32 4k|16 8k;
Context: http, server, location
```
* Sets the `number` and `size` of buffers used to compress a response. By default, the buffer size is equal to one memory page. 


gzip\_min\_length ������Ҫѹ����response��С��ֵ
------------------------------------------
```
Syntax:  gzip_min_length length;
Default: gzip_min_length 20;
Context: http, server, location;
```
* Sets the minimum length of a response that will be gzipped. The length is determined only from the "Content-Length" response header field. 


gzip_types  ������Ҫʹ��gzip��MIME����
------------------------------------------
```
Syntax:  gzip_types mime-type ...
Default: gzip_types text/html;
Context: http, server, location;
```
* Enables gzipping of responses for the specified MIME types in addition to "text/html". The special values "*" matches any MIME type.  


